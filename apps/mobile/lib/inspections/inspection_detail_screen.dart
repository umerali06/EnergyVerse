import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../auth/auth_controller.dart';
import '../dashboard/format.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import '../media/inspection_media_gallery.dart';
import '../media/inspection_voice_notes_section.dart';
import '../sync/sync_engine.dart';
import 'inspection_measurements_section.dart';
import 'inspection_readings_section.dart';
import 'inspections_screen.dart'
    show inspectionStatusFor, inspectionStatusLabel, syncStateBadge;
import 'local_inspections_repository.dart';
import 'signature_pad.dart';

List<Offset> _responseStrokeToOffsets(SignatureStrokeResponse stroke) =>
    stroke.points.map((p) => Offset(p.x.toDouble(), p.y.toDouble())).toList();

List<Offset> _inputStrokeToOffsets(SignatureStrokeInput stroke) =>
    stroke.points.map((p) => Offset(p.x.toDouble(), p.y.toDouble())).toList();

/// Offline-first inspection detail (pushed route) -- reads from the local
/// cache reactively, kicks a best-effort background network refresh, and
/// surfaces a conflict-resolution sheet when [LocalSyncState.conflict].
/// Phase 7.3: while `draft`/`in_progress`, the checklist is interactive
/// (autosaving every answer through the local-first repository) instead of
/// the plain read-only rows this screen rendered through 7.2; a `draft`
/// also gets its checklist template auto-assigned (by the asset's category)
/// and transitions to `in_progress` the moment this screen opens, whether
/// that's a fresh start or resuming a stale local draft.
class InspectionDetailScreen extends StatefulWidget {
  const InspectionDetailScreen({required this.inspectionId, super.key});

  final String inspectionId;

  @override
  State<InspectionDetailScreen> createState() => _InspectionDetailScreenState();
}

class _InspectionDetailScreenState extends State<InspectionDetailScreen> {
  bool _started = false;
  bool _autoStartAttempted = false;
  String? _conflictShownFor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      unawaited(
        SyncProvider.repositoryOf(context)
            .refreshDetailFromNetwork(widget.inspectionId),
      );
    }
  }

  /// Runs once per screen visit, only for a `draft` inspection: assigns the
  /// best-matching local checklist template (by the asset's category,
  /// falling back to `Generic`, or leaves it unassigned if neither is
  /// cached) if one isn't already assigned, then transitions to
  /// `in_progress`. Entirely local -- works under airplane mode as long as
  /// the template cache was refreshed at least once while online.
  Future<void> _maybeAutoStart(LocalInspectionRecord inspection) async {
    if (_autoStartAttempted || inspection.status != 'draft') return;
    _autoStartAttempted = true;
    final repository = SyncProvider.repositoryOf(context);
    if (inspection.checklistTemplateId == null) {
      final category = inspection.assetCategory;
      if (category != null) {
        final template =
            await repository.selectChecklistTemplateForCategory(category);
        if (template != null) {
          await repository.assignChecklistTemplate(
            inspection.id,
            templateId: template.id,
            version: template.version,
            items: repository.decodeTemplateItems(template),
          );
        }
      }
    }
    await repository.startInspection(inspection.id);
  }

  Future<void> _resolveConflict(bool keepLocal) {
    return SyncProvider.repositoryOf(context)
        .resolveConflict(widget.inspectionId, keepLocal: keepLocal);
  }

  Future<void> _maybeShowConflictSheet(LocalInspectionRecord inspection) async {
    if (inspection.syncState != LocalSyncState.conflict) {
      _conflictShownFor = null;
      return;
    }
    if (_conflictShownFor == inspection.id) return;
    _conflictShownFor = inspection.id;
    await _showConflictSheet(inspection);
  }

  Future<void> _showConflictSheet(LocalInspectionRecord inspection) async {
    final server = inspection.conflictServerSnapshot;
    if (!mounted) return;
    await showAppModal<void>(
      context,
      title: 'This inspection changed elsewhere',
      child: _ConflictSheetBody(
        server: server,
        onKeepMine: () {
          Navigator.of(context).pop();
          unawaited(_resolveConflict(true));
        },
        onUseServer: () {
          Navigator.of(context).pop();
          unawaited(_resolveConflict(false));
        },
      ),
    );
  }

  /// Signature capture is the final step of completion (Phase 7.8): tapping
  /// "Complete Inspection" opens the signature pad first, and only a
  /// confirmed signature actually completes the inspection -- there's no
  /// way to complete without signing.
  Future<void> _completeInspection() async {
    final controller = SignaturePadController();
    final confirmed = await showAppModal<bool>(
      context,
      title: 'Sign to complete',
      child: _SignatureCaptureSheet(controller: controller),
    );
    final strokes = controller.toInput();
    controller.dispose();
    if (confirmed != true || !mounted) return;

    final repository = SyncProvider.repositoryOf(context);
    try {
      await repository.completeInspection(widget.inspectionId,
          strokes: strokes);
    } on ChecklistIncompleteError {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Answer every required item before completing.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = SyncProvider.repositoryOf(context);
    return StreamBuilder<LocalInspectionRecord?>(
      stream: repository.watchInspection(widget.inspectionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(DsSpacing.s6),
            child: Column(
              children: [
                AppSkeleton(height: 32),
                SizedBox(height: DsSpacing.s3),
                AppSkeleton(height: 120)
              ],
            ),
          );
        }
        final inspection = snapshot.data;
        if (inspection == null) {
          return Padding(
            padding: const EdgeInsets.all(DsSpacing.s6),
            child: EmptyState(
              action: AppButton(
                label: 'Retry',
                onPressed: () =>
                    repository.refreshDetailFromNetwork(widget.inspectionId),
                variant: AppButtonVariant.ghost,
              ),
              description:
                  "This inspection isn't on this device yet. Check your connection and try again.",
              title: "Couldn't find this inspection",
            ),
          );
        }

        WidgetsBinding.instance
            .addPostFrameCallback((_) => _maybeShowConflictSheet(inspection));
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _maybeAutoStart(inspection));

        final snapshotItems = inspection.checklistItemsSnapshot;
        final responses = inspection.checklistResponses;
        final badge = syncStateBadge(inspection.syncState);
        final editable =
            inspection.status == 'draft' || inspection.status == 'in_progress';
        final missing = missingRequiredItemIds(snapshotItems, responses);

        return ListView(
          padding: const EdgeInsets.all(DsSpacing.s6),
          children: [
            Text(
              inspection.title ?? 'Untitled inspection',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: DsSpacing.s2),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: DsSpacing.s2,
              children: [
                StatusPill(
                  label: inspectionStatusLabel(
                      wireToDartEnumName(inspection.status)),
                  status: inspectionStatusFor(
                      wireToDartEnumName(inspection.status)),
                ),
                AppBadge(
                    label: inspectionStatusLabel(
                        wireToDartEnumName(inspection.inspectionType))),
                if (badge != null)
                  InkWell(
                    key: const Key('sync-state-badge'),
                    onTap: inspection.syncState == LocalSyncState.conflict
                        ? () => _showConflictSheet(inspection)
                        : null,
                    child: badge,
                  ),
              ],
            ),
            if (inspection.syncState == LocalSyncState.error &&
                inspection.errorMessage != null) ...[
              const SizedBox(height: DsSpacing.s3),
              Text(
                inspection.errorMessage!,
                style: TextStyle(color: context.semantic.textMuted),
              ),
            ],
            const SizedBox(height: DsSpacing.s5),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(label: 'Asset', value: inspection.assetId),
                  _InfoRow(label: 'Inspector', value: inspection.inspectorId),
                  _InfoRow(
                    label: 'Started',
                    value: inspection.startedAt != null
                        ? formatCompanyDateTime(inspection.startedAt!)
                        : '—',
                  ),
                  _InfoRow(
                    label: 'Completed',
                    value: inspection.completedAt != null
                        ? formatCompanyDateTime(inspection.completedAt!)
                        : '—',
                  ),
                ],
              ),
            ),
            if (inspection.notes != null && inspection.notes!.isNotEmpty) ...[
              const SizedBox(height: DsSpacing.s4),
              Text('NOTES',
                  style: TextStyle(
                      color: context.semantic.textMuted, letterSpacing: 1)),
              const SizedBox(height: DsSpacing.s1),
              Text(inspection.notes!),
            ],
            const SizedBox(height: DsSpacing.s4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CHECKLIST',
                    style: TextStyle(
                        color: context.semantic.textMuted, letterSpacing: 1)),
                if (snapshotItems.isNotEmpty)
                  Text(
                    '${responses.where(isChecklistResponseAnswered).length} / ${snapshotItems.length}'
                    '${missing.isEmpty ? '' : ' · ${missing.length} required remaining'}',
                    style: TextStyle(color: context.semantic.textMuted),
                  ),
              ],
            ),
            const SizedBox(height: DsSpacing.s2),
            if (snapshotItems.isEmpty)
              const Text('No checklist template has been assigned yet.')
            else
              _ChecklistSection(
                key: ValueKey('checklist-${inspection.id}'),
                inspectionId: inspection.id,
                items: snapshotItems,
                responses: responses,
                editable: editable,
              ),
            const SizedBox(height: DsSpacing.s5),
            InspectionMediaSection(
              key: ValueKey('media-${inspection.id}'),
              inspectionId: inspection.id,
              checklistItems: snapshotItems,
              serverMedia: inspection.media,
              annotations: inspection.annotations,
              editable: editable,
            ),
            const SizedBox(height: DsSpacing.s5),
            InspectionVoiceNotesSection(
              key: ValueKey('voice-${inspection.id}'),
              inspectionId: inspection.id,
              checklistItems: snapshotItems,
              serverVoiceNotes: inspection.voiceNotes,
              editable: editable,
            ),
            const SizedBox(height: DsSpacing.s5),
            InspectionReadingsSection(
              key: ValueKey('readings-${inspection.id}'),
              inspectionId: inspection.id,
              readings: inspection.readings,
              editable: editable,
            ),
            if (inspection.signature != null ||
                inspection.pendingSignatureStrokes != null) ...[
              const SizedBox(height: DsSpacing.s5),
              Text('SIGNATURE',
                  style: TextStyle(
                      color: context.semantic.textMuted, letterSpacing: 1)),
              const SizedBox(height: DsSpacing.s2),
              _SignatureSummary(inspection: inspection),
            ],
            const SizedBox(height: DsSpacing.s5),
            InspectionMeasurementsSection(
              key: ValueKey('measurements-${inspection.id}'),
              inspectionId: inspection.id,
              measurements: inspection.arMeasurements,
              editable: editable,
            ),
            if (editable) ...[
              const SizedBox(height: DsSpacing.s5),
              AppButton(
                key: const Key('complete-inspection'),
                label: 'Complete Inspection',
                icon: Icons.check_circle_outline,
                onPressed: inspection.status == 'in_progress' && missing.isEmpty
                    ? _completeInspection
                    : null,
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Interactive, autosaving checklist body for `draft`/`in_progress`
/// inspections; falls back to the original static rows once `editable` is
/// false (`completed`/`cancelled`).
class _ChecklistSection extends StatefulWidget {
  const _ChecklistSection({
    required this.inspectionId,
    required this.items,
    required this.responses,
    required this.editable,
    super.key,
  });

  final String inspectionId;
  final List<ChecklistTemplateItem> items;
  final List<ChecklistResponse> responses;
  final bool editable;

  @override
  State<_ChecklistSection> createState() => _ChecklistSectionState();
}

class _ChecklistSectionState extends State<_ChecklistSection> {
  final Map<String, Timer> _debounce = {};
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final timer in _debounce.values) {
      timer.cancel();
    }
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  ChecklistResponse? _responseFor(String itemId) {
    for (final response in widget.responses) {
      if (response.itemId == itemId) return response;
    }
    return null;
  }

  TextEditingController _controllerFor(String itemId, String initialText) {
    return _controllers.putIfAbsent(
      itemId,
      () => TextEditingController(text: initialText),
    );
  }

  void _save(ChecklistTemplateItem item, Object rawValue) {
    final response = buildChecklistResponse(
      itemId: item.id,
      itemType: item.itemType,
      rawValue: rawValue,
    );
    unawaited(
      SyncProvider.repositoryOf(context).updateInspection(widget.inspectionId,
          checklistResponses: [response]),
    );
  }

  void _saveDebounced(ChecklistTemplateItem item, Object rawValue) {
    _debounce[item.id]?.cancel();
    _debounce[item.id] =
        Timer(const Duration(milliseconds: 500), () => _save(item, rawValue));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in widget.items)
          Padding(
            padding: const EdgeInsets.only(bottom: DsSpacing.s2),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.label,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      if (item.required_) const AppBadge(label: 'Required'),
                    ],
                  ),
                  if (item.helpText != null && item.helpText!.isNotEmpty) ...[
                    const SizedBox(height: DsSpacing.s1),
                    Text(
                      item.helpText!,
                      style: TextStyle(
                          color: context.semantic.textMuted,
                          fontSize: DsTypography.sizeCaption),
                    ),
                  ],
                  const SizedBox(height: DsSpacing.s2),
                  _buildInput(item),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInput(ChecklistTemplateItem item) {
    final response = _responseFor(item.id);
    final rawValue = response == null ? null : checklistResponseValue(response);

    if (!widget.editable) {
      return Text(
        rawValue?.toString() ?? 'Not answered',
        style: TextStyle(
          fontFamily: DsTypography.mono,
          fontSize: DsTypography.sizeCaption,
          color: context.semantic.textMuted,
        ),
      );
    }

    if (item.itemType == ChecklistTemplateItemItemTypeEnum.boolean) {
      final current = rawValue is bool ? rawValue : null;
      return Row(
        children: [
          Expanded(
            child: AppButton(
              key: Key('item-${item.id}-pass'),
              label: 'Pass',
              variant: current == true
                  ? AppButtonVariant.primary
                  : AppButtonVariant.ghost,
              onPressed: () => _save(item, true),
            ),
          ),
          const SizedBox(width: DsSpacing.s2),
          Expanded(
            child: AppButton(
              key: Key('item-${item.id}-fail'),
              label: 'Fail',
              variant: current == false
                  ? AppButtonVariant.danger
                  : AppButtonVariant.ghost,
              onPressed: () => _save(item, false),
            ),
          ),
        ],
      );
    }

    if (item.itemType == ChecklistTemplateItemItemTypeEnum.select) {
      final options = item.options?.toList() ?? const <String>[];
      final current =
          rawValue is String && options.contains(rawValue) ? rawValue : null;
      return AppSelect<String>(
        label: 'Select an option',
        value: current,
        items: [
          for (final option in options)
            DropdownMenuItem(value: option, child: Text(option)),
        ],
        onChanged: (value) {
          if (value == null) return;
          setState(() => _save(item, value));
        },
      );
    }

    if (item.itemType == ChecklistTemplateItemItemTypeEnum.numeric) {
      final initial = rawValue == null ? '' : rawValue.toString();
      return AppTextField(
        key: Key('item-${item.id}-numeric'),
        label: 'Value',
        controller: _controllerFor(item.id, initial),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (text) {
          final parsed = num.tryParse(text);
          if (parsed != null) _saveDebounced(item, parsed);
        },
      );
    }

    // text
    final initial = rawValue?.toString() ?? '';
    return AppTextField(
      key: Key('item-${item.id}-text'),
      label: 'Notes',
      controller: _controllerFor(item.id, initial),
      maxLines: 3,
      onChanged: (text) => _saveDebounced(item, text),
    );
  }
}

/// Read-only summary shown once the inspector has signed (Phase 7.8):
/// signer identity + timestamp from a synced [SignatureResponse], or a
/// "syncing" placeholder over the raw strokes while still offline/pending.
class _SignatureSummary extends StatelessWidget {
  const _SignatureSummary({required this.inspection});

  final LocalInspectionRecord inspection;

  @override
  Widget build(BuildContext context) {
    final signature = inspection.signature;
    if (signature != null) {
      return AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(
                label: 'Signed by',
                value: '${signature.signerName} (${signature.signerRole})'),
            _InfoRow(
                label: 'Signed at',
                value: formatCompanyDateTime(signature.signedAt)),
            const SizedBox(height: DsSpacing.s3),
            SignaturePreview(
              strokes: signature.strokes.map(_responseStrokeToOffsets).toList(),
            ),
          ],
        ),
      );
    }
    final pending = inspection.pendingSignatureStrokes;
    if (pending == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Signed — syncing…',
            style: TextStyle(color: context.semantic.textMuted)),
        const SizedBox(height: DsSpacing.s2),
        SignaturePreview(strokes: pending.map(_inputStrokeToOffsets).toList()),
      ],
    );
  }
}

/// The signature capture modal opened by "Complete Inspection" (Phase 7.8).
/// Signer identity/timestamp are never editable here -- they're recorded
/// server-side from the authenticated caller once this syncs; this sheet
/// only collects the drawn strokes.
class _SignatureCaptureSheet extends StatefulWidget {
  const _SignatureCaptureSheet({required this.controller});

  final SignaturePadController controller;

  @override
  State<_SignatureCaptureSheet> createState() => _SignatureCaptureSheetState();
}

class _SignatureCaptureSheetState extends State<_SignatureCaptureSheet> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthProvider.of(context).currentUser;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          currentUser == null
              ? 'Signing as you — timestamp recorded automatically.'
              : 'Signing as ${currentUser.email} — timestamp recorded automatically.',
          style: TextStyle(color: context.semantic.textMuted),
        ),
        const SizedBox(height: DsSpacing.s4),
        SignaturePad(controller: widget.controller),
        const SizedBox(height: DsSpacing.s3),
        Row(
          children: [
            Expanded(
              child: AppButton(
                key: const Key('signature-clear'),
                label: 'Clear',
                variant: AppButtonVariant.ghost,
                onPressed:
                    widget.controller.isEmpty ? null : widget.controller.clear,
              ),
            ),
          ],
        ),
        const SizedBox(height: DsSpacing.s4),
        AppButton(
          key: const Key('signature-confirm'),
          label: 'Sign & Complete',
          icon: Icons.check_circle_outline,
          onPressed: widget.controller.isEmpty
              ? null
              : () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}

class _ConflictSheetBody extends StatelessWidget {
  const _ConflictSheetBody({
    required this.server,
    required this.onKeepMine,
    required this.onUseServer,
  });

  final InspectionDetail? server;
  final VoidCallback onKeepMine;
  final VoidCallback onUseServer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Someone else updated this inspection before your offline changes "
          'synced. Choose which version to keep -- the other will be lost.',
          style: TextStyle(color: context.semantic.textMuted),
        ),
        if (server != null) ...[
          const SizedBox(height: DsSpacing.s4),
          AppCard(
            child: _InfoRow(
              label: 'Server revision',
              value: '${server!.revision}',
            ),
          ),
        ],
        const SizedBox(height: DsSpacing.s5),
        AppButton(
          key: const Key('conflict-keep-mine'),
          label: 'Keep my version',
          onPressed: onKeepMine,
        ),
        const SizedBox(height: DsSpacing.s2),
        AppButton(
          key: const Key('conflict-use-server'),
          label: "Discard mine, use server's",
          onPressed: onUseServer,
          variant: AppButtonVariant.ghost,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DsSpacing.s1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
