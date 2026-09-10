import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../auth/app_routes.dart';
import '../auth/auth_controller.dart';
import '../auth/permissions.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../dashboard/format.dart';
import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';
import '../inspections/gps_capture.dart';
import 'safety_reports_controller.dart';
import 'safety_sync_engine.dart';

String safetyLabel(String value) => value
    .split('_')
    .map((word) =>
        word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
    .join(' ');

AppStatus safetySeverityStatus(String severity) => switch (severity) {
      'critical' => AppStatus.critical,
      'high' => AppStatus.warning,
      'medium' => AppStatus.info,
      _ => AppStatus.healthy,
    };

class SafetyReportsScreen extends StatefulWidget {
  const SafetyReportsScreen({super.key});

  @override
  State<SafetyReportsScreen> createState() => _SafetyReportsScreenState();
}

class _SafetyReportsScreenState extends State<SafetyReportsScreen> {
  SafetyReportsController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= SafetyReportsController(
      repository: SafetySyncProvider.repositoryOf(context),
    )..start();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _reportIncident() async {
    final user = AuthProvider.of(context).currentUser;
    if (user == null) return;
    final repository = SafetySyncProvider.repositoryOf(context);
    final sync = SafetySyncProvider.engineOf(context);
    final id = await showDialog<String>(
      context: context,
      builder: (_) => _ReportIncidentDialog(
        onSubmit: ({
          required category,
          required severity,
          required title,
          required description,
          required occurredAt,
          gpsLat,
          gpsLng,
        }) =>
            repository.createOffline(
          reporterId: user.uid,
          category: category,
          severity: severity,
          title: title,
          description: description,
          occurredAt: occurredAt,
          gpsLat: gpsLat,
          gpsLng: gpsLng,
        ),
      ),
    );
    if (!mounted || id == null) return;
    sync.kick();
    Navigator.of(context).pushNamed(AppRoutes.safetyDetail, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();
    final canWrite = PermissionProvider.of(context).can('safety.write');
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => ListView(
        key: const Key('safety-reports-scroll'),
        padding: const EdgeInsets.all(DsSpacing.s6),
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: DsSpacing.s3,
            runSpacing: DsSpacing.s3,
            children: [
              Text('Safety Reports',
                  style: Theme.of(context).textTheme.headlineMedium),
              if (canWrite)
                AppButton(
                  key: const Key('report-incident'),
                  label: 'Report incident',
                  icon: Icons.add_alert_outlined,
                  onPressed: _reportIncident,
                ),
            ],
          ),
          const SizedBox(height: DsSpacing.s2),
          const Text('Incidents and hazards remain available while offline.'),
          const SizedBox(height: DsSpacing.s5),
          Row(children: [
            Expanded(
              child: AppSelect<String?>(
                label: 'Status',
                value: controller.statusFilter,
                onChanged: controller.setStatusFilter,
                items: const [
                  DropdownMenuItem(value: null, child: Text('All statuses')),
                  DropdownMenuItem(value: 'reported', child: Text('Reported')),
                  DropdownMenuItem(
                      value: 'under_review', child: Text('Under review')),
                  DropdownMenuItem(
                      value: 'corrective_action',
                      child: Text('Corrective action')),
                  DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
                  DropdownMenuItem(value: 'closed', child: Text('Closed')),
                  DropdownMenuItem(
                      value: 'cancelled', child: Text('Cancelled')),
                ],
              ),
            ),
            const SizedBox(width: DsSpacing.s3),
            Expanded(
              child: AppSelect<String?>(
                label: 'Severity',
                value: controller.severityFilter,
                onChanged: controller.setSeverityFilter,
                items: const [
                  DropdownMenuItem(value: null, child: Text('All severities')),
                  DropdownMenuItem(value: 'low', child: Text('Low')),
                  DropdownMenuItem(value: 'medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'high', child: Text('High')),
                  DropdownMenuItem(value: 'critical', child: Text('Critical')),
                ],
              ),
            ),
          ]),
          const SizedBox(height: DsSpacing.s5),
          if (controller.status == LoadStatus.loading) ...[
            const AppSkeleton(height: 96),
            const SizedBox(height: DsSpacing.s3),
            const AppSkeleton(height: 96),
          ] else if (controller.status == LoadStatus.error)
            EmptyState(
              title: 'Safety reports unavailable',
              description: 'The local safety cache could not be opened.',
              action: AppButton(
                label: 'Retry',
                variant: AppButtonVariant.ghost,
                onPressed: controller.retry,
              ),
            )
          else if (controller.items.isEmpty)
            const EmptyState(
              title: 'No safety reports found',
              description: 'No reports match the selected filters.',
            )
          else
            for (final report in controller.items)
              Padding(
                padding: const EdgeInsets.only(bottom: DsSpacing.s3),
                child: AppCard(
                  child: InkWell(
                    key: ValueKey('safety-${report.row.id}'),
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRoutes.safetyDetail,
                      arguments: report.row.id,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(report.row.title,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: DsSpacing.s2),
                        Wrap(
                            spacing: DsSpacing.s2,
                            runSpacing: DsSpacing.s2,
                            children: [
                              StatusPill(
                                label: safetyLabel(report.row.severity),
                                status:
                                    safetySeverityStatus(report.row.severity),
                              ),
                              StatusPill(
                                label: safetyLabel(report.row.status),
                                status: AppStatus.info,
                              ),
                              if (report.row.syncState != 'synced')
                                StatusPill(
                                  label: safetyLabel(report.row.syncState),
                                  status: report.row.syncState == 'error'
                                      ? AppStatus.critical
                                      : AppStatus.warning,
                                ),
                            ]),
                        const SizedBox(height: DsSpacing.s2),
                        Text(
                            '${safetyLabel(report.row.category)} • ${formatCompanyDateTime(report.row.occurredAt)}'),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

typedef SubmitIncident = Future<String> Function({
  required CreateSafetyReportRequestCategoryEnum category,
  required CreateSafetyReportRequestSeverityEnum severity,
  required String title,
  required String description,
  required DateTime occurredAt,
  double? gpsLat,
  double? gpsLng,
});

class _ReportIncidentDialog extends StatefulWidget {
  const _ReportIncidentDialog({required this.onSubmit});
  final SubmitIncident onSubmit;

  @override
  State<_ReportIncidentDialog> createState() => _ReportIncidentDialogState();
}

class _ReportIncidentDialogState extends State<_ReportIncidentDialog> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  var _category = CreateSafetyReportRequestCategoryEnum.nearMiss;
  var _severity = CreateSafetyReportRequestSeverityEnum.medium;
  var _occurredAt = DateTime.now();
  GpsPosition _position = (lat: null, lng: null);
  bool _locating = false;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _captureLocation() async {
    setState(() => _locating = true);
    final position = await captureCurrentPosition();
    if (!mounted) return;
    setState(() {
      _position = position;
      _locating = false;
    });
  }

  Future<void> _submit() async {
    if (_title.text.trim().isEmpty || _description.text.trim().isEmpty) {
      setState(() => _error = 'Title and description are required.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final id = await widget.onSubmit(
      category: _category,
      severity: _severity,
      title: _title.text,
      description: _description.text,
      occurredAt: _occurredAt,
      gpsLat: _position.lat,
      gpsLng: _position.lng,
    );
    if (mounted) Navigator.of(context).pop(id);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Report safety incident'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            AppTextField(
                key: const Key('incident-title'),
                label: 'Title',
                controller: _title),
            const SizedBox(height: DsSpacing.s3),
            AppTextField(
              key: const Key('incident-description'),
              label: 'Description',
              controller: _description,
              maxLines: 4,
            ),
            const SizedBox(height: DsSpacing.s3),
            AppSelect(
              label: 'Category',
              value: _category,
              onChanged: (value) => setState(() => _category = value!),
              items: CreateSafetyReportRequestCategoryEnum.values
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(safetyLabel(_wire(value.name))),
                      ))
                  .toList(),
            ),
            const SizedBox(height: DsSpacing.s3),
            AppSelect(
              label: 'Severity',
              value: _severity,
              onChanged: (value) => setState(() => _severity = value!),
              items: CreateSafetyReportRequestSeverityEnum.values
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(safetyLabel(_wire(value.name))),
                      ))
                  .toList(),
            ),
            const SizedBox(height: DsSpacing.s3),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Occurred at'),
              subtitle: Text(formatCompanyDateTime(_occurredAt)),
              trailing: const Icon(Icons.schedule_outlined),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate:
                      DateTime.now().subtract(const Duration(days: 3650)),
                  lastDate: DateTime.now(),
                  initialDate: _occurredAt,
                );
                if (date != null && mounted) {
                  setState(() => _occurredAt = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        _occurredAt.hour,
                        _occurredAt.minute,
                      ));
                }
              },
            ),
            AppButton(
              label: _position.lat == null
                  ? 'Capture location'
                  : 'Location captured',
              icon: Icons.my_location_outlined,
              loading: _locating,
              variant: AppButtonVariant.ghost,
              onPressed: _captureLocation,
            ),
            if (_error != null) ...[
              const SizedBox(height: DsSpacing.s3),
              Text(_error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
          ]),
        ),
        actions: [
          TextButton(
              onPressed: _saving ? null : () => Navigator.pop(context),
              child: const Text('Cancel')),
          AppButton(label: 'Save report', loading: _saving, onPressed: _submit),
        ],
      );
}

String _wire(String name) => name.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => '_${match.group(1)!.toLowerCase()}',
    );
