import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../auth/auth_controller.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../dashboard/format.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import 'users_controller.dart';

String _initials(String email) {
  final name = email.split('@').first;
  final parts = name.split(RegExp(r'[._-]+')).where((part) => part.isNotEmpty).toList();
  final first = parts.isNotEmpty ? parts.first[0] : '?';
  final second = parts.length > 1 ? parts[1][0] : (name.length > 1 ? name[1] : '');
  return '$first$second'.toUpperCase();
}

/// Company user directory, read-only on mobile (invite/edit remain
/// admin-web-only for Phase 3.1 -- see DECISIONS.md).
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  UsersController? _controller;
  final _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= UsersController(api: AuthProvider.of(context).api)..start();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(String userId) {
    final controller = _controller;
    if (controller == null) return;
    showAppModal<void>(
      context,
      title: 'User details',
      child: _UserDetailBody(controller: controller, userId: userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => ListView(
        key: const Key('users-scroll'),
        padding: const EdgeInsets.all(DsSpacing.s6),
        children: [
          Text('Users', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: DsSpacing.s2),
          Text(
            'People with access to your company.',
            style: TextStyle(color: context.semantic.textMuted),
          ),
          const SizedBox(height: DsSpacing.s5),
          AppTextField(
            controller: _searchController,
            hint: 'Name or email',
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
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All statuses')),
                    DropdownMenuItem(value: 'active', child: Text('Active')),
                    DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                  ],
                  label: 'Status',
                  onChanged: (value) => controller.setStatusFilter(value),
                  value: controller.status,
                ),
              ),
              const SizedBox(width: DsSpacing.s3),
              Expanded(
                child: AppSelect<String>(
                  items: const [
                    DropdownMenuItem(value: 'name', child: Text('Name (A–Z)')),
                    DropdownMenuItem(value: '-name', child: Text('Name (Z–A)')),
                    DropdownMenuItem(value: '-created_at', child: Text('Newest first')),
                    DropdownMenuItem(value: 'created_at', child: Text('Oldest first')),
                  ],
                  label: 'Sort',
                  onChanged: (value) {
                    if (value != null) controller.setSort(value);
                  },
                  value: controller.sort,
                ),
              ),
            ],
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
              description: "Couldn't load users. Check your connection and try again.",
              title: 'Something went wrong',
            )
          else if (controller.items.isEmpty)
            const EmptyState(
              description: 'No users match your current filters.',
              title: 'No users found',
            )
          else ...[
            for (final user in controller.items)
              _UserRow(
                key: ValueKey(user.id),
                onTap: () => _openDetail(user.id),
                user: user,
              ),
            if (controller.nextCursor != null)
              Padding(
                padding: const EdgeInsets.only(top: DsSpacing.s2),
                child: AppButton(
                  key: const Key('load-more-users'),
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

class _UserRow extends StatelessWidget {
  const _UserRow({required this.user, required this.onTap, super.key});

  final UserListItem user;
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
              CircleAvatar(
                backgroundColor: DsColors.primary500.withAlpha(60),
                radius: 18,
                child: Text(_initials(user.email)),
              ),
              const SizedBox(width: DsSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.displayName, style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      user.email,
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
                        AppBadge(label: user.roleName),
                        StatusPill(
                          label: user.status,
                          status: user.status == 'active'
                              ? AppStatus.healthy
                              : AppStatus.critical,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DsSpacing.s2),
              Text(
                formatRelativeTime(user.updatedAt),
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

class _UserDetailBody extends StatefulWidget {
  const _UserDetailBody({required this.controller, required this.userId});

  final UsersController controller;
  final String userId;

  @override
  State<_UserDetailBody> createState() => _UserDetailBodyState();
}

class _UserDetailBodyState extends State<_UserDetailBody> {
  LoadStatus _status = LoadStatus.loading;
  UserDetail? _detail;

  @override
  void initState() {
    super.initState();
    void load() {
      widget.controller
          .getUser(widget.userId)
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

    load();
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
        child: Text("Couldn't load this user. Close and try again."),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(detail.displayName, style: Theme.of(context).textTheme.titleLarge),
        Text(
          detail.email,
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
            AppBadge(label: detail.roleName),
            StatusPill(
              label: detail.status,
              status: detail.status == 'active' ? AppStatus.healthy : AppStatus.critical,
            ),
          ],
        ),
        const SizedBox(height: DsSpacing.s4),
        Text(
          'EFFECTIVE PERMISSIONS',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: context.semantic.textMuted, letterSpacing: 1),
        ),
        const SizedBox(height: DsSpacing.s2),
        Wrap(
          spacing: DsSpacing.s2,
          runSpacing: DsSpacing.s2,
          children: [for (final permission in detail.permissions) AppBadge(label: permission)],
        ),
        const SizedBox(height: DsSpacing.s4),
      ],
    );
  }
}
