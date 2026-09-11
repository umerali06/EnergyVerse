import 'dart:async';

import 'package:flutter/material.dart';

import '../auth/auth_controller.dart';
import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';
import 'local_permits_repository.dart';
import 'permit_sync_engine.dart';
import 'permits_screen.dart' show permitLabel;

class PermitDetailScreen extends StatefulWidget {
  const PermitDetailScreen({required this.permitId, this.workerId, super.key});
  final String permitId;
  final String? workerId;
  @override
  State<PermitDetailScreen> createState() => _PermitDetailScreenState();
}

class _PermitDetailScreenState extends State<PermitDetailScreen> {
  bool _refreshed = false;
  String? _shownConflict;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_refreshed) {
      _refreshed = true;
      unawaited(PermitSyncProvider.repositoryOf(context)
          .refreshDetailFromNetwork(widget.permitId));
    }
  }

  Future<void> _acknowledge() async {
    final repository = PermitSyncProvider.repositoryOf(context);
    final sync = PermitSyncProvider.engineOf(context);
    var attested = false;
    final accepted = await showAppModal<bool>(context,
        title: 'Acknowledge permit controls',
        child: StatefulBuilder(
            builder: (context, setSheetState) => ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.6),
                child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text(
                      'Confirm that you reviewed the work scope, checklist, approvals, hazards, and controls. Your identity and receipt time are verified by the server when synchronization succeeds.'),
                  CheckboxListTile(
                      value: attested,
                      onChanged: (value) =>
                          setSheetState(() => attested = value ?? false),
                      title: const Text(
                          'I understand and accept these permit controls'),
                      controlAffinity: ListTileControlAffinity.leading),
                  AppButton(
                      label: 'Sign acknowledgement',
                      onPressed: attested
                          ? () => Navigator.of(context).pop(true)
                          : null)
                ])))));
    if (accepted == true && mounted) {
      await repository.acknowledge(permitId: widget.permitId);
      sync.kick();
    }
  }

  Future<void> _showConflict(LocalPermitRecord record) async {
    if (_shownConflict == record.row.id) return;
    _shownConflict = record.row.id;
    final repository = PermitSyncProvider.repositoryOf(context);
    final keep = await showAppModal<bool>(context,
        title: 'Permit changed while offline',
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text(
              'Reload the server permit before deciding whether to re-sign against its current revision.'),
          const SizedBox(height: DsSpacing.s4),
          AppButton(
              label: 'Review server version and re-sign',
              onPressed: () => Navigator.of(context).pop(true)),
          const SizedBox(height: DsSpacing.s2),
          AppButton(
              label: 'Discard my pending acknowledgement',
              variant: AppButtonVariant.ghost,
              onPressed: () => Navigator.of(context).pop(false))
        ]));
    if (keep != null && mounted) {
      await repository.resolveConflict(widget.permitId,
          keepAcknowledgement: keep);
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = PermitSyncProvider.repositoryOf(context);
    final uid = widget.workerId ?? AuthProvider.of(context).currentUser?.uid;
    return StreamBuilder<LocalPermitRecord?>(
        stream: repository.watchPermit(widget.permitId),
        builder: (context, snapshot) {
          final record = snapshot.data;
          if (record == null) {
            return const Padding(
                padding: EdgeInsets.all(DsSpacing.s6),
                child: EmptyState(
                    title: 'Permit unavailable offline',
                    description:
                        'Connect once to securely cache this assigned permit.'));
          }
          if (record.row.syncState == 'conflict') {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _showConflict(record));
          } else {
            _shownConflict = null;
          }
          final permit = record.detail;
          final acknowledged =
              permit.workerAcknowledgements.any((item) => item.workerId == uid);
          final canAcknowledge = permit.status.name == 'pendingSignatures' &&
              !acknowledged &&
              record.row.syncState == 'synced';
          return ListView(
              padding: const EdgeInsets.all(DsSpacing.s6),
              children: [
                Text(permit.title,
                    style: Theme.of(context).textTheme.headlineSmall),
                Text('${permit.permitNumber} · revision ${permit.revision}'),
                const SizedBox(height: DsSpacing.s3),
                Wrap(spacing: DsSpacing.s2, children: [
                  StatusPill(
                      label: permitLabel(record.row.status),
                      status: AppStatus.info),
                  if (record.row.syncState != 'synced')
                    StatusPill(
                        label: permitLabel(record.row.syncState),
                        status: record.row.syncState == 'conflict'
                            ? AppStatus.critical
                            : AppStatus.warning)
                ]),
                const SizedBox(height: DsSpacing.s4),
                AppCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Work scope',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: DsSpacing.s2),
                      Text(permit.description),
                      const SizedBox(height: DsSpacing.s2),
                      Text(
                          'Valid ${permit.validFrom.toLocal()} — ${permit.validUntil.toLocal()}')
                    ])),
                const SizedBox(height: DsSpacing.s4),
                Text('Safety checklist',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: DsSpacing.s2),
                for (final item in permit.checklistSnapshot)
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(item.completed
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked),
                      title: Text(item.label),
                      subtitle:
                          item.helpText == null ? null : Text(item.helpText!)),
                const SizedBox(height: DsSpacing.s4),
                Text('Hazards and controls',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: DsSpacing.s2),
                for (final risk in permit.riskAssessment)
                  AppCard(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(risk.hazard,
                            style: Theme.of(context).textTheme.titleSmall),
                        Text('At risk: ${risk.personsAtRisk}'),
                        Text('Controls: ${risk.controls}'),
                        Text(
                            'Residual ${risk.residualScore} · ${permitLabel(risk.residualBand.name)}')
                      ])),
                const SizedBox(height: DsSpacing.s4),
                Text('Approvals',
                    style: Theme.of(context).textTheme.titleMedium),
                for (final step in permit.approvalSnapshot)
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(step.label),
                      trailing: Text(permitLabel(step.status.name))),
                const SizedBox(height: DsSpacing.s4),
                if (acknowledged)
                  const StatusPill(
                      label: 'Acknowledged', status: AppStatus.healthy)
                else if (record.row.syncState == 'pending_sync')
                  const Text('Acknowledgement is safely queued on this device.')
                else
                  AppButton(
                      label: 'Review and sign acknowledgement',
                      onPressed: canAcknowledge ? _acknowledge : null),
                if (record.row.syncState == 'error') ...[
                  const SizedBox(height: DsSpacing.s3),
                  Text(record.row.errorMessage ?? 'Synchronization failed'),
                  AppButton(
                      label: 'Retry synchronization',
                      variant: AppButtonVariant.ghost,
                      onPressed: PermitSyncProvider.engineOf(context).syncNow)
                ],
              ]);
        });
  }
}
