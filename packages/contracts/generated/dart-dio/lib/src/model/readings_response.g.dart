// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'readings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReadingsResponseConditionEnum _$readingsResponseConditionEnum_excellent =
    const ReadingsResponseConditionEnum._('excellent');
const ReadingsResponseConditionEnum _$readingsResponseConditionEnum_good =
    const ReadingsResponseConditionEnum._('good');
const ReadingsResponseConditionEnum _$readingsResponseConditionEnum_fair =
    const ReadingsResponseConditionEnum._('fair');
const ReadingsResponseConditionEnum _$readingsResponseConditionEnum_poor =
    const ReadingsResponseConditionEnum._('poor');
const ReadingsResponseConditionEnum _$readingsResponseConditionEnum_critical =
    const ReadingsResponseConditionEnum._('critical');

ReadingsResponseConditionEnum _$readingsResponseConditionEnumValueOf(
    String name) {
  switch (name) {
    case 'excellent':
      return _$readingsResponseConditionEnum_excellent;
    case 'good':
      return _$readingsResponseConditionEnum_good;
    case 'fair':
      return _$readingsResponseConditionEnum_fair;
    case 'poor':
      return _$readingsResponseConditionEnum_poor;
    case 'critical':
      return _$readingsResponseConditionEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ReadingsResponseConditionEnum>
    _$readingsResponseConditionEnumValues = new BuiltSet<
        ReadingsResponseConditionEnum>(const <ReadingsResponseConditionEnum>[
  _$readingsResponseConditionEnum_excellent,
  _$readingsResponseConditionEnum_good,
  _$readingsResponseConditionEnum_fair,
  _$readingsResponseConditionEnum_poor,
  _$readingsResponseConditionEnum_critical,
]);

const ReadingsResponseOperationalStatusEnum
    _$readingsResponseOperationalStatusEnum_running =
    const ReadingsResponseOperationalStatusEnum._('running');
const ReadingsResponseOperationalStatusEnum
    _$readingsResponseOperationalStatusEnum_stopped =
    const ReadingsResponseOperationalStatusEnum._('stopped');
const ReadingsResponseOperationalStatusEnum
    _$readingsResponseOperationalStatusEnum_degraded =
    const ReadingsResponseOperationalStatusEnum._('degraded');

ReadingsResponseOperationalStatusEnum
    _$readingsResponseOperationalStatusEnumValueOf(String name) {
  switch (name) {
    case 'running':
      return _$readingsResponseOperationalStatusEnum_running;
    case 'stopped':
      return _$readingsResponseOperationalStatusEnum_stopped;
    case 'degraded':
      return _$readingsResponseOperationalStatusEnum_degraded;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ReadingsResponseOperationalStatusEnum>
    _$readingsResponseOperationalStatusEnumValues = new BuiltSet<
        ReadingsResponseOperationalStatusEnum>(const <ReadingsResponseOperationalStatusEnum>[
  _$readingsResponseOperationalStatusEnum_running,
  _$readingsResponseOperationalStatusEnum_stopped,
  _$readingsResponseOperationalStatusEnum_degraded,
]);

const ReadingsResponsePriorityLevelEnum
    _$readingsResponsePriorityLevelEnum_low =
    const ReadingsResponsePriorityLevelEnum._('low');
const ReadingsResponsePriorityLevelEnum
    _$readingsResponsePriorityLevelEnum_medium =
    const ReadingsResponsePriorityLevelEnum._('medium');
const ReadingsResponsePriorityLevelEnum
    _$readingsResponsePriorityLevelEnum_high =
    const ReadingsResponsePriorityLevelEnum._('high');
const ReadingsResponsePriorityLevelEnum
    _$readingsResponsePriorityLevelEnum_critical =
    const ReadingsResponsePriorityLevelEnum._('critical');

ReadingsResponsePriorityLevelEnum _$readingsResponsePriorityLevelEnumValueOf(
    String name) {
  switch (name) {
    case 'low':
      return _$readingsResponsePriorityLevelEnum_low;
    case 'medium':
      return _$readingsResponsePriorityLevelEnum_medium;
    case 'high':
      return _$readingsResponsePriorityLevelEnum_high;
    case 'critical':
      return _$readingsResponsePriorityLevelEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ReadingsResponsePriorityLevelEnum>
    _$readingsResponsePriorityLevelEnumValues = new BuiltSet<
        ReadingsResponsePriorityLevelEnum>(const <ReadingsResponsePriorityLevelEnum>[
  _$readingsResponsePriorityLevelEnum_low,
  _$readingsResponsePriorityLevelEnum_medium,
  _$readingsResponsePriorityLevelEnum_high,
  _$readingsResponsePriorityLevelEnum_critical,
]);

Serializer<ReadingsResponseConditionEnum>
    _$readingsResponseConditionEnumSerializer =
    new _$ReadingsResponseConditionEnumSerializer();
Serializer<ReadingsResponseOperationalStatusEnum>
    _$readingsResponseOperationalStatusEnumSerializer =
    new _$ReadingsResponseOperationalStatusEnumSerializer();
Serializer<ReadingsResponsePriorityLevelEnum>
    _$readingsResponsePriorityLevelEnumSerializer =
    new _$ReadingsResponsePriorityLevelEnumSerializer();

class _$ReadingsResponseConditionEnumSerializer
    implements PrimitiveSerializer<ReadingsResponseConditionEnum> {
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
  final Iterable<Type> types = const <Type>[ReadingsResponseConditionEnum];
  @override
  final String wireName = 'ReadingsResponseConditionEnum';

  @override
  Object serialize(
          Serializers serializers, ReadingsResponseConditionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReadingsResponseConditionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReadingsResponseConditionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReadingsResponseOperationalStatusEnumSerializer
    implements PrimitiveSerializer<ReadingsResponseOperationalStatusEnum> {
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
  final Iterable<Type> types = const <Type>[
    ReadingsResponseOperationalStatusEnum
  ];
  @override
  final String wireName = 'ReadingsResponseOperationalStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ReadingsResponseOperationalStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReadingsResponseOperationalStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReadingsResponseOperationalStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReadingsResponsePriorityLevelEnumSerializer
    implements PrimitiveSerializer<ReadingsResponsePriorityLevelEnum> {
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
  final Iterable<Type> types = const <Type>[ReadingsResponsePriorityLevelEnum];
  @override
  final String wireName = 'ReadingsResponsePriorityLevelEnum';

  @override
  Object serialize(
          Serializers serializers, ReadingsResponsePriorityLevelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReadingsResponsePriorityLevelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReadingsResponsePriorityLevelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReadingsResponse extends ReadingsResponse {
  @override
  final String? comments;
  @override
  final ReadingsResponseConditionEnum condition;
  @override
  final bool? leakObserved;
  @override
  final num? noiseLevelDb;
  @override
  final ReadingsResponseOperationalStatusEnum? operationalStatus;
  @override
  final num? pressureBar;
  @override
  final ReadingsResponsePriorityLevelEnum? priorityLevel;
  @override
  final String? recommendations;
  @override
  final DateTime? recordedAt;
  @override
  final String? recordedBy;
  @override
  final num? temperatureC;
  @override
  final String? vibrationObservation;

  factory _$ReadingsResponse(
          [void Function(ReadingsResponseBuilder)? updates]) =>
      (new ReadingsResponseBuilder()..update(updates))._build();

  _$ReadingsResponse._(
      {this.comments,
      required this.condition,
      this.leakObserved,
      this.noiseLevelDb,
      this.operationalStatus,
      this.pressureBar,
      this.priorityLevel,
      this.recommendations,
      this.recordedAt,
      this.recordedBy,
      this.temperatureC,
      this.vibrationObservation})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        condition, r'ReadingsResponse', 'condition');
  }

  @override
  ReadingsResponse rebuild(void Function(ReadingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReadingsResponseBuilder toBuilder() =>
      new ReadingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReadingsResponse &&
        comments == other.comments &&
        condition == other.condition &&
        leakObserved == other.leakObserved &&
        noiseLevelDb == other.noiseLevelDb &&
        operationalStatus == other.operationalStatus &&
        pressureBar == other.pressureBar &&
        priorityLevel == other.priorityLevel &&
        recommendations == other.recommendations &&
        recordedAt == other.recordedAt &&
        recordedBy == other.recordedBy &&
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
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jc(_$hash, recordedBy.hashCode);
    _$hash = $jc(_$hash, temperatureC.hashCode);
    _$hash = $jc(_$hash, vibrationObservation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReadingsResponse')
          ..add('comments', comments)
          ..add('condition', condition)
          ..add('leakObserved', leakObserved)
          ..add('noiseLevelDb', noiseLevelDb)
          ..add('operationalStatus', operationalStatus)
          ..add('pressureBar', pressureBar)
          ..add('priorityLevel', priorityLevel)
          ..add('recommendations', recommendations)
          ..add('recordedAt', recordedAt)
          ..add('recordedBy', recordedBy)
          ..add('temperatureC', temperatureC)
          ..add('vibrationObservation', vibrationObservation))
        .toString();
  }
}

class ReadingsResponseBuilder
    implements Builder<ReadingsResponse, ReadingsResponseBuilder> {
  _$ReadingsResponse? _$v;

  String? _comments;
  String? get comments => _$this._comments;
  set comments(String? comments) => _$this._comments = comments;

  ReadingsResponseConditionEnum? _condition;
  ReadingsResponseConditionEnum? get condition => _$this._condition;
  set condition(ReadingsResponseConditionEnum? condition) =>
      _$this._condition = condition;

  bool? _leakObserved;
  bool? get leakObserved => _$this._leakObserved;
  set leakObserved(bool? leakObserved) => _$this._leakObserved = leakObserved;

  num? _noiseLevelDb;
  num? get noiseLevelDb => _$this._noiseLevelDb;
  set noiseLevelDb(num? noiseLevelDb) => _$this._noiseLevelDb = noiseLevelDb;

  ReadingsResponseOperationalStatusEnum? _operationalStatus;
  ReadingsResponseOperationalStatusEnum? get operationalStatus =>
      _$this._operationalStatus;
  set operationalStatus(
          ReadingsResponseOperationalStatusEnum? operationalStatus) =>
      _$this._operationalStatus = operationalStatus;

  num? _pressureBar;
  num? get pressureBar => _$this._pressureBar;
  set pressureBar(num? pressureBar) => _$this._pressureBar = pressureBar;

  ReadingsResponsePriorityLevelEnum? _priorityLevel;
  ReadingsResponsePriorityLevelEnum? get priorityLevel => _$this._priorityLevel;
  set priorityLevel(ReadingsResponsePriorityLevelEnum? priorityLevel) =>
      _$this._priorityLevel = priorityLevel;

  String? _recommendations;
  String? get recommendations => _$this._recommendations;
  set recommendations(String? recommendations) =>
      _$this._recommendations = recommendations;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  String? _recordedBy;
  String? get recordedBy => _$this._recordedBy;
  set recordedBy(String? recordedBy) => _$this._recordedBy = recordedBy;

  num? _temperatureC;
  num? get temperatureC => _$this._temperatureC;
  set temperatureC(num? temperatureC) => _$this._temperatureC = temperatureC;

  String? _vibrationObservation;
  String? get vibrationObservation => _$this._vibrationObservation;
  set vibrationObservation(String? vibrationObservation) =>
      _$this._vibrationObservation = vibrationObservation;

  ReadingsResponseBuilder() {
    ReadingsResponse._defaults(this);
  }

  ReadingsResponseBuilder get _$this {
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
      _recordedAt = $v.recordedAt;
      _recordedBy = $v.recordedBy;
      _temperatureC = $v.temperatureC;
      _vibrationObservation = $v.vibrationObservation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReadingsResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ReadingsResponse;
  }

  @override
  void update(void Function(ReadingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReadingsResponse build() => _build();

  _$ReadingsResponse _build() {
    final _$result = _$v ??
        new _$ReadingsResponse._(
            comments: comments,
            condition: BuiltValueNullFieldError.checkNotNull(
                condition, r'ReadingsResponse', 'condition'),
            leakObserved: leakObserved,
            noiseLevelDb: noiseLevelDb,
            operationalStatus: operationalStatus,
            pressureBar: pressureBar,
            priorityLevel: priorityLevel,
            recommendations: recommendations,
            recordedAt: recordedAt,
            recordedBy: recordedBy,
            temperatureC: temperatureC,
            vibrationObservation: vibrationObservation);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
