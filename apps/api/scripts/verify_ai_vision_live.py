"""Verify the Claude vision path against the real Anthropic API.

Phase 7.10 shipped AI photo analysis tested only against `FakeAiClient`, and
the video path added later was the same: CI-safe, but never once proven against
the live API. This script closes that gap. It is deliberately a script rather
than a test -- it costs real API credits and needs a real key, so it must never
run in CI.

What it proves is the contract, not Claude's judgement: that the request shape
is accepted, that the forced tool call comes back, and that the response parses
into `AiAnalysisResult` with findings inside the documented bounds. Whether a
synthetic image "really" shows corrosion is not the point and is not asserted.

Usage (needs ANTHROPIC_API_KEY in apps/api/.env):
    poetry run python -m scripts.verify_ai_vision_live
"""

import asyncio
import io
import sys
from typing import cast

import av
from av.video.stream import VideoStream
from PIL import Image, ImageDraw

from app.ai.video_frames import PyAvFrameExtractor
from app.ai.vision_client import AiAnalysisResult, ClaudeVisionClient
from app.core.settings import settings

WIDTH, HEIGHT = 768, 512


def _damaged_flange_image() -> bytes:
    """A crude but unambiguous industrial scene: a pipe flange with rust.

    Drawn rather than committed as a fixture so the repository carries no binary
    test asset, matching how the video decoder tests generate their own clips.
    """
    image = Image.new("RGB", (WIDTH, HEIGHT), (78, 84, 92))
    draw = ImageDraw.Draw(image)

    # Pipe body running left to right.
    draw.rectangle([0, 190, WIDTH, 320], fill=(120, 126, 134))
    draw.rectangle([0, 190, WIDTH, 205], fill=(150, 156, 164))
    draw.rectangle([0, 305, WIDTH, 320], fill=(92, 97, 104))

    # Flange plate in the middle.
    draw.rectangle([330, 150, 420, 360], fill=(105, 111, 119), outline=(60, 64, 70), width=3)
    for y in range(175, 350, 34):
        draw.ellipse([345, y, 365, y + 20], fill=(70, 74, 80), outline=(45, 48, 52))
        draw.ellipse([390, y, 410, y + 20], fill=(70, 74, 80), outline=(45, 48, 52))

    # Rust blooms around the joint and a streak running down the pipe.
    for box, colour in (
        ([300, 210, 350, 300], (146, 64, 26)),
        ([405, 230, 470, 315], (128, 54, 20)),
        ([300, 300, 480, 330], (110, 46, 18)),
        ([440, 250, 620, 285], (134, 60, 24)),
    ):
        draw.ellipse(box, fill=colour)

    buffer = io.BytesIO()
    image.save(buffer, format="JPEG", quality=88)
    return buffer.getvalue()


def _damaged_pipe_clip(seconds: int = 2, fps: int = 8) -> bytes:
    """The same scene as a short clip, panning so frames genuinely differ."""
    base = Image.open(io.BytesIO(_damaged_flange_image())).convert("RGB")
    buffer = io.BytesIO()
    with av.open(buffer, "w", format="mp4") as container:
        stream = cast(VideoStream, container.add_stream("libx264", rate=fps))
        stream.width, stream.height, stream.pix_fmt = WIDTH, HEIGHT, "yuv420p"
        total = seconds * fps
        for index in range(total):
            offset = int((index / max(total - 1, 1)) * 80) - 40
            frame_image = Image.new("RGB", (WIDTH, HEIGHT), (78, 84, 92))
            frame_image.paste(base, (offset, 0))
            for packet in stream.encode(av.VideoFrame.from_image(frame_image)):
                container.mux(packet)
        for packet in stream.encode():
            container.mux(packet)
    return buffer.getvalue()


def _report(label: str, result: AiAnalysisResult) -> None:
    print(f"\n--- {label} ---")
    print(f"  summary        : {result.summary}")
    print(f"  risk_level     : {result.risk_level}")
    print(f"  recommendations: {result.recommendations}")
    print(f"  findings       : {len(result.findings)}")
    for finding in result.findings:
        points = ", ".join(f"({p.x:.2f}, {p.y:.2f})" for p in finding.points)
        stamp = (
            f" @ {finding.frame_timestamp_seconds:.2f}s"
            if finding.frame_timestamp_seconds is not None
            else ""
        )
        print(
            f"    - {finding.shape:9} {finding.damage_type or 'unclassified':22}"
            f" conf={finding.confidence:.2f}{stamp} [{points}]"
        )


def _check_contract(label: str, result: AiAnalysisResult, *, expect_frames: bool) -> None:
    """Assert the response contract -- never Claude's opinion of the image."""
    assert result.summary.strip(), f"{label}: empty summary"
    if result.risk_level is not None:
        assert result.risk_level in ("low", "medium", "high", "critical"), result.risk_level
    for finding in result.findings:
        assert finding.shape in ("point", "rectangle"), finding.shape
        assert 1 <= len(finding.points) <= 2, len(finding.points)
        for point in finding.points:
            assert 0.0 <= point.x <= 1.0 and 0.0 <= point.y <= 1.0, (point.x, point.y)
        assert 0.0 <= finding.confidence <= 1.0, finding.confidence
        if expect_frames:
            # Coordinates are meaningless on a clip without the frame they
            # were measured against.
            assert finding.frame_timestamp_seconds is not None, (
                f"{label}: a video finding carries no frame offset"
            )
    print("  contract       : OK")


async def main() -> int:
    if not settings.anthropic_api_key:
        print("ANTHROPIC_API_KEY is not set; nothing to verify.", file=sys.stderr)
        return 2

    client = ClaudeVisionClient()
    print(f"model: {client.model_name}")

    photo = _damaged_flange_image()
    print(f"photo bytes: {len(photo)}")
    photo_result = await client.analyze_photo(photo, "image/jpeg")
    _report("photo", photo_result)
    _check_contract("photo", photo_result, expect_frames=False)

    clip = _damaged_pipe_clip()
    frames = PyAvFrameExtractor().extract(clip, "video/mp4", max_frames=4)
    print(f"\nclip bytes: {len(clip)} -> {len(frames)} frames sampled at "
          f"{', '.join(f'{f.timestamp_seconds:.2f}s' for f in frames)}")
    video_result = await client.analyze_video_frames(frames)
    _report("video", video_result)
    _check_contract("video", video_result, expect_frames=True)

    print("\nLive Claude vision verification passed (photo + video).")
    return 0


if __name__ == "__main__":
    raise SystemExit(asyncio.run(main()))
