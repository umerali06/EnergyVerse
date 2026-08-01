import 'package:geolocator/geolocator.dart';

/// A best-effort, non-blocking GPS reading: (lat, lng) or (null, null) if
/// location services are off, permission is denied, or the read simply times
/// out. GPS is optional server-side (`InspectionService._validate_gps` only
/// validates a value that's actually provided), so a field inspector without
/// a location fix -- inside a steel-walled facility, say -- must never be
/// blocked from starting an inspection.
typedef GpsPosition = ({double? lat, double? lng});

const _noPosition = (lat: null, lng: null);

Future<GpsPosition> captureCurrentPosition() {
  return _captureCurrentPosition().timeout(
    const Duration(seconds: 10),
    onTimeout: () => _noPosition,
  );
}

/// The `timeLimit` on [Geolocator.getCurrentPosition] only bounds the
/// position fix itself -- the permission-check calls ahead of it have no
/// such bound and, with no platform channel handler registered (a plain
/// widget test, or a device with a wedged location service), can hang
/// rather than throw. The outer `.timeout` above is what actually
/// guarantees this never blocks starting an inspection.
Future<GpsPosition> _captureCurrentPosition() async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) return _noPosition;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return _noPosition;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 8),
      ),
    );
    return (lat: position.latitude, lng: position.longitude);
  } catch (_) {
    return _noPosition;
  }
}
