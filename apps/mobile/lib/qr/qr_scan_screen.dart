import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../auth/app_routes.dart';
import '../auth/auth_controller.dart';
import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';
import 'qr_scan_controller.dart';

typedef QrScannerViewBuilder = Widget Function(
  BuildContext context,
  void Function(String code) onDetected,
);

Widget defaultQrScannerViewBuilder(
  BuildContext context,
  void Function(String code) onDetected,
) {
  return _CameraScannerView(onDetected: onDetected);
}

/// Pulled out as a pure function so the copy for each camera failure mode is
/// unit-testable without mounting the real camera plugin (which can't run
/// in CI -- see the module doc comment on [QrScanScreen]).
String cameraErrorMessage(MobileScannerErrorCode code) {
  return switch (code) {
    MobileScannerErrorCode.permissionDenied =>
      'Camera access was denied. Enable it in system settings, or use manual entry below.',
    MobileScannerErrorCode.unsupported =>
      'This device has no usable camera. Use manual entry below.',
    _ => 'Camera unavailable. Use manual entry below.',
  };
}

/// The primary scan surface (spec §6): live camera scanning with a manual
/// code entry fallback. [scannerBuilder] defaults to the real camera preview
/// but is overridable so widget tests never have to mount a real camera
/// plugin -- live scanning itself is verified on a physical device by hand.
class QrScanScreen extends StatefulWidget {
  const QrScanScreen({
    this.scannerBuilder = defaultQrScannerViewBuilder,
    super.key,
  });

  final QrScannerViewBuilder scannerBuilder;

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  QrScanController? _controller;
  final _manualCodeController = TextEditingController();
  bool _navigating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= QrScanController(api: AuthProvider.of(context).api);
  }

  @override
  void dispose() {
    _manualCodeController.dispose();
    super.dispose();
  }

  void _submitManualCode() => _controller!.resolve(_manualCodeController.text);

  Future<void> _navigateToResult(QrScanController controller) async {
    if (_navigating) return;
    _navigating = true;
    await Navigator.of(
      context,
    ).pushNamed(AppRoutes.qrScanResult, arguments: controller.result);
    _navigating = false;
    if (mounted) controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller!;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.state == QrScanState.success && controller.result != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) unawaited(_navigateToResult(controller));
          });
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(DsSpacing.s6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Scan asset QR code', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: DsSpacing.s2),
              Text(
                "Point the camera at an asset's QR label, or enter its code below.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: DsSpacing.s4),
              ClipRRect(
                borderRadius: BorderRadius.circular(DsRadius.lg),
                child: SizedBox(
                  height: 260,
                  child: widget.scannerBuilder(context, controller.resolve),
                ),
              ),
              const SizedBox(height: DsSpacing.s4),
              if (controller.state == QrScanState.resolving)
                const Padding(
                  padding: EdgeInsets.only(bottom: DsSpacing.s4),
                  child: Center(child: AppLoader(label: 'Resolving code')),
                ),
              if (controller.state == QrScanState.notFound)
                const Padding(
                  padding: EdgeInsets.only(bottom: DsSpacing.s4),
                  child: EmptyState(
                    title: 'Code not found',
                    description:
                        "This code isn't recognized, or belongs to a different company.",
                  ),
                ),
              if (controller.state == QrScanState.error)
                Padding(
                  padding: const EdgeInsets.only(bottom: DsSpacing.s4),
                  child: EmptyState(
                    title: 'Something went wrong',
                    description: controller.errorMessage ??
                        "Couldn't resolve this code. Check your connection and try again.",
                  ),
                ),
              Text('Manual entry', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: DsSpacing.s2),
              AppTextField(
                label: 'Asset code',
                controller: _manualCodeController,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submitManualCode(),
              ),
              const SizedBox(height: DsSpacing.s3),
              AppButton(
                label: 'Look up code',
                onPressed: controller.state == QrScanState.resolving ? null : _submitManualCode,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CameraScannerView extends StatefulWidget {
  const _CameraScannerView({required this.onDetected});

  final void Function(String code) onDetected;

  @override
  State<_CameraScannerView> createState() => _CameraScannerViewState();
}

class _CameraScannerViewState extends State<_CameraScannerView> {
  final MobileScannerController _scanner = MobileScannerController();

  @override
  void dispose() {
    _scanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: _scanner,
      onDetect: (capture) {
        if (capture.barcodes.isEmpty) return;
        final value = capture.barcodes.first.rawValue;
        if (value != null && value.isNotEmpty) widget.onDetected(value);
      },
      errorBuilder: (context, error) {
        return ColoredBox(
          color: Colors.black,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(DsSpacing.s4),
              child: Text(
                cameraErrorMessage(error.errorCode),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
