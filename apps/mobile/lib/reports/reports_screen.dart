import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api_service.dart';
import '../auth/auth_controller.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';
import 'reports_controller.dart';

import 'report_create_sheet.dart';
import 'report_detail_screen.dart';

abstract interface class ReportLinkOpener {
  Future<bool> open(String url);
}

class UrlLauncherReportLinkOpener implements ReportLinkOpener {
  const UrlLauncherReportLinkOpener();

  @override
  Future<bool> open(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

String reportLabel(String value) => value
    .replaceAllMapped(
        RegExp(r'([a-z])([A-Z])'), (match) => '${match[1]} ${match[2]}')
    .split('_')
    .map((word) =>
        word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
    .join(' ');

class ReportsScreen extends StatefulWidget {
  const ReportsScreen(
      {this.api,
      this.linkOpener = const UrlLauncherReportLinkOpener(),
      super.key});

  final GeneratedReportsApiContract? api;
  final ReportLinkOpener linkOpener;

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  ReportsController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    final candidate = widget.api ?? AuthProvider.of(context).api;
    if (candidate is! GeneratedReportsApiContract) return;
    _controller = ReportsController(api: candidate)..start();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _openCreateSheet() async {
    final controller = _controller;
    if (controller == null) return;
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => ReportCreateSheet(
        onSubmit: (req) => controller.createReport(req),
      ),
    );
  }

  Future<void> _openDetail(GeneratedReportListItem report) async {
    final controller = _controller;
    if (controller == null) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (ctx) => ReportDetailScreen(
          reportId: report.id,
          controller: controller,
          linkOpener: widget.linkOpener,
        ),
      ),
    );
  }

  Future<void> _export(GeneratedReportListItem report, String format) async {
    final controller = _controller;
    if (controller == null) return;
    try {
      final artifact = await controller.export(report, format);
      if (artifact == null || !mounted) return;
      final opened = await widget.linkOpener.open(artifact.url);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(opened
            ? '${format.toUpperCase()} export ready'
            : 'Unable to open the private download'),
      ));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Unable to export ${format.toUpperCase()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return const EmptyState(
          title: 'Reports unavailable',
          description: 'This API client does not provide generated reports.');
    }
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => ListView(
        key: const Key('reports-scroll'),
        padding: const EdgeInsets.all(DsSpacing.s6),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reports', style: Theme.of(context).textTheme.headlineMedium),
              AppButton(
                key: const Key('create-report-button'),
                label: '+ Create Report',
                onPressed: _openCreateSheet,
              ),
            ],
          ),
          const SizedBox(height: DsSpacing.s2),
          const Text(
              'Review tenant report snapshots and open finalized private exports.'),
          const SizedBox(height: DsSpacing.s5),
          Row(children: [
            Expanded(
                child: AppSelect<String?>(
                    label: 'Report type',
                    value: controller.reportType,
                    onChanged: (value) => controller.setReportType(value),
                    items: const [
                  DropdownMenuItem(value: null, child: Text('All types')),
                  DropdownMenuItem(
                      value: 'inspection', child: Text('Inspection')),
                  DropdownMenuItem(
                      value: 'maintenance', child: Text('Maintenance')),
                  DropdownMenuItem(value: 'safety', child: Text('Safety')),
                  DropdownMenuItem(
                      value: 'executive_summary',
                      child: Text('Executive summary')),
                  DropdownMenuItem(
                      value: 'asset_health', child: Text('Asset health'))
                ])),
            const SizedBox(width: DsSpacing.s3),
            Expanded(
                child: AppSelect<String?>(
                    label: 'Status',
                    value: controller.reportStatus,
                    onChanged: (value) => controller.setStatus(value),
                    items: const [
                  DropdownMenuItem(value: null, child: Text('All statuses')),
                  DropdownMenuItem(value: 'draft', child: Text('Draft')),
                  DropdownMenuItem(value: 'finalized', child: Text('Finalized'))
                ])),
          ]),
          const SizedBox(height: DsSpacing.s5),
          if (controller.status == LoadStatus.loading) ...[
            const AppSkeleton(height: 110),
            const SizedBox(height: DsSpacing.s3),
            const AppSkeleton(height: 110)
          ] else if (controller.status == LoadStatus.error)
            EmptyState(
                title: 'Reports unavailable',
                description: 'Check your connection and retry.',
                action: AppButton(label: 'Retry', onPressed: controller.retry))
          else if (controller.items.isEmpty)
            const EmptyState(
                title: 'No reports found',
                description: 'No generated reports match these filters.')
          else ...[
            for (final report in controller.items) ...[
              _ReportCard(
                  report: report,
                  exportingKey: controller.exportingKey,
                  onTap: () => _openDetail(report),
                  onExport: (format) => _export(report, format)),
              const SizedBox(height: DsSpacing.s3),
            ],
            if (controller.nextCursor != null)
              AppButton(
                  label: 'Load more',
                  loading: controller.loadingMore,
                  variant: AppButtonVariant.ghost,
                  onPressed: controller.loadMore),
          ],
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard(
      {required this.report,
      required this.exportingKey,
      required this.onTap,
      required this.onExport});

  final GeneratedReportListItem report;
  final String? exportingKey;
  final VoidCallback onTap;
  final ValueChanged<String> onExport;

  @override
  Widget build(BuildContext context) {
    final finalized =
        report.status == GeneratedReportListItemStatusEnum.finalized;
    return AppCard(
        child: InkWell(
            onTap: onTap,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            child: Text(report.title,
                style: Theme.of(context).textTheme.titleMedium)),
        const SizedBox(width: DsSpacing.s2),
        StatusPill(
            label: reportLabel(report.status.name),
            status: finalized ? AppStatus.healthy : AppStatus.info)
      ]),
      const SizedBox(height: DsSpacing.s2),
      Text(
          '${reportLabel(report.reportType.name)} · revision ${report.revision}',
          style: Theme.of(context).textTheme.bodySmall),
      Text('Updated ${report.updatedAt.toLocal()}',
          style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: DsSpacing.s3),
      if (!finalized)
        const Text('Finalize this report before exporting.',
            key: Key('draft-export-gate'))
      else
        Wrap(spacing: DsSpacing.s2, runSpacing: DsSpacing.s2, children: [
          for (final format in const ['pdf', 'docx', 'xlsx'])
            AppButton(
                key: Key('export-$format-${report.id}'),
                label: format.toUpperCase(),
                loading: exportingKey == '${report.id}:$format',
                variant: AppButtonVariant.ghost,
                onPressed: () => onExport(format))
        ]),
    ])));
  }
}
