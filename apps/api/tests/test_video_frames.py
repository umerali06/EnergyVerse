"""Covers `PyAvFrameExtractor` against real encoded video.

Every other test injects `FakeFrameExtractor`, so this is the only place the
actual decode path runs. The clips are generated in-process with PyAV (already
a dependency) rather than committed as fixtures, so there is no binary blob in
the repository and the test stays hermetic.
"""

import io

import av
import pytest
from PIL import Image

from app.ai.video_frames import PyAvFrameExtractor, VideoDecodeError


def _make_clip(seconds: int = 3, fps: int = 10, width: int = 320, height: int = 240) -> bytes:
    """An H.264 clip whose frames darken over time, so sampled frames differ."""
    buffer = io.BytesIO()
    with av.open(buffer, "w", format="mp4") as container:
        stream = container.add_stream("libx264", rate=fps)
        stream.width, stream.height, stream.pix_fmt = width, height, "yuv420p"
        total = seconds * fps
        for index in range(total):
            shade = int(index * 255 / total)
            frame = av.VideoFrame.from_image(
                Image.new("RGB", (width, height), (shade, 40, 255 - shade))
            )
            for packet in stream.encode(frame):
                container.mux(packet)
        for packet in stream.encode():
            container.mux(packet)
    return buffer.getvalue()


def test_extracts_the_requested_number_of_jpeg_frames() -> None:
    frames = PyAvFrameExtractor().extract(_make_clip(), "video/mp4", max_frames=4)

    assert len(frames) == 4
    for frame in frames:
        assert frame.content_type == "image/jpeg"
        # JPEG SOI marker -- the bytes really are an encoded image.
        assert frame.image_bytes.startswith(b"\xff\xd8")


def test_samples_across_the_whole_clip_not_just_the_start() -> None:
    frames = PyAvFrameExtractor().extract(_make_clip(seconds=3), "video/mp4", max_frames=4)
    stamps = [frame.timestamp_seconds for frame in frames]

    assert stamps == sorted(stamps)
    assert len(set(stamps)) == len(stamps)
    # A defect appearing late in the recording must still be seen, so the last
    # sample has to come from the back half of a 3-second clip.
    assert stamps[-1] > 1.5
    # Frames are visually distinct, proving different moments were sampled.
    assert len({frame.image_bytes for frame in frames}) == len(frames)


def test_a_clip_shorter_than_the_frame_budget_yields_what_it_has() -> None:
    frames = PyAvFrameExtractor().extract(
        _make_clip(seconds=1, fps=3), "video/mp4", max_frames=25
    )
    assert 0 < len(frames) <= 25


def test_empty_input_is_reported_as_undecodable() -> None:
    with pytest.raises(VideoDecodeError, match="empty"):
        PyAvFrameExtractor().extract(b"", "video/mp4")


def test_non_video_bytes_are_reported_as_undecodable() -> None:
    with pytest.raises(VideoDecodeError):
        PyAvFrameExtractor().extract(b"this is definitely not a video", "video/mp4")


def test_max_frames_must_be_positive() -> None:
    with pytest.raises(ValueError):
        PyAvFrameExtractor().extract(_make_clip(), "video/mp4", max_frames=0)
