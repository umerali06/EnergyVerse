import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../annotations/annotation_canvas_screen.dart';
import '../auth/auth_controller.dart';
import '../dashboard/format.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import '../inspections/gps_capture.dart';
import '../sync/sync_engine.dart';
import 'local_media_repository.dart';
import 'media_capture_screen.dart';
import 'media_upload_worker.dart';

/// Unifies a server-synced [InspectionMediaResponse] and a not-yet-synced
/// [MediaQueueRecord] behind one shape, so the gallery has a single
/// rendering path regardless of upload state -- this is exactly the "2 of 5
/// media uploaded" requirement made concrete: [isLocalOnly] items are the
/// ones still counted as pending.
class _GalleryItem {
  _GalleryItem.synced(InspectionMediaResponse media)
      : id = media.id,
        mediaLocalId = media.localId,
        kind = media.kind.name,
        beforeAfterTag = media.beforeAfterTag?.name,
        checklistItemId = media.checklistItemId,
        capturedAt = media.capturedAt,
        networkUrl = media.url,
        localFilePath = null,
        uploadStateLabel = null,
        localId = null;

  _GalleryItem.queued(MediaQueueRecord row)
      : id = row.localId,
        mediaLocalId = row.localId,
        kind = row.kind,
        beforeAfterTag = row.beforeAfterTag,
        checklistItemId = row.checklistItemId,
        capturedAt = row.capturedAt,
        networkUrl = null,
        localFilePath = row.localFilePath,
        uploadStateLabel = _uploadStateLabel(row),
        localId = row.localId;

  final String id;

  /// The stable client-generated key an annotation references (`media_id`
  /// on the wire) -- present for both a synced [InspectionMediaResponse]
  /// and a not-yet-synced [MediaQueueRecord], unlike [id] (server-assigned,
  /// null for the latter).
  final String mediaLocalId;
  final String kind;
  final String? beforeAfterTag;
  final String? checklistItemId;
  final DateTime capturedAt;
  final String? networkUrl;
  final String? localFilePath;
  final String? uploadStateLabel;

  /// Non-null only for a not-yet-referenced [MediaQueue] row.
  final String? localId;

  bool get isLocalOnly => localId != null;
  bool get isPhoto => kind == 'photo';
}

/// A network image that degrades to a plain broken-image placeholder
/// instead of letting an expired/unreachable signed URL surface as an
/// uncaught framework error -- a stale thumbnail must never crash the
/// gallery.
Widget _networkImage(String url, {BoxFit? fit}) {
  return Image.network(
    url,
    fit: fit,
    errorBuilder: (context, error, stackTrace) => ColoredBox(
      color: Colors.black12,
      child: Center(
        child: Icon(Icons.broken_image_outlined,
            color: Colors.black45.withAlpha(180)),
      ),
    ),
  );
}

String _uploadStateLabel(MediaQueueRecord row) {
  switch (row.uploadState) {
    case MediaUploadState.queued:
      return 'Queued';
    case MediaUploadState.uploading:
      final pct = row.sizeBytes > 0
          ? (row.uploadedBytes / row.sizeBytes * 100).clamp(0, 100).round()
          : null;
      return pct == null ? 'Uploading' : 'Uploading $pct%';
    case MediaUploadState.uploaded:
    case MediaUploadState.referenced:
      return 'Uploaded';
    case MediaUploadState.failed:
      return 'Failed';
  }
}

/// The inspection detail screen's media section (Phase 7.4): capture,
/// gallery, per-item before/after tag + checklist-item link, remove, and a
/// before/after comparison entry point. `editable` gates capture/remove/tag
/// actions the same way the checklist section does -- a `completed`/
/// `cancelled` inspection's media renders fully read-only.
class InspectionMediaSection extends StatefulWidget {
  const InspectionMediaSection({
    required this.inspectionId,
    required this.checklistItems,
    required this.serverMedia,
    required this.annotations,
    required this.editable,
    super.key,
  });

  final String inspectionId;
  final List<ChecklistTemplateItem> checklistItems;
  final List<InspectionMediaResponse> serverMedia;
  final List<AnnotationResponse> annotations;
  final bool editable;

  @override
  State<InspectionMediaSection> createState() => _InspectionMediaSectionState();
}

class _InspectionMediaSectionState extends State<InspectionMediaSection> {
  bool _showAnnotationOverlay = true;

  List<AnnotationResponse> _annotationsFor(String mediaLocalId) =>
      widget.annotations.where((a) => a.mediaLocalId == mediaLocalId).toList();
  Future<void> _capture() async {
    final result = await Navigator.of(context).push<MediaCaptureResult>(
      MaterialPageRoute(builder: (_) => const MediaCaptureScreen()),
    );
    if (result == null || !mounted) return;
    final companyId = AuthProvider.of(context).currentUser?.companyId;
    if (companyId == null) return;
    final mediaRepository = MediaProvider.repositoryOf(context);
    final worker = MediaProvider.workerOf(context);
    final position = await captureCurrentPosition();
    if (!mounted) return;
    await mediaRepository.enqueueCapture(
      companyId: companyId,
      inspectionId: widget.inspectionId,
      kind: result.kind,
      localFilePath: result.path,
      filename: result.filename,
      contentType: result.kind == 'video' ? 'video/mp4' : 'image/jpeg',
      sizeBytes: result.sizeBytes,
      gpsLat: position.lat,
      gpsLng: position.lng,
      capturedAt: DateTime.now().toUtc(),
    );
    worker.kick();
  }

  Future<void> _remove(_GalleryItem item) {
    if (item.isLocalOnly) {
      return MediaProvider.repositoryOf(context)
          .removeBeforeSync(item.localId!);
    }
    return SyncProvider.repositoryOf(context).enqueueDetachMedia(
      inspectionId: widget.inspectionId,
      mediaId: item.id,
    );
  }

  Future<void> _setTag(_GalleryItem item, String? tag) {
    if (item.isLocalOnly) {
      return MediaProvider.repositoryOf(context)
          .setBeforeAfterTag(item.localId!, tag);
    }
    return SyncProvider.repositoryOf(context).enqueueEditMedia(
      inspectionId: widget.inspectionId,
      mediaId: item.id,
      request: UpdateInspectionMediaRequest(
        (b) => b
          ..beforeAfterTag = tag == null
              ? null
              : UpdateInspectionMediaRequestBeforeAfterTagEnum.valueOf(tag),
      ),
    );
  }

  Future<void> _setChecklistItem(_GalleryItem item, String? checklistItemId) {
    if (item.isLocalOnly) {
      return MediaProvider.repositoryOf(context)
          .setChecklistItemId(item.localId!, checklistItemId);
    }
    // Synced media can only be RE-linked here, not cleared back to
    // unlinked -- `UpdateInspectionMediaRequest` treats a null field as
    // "leave unchanged" (mirrors `UpdateInspectionRequest`'s own
    // established limitation), so a "None" choice is simply not offered
    // once media has already synced (see `_ChecklistItemMenu`).
    if (checklistItemId == null) return Future.value();
    return SyncProvider.repositoryOf(context).enqueueEditMedia(
      inspectionId: widget.inspectionId,
      mediaId: item.id,
      request: UpdateInspectionMediaRequest(
          (b) => b..checklistItemId = checklistItemId),
    );
  }

  void _openComparison(List<_GalleryItem> items) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (_) => _MediaComparisonScreen(items: items)),
    );
  }

  void _view(_GalleryItem item) {
    if (item.isPhoto) {
      _openAnnotate(item);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => _MediaViewerScreen(item: item)),
    );
  }

  List<AnnotationPointResponse> _toPointResponses(List<Offset> points) => points
      .map((o) => AnnotationPointResponse((b) => b
        ..x = o.dx
        ..y = o.dy))
      .toList();

  void _openAnnotate(_GalleryItem item) {
    final repository = SyncProvider.repositoryOf(context);
    final currentUid = AuthProvider.of(context).currentUser?.uid ?? '';
    final imageProvider = item.networkUrl != null
        ? NetworkImage(item.networkUrl!) as ImageProvider
        : FileImage(File(item.localFilePath!));

    Future<List<AnnotationResponse>> refreshed() async {
      final record = await repository.getInspection(widget.inspectionId);
      return (record?.annotations ?? const [])
          .where((a) => a.mediaLocalId == item.mediaLocalId)
          .toList();
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AnnotationCanvasScreen(
          imageProvider: imageProvider,
          initialAnnotations: _annotationsFor(item.mediaLocalId),
          editable: widget.editable,
          onCreate: ({
            required shape,
            required points,
            required color,
            damageType,
            note,
          }) async {
            await repository.createAnnotation(
              inspectionId: widget.inspectionId,
              mediaLocalId: item.mediaLocalId,
              shape: shape,
              points: _toPointResponses(points),
              color: color,
              createdBy: currentUid,
              damageType: damageType,
              note: note,
            );
            return refreshed();
          },
          onUpdate: ({required annotationId, points, damageType, note}) async {
            await repository.updateAnnotation(
              inspectionId: widget.inspectionId,
              annotationId: annotationId,
              points: points == null ? null : _toPointResponses(points),
              damageType: damageType,
              note: note,
            );
            return refreshed();
          },
          onDelete: (annotationId) async {
            await repository.deleteAnnotation(
              inspectionId: widget.inspectionId,
              annotationId: annotationId,
            );
            return refreshed();
          },
          // Analysis needs a real server media id and a live network round
          // trip to the AI, so it's only offered once this photo has synced
          // -- a not-yet-uploaded item has no `onAnalyze` at all.
          onAnalyze: item.isLocalOnly
              ? null
              : () async {
                  await repository.analyzeMedia(
                    inspectionId: widget.inspectionId,
                    mediaId: item.id,
                  );
                  return refreshed();
                },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaRepository = MediaProvider.repositoryOf(context);
    return StreamBuilder<List<MediaQueueRecord>>(
      stream: mediaRepository.watchMediaForInspection(widget.inspectionId),
      builder: (context, snapshot) {
        // `MediaQueue` is shared with voice notes (Phase 7.6, `kind ==
        // 'audio'`) -- this gallery only ever renders photo/video tiles.
        final queued = (snapshot.data ?? const [])
            .where((row) => row.kind != 'audio')
            .toList();
        final items = <_GalleryItem>[
          ...widget.serverMedia.map(_GalleryItem.synced),
          ...queued.map(_GalleryItem.queued),
        ];
        final uploadedCount = widget.serverMedia.length;
        final pendingCount = queued
            .where((row) => row.uploadState != MediaUploadState.referenced)
            .length;
        final totalCount = uploadedCount + pendingCount;
        final canCompare = items
                .where((i) => i.beforeAfterTag == 'before' && i.isPhoto)
                .isNotEmpty &&
            items
                .where((i) => i.beforeAfterTag == 'after' && i.isPhoto)
                .isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('MEDIA',
                    style: TextStyle(
                        color: context.semantic.textMuted, letterSpacing: 1)),
                Row(
                  children: [
                    if (totalCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(right: DsSpacing.s2),
                        child: Text(
                          '$uploadedCount of $totalCount uploaded',
                          key: const Key('media-upload-progress'),
                          style: TextStyle(color: context.semantic.textMuted),
                        ),
                      ),
                    if (widget.annotations.isNotEmpty)
                      IconButton(
                        key: const Key('toggle-annotation-overlay'),
                        icon: Icon(
                          _showAnnotationOverlay
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18,
                        ),
                        tooltip: _showAnnotationOverlay
                            ? 'Hide annotations'
                            : 'Show annotations',
                        onPressed: () => setState(() =>
                            _showAnnotationOverlay = !_showAnnotationOverlay),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: DsSpacing.s2),
            if (items.isEmpty)
              const EmptyState(
                title: 'No media yet',
                description:
                    'Capture a photo or video to attach evidence to this inspection.',
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: DsSpacing.s2,
                  mainAxisSpacing: DsSpacing.s2,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _MediaTile(
                    key: Key('media-tile-${item.id}'),
                    item: item,
                    checklistItems: widget.checklistItems,
                    editable: widget.editable,
                    annotations: _showAnnotationOverlay
                        ? _annotationsFor(item.mediaLocalId)
                        : const [],
                    onTap: () => _view(item),
                    onRemove: () => unawaited(_remove(item)),
                    onSetTag: (tag) => unawaited(_setTag(item, tag)),
                    onSetChecklistItem: (id) =>
                        unawaited(_setChecklistItem(item, id)),
                  );
                },
              ),
            if (widget.editable) ...[
              const SizedBox(height: DsSpacing.s3),
              AppButton(
                label: 'Add photo/video',
                icon: Icons.add_a_photo_outlined,
                variant: AppButtonVariant.ghost,
                onPressed: () => unawaited(_capture()),
              ),
            ],
            if (canCompare) ...[
              const SizedBox(height: DsSpacing.s2),
              AppButton(
                label: 'Compare before/after',
                icon: Icons.compare_outlined,
                variant: AppButtonVariant.ghost,
                onPressed: () => _openComparison(items),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _MediaTile extends StatelessWidget {
  const _MediaTile({
    required this.item,
    required this.checklistItems,
    required this.editable,
    required this.annotations,
    required this.onTap,
    required this.onRemove,
    required this.onSetTag,
    required this.onSetChecklistItem,
    super.key,
  });

  final _GalleryItem item;
  final List<ChecklistTemplateItem> checklistItems;
  final bool editable;
  final List<AnnotationResponse> annotations;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final ValueChanged<String?> onSetTag;
  final ValueChanged<String?> onSetChecklistItem;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(DsRadius.md),
      child: Material(
        color: context.semantic.elevated,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (item.isPhoto)
                item.networkUrl != null
                    ? _networkImage(item.networkUrl!, fit: BoxFit.cover)
                    : Image.file(File(item.localFilePath!), fit: BoxFit.cover)
              else if (item.localFilePath != null)
                _LocalVideoThumbnail(path: item.localFilePath!)
              else
                const ColoredBox(
                  color: Colors.black45,
                  child: Center(
                      child:
                          Icon(Icons.play_circle_outline, color: Colors.white)),
                ),
              // At-a-glance preview only -- the tile crops via `BoxFit.cover`
              // while this paints against the full tile box, so it can be
              // very slightly offset for a non-square photo. The canvas
              // itself (opened on tap) is the authoritative, precisely
              // aligned view.
              if (item.isPhoto && annotations.isNotEmpty)
                Positioned.fill(
                    child: CustomPaint(
                        painter: AnnotationOverlayPainter(annotations))),
              if (item.beforeAfterTag != null)
                Positioned(
                  left: DsSpacing.s1,
                  top: DsSpacing.s1,
                  child: AppBadge(
                      label:
                          item.beforeAfterTag == 'before' ? 'Before' : 'After'),
                ),
              if (item.uploadStateLabel != null)
                Positioned(
                  left: DsSpacing.s1,
                  bottom: DsSpacing.s1,
                  right: DsSpacing.s1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(DsRadius.sm),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      child: Text(
                        item.uploadStateLabel!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              if (editable)
                Positioned(
                  right: 0,
                  top: 0,
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (choice) {
                      switch (choice) {
                        case 'before':
                          onSetTag('before');
                        case 'after':
                          onSetTag('after');
                        case 'untag':
                          onSetTag(null);
                        case 'remove':
                          onRemove();
                        default:
                          if (choice.startsWith('checklist:')) {
                            final id = choice.substring('checklist:'.length);
                            onSetChecklistItem(id.isEmpty ? null : id);
                          }
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: 'before', child: Text('Tag as before')),
                      const PopupMenuItem(
                          value: 'after', child: Text('Tag as after')),
                      if (item.beforeAfterTag != null)
                        const PopupMenuItem(
                            value: 'untag', child: Text('Remove tag')),
                      const PopupMenuDivider(),
                      if (item.isLocalOnly)
                        const PopupMenuItem(
                            value: 'checklist:',
                            child: Text('Unlink checklist item')),
                      for (final checklistItem in checklistItems)
                        PopupMenuItem(
                          value: 'checklist:${checklistItem.id}',
                          child: Text('Link: ${checklistItem.label}'),
                        ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                          value: 'remove', child: Text('Remove')),
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

class _LocalVideoThumbnail extends StatefulWidget {
  const _LocalVideoThumbnail({required this.path});

  final String path;

  @override
  State<_LocalVideoThumbnail> createState() => _LocalVideoThumbnailState();
}

class _LocalVideoThumbnailState extends State<_LocalVideoThumbnail> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    unawaited(_generate());
  }

  Future<void> _generate() async {
    try {
      final bytes = await VideoThumbnail.thumbnailData(
        video: widget.path,
        imageFormat: ImageFormat.JPEG,
        quality: 50,
        maxWidth: 240,
      );
      if (mounted) setState(() => _bytes = bytes);
    } catch (_) {
      // Falls back to the placeholder icon below; playback itself doesn't
      // depend on a thumbnail existing.
    }
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _bytes;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (bytes != null)
          Image.memory(bytes, fit: BoxFit.cover)
        else
          const ColoredBox(color: Colors.black45),
        const Center(
            child: Icon(Icons.play_circle_outline, color: Colors.white)),
      ],
    );
  }
}

class _MediaViewerScreen extends StatefulWidget {
  const _MediaViewerScreen({required this.item});

  final _GalleryItem item;

  @override
  State<_MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<_MediaViewerScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (!widget.item.isPhoto) {
      final controller = widget.item.networkUrl != null
          ? VideoPlayerController.networkUrl(Uri.parse(widget.item.networkUrl!))
          : VideoPlayerController.file(File(widget.item.localFilePath!));
      _controller = controller;
      unawaited(
        controller.initialize().then((_) {
          if (!mounted) return;
          setState(() {});
          controller.play();
        }),
      );
    }
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final controller = _controller;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:
          AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: Center(
        child: item.isPhoto
            ? (item.networkUrl != null
                ? _networkImage(item.networkUrl!)
                : Image.file(File(item.localFilePath!)))
            : (controller != null && controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  )
                : const AppLoader(label: 'Loading video')),
      ),
    );
  }
}

/// A hand-rolled drag-to-reveal slider (no third-party package) comparing
/// any 'before' + 'after' tagged photo the inspector picks -- the brief's
/// independent-tag model means these aren't a rigid linked pair, so the
/// pickers below cover every tagged photo, not just one designated set.
class _MediaComparisonScreen extends StatefulWidget {
  const _MediaComparisonScreen({required this.items});

  final List<_GalleryItem> items;

  @override
  State<_MediaComparisonScreen> createState() => _MediaComparisonScreenState();
}

class _MediaComparisonScreenState extends State<_MediaComparisonScreen> {
  _GalleryItem? _before;
  _GalleryItem? _after;
  double _sliderFraction = 0.5;

  String _label(_GalleryItem item) => formatCompanyDateTime(item.capturedAt);

  @override
  Widget build(BuildContext context) {
    final beforeItems = widget.items
        .where((i) => i.beforeAfterTag == 'before' && i.isPhoto)
        .toList();
    final afterItems = widget.items
        .where((i) => i.beforeAfterTag == 'after' && i.isPhoto)
        .toList();
    final before =
        _before ?? (beforeItems.isNotEmpty ? beforeItems.first : null);
    final after = _after ?? (afterItems.isNotEmpty ? afterItems.first : null);

    return Scaffold(
      appBar: AppBar(title: const Text('Before / after')),
      body: Padding(
        padding: const EdgeInsets.all(DsSpacing.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSelect<String>(
              label: 'Before photo',
              value: before?.id,
              items: [
                for (final item in beforeItems)
                  DropdownMenuItem(value: item.id, child: Text(_label(item))),
              ],
              onChanged: (id) => setState(
                  () => _before = beforeItems.firstWhere((i) => i.id == id)),
            ),
            const SizedBox(height: DsSpacing.s3),
            AppSelect<String>(
              label: 'After photo',
              value: after?.id,
              items: [
                for (final item in afterItems)
                  DropdownMenuItem(value: item.id, child: Text(_label(item))),
              ],
              onChanged: (id) => setState(
                  () => _after = afterItems.firstWhere((i) => i.id == id)),
            ),
            const SizedBox(height: DsSpacing.s4),
            if (before != null && after != null)
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _sliderFraction =
                              (details.localPosition.dx / constraints.maxWidth)
                                  .clamp(0.0, 1.0);
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(DsRadius.md),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _mediaImage(after),
                            ClipRect(
                              clipper: _LeftFractionClipper(_sliderFraction),
                              child: _mediaImage(before),
                            ),
                            Positioned(
                              left: constraints.maxWidth * _sliderFraction - 1,
                              top: 0,
                              bottom: 0,
                              child: Container(width: 2, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              const Expanded(
                child: EmptyState(
                  title: 'Nothing to compare yet',
                  description:
                      'Tag at least one before photo and one after photo first.',
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _mediaImage(_GalleryItem item) => item.networkUrl != null
      ? _networkImage(item.networkUrl!, fit: BoxFit.cover)
      : Image.file(File(item.localFilePath!), fit: BoxFit.cover);
}

class _LeftFractionClipper extends CustomClipper<Rect> {
  _LeftFractionClipper(this.fraction);

  final double fraction;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * fraction, size.height);

  @override
  bool shouldReclip(covariant _LeftFractionClipper oldClipper) =>
      oldClipper.fraction != fraction;
}
