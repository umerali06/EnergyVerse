import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../auth/auth_controller.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import 'roles_controller.dart';

/// Company role catalog, read-only on mobile (creating and editing roles
/// remain admin-web-only for Phase 3.2 -- see DECISIONS.md).
class RolesScreen extends StatefulWidget {
  const RolesScreen({super.key});

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  RolesController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= RolesController(api: AuthProvider.of(context).api)..start();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _openDetail(String roleId) {
    final controller = _controller;
    if (controller == null) return;
    showAppModal<void>(
      context,
      title: 'Role details',
      child: _RoleDetailBody(controller: controller, roleId: roleId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => ListView(
        key: const Key('roles-scroll'),
        padding: const EdgeInsets.all(DsSpacing.s6),
        children: [
          Text('Roles', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: DsSpacing.s2),
          Text(
            'The permission model for your company.',
            style: TextStyle(color: context.semantic.textMuted),
          ),
          const SizedBox(height: DsSpacing.s5),
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
              description: "Couldn't load roles. Check your connection and try again.",
              title: 'Something went wrong',
            )
          else if (controller.items.isEmpty)
            const EmptyState(description: 'No roles exist yet.', title: 'No roles found')
          else
            for (final role in controller.items)
              _RoleRow(key: ValueKey(role.id), onTap: () => _openDetail(role.id), role: role),
        ],
      ),
    );
  }
}

class _RoleRow extends StatelessWidget {
  const _RoleRow({required this.role, required this.onTap, super.key});

  final RoleSummary role;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DsSpacing.s3),
      child: AppCard(
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(role.name, style: Theme.of(context).textTheme.titleMedium),
                    if (role.description.isNotEmpty)
                      Text(
                        role.description,
                        style: TextStyle(
                          fontSize: DsTypography.sizeCaption,
                          color: context.semantic.textMuted,
                        ),
                      ),
                    const SizedBox(height: DsSpacing.s2),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: DsSpacing.s2,
                      children: [
                        AppBadge(label: role.isSystem ? 'System' : 'Custom'),
                        AppBadge(label: '${role.permissionCount} permissions'),
                        AppBadge(label: '${role.assignedUserCount} users'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleDetailBody extends StatefulWidget {
  const _RoleDetailBody({required this.controller, required this.roleId});

  final RolesController controller;
  final String roleId;

  @override
  State<_RoleDetailBody> createState() => _RoleDetailBodyState();
}

class _RoleDetailBodyState extends State<_RoleDetailBody> {
  LoadStatus _status = LoadStatus.loading;
  RoleDetail? _detail;

  @override
  void initState() {
    super.initState();
    widget.controller
        .getRole(widget.roleId)
        .then((result) {
          if (!mounted) return;
          setState(() {
            _detail = result;
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
        padding: EdgeInsets.symmetric(vertical: DsSpacing.s6),
        child: Center(child: AppLoader()),
      );
    }
    final detail = _detail;
    if (_status == LoadStatus.error || detail == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: DsSpacing.s4),
        child: Text("Couldn't load this role. Close and try again."),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(detail.name, style: Theme.of(context).textTheme.titleLarge),
        if (detail.description.isNotEmpty)
          Text(
            detail.description,
            style: TextStyle(
              fontSize: DsTypography.sizeBodySmall,
              color: context.semantic.textMuted,
            ),
          ),
        const SizedBox(height: DsSpacing.s3),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: DsSpacing.s2,
          children: [
            AppBadge(label: detail.isSystem ? 'System' : 'Custom'),
            AppBadge(label: '${detail.assignedUserCount} users assigned'),
          ],
        ),
        const SizedBox(height: DsSpacing.s4),
        Text(
          'PERMISSIONS',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: context.semantic.textMuted, letterSpacing: 1),
        ),
        const SizedBox(height: DsSpacing.s2),
        Wrap(
          spacing: DsSpacing.s2,
          runSpacing: DsSpacing.s2,
          children: [for (final permission in detail.permissionKeys) AppBadge(label: permission)],
        ),
        const SizedBox(height: DsSpacing.s4),
      ],
    );
  }
}
