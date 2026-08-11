import 'dart:async';

import 'package:flutter/material.dart';

import '../auth/auth_controller.dart';
import '../dashboard/format.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import 'local_work_orders_repository.dart';
import 'work_order_sync_engine.dart';
import 'work_orders_screen.dart'
    show workOrderPriorityFor, workOrderPriorityLabel, workOrderStatusFor, workOrderStatusLabel;

/// Offline-first work order detail (pushed route) -- reads from the local
/// cache reactively, kicks a best-effort background network refresh, and
/// surfaces a conflict-resolution sheet on [WorkOrderLocalSyncState.conflict],
/// mirroring `InspectionDetailScreen`. "Accept Task" and "Submit for Review"
/// are only ever offered to the technician this work order is actually
/// assigned to (D-066's self-only rule, enforced server-side too) -- every
/// other action (assign/close/cancel) is a supervisor action taken from the
/// admin app, not offered here at all.
class WorkOrderDetailScreen extends StatefulWidget {
  const WorkOrderDetailScreen({required this.workOrderId, super.key});

  final String workOrderId;

  @override
  State<WorkOrderDetailScreen> createState() => _WorkOrderDetailScreenState();
}

class _WorkOrderDetailScreenState extends State<WorkOrderDetailScreen> {
  bool _refreshed = false;
  String? _conflictShownFor;
  bool _accepting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_refreshed) {
      _refreshed = true;
      unawaited(
        WorkOrderSyncProvider.repositoryOf(context)
            .refreshDetailFromNetwork(widget.workOrderId),
      );
    }
  }

  Future<void> _accept() async {
    setState(() => _accepting = true);
    try {
      await WorkOrderSyncProvider.repositoryOf(context)
          .acceptWorkOrder(widget.workOrderId);
    } finally {
      if (mounted) setState(() => _accepting = false);
    }
  }

  Future<void> _openSubmitForReview(LocalWorkOrderRecord workOrder) async {
    final result = await showAppModal<_SubmitForReviewResult>(
      context,
      title: 'Submit for review',
      child: _SubmitForReviewSheet(workOrder: workOrder),
    );
    if (result == null || !mounted) return;
    await WorkOrderSyncProvider.repositoryOf(context).submitWorkOrderForReview(
      widget.workOrderId,
      completionNotes: result.completionNotes,
      laborHours: result.laborHours,
      materialsUsed: result.materialsUsed,
    );
  }

  Future<void> _resolveConflict(bool keepLocal) {
    return WorkOrderSyncProvider.repositoryOf(context)
        .resolveConflict(widget.workOrderId, keepLocal: keepLocal);
  }

  Future<void> _maybeShowConflictSheet(LocalWorkOrderRecord workOrder) async {
    if (workOrder.row.syncState != 'conflict') {
      _conflictShownFor = null;
      return;
    }
    if (_conflictShownFor == workOrder.row.id) return;
    _conflictShownFor = workOrder.row.id;
    await _showConflictSheet(workOrder);
  }

  Future<void> _showConflictSheet(LocalWorkOrderRecord workOrder) async {
    final keepLocal = await showAppModal<bool>(
      context,
      title: 'This work order changed elsewhere',
      child: _ConflictSheetBody(
        onKeepMine: () => Navigator.of(context).pop(true),
        onUseServer: () => Navigator.of(context).pop(false),
      ),
    );
    if (keepLocal == null || !mounted) return;
    await _resolveConflict(keepLocal);
  }

  @override
  Widget build(BuildContext context) {
    final repository = WorkOrderSyncProvider.repositoryOf(context);
    final currentUid = AuthProvider.of(context).currentUser?.uid;
    return StreamBuilder<LocalWorkOrderRecord?>(
      stream: repository.watchWorkOrder(widget.workOrderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
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
        final workOrder = snapshot.data;
        if (workOrder == null) {
          return Padding(
            padding: const EdgeInsets.all(DsSpacing.s6),
            child: EmptyState(
              action: AppButton(
                label: 'Retry',
                onPressed: () =>
                    repository.refreshDetailFromNetwork(widget.workOrderId),
                variant: AppButtonVariant.ghost,
              ),
              description:
                  "This work order isn't on this device yet. Check your connection and try again.",
              title: "Couldn't find this work order",
            ),
          );
        }

        WidgetsBinding.instance
            .addPostFrameCallback((_) => _maybeShowConflictSheet(workOrder));

        final row = workOrder.row;
        final isAssignedToMe = currentUid != null && row.technicianId == currentUid;
        final canAccept = isAssignedToMe && row.status == 'assigned';
        final canSubmitForReview = isAssignedToMe && row.status == 'in_progress';
        final hasCompletionDetails =
            row.status == 'pending_review' || row.status == 'closed';

        return ListView(
          padding: const EdgeInsets.all(DsSpacing.s6),
          children: [
            Text(row.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: DsSpacing.s2),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: DsSpacing.s2,
              children: [
                StatusPill(
                  label: workOrderStatusLabel(row.status),
                  status: workOrderStatusFor(row.status),
                ),
                StatusPill(
                  label: workOrderPriorityLabel(row.priority),
                  status: workOrderPriorityFor(row.priority),
                ),
                if (row.syncState == 'pending_sync')
                  const StatusPill(label: 'Pending sync', status: AppStatus.info),
                if (row.syncState == 'conflict')
                  InkWell(
                    key: const Key('sync-state-badge'),
                    onTap: () => _showConflictSheet(workOrder),
                    child: const StatusPill(label: 'Conflict', status: AppStatus.critical),
                  ),
                if (row.syncState == 'error')
                  const StatusPill(label: 'Sync error', status: AppStatus.critical),
              ],
            ),
            if (row.syncState == 'error' && row.errorMessage != null) ...[
              const SizedBox(height: DsSpacing.s3),
              Text(row.errorMessage!, style: TextStyle(color: context.semantic.textMuted)),
            ],
            const SizedBox(height: DsSpacing.s5),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(label: 'Asset', value: row.assetId),
                  _InfoRow(
                    label: 'Due date',
                    value: row.dueDate != null ? formatCompanyDateTime(row.dueDate!) : '—',
                  ),
                  _InfoRow(label: 'Technician', value: row.technicianId ?? 'Unassigned'),
                ],
              ),
            ),
            if (row.description != null && row.description!.isNotEmpty) ...[
              const SizedBox(height: DsSpacing.s4),
              Text('DESCRIPTION',
                  style: TextStyle(color: context.semantic.textMuted, letterSpacing: 1)),
              const SizedBox(height: DsSpacing.s1),
              Text(row.description!),
            ],
            if (hasCompletionDetails) ...[
              const SizedBox(height: DsSpacing.s5),
              Text('COMPLETION DETAILS',
                  style: TextStyle(color: context.semantic.textMuted, letterSpacing: 1)),
              const SizedBox(height: DsSpacing.s2),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(
                      label: 'Labor hours',
                      value: row.laborHours != null ? row.laborHours!.toString() : '—',
                    ),
                    _InfoRow(
                      label: 'Materials used',
                      value: workOrder.materialsUsed.isEmpty
                          ? '—'
                          : workOrder.materialsUsed.join(', '),
                    ),
                    if (row.completionNotes != null && row.completionNotes!.isNotEmpty)
                      _InfoRow(label: 'Notes', value: row.completionNotes!),
                  ],
                ),
              ),
            ],
            if (canAccept || canSubmitForReview) ...[
              const SizedBox(height: DsSpacing.s5),
              if (canAccept)
                AppButton(
                  label: 'Accept task',
                  loading: _accepting,
                  onPressed: _accept,
                ),
              if (canSubmitForReview)
                AppButton(
                  label: 'Submit for review',
                  onPressed: () => _openSubmitForReview(workOrder),
                ),
            ],
          ],
        );
      },
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
          Text(label, style: TextStyle(color: context.semantic.textMuted)),
          Flexible(
            child: Text(value, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

class _SubmitForReviewResult {
  const _SubmitForReviewResult({
    required this.completionNotes,
    this.laborHours,
    this.materialsUsed = const [],
  });

  final String completionNotes;
  final double? laborHours;
  final List<String> materialsUsed;
}

class _SubmitForReviewSheet extends StatefulWidget {
  const _SubmitForReviewSheet({required this.workOrder});

  final LocalWorkOrderRecord workOrder;

  @override
  State<_SubmitForReviewSheet> createState() => _SubmitForReviewSheetState();
}

class _SubmitForReviewSheetState extends State<_SubmitForReviewSheet> {
  late final TextEditingController _notesController;
  late final TextEditingController _laborController;
  late final TextEditingController _materialsController;
  String? _error;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.workOrder.row.completionNotes);
    _laborController = TextEditingController(
      text: widget.workOrder.row.laborHours?.toString() ?? '',
    );
    _materialsController =
        TextEditingController(text: widget.workOrder.materialsUsed.join(', '));
  }

  @override
  void dispose() {
    _notesController.dispose();
    _laborController.dispose();
    _materialsController.dispose();
    super.dispose();
  }

  void _submit() {
    final notes = _notesController.text.trim();
    if (notes.isEmpty) {
      setState(() => _error = 'Describe the repair before submitting.');
      return;
    }
    final laborText = _laborController.text.trim();
    final laborHours = laborText.isEmpty ? null : double.tryParse(laborText);
    if (laborText.isNotEmpty && laborHours == null) {
      setState(() => _error = 'Labor hours must be a number.');
      return;
    }
    final materials = _materialsController.text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
    Navigator.of(context).pop(
      _SubmitForReviewResult(
        completionNotes: notes,
        laborHours: laborHours,
        materialsUsed: materials,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: _notesController,
          label: 'Completion notes',
          maxLines: 4,
        ),
        const SizedBox(height: DsSpacing.s3),
        AppTextField(
          controller: _laborController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          label: 'Labor hours (optional)',
        ),
        const SizedBox(height: DsSpacing.s3),
        AppTextField(
          controller: _materialsController,
          hint: 'Comma-separated, e.g. Gasket kit, Grease cartridge',
          label: 'Materials used (optional)',
        ),
        if (_error != null) ...[
          const SizedBox(height: DsSpacing.s2),
          Text(_error!, style: const TextStyle(color: DsColors.statusCritical)),
        ],
        const SizedBox(height: DsSpacing.s4),
        Align(
          alignment: Alignment.centerRight,
          child: AppButton(label: 'Submit for review', onPressed: _submit),
        ),
      ],
    );
  }
}

class _ConflictSheetBody extends StatelessWidget {
  const _ConflictSheetBody({required this.onKeepMine, required this.onUseServer});

  final VoidCallback onKeepMine;
  final VoidCallback onUseServer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'A supervisor changed this work order while your update was pending. '
          'Keep what you entered on this device, or discard it and use the '
          "server's current version.",
        ),
        const SizedBox(height: DsSpacing.s4),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton(
              key: const Key('conflict-use-server'),
              label: "Discard mine, use server's",
              onPressed: onUseServer,
              variant: AppButtonVariant.ghost,
            ),
            const SizedBox(width: DsSpacing.s2),
            AppButton(
              key: const Key('conflict-keep-mine'),
              label: 'Keep my version',
              onPressed: onKeepMine,
            ),
          ],
        ),
      ],
    );
  }
}
