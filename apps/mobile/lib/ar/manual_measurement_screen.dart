import 'package:flutter/material.dart';

import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';
import 'measurement_capture_result.dart';

enum _DistanceUnit { meters, centimeters, feet, inches }

extension on _DistanceUnit {
  String get label => switch (this) {
        _DistanceUnit.meters => 'm',
        _DistanceUnit.centimeters => 'cm',
        _DistanceUnit.feet => 'ft',
        _DistanceUnit.inches => 'in',
      };

  double toMeters(double value) => switch (this) {
        _DistanceUnit.meters => value,
        _DistanceUnit.centimeters => value / 100,
        _DistanceUnit.feet => value / 3.28084,
        _DistanceUnit.inches => value / 39.3701,
      };
}

/// Manual dimension-entry fallback (spec 7.2's mandatory fallback, D-062/
/// D-063) -- always available, not just when AR fails: a device with no
/// ARCore/ARKit support, a dark/low-texture surface AR can't track, or an
/// inspector who simply prefers typing a tape-measure reading all land here.
/// No screenshot/points -- a typed value has no visual capture step.
class ManualMeasurementScreen extends StatefulWidget {
  const ManualMeasurementScreen({super.key});

  @override
  State<ManualMeasurementScreen> createState() =>
      _ManualMeasurementScreenState();
}

class _ManualMeasurementScreenState extends State<ManualMeasurementScreen> {
  final _valueController = TextEditingController();
  final _labelController = TextEditingController();
  final _noteController = TextEditingController();
  _DistanceUnit _unit = _DistanceUnit.meters;

  @override
  void dispose() {
    _valueController.dispose();
    _labelController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  double? get _parsedValue => double.tryParse(_valueController.text.trim());

  void _save() {
    final value = _parsedValue;
    if (value == null || value <= 0) return;
    Navigator.of(context).pop(
      MeasurementCaptureResult(
        method: 'manual',
        distanceMeters: _unit.toMeters(value),
        label: _labelController.text.trim().isEmpty
            ? null
            : _labelController.text.trim(),
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canSave = (_parsedValue ?? 0) > 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Enter measurement')),
      body: ListView(
        padding: const EdgeInsets.all(DsSpacing.s6),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  key: const Key('manual-measurement-value'),
                  label: 'Distance',
                  controller: _valueController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: DsSpacing.s3),
              SizedBox(
                width: 96,
                child: AppSelect<_DistanceUnit>(
                  label: 'Unit',
                  value: _unit,
                  items: [
                    for (final unit in _DistanceUnit.values)
                      DropdownMenuItem(value: unit, child: Text(unit.label)),
                  ],
                  onChanged: (unit) => setState(() => _unit = unit ?? _unit),
                ),
              ),
            ],
          ),
          const SizedBox(height: DsSpacing.s4),
          AppTextField(
            key: const Key('manual-measurement-label'),
            label: 'Label (optional)',
            controller: _labelController,
          ),
          const SizedBox(height: DsSpacing.s4),
          AppTextField(
            key: const Key('manual-measurement-note'),
            label: 'Note (optional)',
            controller: _noteController,
            maxLines: 3,
          ),
          const SizedBox(height: DsSpacing.s5),
          AppButton(
            key: const Key('manual-measurement-save'),
            label: 'Save measurement',
            icon: Icons.check,
            onPressed: canSave ? _save : null,
          ),
        ],
      ),
    );
  }
}
