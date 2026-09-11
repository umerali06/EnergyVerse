import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../auth/auth_controller.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../design_system/primitives.dart';
import '../navigation/nav_config.dart';
import 'notifications_controller.dart';

/// Where each notification target lives in the mobile route table. The server
/// emits a target type and id rather than a URL, so each client owns its own
/// routing -- the admin has an equivalent map.
const _routeForTarget = <String, String>{
  'work_order': AppNav.workOrders,
  'safety_report': AppNav.safety,
  'permit': AppNav.permits,
  'inspection': AppNav.inspections,
  'report': AppNav.reports,
};

IconData _iconForEvent(String event) {
  if (event.startsWith('work_order')) return Icons.build_outlined;
  if (event.startsWith('safety_report')) return Icons.health_and_safety_outlined;
  if (event.startsWith('permit')) return Icons.assignment_turned_in_outlined;
  if (event.startsWith('inspection')) return Icons.fact_check_outlined;
  return Icons.description_outlined;
}

String _relative(DateTime timestamp) {
  final delta = DateTime.now().toUtc().difference(timestamp.toUtc());
  if (delta.inMinutes < 1) return 'just now';
  if (delta.inMinutes < 60) return '${delta.inMinutes}m ago';
  if (delta.inHours < 24) return '${delta.inHours}h ago';
  return '${delta.inDays}d ago';
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({this.api, super.key});

  final NotificationsApiContract? api;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationsController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    final candidate = widget.api ?? AuthProvider.of(context).api;
    if (candidate is! NotificationsApiContract) return;
    _controller = NotificationsController(api: candidate)..start();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _open(NotificationResponse notification) async {
    final controller = _controller;
    if (controller == null) return;
    await controller.markRead(notification.id);
    if (!mounted) return;
    final route = _routeForTarget[notification.targetType];
    if (route != null) {
      await Navigator.of(context).pushNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return const Center(child: Text('Notifications are unavailable.'));
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.unreadCount > 0
                          ? '${controller.unreadCount} unread'
                          : 'All caught up',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  FilterChip(
                    label: const Text('Unread only'),
                    selected: controller.unreadOnly,
                    onSelected: (value) => controller.setUnreadOnly(value),
                  ),
                  if (controller.unreadCount > 0) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: controller.markAllRead,
                      child: const Text('Mark all read'),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(child: _body(controller)),
          ],
        );
      },
    );
  }

  Widget _body(NotificationsController controller) {
    switch (controller.status) {
      case LoadStatus.loading:
        return const Center(child: AppLoader(label: 'Loading notifications'));
      case LoadStatus.error:
        // A failed request must read as a failure, never as an empty inbox.
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Notifications could not be loaded.'),
              const SizedBox(height: 12),
              FilledButton(onPressed: controller.load, child: const Text('Retry')),
            ],
          ),
        );
      case LoadStatus.ready:
        if (controller.items.isEmpty) {
          return Center(
            child: Text(
              controller.unreadOnly
                  ? 'Nothing unread.'
                  : 'You have no notifications yet.',
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView.separated(
            itemCount: controller.items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = controller.items[index];
              final unread = notification.readAt == null;
              return ListTile(
                leading: Icon(_iconForEvent(notification.event)),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: unread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.body),
                    const SizedBox(height: 2),
                    Text(
                      _relative(notification.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                trailing: unread
                    ? const Icon(Icons.circle, size: 10, color: Colors.orange)
                    : null,
                isThreeLine: true,
                onTap: () => _open(notification),
              );
            },
          ),
        );
    }
  }
}
