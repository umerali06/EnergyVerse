"""Render deterministic report-export samples for local visual verification."""

from datetime import UTC, datetime
from pathlib import Path

from app.models.entities import GeneratedReport, ReportNarrative
from app.reports.renderers import RENDERERS


def main() -> None:
    output_dir = Path("tmp/report-export-qa")
    output_dir.mkdir(parents=True, exist_ok=True)
    timestamp = datetime(2026, 8, 20, 10, 30, tzinfo=UTC)
    report = GeneratedReport(
        id="report-qa-001",
        company_id="company-qa",
        created_at=timestamp,
        updated_at=timestamp,
        created_by="inspector-qa",
        report_type="executive_summary",
        title="North Processing Facility — Weekly Safety Summary",
        status="finalized",
        source_snapshot={
            "facility": {"name": "North Processing Facility", "region": "Sindh"},
            "period": {"start": "2026-08-13", "end": "2026-08-20"},
            "metrics": {
                "inspections_completed": 18,
                "open_high_risk_findings": 2,
                "overdue_work_orders": 3,
                "permit_compliance_percent": 96.4,
            },
            "priority_assets": ["Compressor C-104", "Separator V-208"],
        },
        narrative=ReportNarrative(
            summary=(
                "Operations remained stable during the reporting period. Two high-risk "
                "findings require verified corrective action before the affected equipment "
                "returns to unrestricted service."
            ),
            findings=[
                "Compressor C-104 showed abnormal seal wear during the scheduled inspection.",
                "Separator V-208 has an overdue pressure-relief valve verification.",
                "Permit-to-work compliance improved to 96.4 percent.",
            ],
            recommendations=[
                "Keep Compressor C-104 under restricted operation until maintenance sign-off.",
                "Complete and independently verify the V-208 valve test within 24 hours.",
                "Review the three overdue work orders at the next shift handover.",
            ],
            risk_score=68.0,
        ),
        ai_model="claude-enterprise-advisory",
        finalized_by="hse-manager-qa",
        finalized_at=timestamp,
        finalization_attestation=True,
    )
    for extension, renderer in RENDERERS.items():
        (output_dir / f"finalized-report.{extension}").write_bytes(renderer(report))


if __name__ == "__main__":
    main()
