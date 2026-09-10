// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_twin_hotspot_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DigitalTwinHotspotResponseCurrentStatusEnum
    _$digitalTwinHotspotResponseCurrentStatusEnum_healthy =
    const DigitalTwinHotspotResponseCurrentStatusEnum._('healthy');
const DigitalTwinHotspotResponseCurrentStatusEnum
    _$digitalTwinHotspotResponseCurrentStatusEnum_warning =
    const DigitalTwinHotspotResponseCurrentStatusEnum._('warning');
const DigitalTwinHotspotResponseCurrentStatusEnum
    _$digitalTwinHotspotResponseCurrentStatusEnum_critical =
    const DigitalTwinHotspotResponseCurrentStatusEnum._('critical');

DigitalTwinHotspotResponseCurrentStatusEnum
    _$digitalTwinHotspotResponseCurrentStatusEnumValueOf(String name) {
  switch (name) {
    case 'healthy':
      return _$digitalTwinHotspotResponseCurrentStatusEnum_healthy;
    case 'warning':
      return _$digitalTwinHotspotResponseCurrentStatusEnum_warning;
    case 'critical':
      return _$digitalTwinHotspotResponseCurrentStatusEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<DigitalTwinHotspotResponseCurrentStatusEnum>
    _$digitalTwinHotspotResponseCurrentStatusEnumValues = new BuiltSet<
        DigitalTwinHotspotResponseCurrentStatusEnum>(const <DigitalTwinHotspotResponseCurrentStatusEnum>[
  _$digitalTwinHotspotResponseCurrentStatusEnum_healthy,
  _$digitalTwinHotspotResponseCurrentStatusEnum_warning,
  _$digitalTwinHotspotResponseCurrentStatusEnum_critical,
]);

Serializer<DigitalTwinHotspotResponseCurrentStatusEnum>
    _$digitalTwinHotspotResponseCurrentStatusEnumSerializer =
    new _$DigitalTwinHotspotResponseCurrentStatusEnumSerializer();

class _$DigitalTwinHotspotResponseCurrentStatusEnumSerializer
    implements
        PrimitiveSerializer<DigitalTwinHotspotResponseCurrentStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'healthy': 'Healthy',
    'warning': 'Warning',
    'critical': 'Critical',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Healthy': 'healthy',
    'Warning': 'warning',
    'Critical': 'critical',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DigitalTwinHotspotResponseCurrentStatusEnum
  ];
  @override
  final String wireName = 'DigitalTwinHotspotResponseCurrentStatusEnum';

  @override
  Object serialize(Serializers serializers,
          DigitalTwinHotspotResponseCurrentStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DigitalTwinHotspotResponseCurrentStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DigitalTwinHotspotResponseCurrentStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DigitalTwinHotspotResponse extends DigitalTwinHotspotResponse {
  @override
  final String assetId;
  @override
  final String assetName;
  @override
  final String assetTag;
  @override
  final String category;
  @override
  final DigitalTwinHotspotResponseCurrentStatusEnum currentStatus;
  @override
  final String id;
  @override
  final String? label;
  @override
  final BuiltList<num> position;
  @override
  final num? radius;

  factory _$DigitalTwinHotspotResponse(
          [void Function(DigitalTwinHotspotResponseBuilder)? updates]) =>
      (new DigitalTwinHotspotResponseBuilder()..update(updates))._build();

  _$DigitalTwinHotspotResponse._(
      {required this.assetId,
      required this.assetName,
      required this.assetTag,
      required this.category,
      required this.currentStatus,
      required this.id,
      this.label,
      required this.position,
      this.radius})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        assetId, r'DigitalTwinHotspotResponse', 'assetId');
    BuiltValueNullFieldError.checkNotNull(
        assetName, r'DigitalTwinHotspotResponse', 'assetName');
    BuiltValueNullFieldError.checkNotNull(
        assetTag, r'DigitalTwinHotspotResponse', 'assetTag');
    BuiltValueNullFieldError.checkNotNull(
        category, r'DigitalTwinHotspotResponse', 'category');
    BuiltValueNullFieldError.checkNotNull(
        currentStatus, r'DigitalTwinHotspotResponse', 'currentStatus');
    BuiltValueNullFieldError.checkNotNull(
        id, r'DigitalTwinHotspotResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        position, r'DigitalTwinHotspotResponse', 'position');
  }

  @override
  DigitalTwinHotspotResponse rebuild(
          void Function(DigitalTwinHotspotResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DigitalTwinHotspotResponseBuilder toBuilder() =>
      new DigitalTwinHotspotResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DigitalTwinHotspotResponse &&
        assetId == other.assetId &&
        assetName == other.assetName &&
        assetTag == other.assetTag &&
        category == other.category &&
        currentStatus == other.currentStatus &&
        id == other.id &&
        label == other.label &&
        position == other.position &&
        radius == other.radius;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, assetName.hashCode);
    _$hash = $jc(_$hash, assetTag.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, currentStatus.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, radius.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DigitalTwinHotspotResponse')
          ..add('assetId', assetId)
          ..add('assetName', assetName)
          ..add('assetTag', assetTag)
          ..add('category', category)
          ..add('currentStatus', currentStatus)
          ..add('id', id)
          ..add('label', label)
          ..add('position', position)
          ..add('radius', radius))
        .toString();
  }
}

class DigitalTwinHotspotResponseBuilder
    implements
        Builder<DigitalTwinHotspotResponse, DigitalTwinHotspotResponseBuilder> {
  _$DigitalTwinHotspotResponse? _$v;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  String? _assetName;
  String? get assetName => _$this._assetName;
  set assetName(String? assetName) => _$this._assetName = assetName;

  String? _assetTag;
  String? get assetTag => _$this._assetTag;
  set assetTag(String? assetTag) => _$this._assetTag = assetTag;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  DigitalTwinHotspotResponseCurrentStatusEnum? _currentStatus;
  DigitalTwinHotspotResponseCurrentStatusEnum? get currentStatus =>
      _$this._currentStatus;
  set currentStatus(
          DigitalTwinHotspotResponseCurrentStatusEnum? currentStatus) =>
      _$this._currentStatus = currentStatus;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  ListBuilder<num>? _position;
  ListBuilder<num> get position => _$this._position ??= new ListBuilder<num>();
  set position(ListBuilder<num>? position) => _$this._position = position;

  num? _radius;
  num? get radius => _$this._radius;
  set radius(num? radius) => _$this._radius = radius;

  DigitalTwinHotspotResponseBuilder() {
    DigitalTwinHotspotResponse._defaults(this);
  }

  DigitalTwinHotspotResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assetId = $v.assetId;
      _assetName = $v.assetName;
      _assetTag = $v.assetTag;
      _category = $v.category;
      _currentStatus = $v.currentStatus;
      _id = $v.id;
      _label = $v.label;
      _position = $v.position.toBuilder();
      _radius = $v.radius;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DigitalTwinHotspotResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DigitalTwinHotspotResponse;
  }

  @override
  void update(void Function(DigitalTwinHotspotResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DigitalTwinHotspotResponse build() => _build();

  _$DigitalTwinHotspotResponse _build() {
    _$DigitalTwinHotspotResponse _$result;
    try {
      _$result = _$v ??
          new _$DigitalTwinHotspotResponse._(
              assetId: BuiltValueNullFieldError.checkNotNull(
                  assetId, r'DigitalTwinHotspotResponse', 'assetId'),
              assetName: BuiltValueNullFieldError.checkNotNull(
                  assetName, r'DigitalTwinHotspotResponse', 'assetName'),
              assetTag: BuiltValueNullFieldError.checkNotNull(
                  assetTag, r'DigitalTwinHotspotResponse', 'assetTag'),
              category: BuiltValueNullFieldError.checkNotNull(
                  category, r'DigitalTwinHotspotResponse', 'category'),
              currentStatus: BuiltValueNullFieldError.checkNotNull(
                  currentStatus,
                  r'DigitalTwinHotspotResponse',
                  'currentStatus'),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'DigitalTwinHotspotResponse', 'id'),
              label: label,
              position: position.build(),
              radius: radius);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'position';
        position.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'DigitalTwinHotspotResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
