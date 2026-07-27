import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../auth/auth_controller.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../dashboard/format.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import 'assets_controller.dart';
import 'assets_screen.dart' show statusFor, statusLabel;

/// Full pushed-route asset detail: overview + 4 reserved tabs (Inspections,
/// Work Orders, History, Media). Unlike Users/Audit's bottom-sheet detail,
/// this is a real route because a sheet can't hold 5 tabs of content — see
/// DECISIONS.md for the ADR on this departure from the sheet convention.
class AssetDetailScreen extends StatefulWidget {
  const AssetDetailScreen({required this.assetId, super.key});

  final String assetId;

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen> {
  AssetsController? _controller;
  LoadStatus _status = LoadStatus.loading;
  AssetDetail? _asset;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      final controller = AssetsController(api: AuthProvider.of(context).api);
      _controller = controller;
      unawaited(controller.loadLookups());
      _load();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _load() {
    setState(() => _status = LoadStatus.loading);
    _controller!
        .getAsset(widget.assetId)
        .then((asset) {
          if (!mounted) return;
          setState(() {
            _asset = asset;
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
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();
    return AnimatedBuilder(animation: controller, builder: (context, _) => _buildBody(controller));
  }

  Widget _buildBody(AssetsController controller) {
    if (_status == LoadStatus.loading) {
      return const Padding(
        padding: EdgeInsets.all(DsSpacing.s6),
        child: Column(
          children: [
            AppSkeleton(height: 32),
            SizedBox(height: DsSpacing.s3),
            AppSkeleton(height: 120),
          ],
        ),
      );
    }
    final asset = _asset;
    if (_status == LoadStatus.error || asset == null) {
      return Padding(
        padding: const EdgeInsets.all(DsSpacing.s6),
        child: EmptyState(
          action: AppButton(label: 'Retry', onPressed: _load, variant: AppButtonVariant.ghost),
          description: "Couldn't load this asset. Check your connection and try again.",
          title: 'Something went wrong',
        ),
      );
    }

    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              DsSpacing.s6,
              DsSpacing.s6,
              DsSpacing.s6,
              DsSpacing.s3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(asset.name, style: Theme.of(context).textTheme.headlineSmall),
                          Text(
                            asset.assetTag,
                            style: TextStyle(
                              fontFamily: DsTypography.mono,
                              fontSize: DsTypography.sizeBodySmall,
                              color: context.semantic.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tooltip(
                      message: 'Editing assets arrives in Phase 4.3',
                      child: AppButton(label: 'Edit', onPressed: null, variant: AppButtonVariant.ghost),
                    ),
                  ],
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
                    Text(
                      asset.areaId != null
                          ? '${controller.facilityName(asset.facilityId)} → ${controller.areaName(asset.areaId)}'
                          : controller.facilityName(asset.facilityId),
                      style: TextStyle(color: context.semantic.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Inspections'),
              Tab(text: 'Work Orders'),
              Tab(text: 'History'),
              Tab(text: 'Media'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _OverviewTab(asset: asset, controller: controller),
                const _StaticEmptyTab(
                  description: 'Inspections will appear here once Phase 7 lands.',
                  title: 'No inspections yet',
                ),
                const _StaticEmptyTab(
                  description: 'Work orders will appear here once Phase 11 lands.',
                  title: 'No work orders yet',
                ),
                _HistoryTab(assetId: asset.id, controller: controller),
                _MediaTab(asset: asset),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DsSpacing.s3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: DsTypography.mono,
              fontSize: DsTypography.sizeCaption,
              color: context.semantic.textMuted,
              letterSpacing: 1,
            ),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatefulWidget {
  const _OverviewTab({required this.asset, required this.controller});

  final AssetDetail asset;
  final AssetsController controller;

  @override
  State<_OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<_OverviewTab> {
  LoadStatus _childrenStatus = LoadStatus.loading;
  List<AssetListItem> _children = const [];

  @override
  void initState() {
    super.initState();
    widget.controller
        .getChildAssets(widget.asset.id)
        .then((items) {
          if (!mounted) return;
          setState(() {
            _children = items;
            _childrenStatus = LoadStatus.ready;
          });
        })
        .catchError((_) {
          if (!mounted) return;
          setState(() => _childrenStatus = LoadStatus.error);
        });
  }

  @override
  Widget build(BuildContext context) {
    final asset = widget.asset;
    final hasGps = asset.gpsLat != null && asset.gpsLng != null;
    return ListView(
      key: const Key('asset-overview-scroll'),
      padding: const EdgeInsets.all(DsSpacing.s6),
      children: [
        _Field(label: 'Manufacturer', value: asset.manufacturer ?? '—'),
        _Field(label: 'Model', value: asset.model ?? '—'),
        _Field(label: 'Serial number', value: asset.serialNumber ?? '—'),
        _Field(
          label: 'Installation date',
          value: asset.installationDate != null
              ? formatCompanyDate(asset.installationDate!.toDateTime())
              : '—',
        ),
        if (asset.description != null && asset.description!.isNotEmpty)
          _Field(label: 'Description', value: asset.description!),
        Padding(
          padding: const EdgeInsets.only(bottom: DsSpacing.s3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LOCATION',
                style: TextStyle(
                  fontFamily: DsTypography.mono,
                  fontSize: DsTypography.sizeCaption,
                  color: context.semantic.textMuted,
                  letterSpacing: 1,
                ),
              ),
              if (hasGps) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${asset.gpsLat!.toStringAsFixed(6)}, ${asset.gpsLng!.toStringAsFixed(6)}',
                      style: TextStyle(fontFamily: DsTypography.mono),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 16),
                      onPressed: () => Clipboard.setData(
                        ClipboardData(text: '${asset.gpsLat}, ${asset.gpsLng}'),
                      ),
                      tooltip: 'Copy coordinates',
                    ),
                  ],
                ),
              ] else
                const Text('No location recorded.'),
            ],
          ),
        ),
        Text(
          'SUB-ASSETS',
          style: TextStyle(
            fontFamily: DsTypography.mono,
            fontSize: DsTypography.sizeCaption,
            color: context.semantic.textMuted,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: DsSpacing.s2),
        if (_childrenStatus == LoadStatus.loading) const AppSkeleton(height: 20, width: 160),
        if (_childrenStatus == LoadStatus.ready && _children.isEmpty) const Text('No sub-assets.'),
        if (_childrenStatus == LoadStatus.ready && _children.isNotEmpty)
          for (final child in _children)
            Padding(
              padding: const EdgeInsets.only(bottom: DsSpacing.s1),
              child: Text('${child.name} (${child.assetTag})'),
            ),
        const SizedBox(height: DsSpacing.s4),
        _Field(label: 'Created', value: formatCompanyDateTime(asset.createdAt)),
        _Field(label: 'Last updated', value: formatCompanyDateTime(asset.updatedAt)),
      ],
    );
  }
}

class _HistoryTab extends StatefulWidget {
  const _HistoryTab({required this.assetId, required this.controller});

  final String assetId;
  final AssetsController controller;

  @override
  State<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<_HistoryTab> {
  LoadStatus _status = LoadStatus.loading;
  List<AssetHistoryEvent> _events = const [];

  @override
  void initState() {
    super.initState();
    widget.controller
        .getAssetHistory(widget.assetId)
        .then((page) {
          if (!mounted) return;
          setState(() {
            _events = page.items?.toList() ?? const [];
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
      return const Padding(padding: EdgeInsets.all(DsSpacing.s6), child: AppSkeleton(height: 64));
    }
    if (_status == LoadStatus.error) {
      return const Padding(
        padding: EdgeInsets.all(DsSpacing.s6),
        child: EmptyState(
          description: "Couldn't load this asset's history.",
          title: 'Something went wrong',
        ),
      );
    }
    if (_events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(DsSpacing.s6),
        child: EmptyState(
          description: 'No history has been recorded for this asset yet.',
          title: 'No history yet',
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(DsSpacing.s6),
      children: [
        for (final event in _events)
          Padding(
            padding: const EdgeInsets.only(bottom: DsSpacing.s3),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatRelativeTime(event.occurredAt),
                    style: TextStyle(
                      fontFamily: DsTypography.mono,
                      fontSize: DsTypography.sizeCaption,
                      color: context.semantic.textMuted,
                    ),
                  ),
                  Text(event.type, style: Theme.of(context).textTheme.titleSmall),
                  Text(event.summary),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _MediaTab extends StatelessWidget {
  const _MediaTab({required this.asset});

  final AssetDetail asset;

  @override
  Widget build(BuildContext context) {
    final count = (asset.photos?.length ?? 0) + (asset.documents?.length ?? 0) + (asset.manuals?.length ?? 0);
    if (count == 0) {
      return const Padding(
        padding: EdgeInsets.all(DsSpacing.s6),
        child: EmptyState(
          description: 'Photos, documents, and manuals will appear here once uploads land in Phase 4.3.',
          title: 'No photos or documents yet',
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(DsSpacing.s6),
      children: [
        if (asset.photos != null && asset.photos!.isNotEmpty)
          _Field(label: 'Photos', value: '${asset.photos!.length} photo(s)'),
        if (asset.documents != null && asset.documents!.isNotEmpty)
          _Field(label: 'Documents', value: '${asset.documents!.length} document(s)'),
        if (asset.manuals != null && asset.manuals!.isNotEmpty)
          _Field(label: 'Manuals', value: '${asset.manuals!.length} manual(s)'),
      ],
    );
  }
}

class _StaticEmptyTab extends StatelessWidget {
  const _StaticEmptyTab({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DsSpacing.s6),
      child: EmptyState(description: description, title: title),
    );
  }
}
