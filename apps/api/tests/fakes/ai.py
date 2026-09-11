"""In-memory stand-ins for `ClaudeVisionClient` and the video frame
extractor, used by tests instead of calling the real Anthropic API or
decoding a real video file. Both expose the minimal surface
`InspectionService` depends on."""

from dataclasses import dataclass, field

from app.ai.video_frames import DEFAULT_MAX_FRAMES, VideoFrame
from app.ai.vision_client import AiAnalysisResult


@dataclass
class FakeAiClient:
    model_name: str = "fake-vision-model"
    result: AiAnalysisResult | None = None
    error: Exception | None = None
    calls: list[tuple[bytes, str]] = field(default_factory=list)
    video_result: AiAnalysisResult | None = None
    video_error: Exception | None = None
    video_calls: list[list[VideoFrame]] = field(default_factory=list)

    async def analyze_photo(self, image_bytes: bytes, content_type: str) -> AiAnalysisResult:
        self.calls.append((image_bytes, content_type))
        if self.error is not None:
            raise self.error
        if self.result is not None:
            return self.result
        return AiAnalysisResult(summary="No issues detected.", findings=[])

    async def analyze_video_frames(self, frames: list[VideoFrame]) -> AiAnalysisResult:
        self.video_calls.append(frames)
        if self.video_error is not None:
            raise self.video_error
        if self.video_result is not None:
            return self.video_result
        return AiAnalysisResult(summary="No issues detected in the clip.", findings=[])


@dataclass
class FakeFrameExtractor:
    """Returns canned frames so tests never need a real encoded video.

    `PyAvFrameExtractor`'s own decoding is covered separately against a real
    generated clip; this seam keeps every inspection test CI-safe and fast.
    """

    frames: list[VideoFrame] | None = None
    error: Exception | None = None
    calls: list[tuple[bytes, str, int]] = field(default_factory=list)

    def extract(
        self, video_bytes: bytes, content_type: str, max_frames: int = DEFAULT_MAX_FRAMES
    ) -> list[VideoFrame]:
        self.calls.append((video_bytes, content_type, max_frames))
        if self.error is not None:
            raise self.error
        if self.frames is not None:
            return self.frames
        return [
            VideoFrame(timestamp_seconds=0.5, image_bytes=b"frame-one"),
            VideoFrame(timestamp_seconds=1.5, image_bytes=b"frame-two"),
        ]
