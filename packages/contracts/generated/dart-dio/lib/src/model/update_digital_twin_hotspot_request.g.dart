// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_digital_twin_hotspot_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateDigitalTwinHotspotRequest
    extends UpdateDigitalTwinHotspotRequest {
  @override
  final String assetId;
  @override
  final String id;
  @override
  final String? label;
  @override
  final BuiltList<num> position;
  @override
  final num? radius;

  factory _$UpdateDigitalTwinHotspotRequest(
          [void Function(UpdateDigitalTwinHotspotRequestBuilder)? updates]) =>
      (new UpdateDigitalTwinHotspotRequestBuilder()..update(updates))._build();

  _$UpdateDigitalTwinHotspotRequest._(
      {required this.assetId,
      required this.id,
      this.label,
      required this.position,
      this.radius})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        assetId, r'UpdateDigitalTwinHotspotRequest', 'assetId');
    BuiltValueNullFieldError.checkNotNull(
        id, r'UpdateDigitalTwinHotspotRequest', 'id');
    BuiltValueNullFieldError.checkNotNull(
        position, r'UpdateDigitalTwinHotspotRequest', 'position');
  }

  @override
  UpdateDigitalTwinHotspotRequest rebuild(
          void Function(UpdateDigitalTwinHotspotRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateDigitalTwinHotspotRequestBuilder toBuilder() =>
      new UpdateDigitalTwinHotspotRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateDigitalTwinHotspotRequest &&
        assetId == other.assetId &&
        id == other.id &&
        label == other.label &&
        position == other.position &&
        radius == other.radius;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, radius.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateDigitalTwinHotspotRequest')
          ..add('assetId', assetId)
          ..add('id', id)
          ..add('label', label)
          ..add('position', position)
          ..add('radius', radius))
        .toString();
  }
}

class UpdateDigitalTwinHotspotRequestBuilder
    implements
        Builder<UpdateDigitalTwinHotspotRequest,
            UpdateDigitalTwinHotspotRequestBuilder> {
  _$UpdateDigitalTwinHotspotRequest? _$v;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

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

  UpdateDigitalTwinHotspotRequestBuilder() {
    UpdateDigitalTwinHotspotRequest._defaults(this);
  }

  UpdateDigitalTwinHotspotRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assetId = $v.assetId;
      _id = $v.id;
      _label = $v.label;
      _position = $v.position.toBuilder();
      _radius = $v.radius;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateDigitalTwinHotspotRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateDigitalTwinHotspotRequest;
  }

  @override
  void update(void Function(UpdateDigitalTwinHotspotRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateDigitalTwinHotspotRequest build() => _build();

  _$UpdateDigitalTwinHotspotRequest _build() {
    _$UpdateDigitalTwinHotspotRequest _$result;
    try {
      _$result = _$v ??
          new _$UpdateDigitalTwinHotspotRequest._(
              assetId: BuiltValueNullFieldError.checkNotNull(
                  assetId, r'UpdateDigitalTwinHotspotRequest', 'assetId'),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'UpdateDigitalTwinHotspotRequest', 'id'),
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
            r'UpdateDigitalTwinHotspotRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
