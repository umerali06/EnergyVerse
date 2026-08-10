import 'dart:async';
import 'dart:io';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../ar/ar_measurement_screen.dart';
import '../ar/manual_measurement_screen.dart';
import '../ar/measurement_capture_result.dart';
import '../auth/auth_controller.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import '../media/media_upload_worker.dart';
import '../sync/sync_engine.dart';

/// `1.5 m` under 1 meter shows as centimeters (`45.0 cm`) for readability --
/// a fixed threshold, not a per-record unit choice, mirroring D-058's
/// documented-unit rationale (the stored value is always meters; this is
/// display-only).
String formatMeasurementDistance(double meters) {
  if (meters < 1) return '${(meters * 100).toStringAsFixed(1)} cm';
  return '${meters.toStringAsFixed(2)} m';
}

/// The inspection detail screen's AR/manual dimension-measurement section
/// (spec 7.2 "AR-based dimension measurement", Phase 7.9). Measurements are
/// written to the local cache optimistically (see
/// [LocalInspectionsRepository.createMeasurement]), same posture as damage
/// annotations (D-054/D-055) -- so [measurements] already reflects
/// not-yet-synced local writes, not just the last server response. An
/// AR-captured measurement's screenshot rides the exact same [MediaQueue]/
/// [MediaUploadWorker] pipeline a photo does; only the record referencing it
/// is new.
class InspectionMeasurementsSection extends StatefulWidget {
  const InspectionMeasurementsSection({
    required this.inspectionId,
    required this.measurements,
    required this.editable,
    super.key,
  });

  final String inspectionId;
  final List<ArMeasurementResponse> measurements;
  final bool editable;

  @override
  State<InspectionMeasurementsSection> createState() =>
      _InspectionMeasurementsSectionState();
}

class _InspectionMeasurementsSectionState
    extends State<InspectionMeasurementsSection> {
  Future<void> _addMeasurement() async {
    final choice = await showAppModal<String>(
      context,
      title: 'Add measurement',
      child: _MeasurementMethodChoice(),
    );
    if (choice == null || !mounted) return;

    final result = await Navigator.of(context).push<MeasurementCaptureResult>(
      MaterialPageRoute<MeasurementCaptureResult>(
        builder: (_) => choice == 'ar'
            ? const ArMeasurementScreen()
            : const ManualMeasurementScreen(),
      ),
    );
    if (result == null || !mounted) return;
    await _saveResult(result);
  }

  Future<void> _saveResult(MeasurementCaptureResult result) async {
    final currentUser = AuthProvider.of(context).currentUser;
    final companyId = currentUser?.companyId;
    final repository = SyncProvider.repositoryOf(context);

    String? mediaLocalId;
    final screenshotPath = result.screenshotPath;
    if (screenshotPath != null && companyId != null) {
      final mediaRepository = MediaProvider.repositoryOf(context);
      final worker = MediaProvider.workerOf(context);
      mediaLocalId = await mediaRepository.enqueueCapture(
        companyId: companyId,
        inspectionId: widget.inspectionId,
        kind: 'photo',
        localFilePath: screenshotPath,
        filename: result.screenshotFilename ?? 'measurement.png',
        contentType: 'image/png',
        sizeBytes:
            result.screenshotSizeBytes ?? await File(screenshotPath).length(),
        capturedAt: DateTime.now().toUtc(),
      );
      worker.kick();
    }

    await repository.createMeasurement(
      inspectionId: widget.inspectionId,
      method: result.method,
      distanceMeters: result.distanceMeters,
      createdBy: currentUser?.uid ?? '',
      label: result.label,
      mediaLocalId: mediaLocalId,
      note: result.note,
    );
  }

  Future<void> _remove(ArMeasurementResponse measurement) {
    return SyncProvider.repositoryOf(context).deleteMeasurement(
      inspectionId: widget.inspectionId,
      measurementId: measurement.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('MEASUREMENTS',
            style:
                TextStyle(color: context.semantic.textMuted, letterSpacing: 1)),
        const SizedBox(height: DsSpacing.s2),
        if (widget.measurements.isEmpty)
          const EmptyState(
            title: 'No measurements yet',
            description: 'Capture an AR measurement or enter one manually.',
          )
        else
          ...widget.measurements.map(
            (measurement) => Padding(
              padding: const EdgeInsets.only(bottom: DsSpacing.s2),
              child: _MeasurementTile(
                key: Key('measurement-tile-${measurement.id}'),
                measurement: measurement,
                editable: widget.editable,
                onRemove: () => unawaited(_remove(measurement)),
              ),
            ),
          ),
        if (widget.editable) ...[
          const SizedBox(height: DsSpacing.s2),
          AppButton(
            key: const Key('add-measurement'),
            label: 'Add measurement',
            icon: Icons.straighten,
            variant: AppButtonVariant.ghost,
            onPressed: () => unawaited(_addMeasurement()),
          ),
        ],
      ],
    );
  }
}

class _MeasurementMethodChoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          key: const Key('measurement-choice-ar'),
          label: 'Measure with AR',
          icon: Icons.view_in_ar_outlined,
          onPressed: () => Navigator.of(context).pop('ar'),
        ),
        const SizedBox(height: DsSpacing.s2),
        AppButton(
          key: const Key('measurement-choice-manual'),
          label: 'Enter manually',
          icon: Icons.edit_outlined,
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop('manual'),
        ),
      ],
    );
  }
}

class _MeasurementTile extends StatelessWidget {
  const _MeasurementTile({
    required this.measurement,
    required this.editable,
    required this.onRemove,
    super.key,
  });

  final ArMeasurementResponse measurement;
  final bool editable;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final isAr = measurement.method.name == 'ar';
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isAr ? Icons.view_in_ar_outlined : Icons.edit_outlined,
              color: context.semantic.textMuted),
          const SizedBox(width: DsSpacing.s2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatMeasurementDistance(
                      measurement.distanceMeters.toDouble()),
                  style: TextStyle(
                    fontFamily: DsTypography.mono,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (measurement.label != null && measurement.label!.isNotEmpty)
                  Text(measurement.label!),
                if (measurement.note != null && measurement.note!.isNotEmpty)
                  Text(
                    measurement.note!,
                    style: TextStyle(
                        color: context.semantic.textMuted,
                        fontSize: DsTypography.sizeCaption),
                  ),
              ],
            ),
          ),
          if (editable)
            IconButton(
              key: Key('measurement-remove-${measurement.id}'),
              icon: const Icon(Icons.delete_outline),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
