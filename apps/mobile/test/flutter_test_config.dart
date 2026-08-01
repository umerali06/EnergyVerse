import 'dart:async';

import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

/// Any unmocked platform channel call (no plugin registered under
/// `flutter test`) can hang instead of throwing, which stalls
/// `pumpAndSettle` well past its own timeout. `Geolocator.*` calls only ever
/// happen through `gps_capture.dart`'s best-effort helper, so swapping in a
/// platform double that resolves instantly (services disabled) makes every
/// widget test exercising the start-inspection flow deterministic, without
/// each test file needing to know this plumbing exists.
class _NoLocationPlatform extends GeolocatorPlatform {
  @override
  Future<bool> isLocationServiceEnabled() async => false;
}

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  GeolocatorPlatform.instance = _NoLocationPlatform();
  await testMain();
}
