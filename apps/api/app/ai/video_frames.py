"""Frame extraction for AI video analysis.

Claude's vision API accepts images, not video, so a video inspection clip is
analysed by sampling representative frames and sending them together as one
message. Sampling is spread evenly across the clip's duration rather than
taking the first N frames, so a fault that only appears part-way through the
recording is still seen.

`InspectionService` depends on the `VideoFrameExtractor` protocol rather than
the PyAV implementation, so tests inject a fake and CI never needs a real video
file -- the same seam `VisionAnalysisClient` and `InspectionMediaStorage` use.
"""

import io
from dataclasses import dataclass
from typing import Protocol, cast

import av
from av.container import InputContainer
from PIL import Image

# Claude charges per image and degrades on very large inputs; handheld
# inspection footage rarely benefits from more than this.
DEFAULT_MAX_FRAMES = 6
MAX_FRAME_EDGE_PX = 1024
JPEG_QUALITY = 82
FRAME_CONTENT_TYPE = "image/jpeg"

# Guards a pathological file (or a wrong-duration header) from turning one
# analysis request into an unbounded decode.
MAX_FRAMES_DECODED = 30_000


class VideoDecodeError(Exception):
    """The clip could not be decoded (corrupt, empty, or an unsupported codec)."""


@dataclass(frozen=True)
class VideoFrame:
    """One sampled frame, JPEG-encoded, with its offset into the clip."""

    timestamp_seconds: float
    image_bytes: bytes
    content_type: str = FRAME_CONTENT_TYPE


class VideoFrameExtractor(Protocol):
    def extract(
        self, video_bytes: bytes, content_type: str, max_frames: int = DEFAULT_MAX_FRAMES
    ) -> list[VideoFrame]: ...


def _encode(image: Image.Image) -> bytes:
    """Downscale to a sane edge length and JPEG-encode."""
    if image.mode != "RGB":
        image = image.convert("RGB")
    if max(image.size) > MAX_FRAME_EDGE_PX:
        image.thumbnail((MAX_FRAME_EDGE_PX, MAX_FRAME_EDGE_PX))
    buffer = io.BytesIO()
    image.save(buffer, format="JPEG", quality=JPEG_QUALITY)
    return buffer.getvalue()


def _duration_seconds(container: InputContainer) -> float | None:
    if container.duration is None:
        return None
    seconds = float(container.duration) / av.time_base
    return seconds if seconds > 0 else None


def _sample_targets(duration: float | None, max_frames: int) -> list[float] | None:
    """Offsets to sample, one per frame, centred within equal slices.

    Centring (the `+ 0.5`) avoids sampling exactly at 0.0, which on many clips
    is a black or auto-exposing first frame.
    """
    if duration is None:
        return None
    return [duration * (index + 0.5) / max_frames for index in range(max_frames)]


class PyAvFrameExtractor:
    """Decodes with PyAV, which bundles its own ffmpeg -- no system binary."""

    def extract(
        self, video_bytes: bytes, content_type: str, max_frames: int = DEFAULT_MAX_FRAMES
    ) -> list[VideoFrame]:
        if max_frames < 1:
            raise ValueError("max_frames must be at least 1")
        if not video_bytes:
            raise VideoDecodeError("The video file is empty")

        frames: list[VideoFrame] = []
        try:
            with cast(InputContainer, av.open(io.BytesIO(video_bytes))) as container:
                if not container.streams.video:
                    raise VideoDecodeError("The file contains no video stream")
                stream = container.streams.video[0]
                stream.thread_type = "AUTO"

                targets = _sample_targets(_duration_seconds(container), max_frames)
                decoded = 0

                # One sequential pass. Seeking would be cheaper but many
                # phone-recorded clips carry unreliable keyframe indexes, and
                # inspection footage is short enough for a linear read.
                for frame in container.decode(stream):
                    decoded += 1
                    if decoded > MAX_FRAMES_DECODED:
                        break
                    stamp = float(frame.time) if frame.time is not None else 0.0

                    if targets is None:
                        # Unknown duration: take the leading frames rather than
                        # guess at a spacing we cannot compute.
                        frames.append(VideoFrame(stamp, _encode(frame.to_image())))
                        if len(frames) >= max_frames:
                            break
                        continue

                    if stamp >= targets[len(frames)]:
                        frames.append(VideoFrame(stamp, _encode(frame.to_image())))
                        if len(frames) >= len(targets):
                            break

                if decoded == 0:
                    raise VideoDecodeError("The video stream contained no decodable frames")

                # A clip shorter than its declared duration can end before the
                # later targets are reached; the frames gathered still stand.
        except VideoDecodeError:
            raise
        except av.FFmpegError as error:  # pragma: no cover - depends on the file
            raise VideoDecodeError(f"Could not decode the video: {error}") from error

        if not frames:
            raise VideoDecodeError("No frames could be extracted from the video")
        return frames


def get_video_frame_extractor() -> PyAvFrameExtractor:
    return PyAvFrameExtractor()
