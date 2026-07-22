import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../auth/auth_controller.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../dashboard/format.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import 'audit_controller.dart';

Map<String, dynamic> _plainMetadata(BuiltMap<String, JsonObject?>? metadata) {
  if (metadata == null) return const {};
  return {for (final entry in metadata.entries) entry.key: entry.value?.value};
}

String _formatValue(dynamic value, {int indent = 0}) {
  final pad = '  ' * indent;
  if (value is Map) {
    if (value.isEmpty) return '$pad(empty)';
    return value.entries
        .map((entry) => '$pad${entry.key}: ${_formatValue(entry.value, indent: indent + 1).trimLeft()}')
        .join('\n');
  }
  if (value is List) {
    if (value.isEmpty) return '$pad(none)';
    return value.map((item) => '$pad- ${_formatValue(item).trimLeft()}').join('\n');
  }
  return '$pad$value';
}

/// Company audit trail, read-only on mobile (CSV export remains
/// admin-web-only for this phase -- see DECISIONS.md).
class AuditScreen extends StatefulWidget {
  const AuditScreen({super.key});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  AuditController? _controller;
  final _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= AuditController(api: AuthProvider.of(context).api)..start();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final controller = _controller;
    if (controller == null) return;
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: DateTimeRange(start: controller.fromDate, end: controller.toDate),
    );
    if (picked != null) {
      await controller.setDateRange(picked.start, picked.end);
    }
  }

  void _openDetail(AuditLogEntry entry) {
    showAppModal<void>(
      context,
      title: 'Event details',
      child: _AuditDetailBody(entry: entry),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => ListView(
        key: const Key('audit-scroll'),
        padding: const EdgeInsets.all(DsSpacing.s6),
        children: [
          Text('Audit Log', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: DsSpacing.s2),
          Text(
            'The complete, filterable record of every change made in your company.',
            style: TextStyle(color: context.semantic.textMuted),
          ),
          const SizedBox(height: DsSpacing.s5),
          AppButton(
            label:
                '${formatCompanyDate(controller.fromDate)} – ${formatCompanyDate(controller.toDate)}',
            onPressed: _pickDateRange,
            variant: AppButtonVariant.ghost,
          ),
          const SizedBox(height: DsSpacing.s3),
          AppTextField(
            controller: _searchController,
            hint: 'Search target or details',
            label: 'Search',
            onSubmitted: controller.setSearch,
            suffixIcon: const Icon(Icons.search),
            textInputAction: TextInputAction.search,
          ),
          const SizedBox(height: DsSpacing.s3),
          Row(
            children: [
              Expanded(
                child: AppSelect<String?>(
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All actions')),
                    for (final action in controller.actions)
                      DropdownMenuItem(value: action, child: Text(describeAction(action))),
                  ],
                  label: 'Action',
                  onChanged: controller.setActionFilter,
                  value: controller.action,
                ),
              ),
              const SizedBox(width: DsSpacing.s3),
              Expanded(
                child: AppSelect<String?>(
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All targets')),
                    for (final targetType in controller.targetTypes)
                      DropdownMenuItem(value: targetType, child: Text(targetType)),
                  ],
                  label: 'Target type',
                  onChanged: controller.setTargetTypeFilter,
                  value: controller.targetType,
                ),
              ),
            ],
          ),
          const SizedBox(height: DsSpacing.s5),
          if (controller.truncated)
            Padding(
              padding: const EdgeInsets.only(bottom: DsSpacing.s4),
              child: AppCard(
                child: Text(
                  'This date range holds more events than can be shown at once. '
                  'Narrow the range for a complete view.',
                  style: TextStyle(color: context.semantic.textMuted),
                ),
              ),
            ),
          if (controller.listStatus == LoadStatus.loading) ...[
            const AppSkeleton(height: 64),
            const SizedBox(height: DsSpacing.s3),
            const AppSkeleton(height: 64),
            const SizedBox(height: DsSpacing.s3),
            const AppSkeleton(height: 64),
          ] else if (controller.listStatus == LoadStatus.error)
            EmptyState(
              action: AppButton(
                label: 'Retry',
                onPressed: controller.retry,
                variant: AppButtonVariant.ghost,
              ),
              description: "Couldn't load the audit log. Check your connection and try again.",
              title: 'Something went wrong',
            )
          else if (controller.items.isEmpty)
            const EmptyState(
              description: 'No events match these filters.',
              title: 'No events found',
            )
          else ...[
            for (final entry in controller.items)
              _AuditRow(
                key: ValueKey(entry.id),
                entry: entry,
                onTap: () => _openDetail(entry),
              ),
            if (controller.nextCursor != null)
              Padding(
                padding: const EdgeInsets.only(top: DsSpacing.s2),
                child: AppButton(
                  key: const Key('load-more-audit'),
                  label: 'Load more',
                  loading: controller.loadingMore,
                  onPressed: controller.loadMore,
                  variant: AppButtonVariant.ghost,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _AuditRow extends StatelessWidget {
  const _AuditRow({required this.entry, required this.onTap, super.key});

  final AuditLogEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DsSpacing.s3),
      child: AppCard(
        child: InkWell(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(iconFor(actionIconFor(entry.action)), color: context.semantic.textMuted),
              const SizedBox(width: DsSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.actorName ?? 'Unknown user'} ${describeAction(entry.action)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (entry.actorRole != null)
                      Text(
                        entry.actorRole!,
                        style: TextStyle(
                          fontSize: DsTypography.sizeCaption,
                          color: context.semantic.textMuted,
                        ),
                      ),
                    const SizedBox(height: DsSpacing.s2),
                    Text(
                      formatTarget(entry.targetType, entry.targetId),
                      style: TextStyle(
                        fontFamily: DsTypography.mono,
                        fontSize: DsTypography.sizeCaption,
                        color: context.semantic.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DsSpacing.s2),
              Text(
                formatRelativeTime(entry.createdAt),
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

class _AuditDetailBody extends StatelessWidget {
  const _AuditDetailBody({required this.entry});

  final AuditLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final metadata = _plainMetadata(entry.metadata);
    final hasBeforeAfter = metadata.containsKey('before') || metadata.containsKey('after');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(describeAction(entry.action), style: Theme.of(context).textTheme.titleLarge),
        Text(
          formatCompanyDateTime(entry.createdAt),
          style: TextStyle(
            fontFamily: DsTypography.mono,
            fontSize: DsTypography.sizeBodySmall,
            color: context.semantic.textMuted,
          ),
        ),
        const SizedBox(height: DsSpacing.s3),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: DsSpacing.s2,
          children: [
            AppBadge(label: entry.actorName ?? entry.actorUid),
            if (entry.actorRole != null) AppBadge(label: entry.actorRole!),
          ],
        ),
        const SizedBox(height: DsSpacing.s4),
        Text(
          formatTarget(entry.targetType, entry.targetId),
          style: TextStyle(fontFamily: DsTypography.mono, color: context.semantic.textMuted),
        ),
        const SizedBox(height: DsSpacing.s4),
        if (hasBeforeAfter) ...[
          if (metadata.containsKey('before')) ...[
            Text('BEFORE', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: DsSpacing.s2),
            Text(_formatValue(metadata['before']), style: TextStyle(fontFamily: DsTypography.mono)),
            const SizedBox(height: DsSpacing.s3),
          ],
          if (metadata.containsKey('after')) ...[
            Text('AFTER', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: DsSpacing.s2),
            Text(_formatValue(metadata['after']), style: TextStyle(fontFamily: DsTypography.mono)),
          ],
        ] else if (metadata.isEmpty)
          Text(
            'No additional details for this event.',
            style: TextStyle(color: context.semantic.textMuted),
          )
        else ...[
          Text('DETAILS', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: DsSpacing.s2),
          Text(_formatValue(metadata), style: TextStyle(fontFamily: DsTypography.mono)),
        ],
        const SizedBox(height: DsSpacing.s4),
      ],
    );
  }
}
