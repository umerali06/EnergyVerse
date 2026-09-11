import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../auth/auth_controller.dart';
import '../auth/permissions.dart';
import '../dashboard/format.dart';
import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';
import 'local_safety_evidence_repository.dart';
import 'local_safety_reports_repository.dart';
import 'safety_evidence_upload_worker.dart';
import 'safety_reports_screen.dart';
import 'safety_sync_engine.dart';

class SafetyReportDetailScreen extends StatefulWidget {
  const SafetyReportDetailScreen({
    required this.reportId,
    this.currentUserId,
    super.key,
  });
  final String reportId;
  final String? currentUserId;

  @override
  State<SafetyReportDetailScreen> createState() =>
      _SafetyReportDetailScreenState();
}

class _SafetyReportDetailScreenState extends State<SafetyReportDetailScreen> {
  LocalSafetyReportsRepository? _repository;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repository ??= SafetySyncProvider.repositoryOf(context)
      ..refreshDetailFromNetwork(widget.reportId);
  }

  Future<void> _captureEvidence(String kind, ImageSource source) async {
    final picker = ImagePicker();
    final file = kind == 'photo'
        ? await picker.pickImage(source: source, imageQuality: 90)
        : await picker.pickVideo(
            source: source,
            maxDuration: const Duration(minutes: 3),
          );
    if (file == null || !mounted) return;
    try {
      final contentType = _contentType(file.name, kind);
      await SafetyEvidenceProvider.repositoryOf(context).importCapture(
        reportId: widget.reportId,
        kind: kind,
        sourcePath: file.path,
        filename: file.name,
        contentType: contentType,
      );
      if (!mounted) return;
      SafetyEvidenceProvider.workerOf(context).kick();
      ScaffoldMessenger.of(context).showSnackBar(
        buildAppToast('Evidence saved and queued for secure upload.'),
      );
    } on ArgumentError catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        buildAppToast(error.message?.toString() ?? 'Evidence is invalid.',
            status: AppStatus.critical),
      );
    }
  }

  Future<void> _chooseEvidence() => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (sheetContext) => SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take photo'),
              onTap: () {
                Navigator.pop(sheetContext);
                _captureEvidence('photo', ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose photo'),
              onTap: () {
                Navigator.pop(sheetContext);
                _captureEvidence('photo', ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam_outlined),
              title: const Text('Record video'),
              onTap: () {
                Navigator.pop(sheetContext);
                _captureEvidence('video', ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library_outlined),
              title: const Text('Choose video'),
              onTap: () {
                Navigator.pop(sheetContext);
                _captureEvidence('video', ImageSource.gallery);
              },
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final repository = _repository;
    if (repository == null) return const SizedBox.shrink();
    return StreamBuilder<LocalSafetyReportRecord?>(
      stream: repository.watchReport(widget.reportId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(DsSpacing.s6),
            child: AppSkeleton(height: 220),
          );
        }
        final record = snapshot.data;
        final report = record?.row;
        if (report == null || record == null) {
          return const EmptyState(
            title: 'Safety report unavailable',
            description:
                'This report is not stored on this device and could not be downloaded.',
          );
        }
        return ListView(
          key: const Key('safety-detail-scroll'),
          padding: const EdgeInsets.all(DsSpacing.s6),
          children: [
            Text(report.title,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: DsSpacing.s3),
            Wrap(spacing: DsSpacing.s2, runSpacing: DsSpacing.s2, children: [
              StatusPill(
                label: safetyLabel(report.severity),
                status: safetySeverityStatus(report.severity),
              ),
              StatusPill(
                label: safetyLabel(report.status),
                status: AppStatus.info,
              ),
              if (report.syncState != 'synced')
                StatusPill(
                  label: safetyLabel(report.syncState),
                  status: report.syncState == 'error'
                      ? AppStatus.critical
                      : AppStatus.warning,
                ),
            ]),
            const SizedBox(height: DsSpacing.s5),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Incident details',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: DsSpacing.s4),
                  _DetailRow('Category', safetyLabel(report.category)),
                  _DetailRow(
                      'Occurred', formatCompanyDateTime(report.occurredAt)),
                  _DetailRow('Reporter', report.reporterId),
                  if (report.assignedManagerId != null)
                    _DetailRow('Assigned manager', report.assignedManagerId!),
                  if (report.gpsLat != null && report.gpsLng != null)
                    _DetailRow('Location',
                        '${report.gpsLat!.toStringAsFixed(6)}, ${report.gpsLng!.toStringAsFixed(6)}'),
                  _DetailRow('Revision', report.revision.toString()),
                ],
              ),
            ),
            const SizedBox(height: DsSpacing.s4),
            _EvidenceSection(
              reportId: report.id,
              evidence: record.evidence,
              canAdd: PermissionProvider.of(context).can('safety.write') &&
                  report.status != 'closed' &&
                  report.status != 'cancelled',
              onAdd: _chooseEvidence,
            ),
            const SizedBox(height: DsSpacing.s4),
            _CorrectiveActionsSection(
              reportId: report.id,
              actions: record.correctiveActions,
              repository: repository,
              currentUserId: widget.currentUserId ??
                  (record.correctiveActions.isEmpty
                      ? null
                      : AuthProvider.of(context).currentUser?.uid),
            ),
            const SizedBox(height: DsSpacing.s4),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: DsSpacing.s3),
                  SelectableText(report.description),
                ],
              ),
            ),
            if (report.errorMessage != null) ...[
              const SizedBox(height: DsSpacing.s4),
              AppCard(
                child: Row(children: [
                  const Icon(Icons.sync_problem_outlined),
                  const SizedBox(width: DsSpacing.s3),
                  Expanded(child: Text(report.errorMessage!)),
                  TextButton(
                    onPressed: SafetySyncProvider.engineOf(context).syncNow,
                    child: const Text('Retry'),
                  ),
                ]),
              ),
            ],
          ],
        );
      },
    );
  }
}

String _contentType(String filename, String kind) {
  final lower = filename.toLowerCase();
  if (kind == 'photo') {
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    throw ArgumentError('Only JPEG and PNG safety photos are supported.');
  }
  if (lower.endsWith('.mov')) return 'video/quicktime';
  if (lower.endsWith('.mp4')) return 'video/mp4';
  throw ArgumentError('Only MP4 and MOV safety videos are supported.');
}

class _EvidenceSection extends StatelessWidget {
  const _EvidenceSection({
    required this.reportId,
    required this.evidence,
    required this.canAdd,
    required this.onAdd,
  });
  final String reportId;
  final List<SafetyEvidenceResponse> evidence;
  final bool canAdd;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final queued = SafetyEvidenceProvider.repositoryOf(context);
    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
              child: Text('Evidence',
                  style: Theme.of(context).textTheme.titleLarge)),
          if (canAdd)
            AppButton(
              key: const Key('add-safety-evidence'),
              label: 'Add evidence',
              icon: Icons.add_a_photo_outlined,
              variant: AppButtonVariant.ghost,
              onPressed: onAdd,
            ),
        ]),
        const SizedBox(height: DsSpacing.s3),
        for (final item in evidence)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(item.kind.name == 'photo'
                ? Icons.image_outlined
                : Icons.video_file_outlined),
            title: Text(item.filename),
            subtitle: Text('${item.contentType} • ${item.size} bytes'),
          ),
        StreamBuilder<List<SafetyEvidenceQueueRecord>>(
          stream: queued.watchForReport(reportId),
          builder: (context, snapshot) => Column(
            children: [
              for (final item
                  in snapshot.data ?? const <SafetyEvidenceQueueRecord>[])
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.cloud_upload_outlined),
                  title: Text(item.row.filename),
                  subtitle: Text(item.row.state == 'error'
                      ? item.row.lastError ?? 'Upload failed'
                      : 'Pending secure upload'),
                  trailing: item.row.state == 'error'
                      ? TextButton(
                          onPressed: () => queued.retry(item.row.localId),
                          child: const Text('Retry'),
                        )
                      : null,
                ),
            ],
          ),
        ),
        if (evidence.isEmpty)
          const Text('No uploaded evidence is attached to this report.'),
      ]),
    );
  }
}

class _CorrectiveActionsSection extends StatelessWidget {
  const _CorrectiveActionsSection({
    required this.reportId,
    required this.actions,
    required this.repository,
    required this.currentUserId,
  });
  final String reportId;
  final List<CorrectiveActionResponse> actions;
  final LocalSafetyReportsRepository repository;
  final String? currentUserId;

  Future<void> _update(BuildContext context, CorrectiveActionResponse action,
      UpdateCorrectiveActionRequestStatusEnum status) async {
    String? notes;
    if (status == UpdateCorrectiveActionRequestStatusEnum.completed) {
      final controller = TextEditingController();
      notes = await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Complete corrective action'),
          content: AppTextField(
            label: 'Completion notes',
            controller: controller,
            maxLines: 4,
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel')),
            AppButton(
              label: 'Complete',
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(dialogContext, controller.text.trim());
                }
              },
            ),
          ],
        ),
      );
      controller.dispose();
      if (notes == null) return;
    }
    await repository.updateCorrectiveActionOffline(
      reportId: reportId,
      actionId: action.id,
      status: status,
      completionNotes: notes,
    );
    if (context.mounted) SafetySyncProvider.engineOf(context).kick();
  }

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const AppCard(child: Text('No corrective actions are assigned.'));
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Corrective actions',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: DsSpacing.s3),
          for (final action in actions) ...[
            Text(action.description,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: DsSpacing.s1),
            Text(
                'Due ${formatCompanyDate(action.dueDate)} • ${safetyLabel(action.priority.name)}'),
            const SizedBox(height: DsSpacing.s2),
            StatusPill(
                label: safetyLabel(action.status.name), status: AppStatus.info),
            if (action.assigneeId == currentUserId &&
                action.status.name == 'open')
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _update(context, action,
                      UpdateCorrectiveActionRequestStatusEnum.inProgress),
                  child: const Text('Start action'),
                ),
              ),
            if (action.assigneeId == currentUserId &&
                action.status.name == 'inProgress')
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _update(context, action,
                      UpdateCorrectiveActionRequestStatusEnum.completed),
                  child: const Text('Complete action'),
                ),
              ),
            const Divider(),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: DsSpacing.s3),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 132, child: Text(label)),
          Expanded(child: SelectableText(value)),
        ]),
      );
}
