import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';
import 'reports_controller.dart';
import 'reports_screen.dart' show ReportLinkOpener, UrlLauncherReportLinkOpener, reportLabel;

class ReportDetailScreen extends StatefulWidget {
  const ReportDetailScreen({
    required this.reportId,
    required this.controller,
    this.linkOpener = const UrlLauncherReportLinkOpener(),
    super.key,
  });

  final String reportId;
  final ReportsController controller;
  final ReportLinkOpener linkOpener;

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  LoadStatus _status = LoadStatus.loading;
  GeneratedReportDetail? _detail;
  String? _error;
  bool _saving = false;
  bool _regenerating = false;
  bool _finalizing = false;
  bool _deleting = false;

  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _recommendationsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _recommendationsController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _status = LoadStatus.loading);
    try {
      final detail = await widget.controller.getReport(widget.reportId);
      if (!mounted) return;
      _populateFields(detail);
      setState(() {
        _detail = detail;
        _status = LoadStatus.ready;
      });
    } catch (e, st) {
      debugPrint('REPORT DETAIL LOAD ERROR: $e\n$st');
      if (mounted) {
        setState(() {
          _status = LoadStatus.error;
          _error = 'Unable to load report detail: $e';
        });
      }
    }
  }

  void _populateFields(GeneratedReportDetail detail) {
    _titleController.text = detail.title;
    _summaryController.text = detail.narrative.summary;
    final recs = detail.narrative.recommendations;
    _recommendationsController.text =
        recs != null ? recs.map((e) => e).join('\n') : '';
  }

  Future<void> _saveEdits() async {
    final detail = _detail;
    if (detail == null) return;
    setState(() => _saving = true);
    try {
      final updated = await widget.controller.updateReport(
        detail.id,
        UpdateGeneratedReportRequest(
          (b) => b
            ..expectedRevision = detail.revision
            ..title = _titleController.text.trim()
            ..summary = _summaryController.text.trim()
            ..recommendations = ListBuilder<String>(
              _recommendationsController.text
                  .split('\n')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty),
            ),
        ),
      );
      if (!mounted) return;
      _populateFields(updated);
      setState(() => _detail = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report changes saved.')),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save report edits.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _regenerate() async {
    final detail = _detail;
    if (detail == null) return;
    setState(() => _regenerating = true);
    try {
      final updated = await widget.controller.regenerateReport(
        detail.id,
        RegenerateGeneratedReportRequest(
          (b) => b..expectedRevision = detail.revision,
        ),
      );
      if (!mounted) return;
      _populateFields(updated);
      setState(() => _detail = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Advisory narrative regenerated.')),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to regenerate narrative.')),
        );
      }
    } finally {
      if (mounted) setState(() => _regenerating = false);
    }
  }

  Future<void> _finalize() async {
    final detail = _detail;
    if (detail == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Finalize Report'),
        content: const Text(
          'I attest that I have reviewed the advisory AI narrative and human edits. Finalizing will freeze this report revision permanently.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Attest & Finalize'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    setState(() => _finalizing = true);
    try {
      final finalized = await widget.controller.finalizeReport(
        detail.id,
        FinalizeGeneratedReportRequest(
          (b) => b
            ..expectedRevision = detail.revision
            ..finalizationAttestation =
                FinalizeGeneratedReportRequestFinalizationAttestationEnum.true_,
        ),
      );
      if (!mounted) return;
      _populateFields(finalized);
      setState(() => _detail = finalized);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report finalized and locked.')),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to finalize report.')),
        );
      }
    } finally {
      if (mounted) setState(() => _finalizing = false);
    }
  }

  Future<void> _delete() async {
    final detail = _detail;
    if (detail == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Draft Report'),
        content: const Text(
          'Are you sure you want to delete this draft report? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    setState(() => _deleting = true);
    try {
      await widget.controller.deleteReport(detail.id);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete report draft.')),
        );
        setState(() => _deleting = false);
      }
    }
  }

  Future<void> _export(String format) async {
    final detail = _detail;
    if (detail == null) return;
    try {
      final listItem = GeneratedReportListItem(
        (b) => b
          ..id = detail.id
          ..title = detail.title
          ..reportType = GeneratedReportListItemReportTypeEnum.valueOf(
            detail.reportType.name,
          )
          ..status = GeneratedReportListItemStatusEnum.valueOf(
            detail.status.name,
          )
          ..revision = detail.revision
          ..createdBy = detail.createdBy
          ..createdAt = detail.createdAt
          ..updatedAt = detail.updatedAt,
      );
      final artifact = await widget.controller.export(listItem, format);
      if (artifact == null || !mounted) return;
      final opened = await widget.linkOpener.open(artifact.url);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(opened
            ? '${format.toUpperCase()} export downloaded'
            : 'Unable to open private download link'),
      ));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to export ${format.toUpperCase()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    return Scaffold(
      appBar: AppBar(
        title: Text(detail?.title ?? 'Report Detail'),
        actions: [
          if (detail != null &&
              detail.status == GeneratedReportDetailStatusEnum.draft)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleting ? null : _delete,
            ),
        ],
      ),
      body: _status == LoadStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : _status == LoadStatus.error || detail == null
              ? EmptyState(
                  title: 'Report Unavailable',
                  description: _error ?? 'Report could not be retrieved.',
                  action: AppButton(label: 'Retry', onPressed: _load),
                )
              : ListView(
                  padding: const EdgeInsets.all(DsSpacing.s6),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            detail.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        StatusPill(
                          label: reportLabel(detail.status.name),
                          status: detail.status ==
                                  GeneratedReportDetailStatusEnum.finalized
                              ? AppStatus.healthy
                              : AppStatus.info,
                        ),
                      ],
                    ),
                    const SizedBox(height: DsSpacing.s2),
                    Text(
                      '${reportLabel(detail.reportType.name)} · Revision ${detail.revision}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: DsSpacing.s4),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.auto_awesome,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: DsSpacing.s2),
                              Text(
                                'AI Advisory Narrative',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: DsSpacing.s2),
                          Text(
                            detail.narrative.summary,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: DsSpacing.s2),
                          const Text(
                            'AI findings are advisory. Review and edit human summary before finalization.',
                            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DsSpacing.s5),
                    if (detail.status == GeneratedReportDetailStatusEnum.draft) ...[
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                      ),
                      const SizedBox(height: DsSpacing.s4),
                      TextField(
                        controller: _summaryController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Executive Summary (Human Edit)',
                        ),
                      ),
                      const SizedBox(height: DsSpacing.s4),
                      TextField(
                        controller: _recommendationsController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Recommendations (One per line)',
                        ),
                      ),
                      const SizedBox(height: DsSpacing.s6),
                      Wrap(
                        spacing: DsSpacing.s3,
                        runSpacing: DsSpacing.s3,
                        children: [
                          AppButton(
                            label: 'Save Edits',
                            loading: _saving,
                            onPressed: _saving ? null : _saveEdits,
                          ),
                          AppButton(
                            label: 'Regenerate Narrative',
                            variant: AppButtonVariant.ghost,
                            loading: _regenerating,
                            onPressed: _regenerating ? null : _regenerate,
                          ),
                          AppButton(
                            label: 'Attest & Finalize',
                            variant: AppButtonVariant.accent,
                            loading: _finalizing,
                            onPressed: _finalizing ? null : _finalize,
                          ),
                        ],
                      ),
                    ] else ...[
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Executive Summary',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: DsSpacing.s2),
                            Text(detail.narrative.summary),
                            const SizedBox(height: DsSpacing.s4),
                            Text(
                              'Recommendations',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: DsSpacing.s2),
                            if (detail.narrative.recommendations != null)
                              for (final rec in detail.narrative.recommendations!)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text('• $rec'),
                                ),
                          ],
                        ),
                      ),
                      const SizedBox(height: DsSpacing.s6),
                      Text(
                        'Export Private Downloads',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: DsSpacing.s3),
                      Wrap(
                        spacing: DsSpacing.s3,
                        children: [
                          for (final format in const ['pdf', 'docx', 'xlsx'])
                            AppButton(
                              label: 'Export ${format.toUpperCase()}',
                              onPressed: () => _export(format),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
    );
  }
}
