import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';

class ReportCreateSheet extends StatefulWidget {
  const ReportCreateSheet({required this.onSubmit, super.key});

  final Future<void> Function(CreateGeneratedReportRequest request) onSubmit;

  @override
  State<ReportCreateSheet> createState() => _ReportCreateSheetState();
}

class _ReportCreateSheetState extends State<ReportCreateSheet> {
  CreateGeneratedReportRequestReportTypeEnum _reportType =
      CreateGeneratedReportRequestReportTypeEnum.inspection;
  final _titleController = TextEditingController();
  final _sourceIdController = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _titleController.dispose();
    _sourceIdController.dispose();
    super.dispose();
  }

  String get _sourceIdLabel {
    switch (_reportType) {
      case CreateGeneratedReportRequestReportTypeEnum.inspection:
        return 'Inspection ID';
      case CreateGeneratedReportRequestReportTypeEnum.maintenance:
        return 'Work Order ID';
      case CreateGeneratedReportRequestReportTypeEnum.safety:
        return 'Safety Report ID';
      case CreateGeneratedReportRequestReportTypeEnum.executiveSummary:
        return 'Facility ID';
      case CreateGeneratedReportRequestReportTypeEnum.assetHealth:
        return 'Asset ID';
      default:
        return 'Source ID';
    }
  }

  Future<void> _submit() async {
    final sourceId = _sourceIdController.text.trim();
    if (sourceId.isEmpty) {
      setState(() => _error = 'Please enter a valid $_sourceIdLabel');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    final request = CreateGeneratedReportRequest(
      (b) => b
        ..id = 'rep_${DateTime.now().millisecondsSinceEpoch}'
        ..reportType = _reportType
        ..sourceId = sourceId
        ..title = _titleController.text.trim().isNotEmpty
            ? _titleController.text.trim()
            : null,
    );

    try {
      await widget.onSubmit(request);
      if (mounted) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        } else {
          setState(() => _submitting = false);
        }
      }
    } catch (e, st) {
      debugPrint('REPORT CREATE SUBMIT ERROR: $e\n$st');
      if (mounted) {
        setState(() {
          _submitting = false;
          _error = 'Failed to generate report draft. Check Source ID.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.85;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: DsSpacing.s4,
            right: DsSpacing.s4,
            top: DsSpacing.s4,
            bottom: MediaQuery.of(context).viewInsets.bottom + DsSpacing.s4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Text(
              'Select report type and link source entity to generate structured advisory narrative.',
            ),
            const SizedBox(height: DsSpacing.s5),
            AppSelect<CreateGeneratedReportRequestReportTypeEnum>(
              label: 'Report Type',
              value: _reportType,
              onChanged: (val) {
                if (val != null) setState(() => _reportType = val);
              },
              items: const [
                DropdownMenuItem(
                  value: CreateGeneratedReportRequestReportTypeEnum.inspection,
                  child: Text('Inspection Report'),
                ),
                DropdownMenuItem(
                  value: CreateGeneratedReportRequestReportTypeEnum.maintenance,
                  child: Text('Maintenance Work Order Report'),
                ),
                DropdownMenuItem(
                  value: CreateGeneratedReportRequestReportTypeEnum.safety,
                  child: Text('Safety Incident Report'),
                ),
                DropdownMenuItem(
                  value: CreateGeneratedReportRequestReportTypeEnum.executiveSummary,
                  child: Text('Executive Summary Report'),
                ),
                DropdownMenuItem(
                  value: CreateGeneratedReportRequestReportTypeEnum.assetHealth,
                  child: Text('Asset Health Report'),
                ),
              ],
            ),
            const SizedBox(height: DsSpacing.s4),
            TextField(
              key: const Key('report-source-id-input'),
              controller: _sourceIdController,
              decoration: InputDecoration(
                labelText: _sourceIdLabel,
                hintText: 'Enter exact ID...',
              ),
            ),
            const SizedBox(height: DsSpacing.s4),
            TextField(
              key: const Key('report-title-input'),
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Report Title (Optional)',
                hintText: 'Auto-generated title if left blank',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: DsSpacing.s3),
              Text(_error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: DsSpacing.s6),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Cancel',
                    variant: AppButtonVariant.ghost,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: DsSpacing.s3),
                Expanded(
                  child: AppButton(
                    key: const Key('submit-generate-report'),
                    label: 'Generate Draft',
                    loading: _submitting,
                    onPressed: _submitting ? null : _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}
