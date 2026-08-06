import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import '../sync/sync_engine.dart';

/// Capitalizes a lowercase Dart enum identifier (e.g. `excellent`) into its
/// display label (`Excellent`) -- every readings enum's wire value already
/// reads correctly capitalized/as-is, so this is purely a display concern,
/// never re-fed back into `valueOf`.
String _label(String dartEnumName) =>
    dartEnumName.isEmpty ? dartEnumName : dartEnumName[0].toUpperCase() + dartEnumName.substring(1);

/// Maps a reading's condition onto the same 3-state health severity the
/// asset itself uses (spec section 9 -> 4.1 `current_status`, Phase 7.7) so
/// the in-progress form previews the asset-health impact its own completion
/// will cause, without waiting for the server's rollup.
AppStatus appStatusForReadingsCondition(String conditionDartName) {
  switch (conditionDartName) {
    case 'excellent':
    case 'good':
      return AppStatus.healthy;
    case 'fair':
    case 'poor':
      return AppStatus.warning;
    case 'critical':
      return AppStatus.critical;
    default:
      return AppStatus.info;
  }
}

const List<String> _conditions = ['excellent', 'good', 'fair', 'poor', 'critical'];
const List<String> _operationalStatuses = ['running', 'stopped', 'degraded'];
const List<String> _priorityLevels = ['low', 'medium', 'high', 'critical'];

/// The inspection detail screen's manual status readings step (Phase 7.7,
/// spec section 9) -- condition, temperature/pressure/noise (fixed
/// documented units: Celsius/bar/decibels), vibration, leak, operational
/// status, comments, recommendations, priority. Autosaves through the same
/// generic `updateInspection`/record-outbox path the 7.3 checklist uses (not
/// a dedicated mutation type), since this is one form with one editor, not
/// an array of independent records like media/annotations/voice notes.
/// `condition` is the only required field -- nothing is sent to the
/// repository until it's chosen, mirroring the backend's own validation.
class InspectionReadingsSection extends StatefulWidget {
  const InspectionReadingsSection({
    required this.inspectionId,
    required this.readings,
    required this.editable,
    super.key,
  });

  final String inspectionId;
  final ReadingsResponse? readings;
  final bool editable;

  @override
  State<InspectionReadingsSection> createState() => _InspectionReadingsSectionState();
}

class _InspectionReadingsSectionState extends State<InspectionReadingsSection> {
  Timer? _debounce;
  String? _condition;
  String? _operationalStatus;
  String? _priorityLevel;
  bool? _leakObserved;
  late final TextEditingController _temperatureController;
  late final TextEditingController _pressureController;
  late final TextEditingController _noiseController;
  late final TextEditingController _vibrationController;
  late final TextEditingController _commentsController;
  late final TextEditingController _recommendationsController;

  @override
  void initState() {
    super.initState();
    final readings = widget.readings;
    _condition = readings?.condition.name;
    _operationalStatus = readings?.operationalStatus?.name;
    _priorityLevel = readings?.priorityLevel?.name;
    _leakObserved = readings?.leakObserved;
    _temperatureController =
        TextEditingController(text: readings?.temperatureC?.toString() ?? '');
    _pressureController = TextEditingController(text: readings?.pressureBar?.toString() ?? '');
    _noiseController = TextEditingController(text: readings?.noiseLevelDb?.toString() ?? '');
    _vibrationController =
        TextEditingController(text: readings?.vibrationObservation ?? '');
    _commentsController = TextEditingController(text: readings?.comments ?? '');
    _recommendationsController =
        TextEditingController(text: readings?.recommendations ?? '');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    for (final controller in [
      _temperatureController,
      _pressureController,
      _noiseController,
      _vibrationController,
      _commentsController,
      _recommendationsController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveNow() {
    final condition = _condition;
    if (condition == null) return;
    final input = ReadingsInput(
      (b) => b
        ..condition = ReadingsInputConditionEnum.valueOf(condition)
        ..temperatureC = num.tryParse(_temperatureController.text.trim())
        ..pressureBar = num.tryParse(_pressureController.text.trim())
        ..noiseLevelDb = num.tryParse(_noiseController.text.trim())
        ..vibrationObservation =
            _vibrationController.text.trim().isEmpty ? null : _vibrationController.text.trim()
        ..leakObserved = _leakObserved
        ..operationalStatus = _operationalStatus == null
            ? null
            : ReadingsInputOperationalStatusEnum.valueOf(_operationalStatus!)
        ..comments = _commentsController.text.trim().isEmpty ? null : _commentsController.text.trim()
        ..recommendations = _recommendationsController.text.trim().isEmpty
            ? null
            : _recommendationsController.text.trim()
        ..priorityLevel =
            _priorityLevel == null ? null : ReadingsInputPriorityLevelEnum.valueOf(_priorityLevel!),
    );
    unawaited(
      SyncProvider.repositoryOf(context).updateInspection(widget.inspectionId, readings: input),
    );
  }

  void _saveDebounced() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _saveNow);
  }

  void _setCondition(String? value) {
    setState(() => _condition = value);
    _saveNow();
  }

  void _setOperationalStatus(String? value) {
    setState(() => _operationalStatus = value);
    _saveNow();
  }

  void _setPriorityLevel(String? value) {
    setState(() => _priorityLevel = value);
    _saveNow();
  }

  void _setLeakObserved(bool value) {
    setState(() => _leakObserved = value);
    _saveNow();
  }

  @override
  Widget build(BuildContext context) {
    final condition = _condition;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('READINGS', style: TextStyle(color: context.semantic.textMuted, letterSpacing: 1)),
            if (condition != null)
              StatusPill(
                label: _label(condition),
                status: appStatusForReadingsCondition(condition),
              ),
          ],
        ),
        const SizedBox(height: DsSpacing.s2),
        if (!widget.editable)
          _ReadingsReadOnly(readings: widget.readings)
        else
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSelect<String>(
                  key: const Key('readings-condition'),
                  label: 'Condition',
                  items: [
                    for (final value in _conditions)
                      DropdownMenuItem(value: value, child: Text(_label(value))),
                  ],
                  value: condition,
                  onChanged: _setCondition,
                ),
                const SizedBox(height: DsSpacing.s3),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        key: const Key('readings-temperature'),
                        label: 'Temperature (°C)',
                        controller: _temperatureController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        onChanged: (_) => _saveDebounced(),
                      ),
                    ),
                    const SizedBox(width: DsSpacing.s2),
                    Expanded(
                      child: AppTextField(
                        key: const Key('readings-pressure'),
                        label: 'Pressure (bar)',
                        controller: _pressureController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => _saveDebounced(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DsSpacing.s3),
                AppTextField(
                  key: const Key('readings-noise'),
                  label: 'Noise level (dB)',
                  controller: _noiseController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => _saveDebounced(),
                ),
                const SizedBox(height: DsSpacing.s3),
                AppTextField(
                  key: const Key('readings-vibration'),
                  label: 'Vibration observation',
                  controller: _vibrationController,
                  onChanged: (_) => _saveDebounced(),
                ),
                const SizedBox(height: DsSpacing.s3),
                Text('Leak observed?', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: DsSpacing.s1),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        key: const Key('readings-leak-no'),
                        label: 'No leak',
                        variant:
                            _leakObserved == false ? AppButtonVariant.primary : AppButtonVariant.ghost,
                        onPressed: () => _setLeakObserved(false),
                      ),
                    ),
                    const SizedBox(width: DsSpacing.s2),
                    Expanded(
                      child: AppButton(
                        key: const Key('readings-leak-yes'),
                        label: 'Leak observed',
                        variant:
                            _leakObserved == true ? AppButtonVariant.danger : AppButtonVariant.ghost,
                        onPressed: () => _setLeakObserved(true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DsSpacing.s3),
                AppSelect<String?>(
                  key: const Key('readings-operational-status'),
                  label: 'Operational status',
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Not set')),
                    for (final value in _operationalStatuses)
                      DropdownMenuItem(value: value, child: Text(_label(value))),
                  ],
                  value: _operationalStatus,
                  onChanged: _setOperationalStatus,
                ),
                const SizedBox(height: DsSpacing.s3),
                AppSelect<String?>(
                  key: const Key('readings-priority'),
                  label: 'Priority level',
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Not set')),
                    for (final value in _priorityLevels)
                      DropdownMenuItem(value: value, child: Text(_label(value))),
                  ],
                  value: _priorityLevel,
                  onChanged: _setPriorityLevel,
                ),
                const SizedBox(height: DsSpacing.s3),
                AppTextField(
                  key: const Key('readings-comments'),
                  label: 'Comments',
                  controller: _commentsController,
                  maxLines: 3,
                  onChanged: (_) => _saveDebounced(),
                ),
                const SizedBox(height: DsSpacing.s3),
                AppTextField(
                  key: const Key('readings-recommendations'),
                  label: 'Recommendations',
                  controller: _recommendationsController,
                  maxLines: 3,
                  onChanged: (_) => _saveDebounced(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ReadingsReadOnly extends StatelessWidget {
  const _ReadingsReadOnly({required this.readings});

  final ReadingsResponse? readings;

  @override
  Widget build(BuildContext context) {
    final readings = this.readings;
    if (readings == null) {
      return const EmptyState(
        title: 'No readings recorded',
        description: 'No manual status readings were logged for this inspection.',
      );
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReadOnlyRow(label: 'Condition', value: _label(readings.condition.name)),
          if (readings.temperatureC != null)
            _ReadOnlyRow(label: 'Temperature', value: '${readings.temperatureC} °C'),
          if (readings.pressureBar != null)
            _ReadOnlyRow(label: 'Pressure', value: '${readings.pressureBar} bar'),
          if (readings.noiseLevelDb != null)
            _ReadOnlyRow(label: 'Noise level', value: '${readings.noiseLevelDb} dB'),
          if (readings.vibrationObservation != null && readings.vibrationObservation!.isNotEmpty)
            _ReadOnlyRow(label: 'Vibration', value: readings.vibrationObservation!),
          if (readings.leakObserved != null)
            _ReadOnlyRow(label: 'Leak observed', value: readings.leakObserved! ? 'Yes' : 'No'),
          if (readings.operationalStatus != null)
            _ReadOnlyRow(
                label: 'Operational status', value: _label(readings.operationalStatus!.name)),
          if (readings.priorityLevel != null)
            _ReadOnlyRow(label: 'Priority', value: _label(readings.priorityLevel!.name)),
          if (readings.comments != null && readings.comments!.isNotEmpty)
            _ReadOnlyRow(label: 'Comments', value: readings.comments!),
          if (readings.recommendations != null && readings.recommendations!.isNotEmpty)
            _ReadOnlyRow(label: 'Recommendations', value: readings.recommendations!),
        ],
      ),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  const _ReadOnlyRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DsSpacing.s1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: DsSpacing.s3),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
