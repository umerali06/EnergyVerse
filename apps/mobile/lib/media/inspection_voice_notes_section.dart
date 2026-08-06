import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../auth/auth_controller.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import '../sync/sync_engine.dart';
import 'local_media_repository.dart';
import 'media_upload_worker.dart';
import 'voice_recording_screen.dart';

/// Unifies a server-synced [VoiceNoteResponse] and a not-yet-synced
/// [MediaQueueRecord] (`kind == 'audio'`) behind one shape, mirroring
/// `_GalleryItem` in `inspection_media_gallery.dart`.
class _VoiceItem {
  _VoiceItem.synced(VoiceNoteResponse note)
      : id = note.id,
        checklistItemId = note.checklistItemId,
        durationMs = note.durationMs,
        networkUrl = note.url,
        localFilePath = null,
        uploadStateLabel = null,
        localId = null;

  _VoiceItem.queued(MediaQueueRecord row)
      : id = row.localId,
        checklistItemId = row.checklistItemId,
        durationMs = row.durationMs ?? 0,
        networkUrl = null,
        localFilePath = row.localFilePath,
        uploadStateLabel = _uploadStateLabel(row),
        localId = row.localId;

  final String id;
  final String? checklistItemId;
  final int durationMs;
  final String? networkUrl;
  final String? localFilePath;
  final String? uploadStateLabel;

  /// Non-null only for a not-yet-referenced [MediaQueue] row.
  final String? localId;

  bool get isLocalOnly => localId != null;
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

ChecklistTemplateItem? _linkedChecklistItem(
  List<ChecklistTemplateItem> items,
  String? checklistItemId,
) {
  if (checklistItemId == null) return null;
  for (final item in items) {
    if (item.id == checklistItemId) return item;
  }
  return null;
}

/// The inspection detail screen's voice-notes section (Phase 7.6): record,
/// list, playback, per-item checklist-item link, and remove. Reuses the
/// exact same [MediaProvider]/[MediaQueueRecord] queue and worker as
/// [InspectionMediaSection] (Phase 7.4) -- a voice note's bytes upload the
/// same way a photo/video's do; only the storage subfolder and outbox
/// mutation type differ (`attach_voice_note` vs `attach_media`). `editable`
/// gates record/remove/link actions the same way the media section does.
class InspectionVoiceNotesSection extends StatefulWidget {
  const InspectionVoiceNotesSection({
    required this.inspectionId,
    required this.checklistItems,
    required this.serverVoiceNotes,
    required this.editable,
    super.key,
  });

  final String inspectionId;
  final List<ChecklistTemplateItem> checklistItems;
  final List<VoiceNoteResponse> serverVoiceNotes;
  final bool editable;

  @override
  State<InspectionVoiceNotesSection> createState() => _InspectionVoiceNotesSectionState();
}

class _InspectionVoiceNotesSectionState extends State<InspectionVoiceNotesSection> {
  final AudioPlayer _player = AudioPlayer();
  String? _playingId;
  StreamSubscription<void>? _completeSubscription;

  @override
  void initState() {
    super.initState();
    _completeSubscription = _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playingId = null);
    });
  }

  @override
  void dispose() {
    unawaited(_completeSubscription?.cancel());
    unawaited(_player.dispose());
    super.dispose();
  }

  Future<void> _record() async {
    final result = await Navigator.of(context).push<VoiceRecordingResult>(
      MaterialPageRoute(builder: (_) => const VoiceRecordingScreen()),
    );
    if (result == null || !mounted) return;
    final companyId = AuthProvider.of(context).currentUser?.companyId;
    if (companyId == null) return;
    final mediaRepository = MediaProvider.repositoryOf(context);
    final worker = MediaProvider.workerOf(context);
    await mediaRepository.enqueueCapture(
      companyId: companyId,
      inspectionId: widget.inspectionId,
      kind: 'audio',
      localFilePath: result.path,
      filename: result.filename,
      contentType: 'audio/mp4',
      sizeBytes: result.sizeBytes,
      capturedAt: DateTime.now().toUtc(),
      durationMs: result.durationMs,
    );
    worker.kick();
  }

  Future<void> _remove(_VoiceItem item) {
    if (item.isLocalOnly) {
      return MediaProvider.repositoryOf(context).removeBeforeSync(item.localId!);
    }
    return SyncProvider.repositoryOf(context).enqueueDetachVoiceNote(
      inspectionId: widget.inspectionId,
      voiceNoteId: item.id,
    );
  }

  Future<void> _setChecklistItem(_VoiceItem item, String? checklistItemId) {
    if (item.isLocalOnly) {
      return MediaProvider.repositoryOf(context)
          .setChecklistItemId(item.localId!, checklistItemId);
    }
    // Synced voice notes can only be RE-linked, not cleared back to
    // unlinked -- `UpdateVoiceNoteRequest` treats a null field as "leave
    // unchanged", mirroring `UpdateInspectionMediaRequest`'s own
    // established limitation.
    if (checklistItemId == null) return Future.value();
    return SyncProvider.repositoryOf(context).enqueueEditVoiceNote(
      inspectionId: widget.inspectionId,
      voiceNoteId: item.id,
      request: UpdateVoiceNoteRequest((b) => b..checklistItemId = checklistItemId),
    );
  }

  Future<void> _togglePlay(_VoiceItem item) async {
    if (_playingId == item.id) {
      await _player.pause();
      if (mounted) setState(() => _playingId = null);
      return;
    }
    final url = item.networkUrl;
    final path = item.localFilePath;
    try {
      if (url != null) {
        await _player.play(UrlSource(url));
      } else if (path != null) {
        await _player.play(DeviceFileSource(path));
      } else {
        return;
      }
      if (mounted) setState(() => _playingId = item.id);
    } catch (_) {
      // A stale/unreachable signed URL or a not-yet-flushed local file must
      // never crash the list -- same posture as the gallery's `_networkImage`.
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaRepository = MediaProvider.repositoryOf(context);
    return StreamBuilder<List<MediaQueueRecord>>(
      stream: mediaRepository.watchMediaForInspection(widget.inspectionId),
      builder: (context, snapshot) {
        final queued =
            (snapshot.data ?? const []).where((row) => row.kind == 'audio').toList();
        final items = <_VoiceItem>[
          ...widget.serverVoiceNotes.map(_VoiceItem.synced),
          ...queued.map(_VoiceItem.queued),
        ];
        final uploadedCount = widget.serverVoiceNotes.length;
        final pendingCount = queued
            .where((row) => row.uploadState != MediaUploadState.referenced)
            .length;
        final totalCount = uploadedCount + pendingCount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('VOICE NOTES',
                    style: TextStyle(color: context.semantic.textMuted, letterSpacing: 1)),
                if (totalCount > 0)
                  Text(
                    '$uploadedCount of $totalCount uploaded',
                    key: const Key('voice-upload-progress'),
                    style: TextStyle(color: context.semantic.textMuted),
                  ),
              ],
            ),
            const SizedBox(height: DsSpacing.s2),
            if (items.isEmpty)
              const EmptyState(
                title: 'No voice notes yet',
                description: 'Record a hands-free note to attach to this inspection.',
              )
            else
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: DsSpacing.s2),
                  child: _VoiceNoteTile(
                    key: Key('voice-tile-${item.id}'),
                    item: item,
                    checklistItems: widget.checklistItems,
                    editable: widget.editable,
                    playing: _playingId == item.id,
                    onTogglePlay: () => unawaited(_togglePlay(item)),
                    onRemove: () => unawaited(_remove(item)),
                    onSetChecklistItem: (id) => unawaited(_setChecklistItem(item, id)),
                  ),
                ),
              ),
            if (widget.editable) ...[
              const SizedBox(height: DsSpacing.s2),
              AppButton(
                label: 'Record voice note',
                icon: Icons.mic_none_outlined,
                variant: AppButtonVariant.ghost,
                onPressed: () => unawaited(_record()),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _VoiceNoteTile extends StatelessWidget {
  const _VoiceNoteTile({
    required this.item,
    required this.checklistItems,
    required this.editable,
    required this.playing,
    required this.onTogglePlay,
    required this.onRemove,
    required this.onSetChecklistItem,
    super.key,
  });

  final _VoiceItem item;
  final List<ChecklistTemplateItem> checklistItems;
  final bool editable;
  final bool playing;
  final VoidCallback onTogglePlay;
  final VoidCallback onRemove;
  final ValueChanged<String?> onSetChecklistItem;

  @override
  Widget build(BuildContext context) {
    final linked = _linkedChecklistItem(checklistItems, item.checklistItemId);
    return AppCard(
      child: Row(
        children: [
          IconButton(
            key: Key('voice-play-${item.id}'),
            icon: Icon(playing ? Icons.pause_circle_outline : Icons.play_circle_outline),
            onPressed: onTogglePlay,
          ),
          const SizedBox(width: DsSpacing.s2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formatVoiceNoteDuration(Duration(milliseconds: item.durationMs))),
                if (linked != null)
                  Text(
                    linked.label,
                    style: TextStyle(
                      color: context.semantic.textMuted,
                      fontSize: DsTypography.sizeCaption,
                    ),
                  ),
                if (item.uploadStateLabel != null)
                  Text(
                    item.uploadStateLabel!,
                    style: TextStyle(
                      color: context.semantic.textMuted,
                      fontSize: DsTypography.sizeCaption,
                    ),
                  ),
              ],
            ),
          ),
          if (editable)
            PopupMenuButton<String>(
              key: Key('voice-menu-${item.id}'),
              onSelected: (choice) {
                if (choice == 'remove') {
                  onRemove();
                } else if (choice.startsWith('checklist:')) {
                  final id = choice.substring('checklist:'.length);
                  onSetChecklistItem(id.isEmpty ? null : id);
                }
              },
              itemBuilder: (context) => [
                if (item.isLocalOnly)
                  const PopupMenuItem(
                      value: 'checklist:', child: Text('Unlink checklist item')),
                for (final checklistItem in checklistItems)
                  PopupMenuItem(
                    value: 'checklist:${checklistItem.id}',
                    child: Text('Link: ${checklistItem.label}'),
                  ),
                const PopupMenuDivider(),
                const PopupMenuItem(value: 'remove', child: Text('Remove')),
              ],
            ),
        ],
      ),
    );
  }
}
