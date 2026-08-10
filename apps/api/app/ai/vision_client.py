"""Phase 7.10 AI photo analysis -- a thin wrapper over the Claude vision API.

This is the first outbound third-party HTTP/SDK call in this backend (every
other integration is Firebase). Findings are always advisory: the caller
persists them as `Annotation(source="ai", ...)` records the inspector can
freely edit or delete, exactly like a manually drawn one (D-054's own
rationale for reserving `source`/`confidence`)."""

import base64
from typing import Protocol

import anthropic
from pydantic import BaseModel, Field, ValidationError

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

_REPORT_TOOL = {
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

    async def analyze_photo(self, image_bytes: bytes, content_type: str) -> AiAnalysisResult:
        client = self._get_client()
        encoded = base64.standard_b64encode(image_bytes).decode("ascii")
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
                max_tokens=1024,
                tools=[_REPORT_TOOL],
                tool_choice={"type": "tool", "name": "report_photo_analysis"},
                messages=[
                    {
                        "role": "user",
                        "content": [
                            {
                                "type": "image",
                                "source": {
                                    "type": "base64",
                                    "media_type": content_type,
                                    "data": encoded,
                                },
                            },
                            {"type": "text", "text": _ANALYSIS_PROMPT},
                        ],
                    }
                ],
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


def get_vision_client() -> ClaudeVisionClient:
    return ClaudeVisionClient()
