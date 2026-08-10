import 'dart:io';

import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_2/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3, Vector4;

import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import 'manual_measurement_screen.dart';
import 'measurement_capture_result.dart';

enum _DistanceUnit { meters, centimeters, feet, inches }

extension on _DistanceUnit {
  String get label => switch (this) {
        _DistanceUnit.meters => 'm',
        _DistanceUnit.centimeters => 'cm',
        _DistanceUnit.feet => 'ft',
        _DistanceUnit.inches => 'in',
      };

  double fromMeters(double meters) => switch (this) {
        _DistanceUnit.meters => meters,
        _DistanceUnit.centimeters => meters * 100,
        _DistanceUnit.feet => meters * 3.28084,
        _DistanceUnit.inches => meters * 39.3701,
      };
}

/// Production AR dimension-measurement capture (spec 7.2 "AR-based
/// dimension measurement", Phase 7.9 Step 2). Opens the AR camera, detects a
/// plane, lets the inspector tap two points, reads the real-world distance
/// between them via [ARSessionManager.getDistanceBetweenAnchors], and
/// captures a screenshot of that exact moment via [ARSessionManager.
/// snapshot] as visual evidence -- shown to the inspector to confirm/label
/// before saving, then handed back as a [MeasurementCaptureResult] for
/// [InspectionMeasurementsSection] to persist alongside the screenshot.
///
/// D-062/D-063: `ar_flutter_plugin_2` was adopted without physical-device
/// validation. "Enter manually instead" stays reachable from every state of
/// this screen (not just after an error) -- the spec's manual fallback is
/// mandatory, not a last resort.
class ArMeasurementScreen extends StatefulWidget {
  const ArMeasurementScreen({super.key});

  @override
  State<ArMeasurementScreen> createState() => _ArMeasurementScreenState();
}

class _ArMeasurementScreenState extends State<ArMeasurementScreen> {
  ARSessionManager? _sessionManager;
  ARObjectManager? _objectManager;
  ARAnchorManager? _anchorManager;

  final List<ARPlaneAnchor> _anchors = [];
  int _planeCount = 0;
  double? _distanceMeters;
  String? _screenshotPath;
  String? _screenshotFilename;
  int? _screenshotSizeBytes;
  _DistanceUnit _unit = _DistanceUnit.centimeters;
  String? _error;
  bool _capturing = false;

  final _labelController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _sessionManager?.dispose();
    _labelController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onArViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    _sessionManager = sessionManager;
    _objectManager = objectManager;
    _anchorManager = anchorManager;

    sessionManager.onInitialize(
      showFeaturePoints: true,
      showPlanes: true,
      showWorldOrigin: false,
    );
    objectManager.onInitialize();

    sessionManager.onPlaneOrPointTap = _onPlaneOrPointTap;
    sessionManager.onPlaneDetected = (count) {
      if (mounted) setState(() => _planeCount = count);
    };
    sessionManager.onError = (message) {
      if (mounted) setState(() => _error = message);
    };
  }

  Future<void> _onPlaneOrPointTap(List<ARHitTestResult> hits) async {
    if (_anchors.length >= 2 || _capturing) return;
    final planeHit =
        hits.where((h) => h.type == ARHitTestResultType.plane).firstOrNull;
    if (planeHit == null) return;

    final anchor = ARPlaneAnchor(transformation: planeHit.worldTransform);
    final added = await _anchorManager?.addAnchor(anchor) ?? false;
    if (!added) {
      if (mounted) {
        setState(() => _error =
            'Could not place a point there -- try a more textured surface.');
      }
      return;
    }

    await _objectManager?.addNode(
      ARNode(
        type: NodeType.webGLB,
        uri:
            'https://github.com/KhronosGroup/glTF-Sample-Models/raw/refs/heads/main/2.0/Box/glTF-Binary/Box.glb',
        scale: Vector3(0.02, 0.02, 0.02),
        position: Vector3.zero(),
        rotation: Vector4(1, 0, 0, 0),
      ),
      planeAnchor: anchor,
    );

    _anchors.add(anchor);
    if (_anchors.length == 2) {
      await _finishMeasurement();
    } else if (mounted) {
      setState(() {});
    }
  }

  Future<void> _finishMeasurement() async {
    setState(() => _capturing = true);
    final distance = await _sessionManager?.getDistanceBetweenAnchors(
        _anchors[0], _anchors[1]);
    String? screenshotPath;
    String? screenshotFilename;
    int? screenshotSizeBytes;
    try {
      final imageProvider = await _sessionManager?.snapshot();
      final bytes = imageProvider is MemoryImage ? imageProvider.bytes : null;
      if (bytes != null) {
        final directory = await getTemporaryDirectory();
        final filename = '${const Uuid().v4()}.png';
        final file = File(p.join(directory.path, filename));
        await file.writeAsBytes(bytes);
        screenshotPath = file.path;
        screenshotFilename = filename;
        screenshotSizeBytes = bytes.length;
      }
    } catch (_) {
      // Screenshot capture is best-effort evidence -- a failure here must
      // never block recording the measurement itself.
    }
    if (!mounted) return;
    setState(() {
      _distanceMeters = distance;
      _screenshotPath = screenshotPath;
      _screenshotFilename = screenshotFilename;
      _screenshotSizeBytes = screenshotSizeBytes;
      _capturing = false;
    });
  }

  Future<void> _reset() async {
    for (final anchor in _anchors) {
      await _anchorManager?.removeAnchor(anchor);
    }
    if (!mounted) return;
    setState(() {
      _anchors.clear();
      _distanceMeters = null;
      _screenshotPath = null;
      _screenshotFilename = null;
      _screenshotSizeBytes = null;
      _error = null;
    });
  }

  void _useManualEntry() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<MeasurementCaptureResult>(
        builder: (_) => const ManualMeasurementScreen(),
      ),
    );
  }

  void _save() {
    final distance = _distanceMeters;
    if (distance == null) return;
    Navigator.of(context).pop(
      MeasurementCaptureResult(
        method: 'ar',
        distanceMeters: distance,
        label: _labelController.text.trim().isEmpty
            ? null
            : _labelController.text.trim(),
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        screenshotPath: _screenshotPath,
        screenshotFilename: _screenshotFilename,
        screenshotSizeBytes: _screenshotSizeBytes,
      ),
    );
  }

  String get _statusText {
    if (_error != null) return _error!;
    if (_capturing) return 'Capturing…';
    if (_planeCount == 0) return 'Move your phone slowly to detect a surface.';
    if (_anchors.isEmpty) return 'Tap a surface to place the first point.';
    if (_anchors.length == 1) return 'Tap again to place the second point.';
    return 'Distance measured.';
  }

  @override
  Widget build(BuildContext context) {
    final measured = _distanceMeters != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Measurement'),
        actions: [
          TextButton(
            key: const Key('ar-measurement-use-manual'),
            onPressed: _useManualEntry,
            child: const Text('Enter manually'),
          ),
        ],
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: _onArViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Positioned(
            left: DsSpacing.s4,
            right: DsSpacing.s4,
            top: DsSpacing.s4,
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_statusText,
                      style: TextStyle(color: context.semantic.textSecondary)),
                  if (measured) ...[
                    const SizedBox(height: DsSpacing.s2),
                    Row(
                      children: [
                        Text(
                          '${_unit.fromMeters(_distanceMeters!).toStringAsFixed(2)} ${_unit.label}',
                          style: TextStyle(
                            color: context.semantic.textSecondary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: DsSpacing.s3),
                        DropdownButton<_DistanceUnit>(
                          value: _unit,
                          items: _DistanceUnit.values
                              .map((u) => DropdownMenuItem(
                                  value: u, child: Text(u.label)))
                              .toList(),
                          onChanged: (u) => setState(() => _unit = u ?? _unit),
                        ),
                      ],
                    ),
                    if (_screenshotPath == null) ...[
                      const SizedBox(height: DsSpacing.s2),
                      Text(
                        "Couldn't capture a screenshot -- the measurement will save without one.",
                        style: TextStyle(
                            color: context.semantic.textMuted,
                            fontSize: DsTypography.sizeCaption),
                      ),
                    ],
                    const SizedBox(height: DsSpacing.s3),
                    AppTextField(
                      key: const Key('ar-measurement-label'),
                      label: 'Label (optional)',
                      controller: _labelController,
                    ),
                    const SizedBox(height: DsSpacing.s3),
                    AppTextField(
                      key: const Key('ar-measurement-note'),
                      label: 'Note (optional)',
                      controller: _noteController,
                      maxLines: 2,
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            left: DsSpacing.s4,
            right: DsSpacing.s4,
            bottom: DsSpacing.s4,
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    key: const Key('ar-measurement-reset'),
                    label: 'Reset',
                    icon: Icons.refresh,
                    variant: AppButtonVariant.ghost,
                    onPressed: _anchors.isEmpty ? null : _reset,
                  ),
                ),
                if (measured) ...[
                  const SizedBox(width: DsSpacing.s3),
                  Expanded(
                    child: AppButton(
                      key: const Key('ar-measurement-save'),
                      label: 'Save',
                      icon: Icons.check,
                      onPressed: _save,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
