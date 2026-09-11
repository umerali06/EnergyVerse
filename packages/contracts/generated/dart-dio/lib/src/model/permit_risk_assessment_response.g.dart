// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_risk_assessment_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PermitRiskAssessmentResponseInitialBandEnum
    _$permitRiskAssessmentResponseInitialBandEnum_low =
    const PermitRiskAssessmentResponseInitialBandEnum._('low');
const PermitRiskAssessmentResponseInitialBandEnum
    _$permitRiskAssessmentResponseInitialBandEnum_medium =
    const PermitRiskAssessmentResponseInitialBandEnum._('medium');
const PermitRiskAssessmentResponseInitialBandEnum
    _$permitRiskAssessmentResponseInitialBandEnum_high =
    const PermitRiskAssessmentResponseInitialBandEnum._('high');
const PermitRiskAssessmentResponseInitialBandEnum
    _$permitRiskAssessmentResponseInitialBandEnum_critical =
    const PermitRiskAssessmentResponseInitialBandEnum._('critical');

PermitRiskAssessmentResponseInitialBandEnum
    _$permitRiskAssessmentResponseInitialBandEnumValueOf(String name) {
  switch (name) {
    case 'low':
      return _$permitRiskAssessmentResponseInitialBandEnum_low;
    case 'medium':
      return _$permitRiskAssessmentResponseInitialBandEnum_medium;
    case 'high':
      return _$permitRiskAssessmentResponseInitialBandEnum_high;
    case 'critical':
      return _$permitRiskAssessmentResponseInitialBandEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<PermitRiskAssessmentResponseInitialBandEnum>
    _$permitRiskAssessmentResponseInitialBandEnumValues = new BuiltSet<
        PermitRiskAssessmentResponseInitialBandEnum>(const <PermitRiskAssessmentResponseInitialBandEnum>[
  _$permitRiskAssessmentResponseInitialBandEnum_low,
  _$permitRiskAssessmentResponseInitialBandEnum_medium,
  _$permitRiskAssessmentResponseInitialBandEnum_high,
  _$permitRiskAssessmentResponseInitialBandEnum_critical,
]);

const PermitRiskAssessmentResponseResidualBandEnum
    _$permitRiskAssessmentResponseResidualBandEnum_low =
    const PermitRiskAssessmentResponseResidualBandEnum._('low');
const PermitRiskAssessmentResponseResidualBandEnum
    _$permitRiskAssessmentResponseResidualBandEnum_medium =
    const PermitRiskAssessmentResponseResidualBandEnum._('medium');
const PermitRiskAssessmentResponseResidualBandEnum
    _$permitRiskAssessmentResponseResidualBandEnum_high =
    const PermitRiskAssessmentResponseResidualBandEnum._('high');
const PermitRiskAssessmentResponseResidualBandEnum
    _$permitRiskAssessmentResponseResidualBandEnum_critical =
    const PermitRiskAssessmentResponseResidualBandEnum._('critical');

PermitRiskAssessmentResponseResidualBandEnum
    _$permitRiskAssessmentResponseResidualBandEnumValueOf(String name) {
  switch (name) {
    case 'low':
      return _$permitRiskAssessmentResponseResidualBandEnum_low;
    case 'medium':
      return _$permitRiskAssessmentResponseResidualBandEnum_medium;
    case 'high':
      return _$permitRiskAssessmentResponseResidualBandEnum_high;
    case 'critical':
      return _$permitRiskAssessmentResponseResidualBandEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<PermitRiskAssessmentResponseResidualBandEnum>
    _$permitRiskAssessmentResponseResidualBandEnumValues = new BuiltSet<
        PermitRiskAssessmentResponseResidualBandEnum>(const <PermitRiskAssessmentResponseResidualBandEnum>[
  _$permitRiskAssessmentResponseResidualBandEnum_low,
  _$permitRiskAssessmentResponseResidualBandEnum_medium,
  _$permitRiskAssessmentResponseResidualBandEnum_high,
  _$permitRiskAssessmentResponseResidualBandEnum_critical,
]);

Serializer<PermitRiskAssessmentResponseInitialBandEnum>
    _$permitRiskAssessmentResponseInitialBandEnumSerializer =
    new _$PermitRiskAssessmentResponseInitialBandEnumSerializer();
Serializer<PermitRiskAssessmentResponseResidualBandEnum>
    _$permitRiskAssessmentResponseResidualBandEnumSerializer =
    new _$PermitRiskAssessmentResponseResidualBandEnumSerializer();

class _$PermitRiskAssessmentResponseInitialBandEnumSerializer
    implements
        PrimitiveSerializer<PermitRiskAssessmentResponseInitialBandEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'low': 'low',
    'medium': 'medium',
    'high': 'high',
    'critical': 'critical',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'low': 'low',
    'medium': 'medium',
    'high': 'high',
    'critical': 'critical',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PermitRiskAssessmentResponseInitialBandEnum
  ];
  @override
  final String wireName = 'PermitRiskAssessmentResponseInitialBandEnum';

  @override
  Object serialize(Serializers serializers,
          PermitRiskAssessmentResponseInitialBandEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PermitRiskAssessmentResponseInitialBandEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PermitRiskAssessmentResponseInitialBandEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PermitRiskAssessmentResponseResidualBandEnumSerializer
    implements
        PrimitiveSerializer<PermitRiskAssessmentResponseResidualBandEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'low': 'low',
    'medium': 'medium',
    'high': 'high',
    'critical': 'critical',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'low': 'low',
    'medium': 'medium',
    'high': 'high',
    'critical': 'critical',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PermitRiskAssessmentResponseResidualBandEnum
  ];
  @override
  final String wireName = 'PermitRiskAssessmentResponseResidualBandEnum';

  @override
  Object serialize(Serializers serializers,
          PermitRiskAssessmentResponseResidualBandEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PermitRiskAssessmentResponseResidualBandEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PermitRiskAssessmentResponseResidualBandEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PermitRiskAssessmentResponse extends PermitRiskAssessmentResponse {
  @override
  final String controls;
  @override
  final String hazard;
  @override
  final String id;
  @override
  final PermitRiskAssessmentResponseInitialBandEnum initialBand;
  @override
  final int initialLikelihood;
  @override
  final int initialScore;
  @override
  final int initialSeverity;
  @override
  final String personsAtRisk;
  @override
  final PermitRiskAssessmentResponseResidualBandEnum residualBand;
  @override
  final int residualLikelihood;
  @override
  final int residualScore;
  @override
  final int residualSeverity;

  factory _$PermitRiskAssessmentResponse(
          [void Function(PermitRiskAssessmentResponseBuilder)? updates]) =>
      (new PermitRiskAssessmentResponseBuilder()..update(updates))._build();

  _$PermitRiskAssessmentResponse._(
      {required this.controls,
      required this.hazard,
      required this.id,
      required this.initialBand,
      required this.initialLikelihood,
      required this.initialScore,
      required this.initialSeverity,
      required this.personsAtRisk,
      required this.residualBand,
      required this.residualLikelihood,
      required this.residualScore,
      required this.residualSeverity})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        controls, r'PermitRiskAssessmentResponse', 'controls');
    BuiltValueNullFieldError.checkNotNull(
        hazard, r'PermitRiskAssessmentResponse', 'hazard');
    BuiltValueNullFieldError.checkNotNull(
        id, r'PermitRiskAssessmentResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        initialBand, r'PermitRiskAssessmentResponse', 'initialBand');
    BuiltValueNullFieldError.checkNotNull(initialLikelihood,
        r'PermitRiskAssessmentResponse', 'initialLikelihood');
    BuiltValueNullFieldError.checkNotNull(
        initialScore, r'PermitRiskAssessmentResponse', 'initialScore');
    BuiltValueNullFieldError.checkNotNull(
        initialSeverity, r'PermitRiskAssessmentResponse', 'initialSeverity');
    BuiltValueNullFieldError.checkNotNull(
        personsAtRisk, r'PermitRiskAssessmentResponse', 'personsAtRisk');
    BuiltValueNullFieldError.checkNotNull(
        residualBand, r'PermitRiskAssessmentResponse', 'residualBand');
    BuiltValueNullFieldError.checkNotNull(residualLikelihood,
        r'PermitRiskAssessmentResponse', 'residualLikelihood');
    BuiltValueNullFieldError.checkNotNull(
        residualScore, r'PermitRiskAssessmentResponse', 'residualScore');
    BuiltValueNullFieldError.checkNotNull(
        residualSeverity, r'PermitRiskAssessmentResponse', 'residualSeverity');
  }

  @override
  PermitRiskAssessmentResponse rebuild(
          void Function(PermitRiskAssessmentResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitRiskAssessmentResponseBuilder toBuilder() =>
      new PermitRiskAssessmentResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitRiskAssessmentResponse &&
        controls == other.controls &&
        hazard == other.hazard &&
        id == other.id &&
        initialBand == other.initialBand &&
        initialLikelihood == other.initialLikelihood &&
        initialScore == other.initialScore &&
        initialSeverity == other.initialSeverity &&
        personsAtRisk == other.personsAtRisk &&
        residualBand == other.residualBand &&
        residualLikelihood == other.residualLikelihood &&
        residualScore == other.residualScore &&
        residualSeverity == other.residualSeverity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, controls.hashCode);
    _$hash = $jc(_$hash, hazard.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, initialBand.hashCode);
    _$hash = $jc(_$hash, initialLikelihood.hashCode);
    _$hash = $jc(_$hash, initialScore.hashCode);
    _$hash = $jc(_$hash, initialSeverity.hashCode);
    _$hash = $jc(_$hash, personsAtRisk.hashCode);
    _$hash = $jc(_$hash, residualBand.hashCode);
    _$hash = $jc(_$hash, residualLikelihood.hashCode);
    _$hash = $jc(_$hash, residualScore.hashCode);
    _$hash = $jc(_$hash, residualSeverity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermitRiskAssessmentResponse')
          ..add('controls', controls)
          ..add('hazard', hazard)
          ..add('id', id)
          ..add('initialBand', initialBand)
          ..add('initialLikelihood', initialLikelihood)
          ..add('initialScore', initialScore)
          ..add('initialSeverity', initialSeverity)
          ..add('personsAtRisk', personsAtRisk)
          ..add('residualBand', residualBand)
          ..add('residualLikelihood', residualLikelihood)
          ..add('residualScore', residualScore)
          ..add('residualSeverity', residualSeverity))
        .toString();
  }
}

class PermitRiskAssessmentResponseBuilder
    implements
        Builder<PermitRiskAssessmentResponse,
            PermitRiskAssessmentResponseBuilder> {
  _$PermitRiskAssessmentResponse? _$v;

  String? _controls;
  String? get controls => _$this._controls;
  set controls(String? controls) => _$this._controls = controls;

  String? _hazard;
  String? get hazard => _$this._hazard;
  set hazard(String? hazard) => _$this._hazard = hazard;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  PermitRiskAssessmentResponseInitialBandEnum? _initialBand;
  PermitRiskAssessmentResponseInitialBandEnum? get initialBand =>
      _$this._initialBand;
  set initialBand(PermitRiskAssessmentResponseInitialBandEnum? initialBand) =>
      _$this._initialBand = initialBand;

  int? _initialLikelihood;
  int? get initialLikelihood => _$this._initialLikelihood;
  set initialLikelihood(int? initialLikelihood) =>
      _$this._initialLikelihood = initialLikelihood;

  int? _initialScore;
  int? get initialScore => _$this._initialScore;
  set initialScore(int? initialScore) => _$this._initialScore = initialScore;

  int? _initialSeverity;
  int? get initialSeverity => _$this._initialSeverity;
  set initialSeverity(int? initialSeverity) =>
      _$this._initialSeverity = initialSeverity;

  String? _personsAtRisk;
  String? get personsAtRisk => _$this._personsAtRisk;
  set personsAtRisk(String? personsAtRisk) =>
      _$this._personsAtRisk = personsAtRisk;

  PermitRiskAssessmentResponseResidualBandEnum? _residualBand;
  PermitRiskAssessmentResponseResidualBandEnum? get residualBand =>
      _$this._residualBand;
  set residualBand(
          PermitRiskAssessmentResponseResidualBandEnum? residualBand) =>
      _$this._residualBand = residualBand;

  int? _residualLikelihood;
  int? get residualLikelihood => _$this._residualLikelihood;
  set residualLikelihood(int? residualLikelihood) =>
      _$this._residualLikelihood = residualLikelihood;

  int? _residualScore;
  int? get residualScore => _$this._residualScore;
  set residualScore(int? residualScore) =>
      _$this._residualScore = residualScore;

  int? _residualSeverity;
  int? get residualSeverity => _$this._residualSeverity;
  set residualSeverity(int? residualSeverity) =>
      _$this._residualSeverity = residualSeverity;

  PermitRiskAssessmentResponseBuilder() {
    PermitRiskAssessmentResponse._defaults(this);
  }

  PermitRiskAssessmentResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _controls = $v.controls;
      _hazard = $v.hazard;
      _id = $v.id;
      _initialBand = $v.initialBand;
      _initialLikelihood = $v.initialLikelihood;
      _initialScore = $v.initialScore;
      _initialSeverity = $v.initialSeverity;
      _personsAtRisk = $v.personsAtRisk;
      _residualBand = $v.residualBand;
      _residualLikelihood = $v.residualLikelihood;
      _residualScore = $v.residualScore;
      _residualSeverity = $v.residualSeverity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitRiskAssessmentResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitRiskAssessmentResponse;
  }

  @override
  void update(void Function(PermitRiskAssessmentResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitRiskAssessmentResponse build() => _build();

  _$PermitRiskAssessmentResponse _build() {
    final _$result = _$v ??
        new _$PermitRiskAssessmentResponse._(
            controls: BuiltValueNullFieldError.checkNotNull(
                controls, r'PermitRiskAssessmentResponse', 'controls'),
            hazard: BuiltValueNullFieldError.checkNotNull(
                hazard, r'PermitRiskAssessmentResponse', 'hazard'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PermitRiskAssessmentResponse', 'id'),
            initialBand: BuiltValueNullFieldError.checkNotNull(
                initialBand, r'PermitRiskAssessmentResponse', 'initialBand'),
            initialLikelihood: BuiltValueNullFieldError.checkNotNull(
                initialLikelihood, r'PermitRiskAssessmentResponse', 'initialLikelihood'),
            initialScore: BuiltValueNullFieldError.checkNotNull(
                initialScore, r'PermitRiskAssessmentResponse', 'initialScore'),
            initialSeverity: BuiltValueNullFieldError.checkNotNull(
                initialSeverity, r'PermitRiskAssessmentResponse', 'initialSeverity'),
            personsAtRisk:
                BuiltValueNullFieldError.checkNotNull(personsAtRisk, r'PermitRiskAssessmentResponse', 'personsAtRisk'),
            residualBand: BuiltValueNullFieldError.checkNotNull(residualBand, r'PermitRiskAssessmentResponse', 'residualBand'),
            residualLikelihood: BuiltValueNullFieldError.checkNotNull(residualLikelihood, r'PermitRiskAssessmentResponse', 'residualLikelihood'),
            residualScore: BuiltValueNullFieldError.checkNotNull(residualScore, r'PermitRiskAssessmentResponse', 'residualScore'),
            residualSeverity: BuiltValueNullFieldError.checkNotNull(residualSeverity, r'PermitRiskAssessmentResponse', 'residualSeverity'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
