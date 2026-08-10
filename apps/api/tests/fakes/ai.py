"""In-memory stand-in for `ClaudeVisionClient`, used by tests instead of
calling the real Anthropic API. Exposes the same minimal
`analyze_photo`/`model_name` surface `InspectionService` depends on."""

from dataclasses import dataclass, field

from app.ai.vision_client import AiAnalysisResult


@dataclass
class FakeAiClient:
    model_name: str = "fake-vision-model"
    result: AiAnalysisResult | None = None
    error: Exception | None = None
    calls: list[tuple[bytes, str]] = field(default_factory=list)

    async def analyze_photo(self, image_bytes: bytes, content_type: str) -> AiAnalysisResult:
        self.calls.append((image_bytes, content_type))
        if self.error is not None:
            raise self.error
        if self.result is not None:
            return self.result
        return AiAnalysisResult(summary="No issues detected.", findings=[])
