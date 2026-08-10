import 'dart:async';
import 'dart:ui' as ui;

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';
import '../inspections/local_inspections_repository.dart'
    show dartEnumNameToWire;

/// The five shapes an inspector can draw (spec 7.2's "practical set"). Kept
/// separate from the wire enum since `select` (tap-to-inspect/move/delete)
/// is a canvas MODE, not a persisted shape.
enum AnnotationTool { select, freehand, rectangle, circle, arrow, point }

extension AnnotationToolX on AnnotationTool {
  String get wireValue {
    switch (this) {
      case AnnotationTool.freehand:
        return 'freehand';
      case AnnotationTool.rectangle:
        return 'rectangle';
      case AnnotationTool.circle:
        return 'circle';
      case AnnotationTool.arrow:
        return 'arrow';
      case AnnotationTool.point:
        return 'point';
      case AnnotationTool.select:
        throw StateError('select is a canvas mode, not a persisted shape');
    }
  }

  IconData get icon {
    switch (this) {
      case AnnotationTool.select:
        return Icons.pan_tool_outlined;
      case AnnotationTool.freehand:
        return Icons.edit_outlined;
      case AnnotationTool.rectangle:
        return Icons.crop_square_outlined;
      case AnnotationTool.circle:
        return Icons.circle_outlined;
      case AnnotationTool.arrow:
        return Icons.north_east_outlined;
      case AnnotationTool.point:
        return Icons.place_outlined;
    }
  }

  String get label {
    switch (this) {
      case AnnotationTool.select:
        return 'Select';
      case AnnotationTool.freehand:
        return 'Freehand';
      case AnnotationTool.rectangle:
        return 'Rectangle';
      case AnnotationTool.circle:
        return 'Circle';
      case AnnotationTool.arrow:
        return 'Arrow';
      case AnnotationTool.point:
        return 'Point';
    }
  }
}

/// (wireValue, label) pairs for the damage-type picker -- spec §8's enum.
const damageTypeOptions = <(String, String)>[
  ('corrosion', 'Corrosion'),
  ('rust', 'Rust'),
  ('crack', 'Crack'),
  ('surface_damage', 'Surface damage'),
  ('paint_deterioration', 'Paint deterioration'),
  ('missing_bolt', 'Missing bolt'),
  ('broken_component', 'Broken component'),
  ('leak', 'Leak'),
  ('wear', 'Wear'),
  ('other', 'Other'),
];

String damageTypeLabel(String? wireValue) => damageTypeOptions
    .firstWhere((o) => o.$1 == wireValue, orElse: () => ('', 'Unlabeled'))
    .$2;

/// The color swatches offered when drawing -- reuses the shared design
/// tokens (never a hardcoded hex) so annotation colors stay on-palette.
const _swatches = <Color>[
  DsColors.statusCritical,
  DsColors.statusWarning,
  DsColors.statusSuccess,
  DsColors.primary500,
  DsColors.accent500,
];

String colorToHex(Color color) =>
    '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

Color colorFromHex(String hex) {
  final digits = hex.startsWith('#') ? hex.substring(1) : hex;
  return Color(int.parse('FF$digits', radix: 16));
}

/// Every callback below performs the local (offline-first) write and
/// returns the resulting, authoritative annotation list for this one photo
/// (already filtered to its `media_local_id`) -- the canvas never hand-
/// builds an [AnnotationResponse] itself, it only ever renders what the
/// repository actually persisted.
typedef CreateAnnotationCallback = Future<List<AnnotationResponse>> Function({
  required String shape,
  required List<Offset> points,
  required String color,
  String? damageType,
  String? note,
});

typedef UpdateAnnotationCallback = Future<List<AnnotationResponse>> Function({
  required String annotationId,
  List<Offset>? points,
  String? damageType,
  String? note,
});

typedef DeleteAnnotationCallback = Future<List<AnnotationResponse>> Function(
    String annotationId);

/// Runs AI analysis on this photo (Phase 7.10) and returns the resulting,
/// authoritative annotation list -- same "never hand-build a response"
/// contract as the other callbacks. Throws on failure (unsupported media
/// kind, upstream AI failure, offline) for the canvas to surface as a
/// snackbar; `null` means this photo isn't synced yet, so no "Analyze"
/// action is offered at all.
typedef AnalyzeCallback = Future<List<AnnotationResponse>> Function();

/// Draw/label/view damage annotations over one inspection photo (Phase
/// 7.5). Coordinates are normalized (0-1 relative to the image's own
/// rendered box, not the device screen), so a shape drawn on one device
/// renders in the same place on any other. `editable` gates every write
/// tool -- a `completed`/`cancelled` inspection opens view-only (tap a
/// shape to see its type/note, nothing else).
class AnnotationCanvasScreen extends StatefulWidget {
  const AnnotationCanvasScreen({
    required this.imageProvider,
    required this.initialAnnotations,
    required this.editable,
    required this.onCreate,
    required this.onUpdate,
    required this.onDelete,
    this.onAnalyze,
    super.key,
  });

  final ImageProvider imageProvider;
  final List<AnnotationResponse> initialAnnotations;
  final bool editable;
  final CreateAnnotationCallback onCreate;
  final UpdateAnnotationCallback onUpdate;
  final DeleteAnnotationCallback onDelete;
  final AnalyzeCallback? onAnalyze;

  @override
  State<AnnotationCanvasScreen> createState() => _AnnotationCanvasScreenState();
}

class _AnnotationCanvasScreenState extends State<AnnotationCanvasScreen> {
  late List<AnnotationResponse> _shapes;
  AnnotationTool _tool = AnnotationTool.select;
  Color _color = _swatches.first;
  double? _aspectRatio;
  bool _imageLoadFailed = false;

  List<Offset> _draftPoints = [];
  bool _drafting = false;

  final List<String> _undoStack = [];
  final List<AnnotationResponse> _redoStack = [];

  bool _showOverlay = true;
  String? _selectedId;
  bool _busy = false;

  Offset? _dragAnchor;
  List<Offset>? _dragOriginalPoints;

  @override
  void initState() {
    super.initState();
    _shapes = [...widget.initialAnnotations];
    _resolveAspectRatio();
  }

  void _resolveAspectRatio() {
    final stream = widget.imageProvider.resolve(const ImageConfiguration());
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, synchronous) {
        if (mounted) {
          setState(() => _aspectRatio = info.image.width / info.image.height);
        }
        stream.removeListener(listener);
      },
      onError: (exception, stackTrace) {
        // A stale/unreachable signed URL must degrade gracefully, not crash
        // -- same posture as the gallery's own `_networkImage` fallback.
        if (mounted) setState(() => _imageLoadFailed = true);
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);
  }

  static const double _hitThreshold = 0.03;

  Offset _clampNormalized(Offset offset, Size size) => Offset(
        (offset.dx / size.width).clamp(0.0, 1.0),
        (offset.dy / size.height).clamp(0.0, 1.0),
      );

  void _onPanStart(DragStartDetails details, Size size) {
    if (!widget.editable) return;
    final point = _clampNormalized(details.localPosition, size);
    if (_tool == AnnotationTool.select) {
      _beginMove(point);
      return;
    }
    setState(() {
      _drafting = true;
      _draftPoints =
          _tool == AnnotationTool.freehand ? [point] : [point, point];
    });
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    if (!widget.editable) return;
    final point = _clampNormalized(details.localPosition, size);
    if (_tool == AnnotationTool.select) {
      _dragSelected(point);
      return;
    }
    if (!_drafting) return;
    setState(() {
      if (_tool == AnnotationTool.freehand) {
        _draftPoints = [..._draftPoints, point];
      } else {
        _draftPoints = [_draftPoints.first, point];
      }
    });
  }

  Future<void> _onPanEnd(DragEndDetails details) async {
    if (!widget.editable) return;
    if (_tool == AnnotationTool.select) {
      await _commitMove();
      return;
    }
    if (!_drafting) return;
    final points = _draftPoints;
    setState(() {
      _drafting = false;
      _draftPoints = [];
    });
    if (points.length < 2 && _tool != AnnotationTool.point) return;
    await _commitNewShape(_tool, points);
  }

  Future<void> _onTapUp(TapUpDetails details, Size size) async {
    final point = _clampNormalized(details.localPosition, size);
    if (!widget.editable) {
      final hit = _findShapeAt(point);
      if (hit != null) await _showDetail(hit, readOnly: true);
      return;
    }
    if (_tool == AnnotationTool.point) {
      await _commitNewShape(AnnotationTool.point, [point]);
      return;
    }
    if (_tool != AnnotationTool.select) return;
    final hit = _findShapeAt(point);
    if (hit == null) {
      setState(() => _selectedId = null);
      return;
    }
    if (_selectedId == hit.id) {
      await _showDetail(hit, readOnly: false);
    } else {
      setState(() => _selectedId = hit.id);
    }
  }

  AnnotationResponse? _findShapeAt(Offset point) {
    for (final shape in _shapes.reversed) {
      if (_hitTest(shape, point)) return shape;
    }
    return null;
  }

  bool _hitTest(AnnotationResponse shape, Offset point) {
    final points = shape.points
        .map((p) => Offset(p.x.toDouble(), p.y.toDouble()))
        .toList();
    switch (shape.shape.name) {
      case 'point':
        return (points.first - point).distance < _hitThreshold;
      case 'rectangle':
      case 'circle':
        final rect = Rect.fromPoints(points[0], points[1]);
        return rect.inflate(_hitThreshold).contains(point);
      case 'arrow':
        return _distanceToSegment(point, points[0], points[1]) < _hitThreshold;
      case 'freehand':
      default:
        if (points.length == 1) {
          return (points.first - point).distance < _hitThreshold;
        }
        for (var i = 0; i < points.length - 1; i++) {
          if (_distanceToSegment(point, points[i], points[i + 1]) <
              _hitThreshold) {
            return true;
          }
        }
        return false;
    }
  }

  double _distanceToSegment(Offset p, Offset a, Offset b) {
    final ab = b - a;
    final lengthSquared = ab.distanceSquared;
    if (lengthSquared == 0) return (p - a).distance;
    final t = (((p - a).dx * ab.dx) + ((p - a).dy * ab.dy)) / lengthSquared;
    final clamped = t.clamp(0.0, 1.0);
    final projection = a + ab * clamped;
    return (p - projection).distance;
  }

  void _beginMove(Offset point) {
    final selectedId = _selectedId;
    if (selectedId == null) return;
    final matches = _shapes.where((s) => s.id == selectedId);
    if (matches.isEmpty) return;
    final shape = matches.first;
    if (!_hitTest(shape, point)) return;
    _dragAnchor = point;
    _dragOriginalPoints = shape.points
        .map((p) => Offset(p.x.toDouble(), p.y.toDouble()))
        .toList();
  }

  void _dragSelected(Offset point) {
    final anchor = _dragAnchor;
    final original = _dragOriginalPoints;
    final selectedId = _selectedId;
    if (anchor == null || original == null || selectedId == null) return;
    final delta = point - anchor;
    final index = _shapes.indexWhere((s) => s.id == selectedId);
    if (index == -1) return;
    final moved = original.map((p) => p + delta).toList();
    setState(() {
      _shapes[index] = _shapes[index].rebuild(
        (b) => b.points.replace(
          moved.map((p) => AnnotationPointResponse((pb) => pb
            ..x = p.dx.clamp(0.0, 1.0)
            ..y = p.dy.clamp(0.0, 1.0))),
        ),
      );
    });
  }

  Future<void> _commitMove() async {
    final selectedId = _selectedId;
    final wasDragging = _dragAnchor != null && selectedId != null;
    _dragAnchor = null;
    _dragOriginalPoints = null;
    if (!wasDragging) return;
    final shape = _shapes.firstWhere((s) => s.id == selectedId);
    setState(() => _busy = true);
    try {
      final result = await widget.onUpdate(
        annotationId: selectedId,
        points: shape.points
            .map((p) => Offset(p.x.toDouble(), p.y.toDouble()))
            .toList(),
      );
      if (mounted) setState(() => _shapes = result);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _commitNewShape(AnnotationTool tool, List<Offset> points) async {
    final labeled = await _promptLabel();
    if (labeled == null) return;
    final existingIds = _shapes.map((s) => s.id).toSet();
    setState(() => _busy = true);
    try {
      final result = await widget.onCreate(
        shape: tool.wireValue,
        points: points,
        color: colorToHex(_color),
        damageType: labeled.$1,
        note: labeled.$2,
      );
      if (!mounted) return;
      final newId = result.map((s) => s.id).firstWhere(
            (id) => !existingIds.contains(id),
            orElse: () => '',
          );
      setState(() {
        _shapes = result;
        if (newId.isNotEmpty) _undoStack.add(newId);
        _redoStack.clear();
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<(String?, String?)?> _promptLabel() {
    String? damageType;
    final noteController = TextEditingController();
    return showModalBottomSheet<(String?, String?)>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: DsSpacing.s4,
            right: DsSpacing.s4,
            top: DsSpacing.s4,
            bottom:
                MediaQuery.of(sheetContext).viewInsets.bottom + DsSpacing.s4,
          ),
          child: StatefulBuilder(
            builder: (sheetContext, setSheetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Label damage',
                      style: Theme.of(sheetContext).textTheme.titleMedium),
                  const SizedBox(height: DsSpacing.s3),
                  AppSelect<String>(
                    label: 'Damage type',
                    value: damageType,
                    items: [
                      for (final option in damageTypeOptions)
                        DropdownMenuItem(
                            value: option.$1, child: Text(option.$2)),
                    ],
                    onChanged: (value) =>
                        setSheetState(() => damageType = value),
                  ),
                  const SizedBox(height: DsSpacing.s3),
                  AppTextField(
                    label: 'Note (optional)',
                    controller: noteController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: DsSpacing.s4),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Cancel',
                          variant: AppButtonVariant.ghost,
                          onPressed: () => Navigator.of(sheetContext).pop(),
                        ),
                      ),
                      const SizedBox(width: DsSpacing.s2),
                      Expanded(
                        child: AppButton(
                          label: 'Save',
                          onPressed: () => Navigator.of(sheetContext).pop((
                            damageType,
                            noteController.text.trim().isEmpty
                                ? null
                                : noteController.text.trim(),
                          )),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showDetail(AnnotationResponse shape,
      {required bool readOnly}) async {
    final damageWire = shape.damageType == null
        ? null
        : dartEnumNameToWire(shape.damageType!.name);
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(DsSpacing.s4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.circle,
                      color: colorFromHex(shape.color), size: 16),
                  const SizedBox(width: DsSpacing.s2),
                  Text(damageTypeLabel(damageWire),
                      style: Theme.of(sheetContext).textTheme.titleMedium),
                  if (shape.source_ == AnnotationResponseSource_Enum.ai) ...[
                    const SizedBox(width: DsSpacing.s2),
                    AppBadge(
                      label: shape.confidence == null
                          ? 'AI'
                          : 'AI · ${(shape.confidence! * 100).round()}%',
                    ),
                  ],
                ],
              ),
              if (shape.note != null) ...[
                const SizedBox(height: DsSpacing.s2),
                Text(shape.note!),
              ],
              if (!readOnly) ...[
                const SizedBox(height: DsSpacing.s4),
                AppButton(
                  label: 'Delete',
                  variant: AppButtonVariant.danger,
                  onPressed: () => Navigator.of(sheetContext).pop('delete'),
                ),
              ],
            ],
          ),
        );
      },
    );
    if (action == 'delete') await _deleteShape(shape.id);
  }

  Future<void> _analyze() async {
    final onAnalyze = widget.onAnalyze;
    if (onAnalyze == null || _busy) return;
    setState(() => _busy = true);
    try {
      final result = await onAnalyze();
      if (!mounted) return;
      setState(() => _shapes = result);
    } catch (error) {
      if (!mounted) return;
      showAppToast(context, 'AI analysis failed: $error',
          status: AppStatus.critical);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteShape(String id) async {
    setState(() => _busy = true);
    try {
      final result = await widget.onDelete(id);
      if (!mounted) return;
      setState(() {
        _shapes = result;
        _selectedId = null;
        _undoStack.remove(id);
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _undo() async {
    if (_undoStack.isEmpty) return;
    final id = _undoStack.removeLast();
    final matches = _shapes.where((s) => s.id == id);
    if (matches.isEmpty) return;
    final shape = matches.first;
    setState(() => _busy = true);
    try {
      final result = await widget.onDelete(id);
      if (!mounted) return;
      setState(() {
        _shapes = result;
        _redoStack.add(shape);
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _redo() async {
    if (_redoStack.isEmpty) return;
    final shape = _redoStack.removeLast();
    final existingIds = _shapes.map((s) => s.id).toSet();
    setState(() => _busy = true);
    try {
      final result = await widget.onCreate(
        shape: shape.shape.name,
        points: shape.points
            .map((p) => Offset(p.x.toDouble(), p.y.toDouble()))
            .toList(),
        color: shape.color,
        damageType: shape.damageType == null
            ? null
            : dartEnumNameToWire(shape.damageType!.name),
        note: shape.note,
      );
      if (!mounted) return;
      final newId = result.map((s) => s.id).firstWhere(
            (id) => !existingIds.contains(id),
            orElse: () => '',
          );
      setState(() {
        _shapes = result;
        if (newId.isNotEmpty) _undoStack.add(newId);
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear all annotations?'),
        content: const Text('Every marked area on this photo will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    try {
      var result = _shapes;
      for (final shape in [..._shapes]) {
        result = await widget.onDelete(shape.id);
      }
      if (!mounted) return;
      setState(() {
        _shapes = result;
        _selectedId = null;
        _undoStack.clear();
        _redoStack.clear();
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = _aspectRatio;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Annotate photo'),
        actions: [
          if (widget.onAnalyze != null)
            IconButton(
              key: const Key('analyze-with-ai'),
              icon: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome_outlined),
              tooltip: 'Analyze with AI',
              onPressed: _busy ? null : () => unawaited(_analyze()),
            ),
          IconButton(
            icon: Icon(_showOverlay
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined),
            tooltip: _showOverlay ? 'Hide annotations' : 'Show annotations',
            onPressed: () => setState(() => _showOverlay = !_showOverlay),
          ),
          if (widget.editable) ...[
            IconButton(
              icon: const Icon(Icons.undo),
              tooltip: 'Undo',
              onPressed:
                  _undoStack.isEmpty || _busy ? null : () => unawaited(_undo()),
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              tooltip: 'Redo',
              onPressed:
                  _redoStack.isEmpty || _busy ? null : () => unawaited(_redo()),
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear all',
              onPressed: _shapes.isEmpty || _busy
                  ? null
                  : () => unawaited(_clearAll()),
            ),
          ],
        ],
      ),
      body: Center(
        child: _imageLoadFailed
            ? const Text(
                "Couldn't load this photo",
                style: TextStyle(color: Colors.white),
              )
            : aspectRatio == null
                ? const AppLoader(label: 'Loading image')
                : AspectRatio(
                    aspectRatio: aspectRatio,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final size =
                            Size(constraints.maxWidth, constraints.maxHeight);
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image(
                              image: widget.imageProvider,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) =>
                                  const ColoredBox(
                                color: Colors.black26,
                                child: Center(
                                  child: Icon(Icons.broken_image_outlined,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            if (_showOverlay)
                              CustomPaint(
                                painter: _AnnotationPainter(
                                  shapes: _shapes,
                                  draftPoints: _draftPoints,
                                  draftTool: _drafting ? _tool : null,
                                  draftColor: _color,
                                  selectedId: _selectedId,
                                ),
                              ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onPanStart: (details) =>
                                  _onPanStart(details, size),
                              onPanUpdate: (details) =>
                                  _onPanUpdate(details, size),
                              onPanEnd: (details) =>
                                  unawaited(_onPanEnd(details)),
                              onTapUp: (details) =>
                                  unawaited(_onTapUp(details, size)),
                            ),
                            if (_busy)
                              Positioned.fill(
                                child: ColoredBox(
                                  color: Colors.black.withAlpha(51),
                                  child: const Center(
                                      child: AppLoader(label: 'Saving')),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
      ),
      bottomNavigationBar: widget.editable ? _buildToolbar(context) : null,
    );
  }

  Widget _buildToolbar(BuildContext context) {
    const tools = [
      AnnotationTool.select,
      AnnotationTool.freehand,
      AnnotationTool.rectangle,
      AnnotationTool.circle,
      AnnotationTool.arrow,
      AnnotationTool.point,
    ];
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(
          vertical: DsSpacing.s2, horizontal: DsSpacing.s2),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final tool in tools)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _ToolButton(
                        tool: tool,
                        selected: _tool == tool,
                        onTap: () => setState(() {
                          _tool = tool;
                          _selectedId = null;
                        }),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: DsSpacing.s2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final swatch in _swatches)
                  GestureDetector(
                    onTap: () => setState(() => _color = swatch),
                    child: Container(
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: swatch,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: _color == swatch ? 2.5 : 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton(
      {required this.tool, required this.selected, required this.onTap});

  final AnnotationTool tool;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DsRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: DsSpacing.s2, vertical: DsSpacing.s1),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withAlpha(38) : null,
          borderRadius: BorderRadius.circular(DsRadius.sm),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tool.icon, color: Colors.white, size: 20),
            Text(tool.label,
                style: const TextStyle(color: Colors.white, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _AnnotationPainter extends CustomPainter {
  _AnnotationPainter({
    required this.shapes,
    required this.draftPoints,
    required this.draftTool,
    required this.draftColor,
    required this.selectedId,
  });

  final List<AnnotationResponse> shapes;
  final List<Offset> draftPoints;
  final AnnotationTool? draftTool;
  final Color draftColor;
  final String? selectedId;

  @override
  void paint(Canvas canvas, Size size) {
    for (final shape in shapes) {
      final points = shape.points
          .map((p) =>
              Offset(p.x.toDouble() * size.width, p.y.toDouble() * size.height))
          .toList();
      final color = colorFromHex(shape.color);
      final selected = shape.id == selectedId;
      paintAnnotationShape(canvas, shape.shape.name, points, color,
          selected: selected);
    }
    if (draftTool != null && draftPoints.isNotEmpty) {
      final points = draftPoints
          .map((p) => Offset(p.dx * size.width, p.dy * size.height))
          .toList();
      paintAnnotationShape(canvas, draftTool!.wireValue, points, draftColor,
          selected: false);
    }
  }

  @override
  bool shouldRepaint(covariant _AnnotationPainter oldDelegate) =>
      oldDelegate.shapes != shapes ||
      oldDelegate.draftPoints != draftPoints ||
      oldDelegate.draftTool != draftTool ||
      oldDelegate.selectedId != selectedId;
}

/// Renders one shape (in already-pixel-scaled [points]) onto [canvas] --
/// shared by [_AnnotationPainter] (the interactive canvas, draft + selection
/// aware) and [AnnotationOverlayPainter] (a bare read-only overlay for
/// thumbnails/reviews elsewhere in the app).
void paintAnnotationShape(
  Canvas canvas,
  String shapeName,
  List<Offset> points,
  Color color, {
  required bool selected,
}) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = selected ? 4 : 3
    ..style = PaintingStyle.stroke;
  switch (shapeName) {
    case 'point':
      canvas.drawCircle(points.first, 8, paint..style = PaintingStyle.fill);
      break;
    case 'rectangle':
      if (points.length >= 2) {
        canvas.drawRect(Rect.fromPoints(points[0], points[1]), paint);
      }
      break;
    case 'circle':
      if (points.length >= 2) {
        canvas.drawOval(Rect.fromPoints(points[0], points[1]), paint);
      }
      break;
    case 'arrow':
      if (points.length >= 2) {
        canvas.drawLine(points[0], points[1], paint);
        _drawArrowHead(canvas, points[0], points[1], paint);
      }
      break;
    case 'freehand':
    default:
      if (points.length >= 2) {
        final path = ui.Path()..moveTo(points.first.dx, points.first.dy);
        for (final point in points.skip(1)) {
          path.lineTo(point.dx, point.dy);
        }
        canvas.drawPath(path, paint);
      }
  }
  if (selected) {
    final bounds = points.length == 1
        ? Rect.fromCircle(center: points.first, radius: 14)
        : Rect.fromPoints(
            points.reduce((a, b) =>
                Offset(a.dx < b.dx ? a.dx : b.dx, a.dy < b.dy ? a.dy : b.dy)),
            points.reduce((a, b) =>
                Offset(a.dx > b.dx ? a.dx : b.dx, a.dy > b.dy ? a.dy : b.dy)),
          ).inflate(6);
    canvas.drawRect(
      bounds,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );
  }
}

void _drawArrowHead(Canvas canvas, Offset from, Offset to, Paint paint) {
  const arrowLength = 12.0;
  const arrowAngle = 0.5;
  final direction = (to - from).direction;
  final left =
      to - Offset.fromDirection(direction + arrowAngle - 3.14159, arrowLength);
  final right =
      to - Offset.fromDirection(direction - arrowAngle + 3.14159, arrowLength);
  canvas.drawLine(to, left, paint);
  canvas.drawLine(to, right, paint);
}

/// A bare, non-interactive overlay of [shapes] -- for the media gallery's
/// grid tile thumbnails, so a marked-up photo is recognizable at a glance
/// without opening the full canvas.
class AnnotationOverlayPainter extends CustomPainter {
  AnnotationOverlayPainter(this.shapes);

  final List<AnnotationResponse> shapes;

  @override
  void paint(Canvas canvas, Size size) {
    for (final shape in shapes) {
      final points = shape.points
          .map((p) =>
              Offset(p.x.toDouble() * size.width, p.y.toDouble() * size.height))
          .toList();
      paintAnnotationShape(
          canvas, shape.shape.name, points, colorFromHex(shape.color),
          selected: false);
    }
  }

  @override
  bool shouldRepaint(covariant AnnotationOverlayPainter oldDelegate) =>
      oldDelegate.shapes != shapes;
}
