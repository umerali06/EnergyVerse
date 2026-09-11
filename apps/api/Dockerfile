# Multi-stage build for the FastAPI backend.
#
# Stage 1 resolves dependencies with Poetry and exports them into a plain
# virtualenv. Stage 2 copies only that virtualenv and the application source, so
# Poetry, build tooling and the dependency cache never reach the running image.
#
# PyAV and Pillow ship manylinux wheels, so no ffmpeg or image libraries need to
# be installed here -- PyAV bundles its own ffmpeg. If a future dependency has no
# wheel, add its build dependencies to the builder stage only, never to runtime.

# ---------- builder ----------
FROM python:3.11-slim AS builder

ENV PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    POETRY_VERSION=2.4.1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_NO_INTERACTION=1

WORKDIR /app

# Pinned to the version that generated poetry.lock (lock-version 2.1).
# An older Poetry refuses to read a newer lock file, which fails the build
# in a way that looks like a dependency problem rather than a version one.
RUN pip install "poetry==${POETRY_VERSION}"

# Copy only the manifests first so the dependency layer is cached and does not
# rebuild every time application source changes.
COPY pyproject.toml poetry.lock ./

# --only main skips the dev group (pytest, ruff, mypy): none of it belongs in a
# production image, and leaving it out keeps the image smaller and the attack
# surface narrower.
RUN poetry install --only main --no-root

# ---------- runtime ----------
FROM python:3.11-slim AS runtime

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH="/app/.venv/bin:$PATH"

# Run as a non-root user. The container has no reason to write anywhere outside
# its own tree, and ECS will not grant it anything more.
RUN useradd --create-home --shell /usr/sbin/nologin --uid 10001 appuser

WORKDIR /app

COPY --from=builder /app/.venv /app/.venv
COPY --chown=appuser:appuser app ./app
COPY --chown=appuser:appuser scripts ./scripts
COPY --chown=appuser:appuser pyproject.toml ./

USER appuser

EXPOSE 8000

# The ALB target group also health-checks /health; this one lets ECS replace a
# task whose process is alive but whose dependencies (Firestore) are not.
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
    CMD python -c "import urllib.request,sys; sys.exit(0 if urllib.request.urlopen('http://127.0.0.1:8000/health', timeout=4).status == 200 else 1)"

# One worker per task: scale by raising the ECS desired count rather than by
# adding workers inside a container, so each unit of capacity is independently
# replaceable and observable.
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1", "--proxy-headers", "--forwarded-allow-ips", "*"]
