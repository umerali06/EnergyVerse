import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../auth/auth_controller.dart';
import '../auth/app_routes.dart';
import '../api/api_service.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../dashboard/format.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import '../inspections/gps_capture.dart';
import '../inspections/inspections_screen.dart' show inspectionStatusFor, inspectionStatusLabel;
import '../sync/sync_engine.dart';
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

  bool _startingInspection = false;

  /// Mirrors the QR "Start Inspection" flow (`qr_scan_result_screen.dart`):
  /// best-effort GPS, then a local-first draft (with the asset's category
  /// stashed for offline template auto-selection) -- no network round trip
  /// in the critical path. The detail screen does template-assignment and
  /// the `draft -> in_progress` transition once it loads (Phase 7.3).
  Future<void> _startInspection(AssetDetail asset) async {
    setState(() => _startingInspection = true);
    try {
      final repository = SyncProvider.repositoryOf(context);
      final inspectorId = AuthProvider.of(context).currentUser?.uid ?? '';
      final position = await captureCurrentPosition();
      final id = await repository.createDraft(
        assetId: asset.id,
        inspectorId: inspectorId,
        inspectionType: 'ad_hoc',
        assetCategory: asset.category,
        gpsLat: position.lat,
        gpsLng: position.lng,
      );
      if (!mounted) return;
      await Navigator.of(context).pushNamed(AppRoutes.inspectionDetail, arguments: id);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't start the inspection. Please try again.")),
      );
    } finally {
      if (mounted) setState(() => _startingInspection = false);
    }
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

    final canWrite = AuthProvider.of(context).currentUser?.permissions.contains('assets.write') ?? false;
    final canInspect =
        AuthProvider.of(context).currentUser?.permissions.contains('inspections.write') ?? false;
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
                    if (canInspect)
                      AppButton(
                        key: const Key('asset-detail-start-inspection'),
                        label: 'Start Inspection',
                        icon: Icons.fact_check_outlined,
                        loading: _startingInspection,
                        onPressed: () => _startInspection(asset),
                      ),
                    if (canWrite) ...[
                      const SizedBox(width: DsSpacing.s2),
                      AppButton(label: 'Edit', onPressed: () async {
                        await Navigator.of(context).pushNamed(AppRoutes.assetForm, arguments: asset.id);
                        _load();
                      }, variant: AppButtonVariant.ghost),
                    ],
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
                _InspectionsTab(assetId: asset.id, controller: controller),
                const _StaticEmptyTab(
                  description: 'Work orders will appear here once Phase 11 lands.',
                  title: 'No work orders yet',
                ),
                _HistoryTab(assetId: asset.id, controller: controller),
                _MediaTab(asset: asset, canWrite: canWrite, controller: controller, onChanged: (next) => setState(() => _asset = next)),
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

class _InspectionsTab extends StatefulWidget {
  const _InspectionsTab({required this.assetId, required this.controller});

  final String assetId;
  final AssetsController controller;

  @override
  State<_InspectionsTab> createState() => _InspectionsTabState();
}

class _InspectionsTabState extends State<_InspectionsTab> {
  LoadStatus _status = LoadStatus.loading;
  List<InspectionListItem> _items = const [];

  @override
  void initState() {
    super.initState();
    widget.controller
        .getInspections(widget.assetId)
        .then((page) {
          if (!mounted) return;
          setState(() {
            _items = page.items.toList();
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
          description: "Couldn't load this asset's inspections.",
          title: 'Something went wrong',
        ),
      );
    }
    if (_items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(DsSpacing.s6),
        child: EmptyState(
          description: 'No inspections have been recorded for this asset yet.',
          title: 'No inspections yet',
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(DsSpacing.s6),
      children: [
        for (final inspection in _items)
          Padding(
            padding: const EdgeInsets.only(bottom: DsSpacing.s3),
            child: AppCard(
              child: InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamed(AppRoutes.inspectionDetail, arguments: inspection.id),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inspection.title ?? 'Untitled',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: DsSpacing.s2),
                          StatusPill(
                            label: inspectionStatusLabel(inspection.status.name),
                            status: inspectionStatusFor(inspection.status.name),
                          ),
                        ],
                      ),
                    ),
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
          ),
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

class _MediaTab extends StatefulWidget {
  const _MediaTab({required this.asset, required this.canWrite, required this.controller, required this.onChanged});

  final AssetDetail asset;
  final bool canWrite;
  final AssetsController controller;
  final ValueChanged<AssetDetail> onChanged;

  @override
  State<_MediaTab> createState() => _MediaTabState();
}

class _MediaTabState extends State<_MediaTab> {
  double? progress;

  Future<void> _photo(ImageSource source) async {
    final file = await ImagePicker().pickImage(source: source, imageQuality: 90);
    if (file == null) return;
    await _upload('photo', file.path, file.name);
  }

  Future<void> _document(String kind) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: kind == 'manual' ? ['pdf', 'doc', 'docx'] : ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png', 'webp'],
    );
    final file = result?.files.single;
    if (file?.path == null) return;
    await _upload(kind, file!.path!, file.name);
  }

  Future<void> _upload(String kind, String path, String filename) async {
    setState(() => progress = 0);
    try {
      final next = await AuthProvider.of(context).api.uploadAssetMedia(
        assetId: widget.asset.id, kind: kind, path: path, filename: filename,
        onProgress: (sent, total) {
          if (mounted && total > 0) setState(() => progress = sent / total);
        },
      );
      widget.onChanged(next);
    } finally {
      if (mounted) setState(() => progress = null);
    }
  }

  Future<void> _remove(AssetMediaResponse media) async {
    final next = await AuthProvider.of(context).api.deleteAssetMedia(widget.asset.id, media.id);
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final asset = widget.asset;
    final count = (asset.photos?.length ?? 0) + (asset.documents?.length ?? 0) + (asset.manuals?.length ?? 0);
    if (count == 0 && !widget.canWrite) {
      return const Padding(
        padding: EdgeInsets.all(DsSpacing.s6),
        child: EmptyState(
          description: 'No photos, documents, or manuals have been attached.',
          title: 'No photos or documents yet',
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(DsSpacing.s6),
      children: [
        if (progress != null) LinearProgressIndicator(value: progress),
        _mediaSection('Photos', asset.photos?.toList() ?? const [], [
          AppButton(label: 'Camera', onPressed: () => _photo(ImageSource.camera), variant: AppButtonVariant.ghost),
          AppButton(label: 'Gallery', onPressed: () => _photo(ImageSource.gallery), variant: AppButtonVariant.ghost),
        ]),
        _mediaSection('Documents', asset.documents?.toList() ?? const [], [
          AppButton(label: 'Add document', onPressed: () => _document('document'), variant: AppButtonVariant.ghost),
        ]),
        _mediaSection('Manuals', asset.manuals?.toList() ?? const [], [
          AppButton(label: 'Add manual', onPressed: () => _document('manual'), variant: AppButtonVariant.ghost),
        ]),
      ],
    );
  }

  Widget _mediaSection(String title, List<AssetMediaResponse> items, List<Widget> actions) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DsSpacing.s5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
          if (widget.canWrite) ...actions,
        ]),
        const SizedBox(height: DsSpacing.s2),
        if (items.isEmpty) Text('No ${title.toLowerCase()} attached.'),
        for (final media in items)
          AppCard(child: Row(children: [
            if (media.kind.name == 'photo')
              ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.network(media.url, width: 64, height: 64, fit: BoxFit.cover)),
            if (media.kind.name == 'photo') const SizedBox(width: DsSpacing.s3),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(media.filename, overflow: TextOverflow.ellipsis),
              Text('${(media.size / 1024).ceil()} KB', style: TextStyle(color: context.semantic.textMuted)),
            ])),
            if (widget.canWrite) IconButton(icon: const Icon(Icons.delete_outline), tooltip: 'Remove', onPressed: () => _remove(media)),
          ])),
      ]),
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
