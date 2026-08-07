import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';

/// Holds a signature's drawn strokes as normalized (0-1) points, mirroring
/// the 7.5 annotation canvas's own normalization convention -- so the
/// drawing renders correctly at any canvas size and matches the backend's
/// `AnnotationPoint`-shaped `SignaturePointInput`/`SignaturePointResponse`.
/// A [ChangeNotifier] rather than plain state so [SignaturePad] and any
/// "Complete" button watching [isEmpty] can share one source of truth.
class SignaturePadController extends ChangeNotifier {
  List<List<Offset>> _strokes = const [];

  bool get isEmpty => _strokes.isEmpty;
  List<List<Offset>> get strokes => _strokes;

  void startStroke(Offset normalizedPoint) {
    _strokes = [..._strokes, [normalizedPoint]];
    notifyListeners();
  }

  void extendStroke(Offset normalizedPoint) {
    if (_strokes.isEmpty) return;
    final last = _strokes.last;
    _strokes = [
      ..._strokes.sublist(0, _strokes.length - 1),
      [...last, normalizedPoint],
    ];
    notifyListeners();
  }

  void clear() {
    _strokes = const [];
    notifyListeners();
  }

  /// Converts the drawn strokes to the wire shape `completeInspection` sends.
  List<SignatureStrokeInput> toInput() => _strokes
      .map(
        (stroke) => SignatureStrokeInput(
          (b) => b.points.addAll(
            stroke.map((point) => SignaturePointInput((p) => p
              ..x = point.dx
              ..y = point.dy)),
          ),
        ),
      )
      .toList();
}

/// A finger/stylus signature capture surface (Phase 7.8). Field-friendly:
/// large hit area, no color/tool palette (unlike the 7.5 annotation canvas)
/// since a signature is always one freehand stroke set in a single color.
class SignaturePad extends StatefulWidget {
  const SignaturePad({required this.controller, super.key});

  final SignaturePadController controller;

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(covariant SignaturePad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onChanged);
      widget.controller.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  Offset _clampNormalized(Offset offset, Size size) => Offset(
        (offset.dx / size.width).clamp(0.0, 1.0),
        (offset.dy / size.height).clamp(0.0, 1.0),
      );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.semantic.elevated,
        borderRadius: BorderRadius.circular(DsRadius.md),
        border: Border.all(color: context.semantic.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DsRadius.md),
        child: SizedBox(
          height: 220,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              return GestureDetector(
                key: const Key('signature-pad-gesture'),
                behavior: HitTestBehavior.opaque,
                onPanStart: (details) => widget.controller
                    .startStroke(_clampNormalized(details.localPosition, size)),
                onPanUpdate: (details) => widget.controller
                    .extendStroke(_clampNormalized(details.localPosition, size)),
                child: CustomPaint(
                  key: const Key('signature-pad-canvas'),
                  size: size,
                  painter: _SignaturePainter(widget.controller.strokes),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Read-only rendering of already-drawn strokes -- a synced signature
/// (server-confirmed identity) or the not-yet-synced local echo -- same
/// visual rendering as [SignaturePad] itself, minus the [GestureDetector].
class SignaturePreview extends StatelessWidget {
  const SignaturePreview({required this.strokes, super.key});

  final List<List<Offset>> strokes;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.semantic.elevated,
        borderRadius: BorderRadius.circular(DsRadius.md),
        border: Border.all(color: context.semantic.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DsRadius.md),
        child: SizedBox(
          height: 140,
          width: double.infinity,
          child: CustomPaint(
            key: const Key('signature-preview-canvas'),
            painter: _SignaturePainter(strokes),
          ),
        ),
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  _SignaturePainter(this.strokes);

  final List<List<Offset>> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (final stroke in strokes) {
      final pixelPoints = stroke
          .map((p) => Offset(p.dx * size.width, p.dy * size.height))
          .toList();
      if (pixelPoints.length < 2) {
        if (pixelPoints.isNotEmpty) {
          canvas.drawCircle(pixelPoints.first, 1.5, paint..style = PaintingStyle.fill);
        }
        continue;
      }
      final path = Path()..moveTo(pixelPoints.first.dx, pixelPoints.first.dy);
      for (final point in pixelPoints.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, paint..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) =>
      oldDelegate.strokes != strokes;
}
