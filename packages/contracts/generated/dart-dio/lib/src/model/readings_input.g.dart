// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'readings_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReadingsInputConditionEnum _$readingsInputConditionEnum_excellent =
    const ReadingsInputConditionEnum._('excellent');
const ReadingsInputConditionEnum _$readingsInputConditionEnum_good =
    const ReadingsInputConditionEnum._('good');
const ReadingsInputConditionEnum _$readingsInputConditionEnum_fair =
    const ReadingsInputConditionEnum._('fair');
const ReadingsInputConditionEnum _$readingsInputConditionEnum_poor =
    const ReadingsInputConditionEnum._('poor');
const ReadingsInputConditionEnum _$readingsInputConditionEnum_critical =
    const ReadingsInputConditionEnum._('critical');

ReadingsInputConditionEnum _$readingsInputConditionEnumValueOf(String name) {
  switch (name) {
    case 'excellent':
      return _$readingsInputConditionEnum_excellent;
    case 'good':
      return _$readingsInputConditionEnum_good;
    case 'fair':
      return _$readingsInputConditionEnum_fair;
    case 'poor':
      return _$readingsInputConditionEnum_poor;
    case 'critical':
      return _$readingsInputConditionEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ReadingsInputConditionEnum> _$readingsInputConditionEnumValues =
    new BuiltSet<ReadingsInputConditionEnum>(const <ReadingsInputConditionEnum>[
  _$readingsInputConditionEnum_excellent,
  _$readingsInputConditionEnum_good,
  _$readingsInputConditionEnum_fair,
  _$readingsInputConditionEnum_poor,
  _$readingsInputConditionEnum_critical,
]);

const ReadingsInputOperationalStatusEnum
    _$readingsInputOperationalStatusEnum_running =
    const ReadingsInputOperationalStatusEnum._('running');
const ReadingsInputOperationalStatusEnum
    _$readingsInputOperationalStatusEnum_stopped =
    const ReadingsInputOperationalStatusEnum._('stopped');
const ReadingsInputOperationalStatusEnum
    _$readingsInputOperationalStatusEnum_degraded =
    const ReadingsInputOperationalStatusEnum._('degraded');

ReadingsInputOperationalStatusEnum _$readingsInputOperationalStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'running':
      return _$readingsInputOperationalStatusEnum_running;
    case 'stopped':
      return _$readingsInputOperationalStatusEnum_stopped;
    case 'degraded':
      return _$readingsInputOperationalStatusEnum_degraded;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ReadingsInputOperationalStatusEnum>
    _$readingsInputOperationalStatusEnumValues = new BuiltSet<
        ReadingsInputOperationalStatusEnum>(const <ReadingsInputOperationalStatusEnum>[
  _$readingsInputOperationalStatusEnum_running,
  _$readingsInputOperationalStatusEnum_stopped,
  _$readingsInputOperationalStatusEnum_degraded,
]);

const ReadingsInputPriorityLevelEnum _$readingsInputPriorityLevelEnum_low =
    const ReadingsInputPriorityLevelEnum._('low');
const ReadingsInputPriorityLevelEnum _$readingsInputPriorityLevelEnum_medium =
    const ReadingsInputPriorityLevelEnum._('medium');
const ReadingsInputPriorityLevelEnum _$readingsInputPriorityLevelEnum_high =
    const ReadingsInputPriorityLevelEnum._('high');
const ReadingsInputPriorityLevelEnum _$readingsInputPriorityLevelEnum_critical =
    const ReadingsInputPriorityLevelEnum._('critical');

ReadingsInputPriorityLevelEnum _$readingsInputPriorityLevelEnumValueOf(
    String name) {
  switch (name) {
    case 'low':
      return _$readingsInputPriorityLevelEnum_low;
    case 'medium':
      return _$readingsInputPriorityLevelEnum_medium;
    case 'high':
      return _$readingsInputPriorityLevelEnum_high;
    case 'critical':
      return _$readingsInputPriorityLevelEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ReadingsInputPriorityLevelEnum>
    _$readingsInputPriorityLevelEnumValues = new BuiltSet<
        ReadingsInputPriorityLevelEnum>(const <ReadingsInputPriorityLevelEnum>[
  _$readingsInputPriorityLevelEnum_low,
  _$readingsInputPriorityLevelEnum_medium,
  _$readingsInputPriorityLevelEnum_high,
  _$readingsInputPriorityLevelEnum_critical,
]);

Serializer<ReadingsInputConditionEnum> _$readingsInputConditionEnumSerializer =
    new _$ReadingsInputConditionEnumSerializer();
Serializer<ReadingsInputOperationalStatusEnum>
    _$readingsInputOperationalStatusEnumSerializer =
    new _$ReadingsInputOperationalStatusEnumSerializer();
Serializer<ReadingsInputPriorityLevelEnum>
    _$readingsInputPriorityLevelEnumSerializer =
    new _$ReadingsInputPriorityLevelEnumSerializer();

class _$ReadingsInputConditionEnumSerializer
    implements PrimitiveSerializer<ReadingsInputConditionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'excellent': 'Excellent',
    'good': 'Good',
    'fair': 'Fair',
    'poor': 'Poor',
    'critical': 'Critical',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Excellent': 'excellent',
    'Good': 'good',
    'Fair': 'fair',
    'Poor': 'poor',
    'Critical': 'critical',
  };

  @override
  final Iterable<Type> types = const <Type>[ReadingsInputConditionEnum];
  @override
  final String wireName = 'ReadingsInputConditionEnum';

  @override
  Object serialize(Serializers serializers, ReadingsInputConditionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReadingsInputConditionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReadingsInputConditionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReadingsInputOperationalStatusEnumSerializer
    implements PrimitiveSerializer<ReadingsInputOperationalStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'running': 'running',
    'stopped': 'stopped',
    'degraded': 'degraded',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'running': 'running',
    'stopped': 'stopped',
    'degraded': 'degraded',
  };

  @override
  final Iterable<Type> types = const <Type>[ReadingsInputOperationalStatusEnum];
  @override
  final String wireName = 'ReadingsInputOperationalStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ReadingsInputOperationalStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReadingsInputOperationalStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReadingsInputOperationalStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReadingsInputPriorityLevelEnumSerializer
    implements PrimitiveSerializer<ReadingsInputPriorityLevelEnum> {
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
  final Iterable<Type> types = const <Type>[ReadingsInputPriorityLevelEnum];
  @override
  final String wireName = 'ReadingsInputPriorityLevelEnum';

  @override
  Object serialize(
          Serializers serializers, ReadingsInputPriorityLevelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReadingsInputPriorityLevelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReadingsInputPriorityLevelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReadingsInput extends ReadingsInput {
  @override
  final String? comments;
  @override
  final ReadingsInputConditionEnum condition;
  @override
  final bool? leakObserved;
  @override
  final num? noiseLevelDb;
  @override
  final ReadingsInputOperationalStatusEnum? operationalStatus;
  @override
  final num? pressureBar;
  @override
  final ReadingsInputPriorityLevelEnum? priorityLevel;
  @override
  final String? recommendations;
  @override
  final num? temperatureC;
  @override
  final String? vibrationObservation;

  factory _$ReadingsInput([void Function(ReadingsInputBuilder)? updates]) =>
      (new ReadingsInputBuilder()..update(updates))._build();

  _$ReadingsInput._(
      {this.comments,
      required this.condition,
      this.leakObserved,
      this.noiseLevelDb,
      this.operationalStatus,
      this.pressureBar,
      this.priorityLevel,
      this.recommendations,
      this.temperatureC,
      this.vibrationObservation})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        condition, r'ReadingsInput', 'condition');
  }

  @override
  ReadingsInput rebuild(void Function(ReadingsInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReadingsInputBuilder toBuilder() => new ReadingsInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReadingsInput &&
        comments == other.comments &&
        condition == other.condition &&
        leakObserved == other.leakObserved &&
        noiseLevelDb == other.noiseLevelDb &&
        operationalStatus == other.operationalStatus &&
        pressureBar == other.pressureBar &&
        priorityLevel == other.priorityLevel &&
        recommendations == other.recommendations &&
        temperatureC == other.temperatureC &&
        vibrationObservation == other.vibrationObservation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, comments.hashCode);
    _$hash = $jc(_$hash, condition.hashCode);
    _$hash = $jc(_$hash, leakObserved.hashCode);
    _$hash = $jc(_$hash, noiseLevelDb.hashCode);
    _$hash = $jc(_$hash, operationalStatus.hashCode);
    _$hash = $jc(_$hash, pressureBar.hashCode);
    _$hash = $jc(_$hash, priorityLevel.hashCode);
    _$hash = $jc(_$hash, recommendations.hashCode);
    _$hash = $jc(_$hash, temperatureC.hashCode);
    _$hash = $jc(_$hash, vibrationObservation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReadingsInput')
          ..add('comments', comments)
          ..add('condition', condition)
          ..add('leakObserved', leakObserved)
          ..add('noiseLevelDb', noiseLevelDb)
          ..add('operationalStatus', operationalStatus)
          ..add('pressureBar', pressureBar)
          ..add('priorityLevel', priorityLevel)
          ..add('recommendations', recommendations)
          ..add('temperatureC', temperatureC)
          ..add('vibrationObservation', vibrationObservation))
        .toString();
  }
}

class ReadingsInputBuilder
    implements Builder<ReadingsInput, ReadingsInputBuilder> {
  _$ReadingsInput? _$v;

  String? _comments;
  String? get comments => _$this._comments;
  set comments(String? comments) => _$this._comments = comments;

  ReadingsInputConditionEnum? _condition;
  ReadingsInputConditionEnum? get condition => _$this._condition;
  set condition(ReadingsInputConditionEnum? condition) =>
      _$this._condition = condition;

  bool? _leakObserved;
  bool? get leakObserved => _$this._leakObserved;
  set leakObserved(bool? leakObserved) => _$this._leakObserved = leakObserved;

  num? _noiseLevelDb;
  num? get noiseLevelDb => _$this._noiseLevelDb;
  set noiseLevelDb(num? noiseLevelDb) => _$this._noiseLevelDb = noiseLevelDb;

  ReadingsInputOperationalStatusEnum? _operationalStatus;
  ReadingsInputOperationalStatusEnum? get operationalStatus =>
      _$this._operationalStatus;
  set operationalStatus(
          ReadingsInputOperationalStatusEnum? operationalStatus) =>
      _$this._operationalStatus = operationalStatus;

  num? _pressureBar;
  num? get pressureBar => _$this._pressureBar;
  set pressureBar(num? pressureBar) => _$this._pressureBar = pressureBar;

  ReadingsInputPriorityLevelEnum? _priorityLevel;
  ReadingsInputPriorityLevelEnum? get priorityLevel => _$this._priorityLevel;
  set priorityLevel(ReadingsInputPriorityLevelEnum? priorityLevel) =>
      _$this._priorityLevel = priorityLevel;

  String? _recommendations;
  String? get recommendations => _$this._recommendations;
  set recommendations(String? recommendations) =>
      _$this._recommendations = recommendations;

  num? _temperatureC;
  num? get temperatureC => _$this._temperatureC;
  set temperatureC(num? temperatureC) => _$this._temperatureC = temperatureC;

  String? _vibrationObservation;
  String? get vibrationObservation => _$this._vibrationObservation;
  set vibrationObservation(String? vibrationObservation) =>
      _$this._vibrationObservation = vibrationObservation;

  ReadingsInputBuilder() {
    ReadingsInput._defaults(this);
  }

  ReadingsInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _comments = $v.comments;
      _condition = $v.condition;
      _leakObserved = $v.leakObserved;
      _noiseLevelDb = $v.noiseLevelDb;
      _operationalStatus = $v.operationalStatus;
      _pressureBar = $v.pressureBar;
      _priorityLevel = $v.priorityLevel;
      _recommendations = $v.recommendations;
      _temperatureC = $v.temperatureC;
      _vibrationObservation = $v.vibrationObservation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReadingsInput other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ReadingsInput;
  }

  @override
  void update(void Function(ReadingsInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReadingsInput build() => _build();

  _$ReadingsInput _build() {
    final _$result = _$v ??
        new _$ReadingsInput._(
            comments: comments,
            condition: BuiltValueNullFieldError.checkNotNull(
                condition, r'ReadingsInput', 'condition'),
            leakObserved: leakObserved,
            noiseLevelDb: noiseLevelDb,
            operationalStatus: operationalStatus,
            pressureBar: pressureBar,
            priorityLevel: priorityLevel,
            recommendations: recommendations,
            temperatureC: temperatureC,
            vibrationObservation: vibrationObservation);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
