import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../assets/assets_screen.dart' show statusFor, statusLabel;
import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';
import '../shell/app_shell.dart' show ComingSoonScreen;

/// The scan surface (spec §6): asset info/status/media, plus the reserved
/// history/work-order sections as honest empty states until Phase 7/11 fill
/// them in, and a "Start Inspection" action that is a clearly-labeled stub
/// until Phase 7 implements the real flow.
class QrScanResultScreen extends StatelessWidget {
  const QrScanResultScreen({required this.result, super.key});

  final QrScanResult result;

  @override
  Widget build(BuildContext context) {
    final asset = result.asset;
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
            title: 'No inspections yet',
            description: 'Inspections will appear here once Phase 7 lands.',
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
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: const Text('Inspections')),
                  body: const ComingSoonScreen(moduleName: 'Inspections'),
                ),
              ),
            ),
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
