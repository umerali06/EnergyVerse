import 'dart:async';

import 'package:flutter/material.dart';

import '../auth/app_routes.dart';
import '../auth/auth_controller.dart';
import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';
import 'local_permits_repository.dart';
import 'permit_sync_engine.dart';

String permitLabel(String value) => value
    .split('_')
    .map((word) =>
        word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
    .join(' ');

class PermitsScreen extends StatefulWidget {
  const PermitsScreen({this.workerId, super.key});
  final String? workerId;
  @override
  State<PermitsScreen> createState() => _PermitsScreenState();
}

class _PermitsScreenState extends State<PermitsScreen> {
  bool _refreshed = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_refreshed) {
      _refreshed = true;
      final uid = widget.workerId ?? AuthProvider.of(context).currentUser?.uid;
      if (uid != null) {
        unawaited(PermitSyncProvider.repositoryOf(context)
            .refreshAssignedFromNetwork(uid));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = PermitSyncProvider.repositoryOf(context);
    final sync = PermitSyncProvider.engineOf(context);
    return StreamBuilder<List<LocalPermitRecord>>(
      stream: repository.watchPermits(),
      builder: (context, snapshot) => ListView(
        padding: const EdgeInsets.all(DsSpacing.s6),
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Assigned permits',
                style: Theme.of(context).textTheme.headlineMedium),
            AnimatedBuilder(
                animation: sync,
                builder: (_, __) => sync.pendingOutboxCount == 0
                    ? const SizedBox.shrink()
                    : TextButton.icon(
                        onPressed: sync.syncNow,
                        icon: const Icon(Icons.sync),
                        label: Text('${sync.pendingOutboxCount} pending'))),
          ]),
          const SizedBox(height: DsSpacing.s2),
          const Text(
              'Safety controls and acknowledgements remain available from the local device cache.'),
          const SizedBox(height: DsSpacing.s5),
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData)
            const AppSkeleton(height: 100)
          else if ((snapshot.data ?? const []).isEmpty)
            const EmptyState(
                title: 'No assigned permits',
                description:
                    'No permits are assigned to you, or this device has not synced them yet.')
          else
            for (final permit in snapshot.data!)
              Padding(
                padding: const EdgeInsets.only(bottom: DsSpacing.s3),
                child: AppCard(
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(
                        AppRoutes.permitDetail,
                        arguments: permit.row.id),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(permit.row.title,
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: DsSpacing.s2),
                          Text(permit.row.permitNumber),
                          const SizedBox(height: DsSpacing.s2),
                          Wrap(spacing: DsSpacing.s2, children: [
                            StatusPill(
                                label: permitLabel(permit.row.status),
                                status: AppStatus.info),
                            if (permit.row.syncState != 'synced')
                              StatusPill(
                                  label: permitLabel(permit.row.syncState),
                                  status: permit.row.syncState == 'conflict'
                                      ? AppStatus.critical
                                      : AppStatus.warning),
                          ]),
                          const SizedBox(height: DsSpacing.s2),
                          Text(
                              'Valid until ${permit.row.validUntil.toLocal()}'),
                        ]),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
