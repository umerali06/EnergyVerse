from collections.abc import Mapping
from typing import Annotated, Any

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from app.auth.verifier import TokenVerificationError, TokenVerifier, get_token_verifier
from app.db.repositories.companies import CompanyRepository
from app.db.repositories.permissions import PermissionRepository
from app.db.repositories.role_permissions import RolePermissionRepository
from app.db.repositories.roles import RoleRepository
from app.db.repositories.users import UserRepository
from app.models.base import CompanyScope
from app.models.entities import CurrentUser
from app.rbac.service import PermissionResolver

bearer_scheme = HTTPBearer(auto_error=False)


async def verify_token(
    credentials: Annotated[
        HTTPAuthorizationCredentials | None,
        Depends(bearer_scheme),
    ],
    verifier: Annotated[TokenVerifier, Depends(get_token_verifier)],
) -> Mapping[str, Any]:
    if credentials is None or credentials.scheme.lower() != "bearer":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={
                "error": "missing_token",
                "message": "Bearer token is required",
            },
            headers={"WWW-Authenticate": "Bearer"},
        )
    try:
        return await verifier.verify(credentials.credentials)
    except TokenVerificationError as error:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={
                "error": error.code,
                "message": str(error),
            },
            headers={"WWW-Authenticate": "Bearer"},
        ) from error


async def get_current_user(
    decoded_token: Annotated[Mapping[str, Any], Depends(verify_token)],
) -> CurrentUser:
    uid = decoded_token.get("uid") or decoded_token.get("sub")
    company_id = decoded_token.get("company_id")
    if not isinstance(uid, str) or not uid or not isinstance(company_id, str) or not company_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": "identity_not_provisioned",
                "message": "User identity is incomplete",
            },
        )

    scope = CompanyScope(company_id=company_id)
    users = UserRepository()
    user = await users.get(scope, uid)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": "user_not_found",
                "message": "User is not provisioned",
            },
        )
    if user.status != "active":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": "user_inactive",
                "message": "User is inactive",
            },
        )

    roles = RoleRepository()
    role = await roles.get(scope, user.role_id)
    if role is None:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": "role_not_found",
                "message": "User role is unavailable",
            },
        )

    company = await CompanyRepository().get(scope)
    if company is None:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": "company_not_found",
                "message": "Company is unavailable",
            },
        )
    resolver = PermissionResolver(
        users,
        roles,
        RolePermissionRepository(),
        PermissionRepository(),
    )
    try:
        permissions = await resolver.resolve_for_user(scope, uid)
    except LookupError as error:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": "permissions_unavailable",
                "message": str(error),
            },
        ) from error

    return CurrentUser(
        uid=uid,
        email=user.email,
        email_verified=decoded_token.get("email_verified") is True,
        company_id=user.company_id,
        company_name=company.name,
        role_key=role.key,
        permissions=permissions,
    )


async def require_verified_email(
    current_user: Annotated[CurrentUser, Depends(get_current_user)],
) -> CurrentUser:
    """Allow identity resolution while blocking application work before verification."""
    if not current_user.email_verified:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "error": "email_unverified",
                "message": "Email verification is required",
            },
        )
    return current_user
