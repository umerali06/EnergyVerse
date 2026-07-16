from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from app.api.health import router as health_router
from app.api.v1.auth import router as auth_router
from app.api.v1.rbac_demo import router as rbac_demo_router
from app.core.errors import http_exception_response
from app.core.firebase import initialize_firebase
from app.core.settings import settings


@asynccontextmanager
async def lifespan(_: FastAPI) -> AsyncIterator[None]:
    initialize_firebase()
    yield


app = FastAPI(title="FEV API", version="0.6.0", lifespan=lifespan)
app.add_exception_handler(HTTPException, http_exception_response)
app.add_middleware(
    CORSMiddleware,
    allow_origins=list(settings.cors_origins),
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(health_router)
app.include_router(auth_router)
app.include_router(rbac_demo_router)


@app.get("/")
async def root() -> dict[str, str]:
    return {"service": "fev-api", "status": "ok"}
