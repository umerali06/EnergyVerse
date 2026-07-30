import 'package:flutter/material.dart';

import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../dashboard/format.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import '../auth/app_routes.dart';
import '../sync/sync_engine.dart';
import 'inspections_controller.dart';
import 'local_inspections_repository.dart';

// Takes the *Dart* enum identifier (`status.name`/`inspectionType.name`,
// e.g. "inProgress", "adHoc") -- built_value enums expose the Dart-side
// camelCase name here, not the snake_case wire value. Local records store
// wire values (`wireToDartEnumName` converts before calling these).
AppStatus inspectionStatusFor(String status) => switch (status) {
      'completed' => AppStatus.healthy,
      'inProgress' => AppStatus.warning,
      'cancelled' => AppStatus.critical,
      _ => AppStatus.info,
    };

String inspectionStatusLabel(String camelCaseName) {
  final spaced = camelCaseName.replaceAllMapped(
    RegExp('([A-Z])'),
    (match) => ' ${match.group(1)}',
  );
  return spaced
      .trim()
      .split(' ')
      .map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

/// A sync-state badge for a locally-cached inspection, or `null` when
/// `synced` (no extra badge needed for the common case).
Widget? syncStateBadge(LocalSyncState state) => switch (state) {
      LocalSyncState.localOnly => const StatusPill(label: 'Local only', status: AppStatus.info),
      LocalSyncState.pendingSync => const StatusPill(label: 'Pending sync', status: AppStatus.info),
      LocalSyncState.conflict => const StatusPill(label: 'Conflict', status: AppStatus.critical),
      LocalSyncState.error => const StatusPill(label: 'Sync error', status: AppStatus.critical),
      LocalSyncState.synced => null,
    };

/// Inspection directory. Detail is a pushed route (inspection_detail_screen.dart),
/// mirroring the asset detail's departure from the bottom-sheet convention.
class InspectionsScreen extends StatefulWidget {
  const InspectionsScreen({super.key});

  @override
  State<InspectionsScreen> createState() => _InspectionsScreenState();
}

class _InspectionsScreenState extends State<InspectionsScreen> {
  InspectionsController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= InspectionsController(
      repository: SyncProvider.repositoryOf(context),
    )..start();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _openDetail(String inspectionId) {
    Navigator.of(context).pushNamed(AppRoutes.inspectionDetail, arguments: inspectionId);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return ListView(
          key: const Key('inspections-scroll'),
          padding: const EdgeInsets.all(DsSpacing.s6),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Inspections', style: Theme.of(context).textTheme.headlineMedium),
                _PendingQueueLink(
                  key: const Key('open-sync-queue'),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.inspectionSyncQueue),
                ),
              ],
            ),
            const SizedBox(height: DsSpacing.s2),
            Text(
              'Every inspection recorded on this device, online or off.',
              style: TextStyle(color: context.semantic.textMuted),
            ),
            const SizedBox(height: DsSpacing.s5),
            AppSelect<String?>(
              items: const [
                DropdownMenuItem(value: null, child: Text('All statuses')),
                DropdownMenuItem(value: 'draft', child: Text('Draft')),
                DropdownMenuItem(value: 'in_progress', child: Text('In progress')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
              ],
              label: 'Status',
              onChanged: controller.setStatusFilter,
              value: controller.status,
            ),
            const SizedBox(height: DsSpacing.s5),
            if (controller.listStatus == LoadStatus.loading) ...[
              const AppSkeleton(height: 72),
              const SizedBox(height: DsSpacing.s3),
              const AppSkeleton(height: 72),
            ] else if (controller.listStatus == LoadStatus.error)
              EmptyState(
                action: AppButton(
                  label: 'Retry',
                  onPressed: controller.retry,
                  variant: AppButtonVariant.ghost,
                ),
                description: "Couldn't load inspections. Check your connection and try again.",
                title: 'Something went wrong',
              )
            else if (controller.items.isEmpty)
              const EmptyState(
                description: 'No inspections match your current filters.',
                title: 'No inspections found',
              )
            else
              for (final inspection in controller.items)
                _InspectionRow(
                  key: ValueKey(inspection.id),
                  inspection: inspection,
                  onTap: () => _openDetail(inspection.id),
                ),
          ],
        );
      },
    );
  }
}

class _PendingQueueLink extends StatelessWidget {
  const _PendingQueueLink({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final sync = SyncProvider.engineOf(context);
    return AnimatedBuilder(
      animation: sync,
      builder: (context, _) {
        final pending = sync.pendingOutboxCount;
        if (pending == 0) {
          return IconButton(
            tooltip: 'Sync queue',
            icon: const Icon(Icons.sync_outlined),
            onPressed: onPressed,
          );
        }
        return TextButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.sync_problem_outlined, size: 18),
          label: Text('$pending pending'),
        );
      },
    );
  }
}

class _InspectionRow extends StatelessWidget {
  const _InspectionRow({required this.inspection, required this.onTap, super.key});

  final LocalInspectionRecord inspection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final badge = syncStateBadge(inspection.syncState);
    return Padding(
      padding: const EdgeInsets.only(bottom: DsSpacing.s3),
      child: AppCard(
        child: InkWell(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inspection.title ?? 'Untitled',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      inspection.inspectorId,
                      style: TextStyle(
                        fontFamily: DsTypography.mono,
                        fontSize: DsTypography.sizeCaption,
                        color: context.semantic.textMuted,
                      ),
                    ),
                    const SizedBox(height: DsSpacing.s2),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: DsSpacing.s2,
                      children: [
                        AppBadge(
                          label: inspectionStatusLabel(wireToDartEnumName(inspection.inspectionType)),
                        ),
                        StatusPill(
                          label: inspectionStatusLabel(wireToDartEnumName(inspection.status)),
                          status: inspectionStatusFor(wireToDartEnumName(inspection.status)),
                        ),
                        if (badge != null) badge,
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DsSpacing.s2),
              Text(
                formatRelativeTime(inspection.updatedAt),
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
    );
  }
}
