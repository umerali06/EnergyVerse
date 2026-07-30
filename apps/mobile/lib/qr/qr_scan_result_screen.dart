import 'package:fev_api_client/fev_api_client.dart' show QrScanResult;
import 'package:flutter/material.dart';

import '../assets/assets_screen.dart' show statusFor, statusLabel;
import '../auth/app_routes.dart';
import '../auth/auth_controller.dart';
import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';
import '../inspections/local_inspections_repository.dart';
import '../sync/sync_engine.dart';

/// The scan surface (spec §6): asset info/status/media, plus the reserved
/// history/work-order sections as honest empty states until Phase 11 fills
/// them in, and a real "Start Inspection" action: writes a `draft`
/// inspection straight to the local cache (a client-generated UUID, ad-hoc
/// type, no device/GPS metadata yet -- no device-info/geolocation package
/// exists in this app) and lands on the detail screen immediately -- no
/// network round trip in the critical path (Phase 7.2). The sync engine
/// replays the queued create whenever a connection is available. The
/// checklist-filling capture flow itself is still 7.3's job.
class QrScanResultScreen extends StatefulWidget {
  const QrScanResultScreen({
    required this.result,
    this.repository,
    this.inspectorId,
    super.key,
  });

  final QrScanResult result;

  /// Overrides the ambient [SyncProvider]'s repository -- a testing seam
  /// (mirrors `qr_scan_screen.dart`'s injectable `scannerBuilder`) so widget
  /// tests can drive "Start Inspection" without a full auth/app context.
  final LocalInspectionsRepository? repository;

  /// Overrides the ambient [AuthProvider]'s current user uid -- same testing
  /// seam as [repository], for the same reason.
  final String? inspectorId;

  @override
  State<QrScanResultScreen> createState() => _QrScanResultScreenState();
}

class _QrScanResultScreenState extends State<QrScanResultScreen> {
  bool _startingInspection = false;

  Future<void> _startInspection() async {
    setState(() => _startingInspection = true);
    try {
      final repository = widget.repository ?? SyncProvider.repositoryOf(context);
      final inspectorId =
          widget.inspectorId ?? AuthProvider.of(context).currentUser?.uid ?? '';
      final id = await repository.createDraft(
        assetId: widget.result.asset.id,
        inspectorId: inspectorId,
        inspectionType: 'ad_hoc',
      );
      if (!mounted) return;
      await Navigator.of(
        context,
      ).pushNamed(AppRoutes.inspectionDetail, arguments: id);
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
    final asset = widget.result.asset;
    final mediaCount = (asset.photos?.length ?? 0) +
        (asset.documents?.length ?? 0) +
        (asset.manuals?.length ?? 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(DsSpacing.s6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            asset.assetTag,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: DsSpacing.s1),
          Text(asset.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: DsSpacing.s2),
          Wrap(
            spacing: DsSpacing.s2,
            runSpacing: DsSpacing.s2,
            children: [
              StatusPill(
                label: statusLabel(asset.currentStatus.name),
                status: statusFor(asset.currentStatus.name),
              ),
              AppBadge(label: asset.category),
            ],
          ),
          const SizedBox(height: DsSpacing.s5),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Asset info', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: DsSpacing.s3),
                _InfoRow(label: 'Manufacturer', value: asset.manufacturer ?? '—'),
                _InfoRow(label: 'Model', value: asset.model ?? '—'),
                _InfoRow(label: 'Serial number', value: asset.serialNumber ?? '—'),
                _InfoRow(label: 'Media attached', value: '$mediaCount'),
              ],
            ),
          ),
          const SizedBox(height: DsSpacing.s4),
          const EmptyState(
            title: 'No maintenance history yet',
            description: 'Maintenance history will appear here once Phase 11 lands.',
          ),
          const SizedBox(height: DsSpacing.s4),
          const EmptyState(
            title: 'No open work orders',
            description: 'Work orders will appear here once Phase 11 lands.',
          ),
          const SizedBox(height: DsSpacing.s5),
          AppButton(
            label: 'Start Inspection',
            icon: Icons.fact_check_outlined,
            loading: _startingInspection,
            onPressed: _startInspection,
          ),
        ],
      ),
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
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
