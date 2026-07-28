import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../auth/auth_controller.dart';
import '../auth/app_routes.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../dashboard/format.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import 'assets_controller.dart';

const _categoryOptions = ['Pump', 'Compressor', 'Vessel', 'Valve', 'Tank', 'Generator', 'Sensor', 'Other'];

AppStatus statusFor(String statusName) => switch (statusName) {
      'healthy' => AppStatus.healthy,
      'warning' => AppStatus.warning,
      'critical' => AppStatus.critical,
      _ => AppStatus.info,
    };

String statusLabel(String statusName) =>
    statusName.isEmpty ? statusName : statusName[0].toUpperCase() + statusName.substring(1);

/// Asset directory, field-friendly (dense but tappable). Detail is a full
/// pushed route (see asset_detail_screen.dart) rather than a bottom sheet,
/// since it carries 5 tabs of real content.
class AssetsScreen extends StatefulWidget {
  const AssetsScreen({this.initialStatus, super.key});

  /// Seeds the status filter once on open (e.g. a dashboard KPI widget
  /// deep-linking to the Critical assets view).
  final String? initialStatus;

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  AssetsController? _controller;
  final _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??=
        AssetsController(api: AuthProvider.of(context).api, initialStatus: widget.initialStatus)
          ..start();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(String assetId) {
    Navigator.of(context).pushNamed(AppRoutes.assetDetail, arguments: assetId);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final areaOptions = controller.facilityId == null
            ? const <AreaDetail>[]
            : controller.areas.where((area) => area.facilityId == controller.facilityId).toList();
        final canWrite = AuthProvider.of(context).currentUser?.permissions.contains('assets.write') ?? false;
        return ListView(
          key: const Key('assets-scroll'),
          padding: const EdgeInsets.all(DsSpacing.s6),
          children: [
            Row(children: [
              Expanded(child: Text('Assets', style: Theme.of(context).textTheme.headlineMedium)),
              if (canWrite) AppButton(label: 'Create', onPressed: () async {
                await Navigator.of(context).pushNamed(AppRoutes.assetForm);
                await controller.retry();
              }),
            ]),
            const SizedBox(height: DsSpacing.s2),
            Text(
              'Every physical asset tracked across your facilities.',
              style: TextStyle(color: context.semantic.textMuted),
            ),
            const SizedBox(height: DsSpacing.s5),
            AppTextField(
              controller: _searchController,
              hint: 'Name, tag, or serial',
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
                      const DropdownMenuItem(value: null, child: Text('All facilities')),
                      for (final facility in controller.facilities)
                        DropdownMenuItem(value: facility.id, child: Text(facility.name)),
                    ],
                    label: 'Facility',
                    onChanged: controller.setFacilityFilter,
                    value: controller.facilityId,
                  ),
                ),
                const SizedBox(width: DsSpacing.s3),
                Expanded(
                  child: AppSelect<String?>(
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All areas')),
                      for (final area in areaOptions)
                        DropdownMenuItem(value: area.id, child: Text(area.name)),
                    ],
                    label: controller.facilityId == null ? 'Area (pick a facility first)' : 'Area',
                    onChanged: controller.setAreaFilter,
                    value: controller.areaId,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DsSpacing.s3),
            Row(
              children: [
                Expanded(
                  child: AppSelect<String?>(
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All categories')),
                      for (final category in _categoryOptions)
                        DropdownMenuItem(value: category, child: Text(category)),
                    ],
                    label: 'Category',
                    onChanged: controller.setCategoryFilter,
                    value: controller.category,
                  ),
                ),
                const SizedBox(width: DsSpacing.s3),
                Expanded(
                  child: AppSelect<String?>(
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All statuses')),
                      DropdownMenuItem(value: 'Healthy', child: Text('Healthy')),
                      DropdownMenuItem(value: 'Warning', child: Text('Warning')),
                      DropdownMenuItem(value: 'Critical', child: Text('Critical')),
                    ],
                    label: 'Status',
                    onChanged: controller.setStatusFilter,
                    value: controller.status,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DsSpacing.s5),
            if (controller.listStatus == LoadStatus.loading) ...[
              const AppSkeleton(height: 72),
              const SizedBox(height: DsSpacing.s3),
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
                description: "Couldn't load assets. Check your connection and try again.",
                title: 'Something went wrong',
              )
            else if (controller.items.isEmpty)
              const EmptyState(
                description: 'No assets match your current filters.',
                title: 'No assets found',
              )
            else ...[
              for (final asset in controller.items)
                _AssetRow(
                  key: ValueKey(asset.id),
                  areaName: controller.areaName(asset.areaId),
                  asset: asset,
                  facilityName: controller.facilityName(asset.facilityId),
                  onTap: () => _openDetail(asset.id),
                ),
              if (controller.nextCursor != null)
                Padding(
                  padding: const EdgeInsets.only(top: DsSpacing.s2),
                  child: AppButton(
                    key: const Key('load-more-assets'),
                    label: 'Load more',
                    loading: controller.loadingMore,
                    onPressed: controller.loadMore,
                    variant: AppButtonVariant.ghost,
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({
    required this.asset,
    required this.facilityName,
    required this.areaName,
    required this.onTap,
    super.key,
  });

  final AssetListItem asset;
  final String facilityName;
  final String? areaName;
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(asset.name, style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      asset.assetTag,
                      style: TextStyle(
                        fontFamily: DsTypography.mono,
                        fontSize: DsTypography.sizeCaption,
                        color: context.semantic.textMuted,
                      ),
                    ),
                    Text(
                      areaName != null ? '$facilityName → $areaName' : facilityName,
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
                        AppBadge(label: asset.category),
                        StatusPill(
                          label: statusLabel(asset.currentStatus.name),
                          status: statusFor(asset.currentStatus.name),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DsSpacing.s2),
              Text(
                formatRelativeTime(asset.updatedAt),
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
