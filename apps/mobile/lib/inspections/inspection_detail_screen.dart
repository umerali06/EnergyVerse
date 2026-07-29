import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../auth/auth_controller.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../dashboard/format.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import 'inspections_screen.dart' show inspectionStatusFor, inspectionStatusLabel;

/// Read-only inspection detail (pushed route) -- lifecycle summary plus the
/// checklist snapshot/responses. The full checklist-filling capture UI is
/// 7.3's job; this screen only ever displays what the API already holds.
class InspectionDetailScreen extends StatefulWidget {
  const InspectionDetailScreen({required this.inspectionId, super.key});

  final String inspectionId;

  @override
  State<InspectionDetailScreen> createState() => _InspectionDetailScreenState();
}

class _InspectionDetailScreenState extends State<InspectionDetailScreen> {
  LoadStatus _status = LoadStatus.loading;
  InspectionDetail? _inspection;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      _load();
    }
  }

  void _load() {
    setState(() => _status = LoadStatus.loading);
    AuthProvider.of(context)
        .api
        .getInspection(widget.inspectionId)
        .then((inspection) {
          if (!mounted) return;
          setState(() {
            _inspection = inspection;
            _status = LoadStatus.ready;
          });
        })
        .catchError((_) {
          if (!mounted) return;
          setState(() => _status = LoadStatus.error);
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_status == LoadStatus.loading) {
      return const Padding(
        padding: EdgeInsets.all(DsSpacing.s6),
        child: Column(
          children: [AppSkeleton(height: 32), SizedBox(height: DsSpacing.s3), AppSkeleton(height: 120)],
        ),
      );
    }
    final inspection = _inspection;
    if (_status == LoadStatus.error || inspection == null) {
      return Padding(
        padding: const EdgeInsets.all(DsSpacing.s6),
        child: EmptyState(
          action: AppButton(label: 'Retry', onPressed: _load, variant: AppButtonVariant.ghost),
          description: "Couldn't load this inspection. Check your connection and try again.",
          title: 'Something went wrong',
        ),
      );
    }

    final snapshot = inspection.checklistItemsSnapshot?.toList() ?? const [];
    final responses = inspection.checklistResponses?.toList() ?? const [];

    return ListView(
      padding: const EdgeInsets.all(DsSpacing.s6),
      children: [
        Text(
          inspection.title ?? 'Untitled inspection',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: DsSpacing.s2),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: DsSpacing.s2,
          children: [
            StatusPill(
              label: inspectionStatusLabel(inspection.status.name),
              status: inspectionStatusFor(inspection.status.name),
            ),
            AppBadge(label: inspectionStatusLabel(inspection.inspectionType.name)),
          ],
        ),
        const SizedBox(height: DsSpacing.s5),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(label: 'Asset', value: inspection.assetId),
              _InfoRow(label: 'Inspector', value: inspection.inspectorId),
              _InfoRow(
                label: 'Started',
                value: inspection.startedAt != null
                    ? formatCompanyDateTime(inspection.startedAt!)
                    : '—',
              ),
              _InfoRow(
                label: 'Completed',
                value: inspection.completedAt != null
                    ? formatCompanyDateTime(inspection.completedAt!)
                    : '—',
              ),
            ],
          ),
        ),
        if (inspection.notes != null && inspection.notes!.isNotEmpty) ...[
          const SizedBox(height: DsSpacing.s4),
          Text('NOTES', style: TextStyle(color: context.semantic.textMuted, letterSpacing: 1)),
          const SizedBox(height: DsSpacing.s1),
          Text(inspection.notes!),
        ],
        const SizedBox(height: DsSpacing.s4),
        Text('CHECKLIST', style: TextStyle(color: context.semantic.textMuted, letterSpacing: 1)),
        const SizedBox(height: DsSpacing.s2),
        if (snapshot.isEmpty)
          const Text('No checklist template has been assigned yet.')
        else
          for (final item in snapshot)
            Padding(
              padding: const EdgeInsets.only(bottom: DsSpacing.s2),
              child: AppCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.required_ ? '${item.label} (required)' : item.label,
                      ),
                    ),
                    Text(
                      _responseFor(responses, item.id),
                      style: TextStyle(
                        fontFamily: DsTypography.mono,
                        fontSize: DsTypography.sizeCaption,
                        color: context.semantic.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  String _responseFor(List<ChecklistResponse> responses, String itemId) {
    final match = responses.where((response) => response.itemId == itemId);
    if (match.isEmpty) return 'Not answered';
    final value = match.first.value;
    if (value == null) return 'Not answered';
    final raw = value.anyOf.values.values.firstWhere(
      (candidate) => candidate != null,
      orElse: () => null,
    );
    return raw == null ? 'Not answered' : raw.toString();
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DsSpacing.s1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
