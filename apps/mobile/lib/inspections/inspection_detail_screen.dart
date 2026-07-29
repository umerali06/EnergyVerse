import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../dashboard/format.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import '../sync/sync_engine.dart';
import 'inspections_screen.dart' show inspectionStatusFor, inspectionStatusLabel, syncStateBadge;
import 'local_inspections_repository.dart';

/// Offline-first inspection detail (pushed route) -- reads from the local
/// cache reactively, kicks a best-effort background network refresh, and
/// surfaces a conflict-resolution sheet when [LocalSyncState.conflict].
/// The full checklist-filling capture UI is 7.3's job; this screen only
/// ever displays what's cached, plus the conflict/error affordances 7.2
/// itself requires.
class InspectionDetailScreen extends StatefulWidget {
  const InspectionDetailScreen({required this.inspectionId, super.key});

  final String inspectionId;

  @override
  State<InspectionDetailScreen> createState() => _InspectionDetailScreenState();
}

class _InspectionDetailScreenState extends State<InspectionDetailScreen> {
  bool _started = false;
  String? _conflictShownFor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      unawaited(
        SyncProvider.repositoryOf(context).refreshDetailFromNetwork(widget.inspectionId),
      );
    }
  }

  Future<void> _resolveConflict(bool keepLocal) {
    return SyncProvider.repositoryOf(context)
        .resolveConflict(widget.inspectionId, keepLocal: keepLocal);
  }

  Future<void> _maybeShowConflictSheet(LocalInspectionRecord inspection) async {
    if (inspection.syncState != LocalSyncState.conflict) {
      _conflictShownFor = null;
      return;
    }
    if (_conflictShownFor == inspection.id) return;
    _conflictShownFor = inspection.id;
    await _showConflictSheet(inspection);
  }

  Future<void> _showConflictSheet(LocalInspectionRecord inspection) async {
    final server = inspection.conflictServerSnapshot;
    if (!mounted) return;
    await showAppModal<void>(
      context,
      title: 'This inspection changed elsewhere',
      child: _ConflictSheetBody(
        server: server,
        onKeepMine: () {
          Navigator.of(context).pop();
          unawaited(_resolveConflict(true));
        },
        onUseServer: () {
          Navigator.of(context).pop();
          unawaited(_resolveConflict(false));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = SyncProvider.repositoryOf(context);
    return StreamBuilder<LocalInspectionRecord?>(
      stream: repository.watchInspection(widget.inspectionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(DsSpacing.s6),
            child: Column(
              children: [AppSkeleton(height: 32), SizedBox(height: DsSpacing.s3), AppSkeleton(height: 120)],
            ),
          );
        }
        final inspection = snapshot.data;
        if (inspection == null) {
          return Padding(
            padding: const EdgeInsets.all(DsSpacing.s6),
            child: EmptyState(
              action: AppButton(
                label: 'Retry',
                onPressed: () => repository.refreshDetailFromNetwork(widget.inspectionId),
                variant: AppButtonVariant.ghost,
              ),
              description: "This inspection isn't on this device yet. Check your connection and try again.",
              title: "Couldn't find this inspection",
            ),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowConflictSheet(inspection));

        final snapshotItems = inspection.checklistItemsSnapshot;
        final responses = inspection.checklistResponses;
        final badge = syncStateBadge(inspection.syncState);

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
                  label: inspectionStatusLabel(wireToDartEnumName(inspection.status)),
                  status: inspectionStatusFor(wireToDartEnumName(inspection.status)),
                ),
                AppBadge(label: inspectionStatusLabel(wireToDartEnumName(inspection.inspectionType))),
                if (badge != null)
                  InkWell(
                    key: const Key('sync-state-badge'),
                    onTap: inspection.syncState == LocalSyncState.conflict
                        ? () => _showConflictSheet(inspection)
                        : null,
                    child: badge,
                  ),
              ],
            ),
            if (inspection.syncState == LocalSyncState.error && inspection.errorMessage != null) ...[
              const SizedBox(height: DsSpacing.s3),
              Text(
                inspection.errorMessage!,
                style: TextStyle(color: context.semantic.textMuted),
              ),
            ],
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
            if (snapshotItems.isEmpty)
              const Text('No checklist template has been assigned yet.')
            else
              for (final item in snapshotItems)
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
      },
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

class _ConflictSheetBody extends StatelessWidget {
  const _ConflictSheetBody({
    required this.server,
    required this.onKeepMine,
    required this.onUseServer,
  });

  final InspectionDetail? server;
  final VoidCallback onKeepMine;
  final VoidCallback onUseServer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Someone else updated this inspection before your offline changes "
          'synced. Choose which version to keep -- the other will be lost.',
          style: TextStyle(color: context.semantic.textMuted),
        ),
        if (server != null) ...[
          const SizedBox(height: DsSpacing.s4),
          AppCard(
            child: _InfoRow(
              label: 'Server revision',
              value: '${server!.revision}',
            ),
          ),
        ],
        const SizedBox(height: DsSpacing.s5),
        AppButton(
          key: const Key('conflict-keep-mine'),
          label: 'Keep my version',
          onPressed: onKeepMine,
        ),
        const SizedBox(height: DsSpacing.s2),
        AppButton(
          key: const Key('conflict-use-server'),
          label: "Discard mine, use server's",
          onPressed: onUseServer,
          variant: AppButtonVariant.ghost,
        ),
      ],
    );
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
