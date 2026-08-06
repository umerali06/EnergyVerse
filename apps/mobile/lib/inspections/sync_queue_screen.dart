import 'package:flutter/material.dart';

import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import '../sync/sync_engine.dart';
import 'local_inspections_repository.dart';

String _mutationLabel(OutboxMutationType type) => switch (type) {
      OutboxMutationType.create => 'Create',
      OutboxMutationType.update => 'Update',
      OutboxMutationType.start => 'Start',
      OutboxMutationType.complete => 'Complete',
      OutboxMutationType.cancel => 'Cancel',
      OutboxMutationType.assignTemplate => 'Assign checklist template',
      OutboxMutationType.attachMedia => 'Attach media',
      OutboxMutationType.editMedia => 'Edit media',
      OutboxMutationType.detachMedia => 'Detach media',
      OutboxMutationType.attachVoiceNote => 'Attach voice note',
      OutboxMutationType.editVoiceNote => 'Edit voice note',
      OutboxMutationType.detachVoiceNote => 'Detach voice note',
      OutboxMutationType.createAnnotation => 'Add annotation',
      OutboxMutationType.updateAnnotation => 'Edit annotation',
      OutboxMutationType.deleteAnnotation => 'Delete annotation',
    };

/// The pending-mutation queue: every outbox row with its mutation type,
/// attempt count, and last error, plus manual "Sync now" and per-item
/// retry/discard. Reachable from InspectionsScreen's app-bar action.
class SyncQueueScreen extends StatelessWidget {
  const SyncQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sync = SyncProvider.engineOf(context);
    final repository = SyncProvider.repositoryOf(context);
    return StreamBuilder<List<OutboxItemRecord>>(
      stream: repository.watchOutbox(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const [];
        return ListView(
          padding: const EdgeInsets.all(DsSpacing.s6),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sync queue', style: Theme.of(context).textTheme.headlineMedium),
                AnimatedBuilder(
                  animation: sync,
                  builder: (context, _) => AppButton(
                    key: const Key('sync-now'),
                    label: 'Sync now',
                    icon: Icons.sync,
                    loading: sync.isDraining,
                    onPressed: items.isEmpty ? null : sync.syncNow,
                    variant: AppButtonVariant.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DsSpacing.s2),
            Text(
              'Changes made offline replay here, one at a time, as soon as a '
              'connection is available.',
              style: TextStyle(color: context.semantic.textMuted),
            ),
            const SizedBox(height: DsSpacing.s5),
            if (items.isEmpty)
              const EmptyState(
                title: 'Nothing pending',
                description: 'Every change on this device has synced.',
              )
            else
              for (final item in items)
                _OutboxRow(key: ValueKey(item.id), item: item, repository: repository),
          ],
        );
      },
    );
  }
}

class _OutboxRow extends StatelessWidget {
  const _OutboxRow({required this.item, required this.repository, super.key});

  final OutboxItemRecord item;
  final LocalInspectionsRepository repository;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DsSpacing.s3),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _mutationLabel(item.mutationType),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (item.attempts > 0) AppBadge(label: '${item.attempts} attempt(s)'),
              ],
            ),
            const SizedBox(height: DsSpacing.s1),
            Text(
              item.inspectionId,
              style: TextStyle(
                fontFamily: DsTypography.mono,
                fontSize: DsTypography.sizeCaption,
                color: context.semantic.textMuted,
              ),
            ),
            if (item.lastError != null) ...[
              const SizedBox(height: DsSpacing.s2),
              Text(
                item.lastError!,
                style: TextStyle(color: context.semantic.textMuted),
              ),
            ],
            const SizedBox(height: DsSpacing.s3),
            Row(
              children: [
                AppButton(
                  key: Key('retry-${item.id}'),
                  label: 'Retry',
                  onPressed: () => repository.retryOutboxItem(item.id),
                  variant: AppButtonVariant.ghost,
                ),
                const SizedBox(width: DsSpacing.s2),
                AppButton(
                  key: Key('discard-${item.id}'),
                  label: 'Discard',
                  onPressed: () => repository.discardOutboxItem(item.id),
                  variant: AppButtonVariant.ghost,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
