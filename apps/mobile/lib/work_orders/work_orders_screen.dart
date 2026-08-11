import 'package:flutter/material.dart';

import '../auth/app_routes.dart';
import '../auth/auth_controller.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../dashboard/format.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import 'local_work_orders_repository.dart';
import 'work_order_sync_engine.dart';
import 'work_orders_controller.dart';

/// Work order status values are stored locally as their WIRE (snake_case)
/// value already (see `LocalWorkOrdersRepository._upsertFromServer`) -- no
/// Dart-enum-name round trip needed here, unlike inspections' status badge
/// helpers.
AppStatus workOrderStatusFor(String status) => switch (status) {
      'open' || 'assigned' => AppStatus.info,
      'in_progress' || 'pending_review' => AppStatus.warning,
      'closed' => AppStatus.healthy,
      'cancelled' => AppStatus.critical,
      _ => AppStatus.info,
    };

String workOrderStatusLabel(String status) => status
    .split('_')
    .map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
    .join(' ');

AppStatus workOrderPriorityFor(String priority) => switch (priority) {
      'low' => AppStatus.healthy,
      'medium' => AppStatus.info,
      'high' => AppStatus.warning,
      _ => AppStatus.critical,
    };

String workOrderPriorityLabel(String priority) =>
    priority.isEmpty ? priority : priority[0].toUpperCase() + priority.substring(1);

/// Work order directory. Defaults to "assigned to me" (the field
/// technician's primary use of this screen); a toggle switches to every
/// work order this device can read. Detail is a pushed route, mirroring
/// inspections/assets.
class WorkOrdersScreen extends StatefulWidget {
  const WorkOrdersScreen({super.key});

  @override
  State<WorkOrdersScreen> createState() => _WorkOrdersScreenState();
}

class _WorkOrdersScreenState extends State<WorkOrdersScreen> {
  WorkOrdersController? _controller;
  bool _mineOnly = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      final uid = AuthProvider.of(context).currentUser?.uid;
      _controller = WorkOrdersController(
        repository: WorkOrderSyncProvider.repositoryOf(context),
        initialTechnicianId: _mineOnly ? uid : null,
      )..start();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleMineOnly(bool value) {
    setState(() => _mineOnly = value);
    final uid = AuthProvider.of(context).currentUser?.uid;
    _controller?.setTechnicianFilter(value ? uid : null);
  }

  void _openDetail(String workOrderId) {
    Navigator.of(context)
        .pushNamed(AppRoutes.workOrderDetail, arguments: workOrderId);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return ListView(
          key: const Key('work-orders-scroll'),
          padding: const EdgeInsets.all(DsSpacing.s6),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Work Orders', style: Theme.of(context).textTheme.headlineMedium),
                _PendingOutboxIndicator(key: const Key('work-order-pending-outbox')),
              ],
            ),
            const SizedBox(height: DsSpacing.s2),
            Text(
              'Maintenance work raised against your facilities.',
              style: TextStyle(color: context.semantic.textMuted),
            ),
            const SizedBox(height: DsSpacing.s5),
            Row(
              children: [
                Expanded(
                  child: AppSelect<String?>(
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All statuses')),
                      DropdownMenuItem(value: 'open', child: Text('Open')),
                      DropdownMenuItem(value: 'assigned', child: Text('Assigned')),
                      DropdownMenuItem(value: 'in_progress', child: Text('In progress')),
                      DropdownMenuItem(value: 'pending_review', child: Text('Pending review')),
                      DropdownMenuItem(value: 'closed', child: Text('Closed')),
                      DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                    ],
                    label: 'Status',
                    onChanged: controller.setStatusFilter,
                    value: controller.status,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DsSpacing.s3),
            Row(
              children: [
                Switch(
                  key: const Key('work-orders-mine-only'),
                  value: _mineOnly,
                  onChanged: _toggleMineOnly,
                ),
                const SizedBox(width: DsSpacing.s2),
                const Text('Assigned to me only'),
              ],
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
                description: "Couldn't load work orders. Check your connection and try again.",
                title: 'Something went wrong',
              )
            else if (controller.items.isEmpty)
              EmptyState(
                description: _mineOnly
                    ? 'No work orders are currently assigned to you.'
                    : 'No work orders match your current filters.',
                title: 'No work orders found',
              )
            else
              for (final workOrder in controller.items)
                _WorkOrderRow(
                  key: ValueKey(workOrder.row.id),
                  workOrder: workOrder,
                  onTap: () => _openDetail(workOrder.row.id),
                ),
          ],
        );
      },
    );
  }
}

class _PendingOutboxIndicator extends StatelessWidget {
  const _PendingOutboxIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final sync = WorkOrderSyncProvider.engineOf(context);
    return AnimatedBuilder(
      animation: sync,
      builder: (context, _) {
        final pending = sync.pendingOutboxCount;
        if (pending == 0) return const SizedBox.shrink();
        return TextButton.icon(
          onPressed: sync.syncNow,
          icon: const Icon(Icons.sync_problem_outlined, size: 18),
          label: Text('$pending pending'),
        );
      },
    );
  }
}

class _WorkOrderRow extends StatelessWidget {
  const _WorkOrderRow({required this.workOrder, required this.onTap, super.key});

  final LocalWorkOrderRecord workOrder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final row = workOrder.row;
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
                    Text(row.title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: DsSpacing.s2),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: DsSpacing.s2,
                      children: [
                        StatusPill(
                          label: workOrderPriorityLabel(row.priority),
                          status: workOrderPriorityFor(row.priority),
                        ),
                        StatusPill(
                          label: workOrderStatusLabel(row.status),
                          status: workOrderStatusFor(row.status),
                        ),
                        if (row.syncState == 'pending_sync')
                          const StatusPill(label: 'Pending sync', status: AppStatus.info),
                        if (row.syncState == 'conflict')
                          const StatusPill(label: 'Conflict', status: AppStatus.critical),
                        if (row.syncState == 'error')
                          const StatusPill(label: 'Sync error', status: AppStatus.critical),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DsSpacing.s2),
              Text(
                formatRelativeTime(row.updatedAt),
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
