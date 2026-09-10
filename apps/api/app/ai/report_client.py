"""Structured advisory narrative generation for Phase 9 reports."""

import json
from typing import Any, Protocol

import anthropic
from pydantic import ValidationError

from app.core.settings import settings
from app.models.entities import ReportNarrative

_PROMPT = (
    "Create a concise industrial operations report narrative from the supplied "
    "authoritative source snapshot. Do not invent facts, readings, causes, or "
    "actions. Clearly preserve uncertainty. Return a short summary, factual "
    "findings, practical recommendations, and an optional 0-100 risk score. "
    "This output is advisory and will be reviewed by a human before finalization."
)

_TOOL = {
    "name": "write_report_narrative",
    "description": "Write a structured advisory report narrative from supplied source data.",
    "input_schema": {
        "type": "object",
        "properties": {
            "summary": {"type": "string"},
            "findings": {"type": "array", "items": {"type": "string"}},
            "recommendations": {"type": "array", "items": {"type": "string"}},
            "risk_score": {"type": "number", "minimum": 0, "maximum": 100},
        },
        "required": ["summary", "findings", "recommendations"],
    },
}


class ReportNarrativeError(Exception):
    pass


class ReportNarrativeClient(Protocol):
    model_name: str

    async def generate(
        self, report_type: str, source_snapshot: dict[str, Any]
    ) -> ReportNarrative: ...


class ClaudeReportNarrativeClient:
    def __init__(self, api_key: str | None = None, model: str | None = None) -> None:
        self._api_key = api_key if api_key is not None else settings.anthropic_api_key
        self.model_name = model or settings.ai_vision_model
        self._client: anthropic.AsyncAnthropic | None = None

    def _get_client(self) -> anthropic.AsyncAnthropic:
        if not self._api_key:
            raise ReportNarrativeError("AI report generation is not configured (no API key)")
        if self._client is None:
            self._client = anthropic.AsyncAnthropic(api_key=self._api_key)
        return self._client

    async def generate(self, report_type: str, source_snapshot: dict[str, Any]) -> ReportNarrative:
        try:
            response = await self._get_client().messages.create(  # type: ignore[call-overload]
                model=self.model_name,
                max_tokens=2048,
                tools=[_TOOL],
                tool_choice={"type": "tool", "name": "write_report_narrative"},
                messages=[
                    {
                        "role": "user",
                        "content": (
                            f"{_PROMPT}\nReport type: {report_type}\n"
                            f"Source snapshot JSON:\n{json.dumps(source_snapshot, default=str)}"
                        ),
                    }
                ],
            )
        except anthropic.APIError as error:
            raise ReportNarrativeError(f"Claude report request failed: {error}") from error

        tool_use = next((block for block in response.content if block.type == "tool_use"), None)
        if tool_use is None:
            raise ReportNarrativeError("Claude did not return a structured report narrative")
        try:
            return ReportNarrative.model_validate(tool_use.input)
        except ValidationError as error:
            raise ReportNarrativeError(f"Malformed AI report response: {error}") from error


def get_report_narrative_client() -> ClaudeReportNarrativeClient:
    return ClaudeReportNarrativeClient()
