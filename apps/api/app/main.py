from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware

from app.api.health import router as health_router
from app.api.v1.areas import router as areas_router
from app.api.v1.assets import router as assets_router
from app.api.v1.audit import router as audit_router
from app.api.v1.auth import router as auth_router
from app.api.v1.company import router as company_router
from app.api.v1.dashboard import router as dashboard_router
from app.api.v1.facilities import router as facilities_router
from app.api.v1.permissions import router as permissions_router
from app.api.v1.platform import router as platform_router
from app.api.v1.rbac_demo import router as rbac_demo_router
from app.api.v1.roles import router as roles_router
from app.api.v1.users import router as users_router
from app.core.errors import (
    ApiError,
    api_error_response,
    http_exception_response,
    unhandled_exception_response,
    validation_exception_response,
)
from app.core.firebase import initialize_firebase
from app.core.request_id import RequestIdMiddleware
from app.core.settings import settings
from app.models.api import ServiceResponse, error_responses


@asynccontextmanager
async def lifespan(_: FastAPI) -> AsyncIterator[None]:
    initialize_firebase()
    yield


app = FastAPI(
    title="FEV API",
    version="0.8.0",
    description=(
        "Flacron EnergyVerse API. Single resources are returned directly. Future list "
        "responses use `{items: [...], next_cursor: string | null}`; cursors are opaque, "
        "`null` means no more pages, and totals are not returned by default."
    ),
    lifespan=lifespan,
    openapi_tags=[
        {"name": "system", "description": "Service status and diagnostics"},
        {"name": "auth", "description": "Authenticated identity"},
        {"name": "rbac-demo", "description": "Temporary RBAC contract proof routes"},
        {"name": "dashboard", "description": "Real-tenant dashboard summary, activity, and series"},
        {"name": "users", "description": "Company-scoped user management"},
        {"name": "roles", "description": "Company-scoped role and permission-set management"},
        {"name": "permissions", "description": "Global permission catalog, grouped by category"},
        {"name": "facilities", "description": "Company-scoped facility management"},
        {"name": "areas", "description": "Company-scoped area management, nested under a facility"},
        {
            "name": "assets",
            "description": "Company-scoped asset management, nested under a facility and area",
        },
        {"name": "company", "description": "Company profile, branding, and tenant-wide settings"},
        {"name": "audit", "description": "Company audit trail — read-only compliance view"},
        {
            "name": "platform",
            "description": "Super-Admin cross-tenant platform administration (platform.admin only)",
        },
    ],
)
app.add_exception_handler(ApiError, api_error_response)
app.add_exception_handler(HTTPException, http_exception_response)
app.add_exception_handler(RequestValidationError, validation_exception_response)
app.add_exception_handler(Exception, unhandled_exception_response)
app.add_middleware(
    CORSMiddleware,
    allow_origins=list(settings.cors_origins),
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.add_middleware(RequestIdMiddleware)
app.include_router(health_router)
app.include_router(auth_router)
app.include_router(dashboard_router)
app.include_router(rbac_demo_router)
app.include_router(users_router)
app.include_router(roles_router)
app.include_router(permissions_router)
app.include_router(facilities_router)
app.include_router(areas_router)
app.include_router(assets_router)
app.include_router(company_router)
app.include_router(audit_router)
app.include_router(platform_router)


@app.get(
    "/",
    response_model=ServiceResponse,
    operation_id="get_root",
    tags=["system"],
    responses=error_responses(500),
)
async def root() -> ServiceResponse:
    return ServiceResponse(service="fev-api", status="ok")
