import asyncio
from typing import Any

import pytest
from fastapi.testclient import TestClient

from app.audit.service import AuditService
from app.auth.dependencies import get_current_user
from app.db.repositories.audit_logs import AuditLogRepository
from app.db.repositories.training import TrainingModuleRepository, TrainingProgressRepository
from app.main import app
from app.models.entities import CurrentUser
from app.rbac.constants import SYSTEM_ROLE_TEMPLATES
from app.rbac.dependencies import get_access_denial_audit
from app.training.service import TrainingService, get_training_service
from scripts.seed import ACME_COMPANY_ID, run_seed
from tests.fakes.firestore import FakeAsyncClient

BETA_COMPANY_ID = "beta-utilities"

ORIENTATION_ID = f"{ACME_COMPANY_ID}__training__facility-orientation"
LOCATION_ID = f"{ACME_COMPANY_ID}__training__equipment-location"
LOTO_ID = f"{ACME_COMPANY_ID}__training__loto-procedure"


@pytest.fixture()
def wiring() -> Any:
    client = FakeAsyncClient()
    asyncio.run(run_seed(client))

    audit = AuditService(AuditLogRepository(client))
    service = TrainingService(
        modules=TrainingModuleRepository(client, audit),
        progress=TrainingProgressRepository(client, audit),
    )
    app.dependency_overrides[get_training_service] = lambda: service
    app.dependency_overrides[get_access_denial_audit] = lambda: audit
    yield {"client": client, "service": service}
    app.dependency_overrides.pop(get_training_service, None)
    app.dependency_overrides.pop(get_access_denial_audit, None)


def _identity(uid: str = "trainee-1", company_id: str = ACME_COMPANY_ID) -> CurrentUser:
    return CurrentUser(
        uid=uid,
        email=f"{uid}@acme.example.invalid",
        email_verified=True,
        company_id=company_id,
        company_name="Acme Energy",
        role_key="company_admin",
        permissions=frozenset(SYSTEM_ROLE_TEMPLATES["company_admin"].permission_keys),
    )


def _request(identity: CurrentUser, method: str, path: str, **kwargs: Any) -> Any:
    app.dependency_overrides[get_current_user] = lambda: identity
    try:
        with TestClient(app) as client:
            return client.request(method, path, **kwargs)
    finally:
        app.dependency_overrides.pop(get_current_user, None)


def _start(identity: CurrentUser, module_id: str) -> Any:
    return _request(identity, "POST", f"/api/v1/training/modules/{module_id}/start")


def _complete_step(
    identity: CurrentUser, module_id: str, step_id: str, correct: bool | None = None
) -> Any:
    return _request(
        identity,
        "POST",
        f"/api/v1/training/modules/{module_id}/steps/{step_id}/complete",
        json={"correct": correct},
    )


def _complete(identity: CurrentUser, module_id: str) -> Any:
    return _request(identity, "POST", f"/api/v1/training/modules/{module_id}/complete")


def test_seed_provides_a_module_for_every_required_competency(wiring: Any) -> None:
    body = _request(_identity(), "GET", "/api/v1/training/modules").json()

    kinds = {module["kind"] for module in body["items"]}
    # The five competencies the requirements name.
    assert kinds == {
        "exploration",
        "equipment_location",
        "safety_procedure",
        "emergency_drill",
        "maintenance_simulation",
    }


def test_modules_bind_to_real_facility_assets(wiring: Any) -> None:
    body = _request(_identity(), "GET", f"/api/v1/training/modules/{LOCATION_ID}").json()

    targets = [step["target_asset_id"] for step in body["steps"]]
    # Training runs against the tenant's own equipment, never a mock-up.
    assert all(target and target.startswith(f"{ACME_COMPANY_ID}__asset__") for target in targets)


def test_steps_are_returned_in_order(wiring: Any) -> None:
    body = _request(_identity(), "GET", f"/api/v1/training/modules/{LOTO_ID}").json()

    orders = [step["order"] for step in body["steps"]]
    assert orders == sorted(orders)


def test_the_correct_answer_is_never_sent_to_the_client(wiring: Any) -> None:
    body = _request(_identity(), "GET", f"/api/v1/training/modules/{LOTO_ID}").json()

    choose_steps = [step for step in body["steps"] if step["action"] == "choose"]
    assert choose_steps, "this module should have a scored multiple-choice step"
    for step in choose_steps:
        assert step["options"], "the options must still be offered"
        # Sending the answer would make every scored step trivially passable.
        assert "correct_option" not in step


def test_modules_are_tenant_isolated(wiring: Any) -> None:
    response = _request(
        _identity(company_id=BETA_COMPANY_ID), "GET", f"/api/v1/training/modules/{LOTO_ID}"
    )
    assert response.status_code == 404


def test_starting_twice_resumes_the_same_attempt(wiring: Any) -> None:
    first = _start(_identity(), ORIENTATION_ID).json()
    second = _start(_identity(), ORIENTATION_ID).json()

    # A dropped headset connection must resume, not lose the run.
    assert first["id"] == second["id"]
    assert second["attempts"] == 1


def test_restarting_after_completion_opens_a_new_attempt(wiring: Any) -> None:
    _start(_identity(), ORIENTATION_ID)
    _complete(_identity(), ORIENTATION_ID)

    retake = _start(_identity(), ORIENTATION_ID).json()

    # Competency lapses, so a retake is a fresh attempt and the earlier result
    # stays in history.
    assert retake["attempts"] == 2
    assert retake["status"] == "in_progress"
    history = _request(
        _identity(), "GET", "/api/v1/training/progress", params={"module_id": ORIENTATION_ID}
    ).json()
    assert len(history["items"]) == 2


def test_recording_a_step_before_starting_is_rejected(wiring: Any) -> None:
    response = _complete_step(_identity(), ORIENTATION_ID, "step-orientation-entry")
    assert response.status_code == 409
    assert response.json()["error"] == "training_not_started"


def test_unknown_step_is_rejected(wiring: Any) -> None:
    _start(_identity(), ORIENTATION_ID)
    response = _complete_step(_identity(), ORIENTATION_ID, "step-does-not-exist")
    assert response.status_code == 404
    assert response.json()["error"] == "training_step_not_found"


def test_only_scored_actions_count_towards_the_score(wiring: Any) -> None:
    _start(_identity(), ORIENTATION_ID)

    body = _complete_step(_identity(), ORIENTATION_ID, "step-orientation-entry").json()

    # `observe` is a progress marker, not something that can be answered wrongly.
    assert body["completed_step_ids"] == ["step-orientation-entry"]
    assert body["scored_count"] == 0


def test_a_scored_step_counts(wiring: Any) -> None:
    _start(_identity(), LOCATION_ID)

    body = _complete_step(_identity(), LOCATION_ID, "step-locate-p101", correct=True).json()

    assert body["scored_count"] == 1
    assert body["correct_count"] == 1


def test_replaying_a_step_does_not_double_count(wiring: Any) -> None:
    _start(_identity(), LOCATION_ID)
    _complete_step(_identity(), LOCATION_ID, "step-locate-p101", correct=True)

    body = _complete_step(_identity(), LOCATION_ID, "step-locate-p101", correct=True).json()

    # A headset reconnecting may resend the last step it managed to report.
    assert body["scored_count"] == 1
    assert body["correct_count"] == 1


def test_a_module_with_no_scored_steps_passes_on_completion(wiring: Any) -> None:
    _start(_identity(), ORIENTATION_ID)
    for step_id in (
        "step-orientation-entry",
        "step-orientation-process-unit",
        "step-orientation-tank-farm",
        "step-orientation-muster",
    ):
        _complete_step(_identity(), ORIENTATION_ID, step_id)

    body = _complete(_identity(), ORIENTATION_ID).json()

    # Nothing here can be answered wrongly; the evidence is that the trainee
    # walked the facility.
    assert body["status"] == "completed"
    assert body["score"] == 100


def test_falling_below_the_threshold_fails_the_attempt(wiring: Any) -> None:
    _start(_identity(), LOCATION_ID)
    _complete_step(_identity(), LOCATION_ID, "step-locate-p101", correct=True)
    _complete_step(_identity(), LOCATION_ID, "step-locate-t301", correct=False)
    _complete_step(_identity(), LOCATION_ID, "step-locate-v401", correct=False)
    _complete_step(_identity(), LOCATION_ID, "step-locate-m501", correct=False)

    body = _complete(_identity(), LOCATION_ID).json()

    assert body["score"] == 25
    # A completion record has to mean competency, not attendance.
    assert body["status"] == "failed"


def test_meeting_the_threshold_passes_the_attempt(wiring: Any) -> None:
    _start(_identity(), LOCATION_ID)
    for step_id in (
        "step-locate-p101",
        "step-locate-t301",
        "step-locate-v401",
    ):
        _complete_step(_identity(), LOCATION_ID, step_id, correct=True)
    _complete_step(_identity(), LOCATION_ID, "step-locate-m501", correct=False)

    body = _complete(_identity(), LOCATION_ID).json()

    assert body["score"] == 75
    assert body["status"] == "completed"


def test_progress_is_personal(wiring: Any) -> None:
    _start(_identity("trainee-1"), ORIENTATION_ID)

    other = _request(_identity("trainee-2"), "GET", "/api/v1/training/progress").json()

    assert other["items"] == []


def test_filtering_modules_by_kind(wiring: Any) -> None:
    body = _request(
        _identity(), "GET", "/api/v1/training/modules", params={"kind": "emergency_drill"}
    ).json()

    assert len(body["items"]) == 1
    assert body["items"][0]["kind"] == "emergency_drill"


def test_a_choose_step_is_scored_against_the_server_side_answer(wiring: Any) -> None:
    _start(_identity(), LOTO_ID)

    body = _request(
        _identity(),
        "POST",
        f"/api/v1/training/modules/{LOTO_ID}/steps/step-loto-first-action/complete",
        json={"selected_option": "Notify the control room and request shutdown"},
    ).json()

    assert body["scored_count"] == 1
    assert body["correct_count"] == 1


def test_a_wrong_choice_scores_zero(wiring: Any) -> None:
    _start(_identity(), LOTO_ID)

    body = _request(
        _identity(),
        "POST",
        f"/api/v1/training/modules/{LOTO_ID}/steps/step-loto-first-action/complete",
        json={"selected_option": "Remove the coupling guard"},
    ).json()

    assert body["scored_count"] == 1
    assert body["correct_count"] == 0


def test_a_client_cannot_declare_its_own_choice_correct(wiring: Any) -> None:
    _start(_identity(), LOTO_ID)

    body = _request(
        _identity(),
        "POST",
        f"/api/v1/training/modules/{LOTO_ID}/steps/step-loto-first-action/complete",
        # A tampered client claiming success on the wrong answer.
        json={"selected_option": "Drain the casing", "correct": True},
    ).json()

    # `correct` is ignored for `choose` steps; trusting it would make every
    # multiple-choice step trivially passable.
    assert body["correct_count"] == 0
