// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_risk_assessment_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermitRiskAssessmentInput extends PermitRiskAssessmentInput {
  @override
  final String controls;
  @override
  final String hazard;
  @override
  final String? id;
  @override
  final int initialLikelihood;
  @override
  final int initialSeverity;
  @override
  final String personsAtRisk;
  @override
  final int residualLikelihood;
  @override
  final int residualSeverity;

  factory _$PermitRiskAssessmentInput(
          [void Function(PermitRiskAssessmentInputBuilder)? updates]) =>
      (new PermitRiskAssessmentInputBuilder()..update(updates))._build();

  _$PermitRiskAssessmentInput._(
      {required this.controls,
      required this.hazard,
      this.id,
      required this.initialLikelihood,
      required this.initialSeverity,
      required this.personsAtRisk,
      required this.residualLikelihood,
      required this.residualSeverity})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        controls, r'PermitRiskAssessmentInput', 'controls');
    BuiltValueNullFieldError.checkNotNull(
        hazard, r'PermitRiskAssessmentInput', 'hazard');
    BuiltValueNullFieldError.checkNotNull(
        initialLikelihood, r'PermitRiskAssessmentInput', 'initialLikelihood');
    BuiltValueNullFieldError.checkNotNull(
        initialSeverity, r'PermitRiskAssessmentInput', 'initialSeverity');
    BuiltValueNullFieldError.checkNotNull(
        personsAtRisk, r'PermitRiskAssessmentInput', 'personsAtRisk');
    BuiltValueNullFieldError.checkNotNull(
        residualLikelihood, r'PermitRiskAssessmentInput', 'residualLikelihood');
    BuiltValueNullFieldError.checkNotNull(
        residualSeverity, r'PermitRiskAssessmentInput', 'residualSeverity');
  }

  @override
  PermitRiskAssessmentInput rebuild(
          void Function(PermitRiskAssessmentInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitRiskAssessmentInputBuilder toBuilder() =>
      new PermitRiskAssessmentInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitRiskAssessmentInput &&
        controls == other.controls &&
        hazard == other.hazard &&
        id == other.id &&
        initialLikelihood == other.initialLikelihood &&
        initialSeverity == other.initialSeverity &&
        personsAtRisk == other.personsAtRisk &&
        residualLikelihood == other.residualLikelihood &&
        residualSeverity == other.residualSeverity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, controls.hashCode);
    _$hash = $jc(_$hash, hazard.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, initialLikelihood.hashCode);
    _$hash = $jc(_$hash, initialSeverity.hashCode);
    _$hash = $jc(_$hash, personsAtRisk.hashCode);
    _$hash = $jc(_$hash, residualLikelihood.hashCode);
    _$hash = $jc(_$hash, residualSeverity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermitRiskAssessmentInput')
          ..add('controls', controls)
          ..add('hazard', hazard)
          ..add('id', id)
          ..add('initialLikelihood', initialLikelihood)
          ..add('initialSeverity', initialSeverity)
          ..add('personsAtRisk', personsAtRisk)
          ..add('residualLikelihood', residualLikelihood)
          ..add('residualSeverity', residualSeverity))
        .toString();
  }
}

class PermitRiskAssessmentInputBuilder
    implements
        Builder<PermitRiskAssessmentInput, PermitRiskAssessmentInputBuilder> {
  _$PermitRiskAssessmentInput? _$v;

  String? _controls;
  String? get controls => _$this._controls;
  set controls(String? controls) => _$this._controls = controls;

  String? _hazard;
  String? get hazard => _$this._hazard;
  set hazard(String? hazard) => _$this._hazard = hazard;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _initialLikelihood;
  int? get initialLikelihood => _$this._initialLikelihood;
  set initialLikelihood(int? initialLikelihood) =>
      _$this._initialLikelihood = initialLikelihood;

  int? _initialSeverity;
  int? get initialSeverity => _$this._initialSeverity;
  set initialSeverity(int? initialSeverity) =>
      _$this._initialSeverity = initialSeverity;

  String? _personsAtRisk;
  String? get personsAtRisk => _$this._personsAtRisk;
  set personsAtRisk(String? personsAtRisk) =>
      _$this._personsAtRisk = personsAtRisk;

  int? _residualLikelihood;
  int? get residualLikelihood => _$this._residualLikelihood;
  set residualLikelihood(int? residualLikelihood) =>
      _$this._residualLikelihood = residualLikelihood;

  int? _residualSeverity;
  int? get residualSeverity => _$this._residualSeverity;
  set residualSeverity(int? residualSeverity) =>
      _$this._residualSeverity = residualSeverity;

  PermitRiskAssessmentInputBuilder() {
    PermitRiskAssessmentInput._defaults(this);
  }

  PermitRiskAssessmentInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _controls = $v.controls;
      _hazard = $v.hazard;
      _id = $v.id;
      _initialLikelihood = $v.initialLikelihood;
      _initialSeverity = $v.initialSeverity;
      _personsAtRisk = $v.personsAtRisk;
      _residualLikelihood = $v.residualLikelihood;
      _residualSeverity = $v.residualSeverity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitRiskAssessmentInput other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitRiskAssessmentInput;
  }

  @override
  void update(void Function(PermitRiskAssessmentInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitRiskAssessmentInput build() => _build();

  _$PermitRiskAssessmentInput _build() {
    final _$result = _$v ??
        new _$PermitRiskAssessmentInput._(
            controls: BuiltValueNullFieldError.checkNotNull(
                controls, r'PermitRiskAssessmentInput', 'controls'),
            hazard: BuiltValueNullFieldError.checkNotNull(
                hazard, r'PermitRiskAssessmentInput', 'hazard'),
            id: id,
            initialLikelihood: BuiltValueNullFieldError.checkNotNull(
                initialLikelihood, r'PermitRiskAssessmentInput', 'initialLikelihood'),
            initialSeverity: BuiltValueNullFieldError.checkNotNull(
                initialSeverity, r'PermitRiskAssessmentInput', 'initialSeverity'),
            personsAtRisk: BuiltValueNullFieldError.checkNotNull(
                personsAtRisk, r'PermitRiskAssessmentInput', 'personsAtRisk'),
            residualLikelihood: BuiltValueNullFieldError.checkNotNull(
                residualLikelihood,
                r'PermitRiskAssessmentInput',
                'residualLikelihood'),
            residualSeverity: BuiltValueNullFieldError.checkNotNull(
                residualSeverity, r'PermitRiskAssessmentInput', 'residualSeverity'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
