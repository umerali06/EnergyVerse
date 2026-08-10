/// What either capture screen (AR or manual) hands back to
/// [InspectionMeasurementsSection] to persist -- never anything screen- or
/// plugin-specific, so the section doesn't need to know which path produced
/// it. [screenshotPath]/[screenshotFilename]/[screenshotSizeBytes] are only
/// ever set together, for an AR capture that produced evidence; a manual
/// entry leaves all three null.
class MeasurementCaptureResult {
  const MeasurementCaptureResult({
    required this.method,
    required this.distanceMeters,
    this.label,
    this.note,
    this.screenshotPath,
    this.screenshotFilename,
    this.screenshotSizeBytes,
  });

  final String method; // 'ar' | 'manual'
  final double distanceMeters;
  final String? label;
  final String? note;
  final String? screenshotPath;
  final String? screenshotFilename;
  final int? screenshotSizeBytes;
}
