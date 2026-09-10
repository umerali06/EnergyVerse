"""Phase 7.10 AI photo analysis -- a thin wrapper over the Claude vision API.

This is the first outbound third-party HTTP/SDK call in this backend (every
other integration is Firebase). Findings are always advisory: the caller
persists them as `Annotation(source="ai", ...)` records the inspector can
freely edit or delete, exactly like a manually drawn one (D-054's own
rationale for reserving `source`/`confidence`)."""

import base64
from copy import deepcopy
from typing import Any, Protocol

import anthropic
from pydantic import BaseModel, Field, ValidationError

from app.ai.video_frames import VideoFrame
from app.core.settings import settings

DAMAGE_TYPES = (
    "corrosion",
    "rust",
    "crack",
    "surface_damage",
    "paint_deterioration",
    "missing_bolt",
    "broken_component",
    "leak",
    "wear",
    "other",
)

_ANALYSIS_PROMPT = (
    "You are assisting a field inspector reviewing an industrial asset photo "
    "(oil & gas, energy, or utility equipment). Look only for visible physical "
    "damage or defects -- corrosion, rust, cracks, surface damage, paint "
    "deterioration, missing bolts, broken components, fluid leaks, or general "
    "wear. Do not speculate about anything not visible in the image. "
    "Call report_photo_analysis with your findings. For each finding, give a "
    "shape ('point' for a specific spot, 'rectangle' for an affected area) and "
    "its points as normalized 0-1 coordinates relative to the image's own "
    "width/height (a rectangle needs its top-left and bottom-right corners; a "
    "point needs just one coordinate pair). If the photo shows no visible "
    "damage, return an empty findings array and say so plainly in the summary."
)

_VIDEO_ANALYSIS_PROMPT = (
    "You are assisting a field inspector reviewing frames sampled from a video "
    "recording of an industrial asset (oil & gas, energy, or utility "
    "equipment). The frames are given in chronological order and each is "
    "labelled with its offset in seconds from the start of the clip. They come "
    "from one continuous recording, so the same defect may appear in several "
    "frames -- report it once, against the frame where it is clearest. Look "
    "only for visible physical damage or defects: corrosion, rust, cracks, "
    "surface damage, paint deterioration, missing bolts, broken components, "
    "fluid leaks, or general wear. Do not speculate about anything not visible. "
    "Call report_video_analysis with your findings. Every finding must carry "
    "frame_timestamp_seconds set to the labelled offset of the frame it was "
    "seen in, and its points as normalized 0-1 coordinates relative to that "
    "frame's own width/height (a rectangle needs its top-left and bottom-right "
    "corners; a point needs one coordinate pair). If the frames show no "
    "visible damage, return an empty findings array and say so in the summary."
)

_REPORT_TOOL: dict[str, Any] = {
    "name": "report_photo_analysis",
    "description": "Report visible damage/defects detected in an inspection photo.",
    "input_schema": {
        "type": "object",
        "properties": {
            "summary": {
                "type": "string",
                "description": "One or two sentence plain-language summary of what was found.",
            },
            "recommendations": {
                "type": "string",
                "description": "Suggested next action for the inspector, if any.",
            },
            "risk_level": {
                "type": "string",
                "enum": ["low", "medium", "high", "critical"],
                "description": "Overall risk level implied by the findings, if any were found.",
            },
            "findings": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "shape": {"type": "string", "enum": ["point", "rectangle"]},
                        "points": {
                            "type": "array",
                            "items": {
                                "type": "object",
                                "properties": {
                                    "x": {"type": "number", "minimum": 0, "maximum": 1},
                                    "y": {"type": "number", "minimum": 0, "maximum": 1},
                                },
                                "required": ["x", "y"],
                            },
                            "minItems": 1,
                            "maxItems": 2,
                        },
                        "damage_type": {"type": "string", "enum": list(DAMAGE_TYPES)},
                        "confidence": {"type": "number", "minimum": 0, "maximum": 1},
                        "note": {"type": "string"},
                    },
                    "required": ["shape", "points", "confidence"],
                },
            },
        },
        "required": ["summary", "findings"],
    },
}


def _video_report_tool() -> dict[str, Any]:
    """The photo tool with a required per-finding frame offset.

    Built from the photo schema rather than duplicated so the two cannot drift
    apart as damage types or point rules change.
    """
    schema: dict[str, Any] = deepcopy(_REPORT_TOOL["input_schema"])
    finding: dict[str, Any] = schema["properties"]["findings"]["items"]
    finding["properties"]["frame_timestamp_seconds"] = {
        "type": "number",
        "minimum": 0,
        "description": "Offset in seconds of the labelled frame this finding was seen in.",
    }
    finding["required"] = [*finding["required"], "frame_timestamp_seconds"]
    return {
        "name": "report_video_analysis",
        "description": "Report visible damage/defects detected across inspection video frames.",
        "input_schema": schema,
    }


_VIDEO_REPORT_TOOL = _video_report_tool()


def _image_block(image_bytes: bytes, content_type: str) -> dict[str, Any]:
    return {
        "type": "image",
        "source": {
            "type": "base64",
            "media_type": content_type,
            "data": base64.standard_b64encode(image_bytes).decode("ascii"),
        },
    }


class AiClientError(Exception):
    """Raised when the vision API call fails, is misconfigured, or returns an
    unusable response -- the service layer translates this into a clean 502
    `ai_analysis_failed`, never a raw stack trace."""


class AiFindingPoint(BaseModel):
    x: float = Field(ge=0, le=1)
    y: float = Field(ge=0, le=1)


class AiFinding(BaseModel):
    shape: str
    points: list[AiFindingPoint] = Field(min_length=1, max_length=2)
    damage_type: str | None = None
    confidence: float = Field(ge=0, le=1)
    note: str | None = None
    # Video runs only: the offset of the frame these coordinates belong to.
    frame_timestamp_seconds: float | None = Field(default=None, ge=0)


class AiAnalysisResult(BaseModel):
    summary: str
    recommendations: str | None = None
    risk_level: str | None = None
    findings: list[AiFinding] = Field(default_factory=list)


class VisionAnalysisClient(Protocol):
    """The minimal surface `InspectionService` depends on -- lets tests
    inject a `FakeAiClient` (see `tests/fakes/ai.py`) without needing a real
    Anthropic API key, same rationale as `InspectionMediaStorage` accepting
    a `FakeBucket`."""

    model_name: str

    async def analyze_photo(self, image_bytes: bytes, content_type: str) -> AiAnalysisResult: ...

    async def analyze_video_frames(self, frames: list[VideoFrame]) -> AiAnalysisResult: ...


class ClaudeVisionClient:
    """Real Claude vision implementation. `InspectionService` depends on the
    minimal `analyze_photo`/`model_name` surface, not this class directly, so
    tests inject a fake instead of needing a real API key."""

    def __init__(self, api_key: str | None = None, model: str | None = None) -> None:
        self._api_key = api_key if api_key is not None else settings.anthropic_api_key
        self.model_name = model or settings.ai_vision_model
        self._client: anthropic.AsyncAnthropic | None = None

    def _get_client(self) -> anthropic.AsyncAnthropic:
        if not self._api_key:
            raise AiClientError("AI photo analysis is not configured (no API key)")
        if self._client is None:
            self._client = anthropic.AsyncAnthropic(api_key=self._api_key)
        return self._client

    async def _report(
        self, content: list[dict[str, Any]], tool: dict[str, Any]
    ) -> AiAnalysisResult:
        """Issue one tool-forced vision request and validate the result.

        Shared by the photo and video paths so both get identical error
        translation and response validation.
        """
        client = self._get_client()
        try:
            # The Anthropic SDK's overloads expect its own precise TypedDicts
            # (ToolParam/ToolChoiceToolParam/MessageParam) rather than plain
            # dicts; this call is correct at runtime (the SDK accepts plain
            # dicts, matching its own examples) but doesn't structurally match
            # under strict mypy -- same class of third-party-typing gap as
            # `firebase_admin`'s own `type: ignore[import-untyped]` elsewhere
            # in this codebase.
            response = await client.messages.create(  # type: ignore[call-overload]
                model=self.model_name,
                max_tokens=2048,
                tools=[tool],
                tool_choice={"type": "tool", "name": tool["name"]},
                messages=[{"role": "user", "content": content}],
            )
        except anthropic.APIError as error:
            raise AiClientError(f"Claude vision request failed: {error}") from error

        tool_use = next((block for block in response.content if block.type == "tool_use"), None)
        if tool_use is None:
            raise AiClientError("Claude did not return structured findings")
        try:
            return AiAnalysisResult.model_validate(tool_use.input)
        except ValidationError as error:
            raise AiClientError(f"Malformed AI response: {error}") from error

    async def analyze_photo(self, image_bytes: bytes, content_type: str) -> AiAnalysisResult:
        content: list[dict[str, Any]] = [
            _image_block(image_bytes, content_type),
            {"type": "text", "text": _ANALYSIS_PROMPT},
        ]
        return await self._report(content, _REPORT_TOOL)

    async def analyze_video_frames(self, frames: list[VideoFrame]) -> AiAnalysisResult:
        """Analyse frames sampled from one clip as a single request.

        Sending every frame in one message (rather than one request per frame)
        lets Claude recognise that the same defect recurs across frames and
        report it once, which is why findings carry a frame offset instead of
        each frame producing its own isolated analysis.
        """
        if not frames:
            raise AiClientError("No frames were extracted from the video to analyse")

        content: list[dict[str, Any]] = []
        for frame in frames:
            content.append({"type": "text", "text": f"Frame at {frame.timestamp_seconds:.2f}s:"})
            content.append(_image_block(frame.image_bytes, frame.content_type))
        content.append({"type": "text", "text": _VIDEO_ANALYSIS_PROMPT})
        return await self._report(content, _VIDEO_REPORT_TOOL)


def get_vision_client() -> ClaudeVisionClient:
    return ClaudeVisionClient()
