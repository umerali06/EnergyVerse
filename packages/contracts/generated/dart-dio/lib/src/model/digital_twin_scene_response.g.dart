// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_twin_scene_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DigitalTwinSceneResponse extends DigitalTwinSceneResponse {
  @override
  final BuiltList<CameraPreset>? cameraPresets;
  @override
  final String facilityId;
  @override
  final String facilityName;
  @override
  final BuiltList<DigitalTwinHotspotResponse>? hotspots;
  @override
  final String? model3dUrl;
  @override
  final String? sceneType;
  @override
  final DateTime updatedAt;

  factory _$DigitalTwinSceneResponse(
          [void Function(DigitalTwinSceneResponseBuilder)? updates]) =>
      (new DigitalTwinSceneResponseBuilder()..update(updates))._build();

  _$DigitalTwinSceneResponse._(
      {this.cameraPresets,
      required this.facilityId,
      required this.facilityName,
      this.hotspots,
      this.model3dUrl,
      this.sceneType,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        facilityId, r'DigitalTwinSceneResponse', 'facilityId');
    BuiltValueNullFieldError.checkNotNull(
        facilityName, r'DigitalTwinSceneResponse', 'facilityName');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'DigitalTwinSceneResponse', 'updatedAt');
  }

  @override
  DigitalTwinSceneResponse rebuild(
          void Function(DigitalTwinSceneResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DigitalTwinSceneResponseBuilder toBuilder() =>
      new DigitalTwinSceneResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DigitalTwinSceneResponse &&
        cameraPresets == other.cameraPresets &&
        facilityId == other.facilityId &&
        facilityName == other.facilityName &&
        hotspots == other.hotspots &&
        model3dUrl == other.model3dUrl &&
        sceneType == other.sceneType &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cameraPresets.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, facilityName.hashCode);
    _$hash = $jc(_$hash, hotspots.hashCode);
    _$hash = $jc(_$hash, model3dUrl.hashCode);
    _$hash = $jc(_$hash, sceneType.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DigitalTwinSceneResponse')
          ..add('cameraPresets', cameraPresets)
          ..add('facilityId', facilityId)
          ..add('facilityName', facilityName)
          ..add('hotspots', hotspots)
          ..add('model3dUrl', model3dUrl)
          ..add('sceneType', sceneType)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class DigitalTwinSceneResponseBuilder
    implements
        Builder<DigitalTwinSceneResponse, DigitalTwinSceneResponseBuilder> {
  _$DigitalTwinSceneResponse? _$v;

  ListBuilder<CameraPreset>? _cameraPresets;
  ListBuilder<CameraPreset> get cameraPresets =>
      _$this._cameraPresets ??= new ListBuilder<CameraPreset>();
  set cameraPresets(ListBuilder<CameraPreset>? cameraPresets) =>
      _$this._cameraPresets = cameraPresets;

  String? _facilityId;
  String? get facilityId => _$this._facilityId;
  set facilityId(String? facilityId) => _$this._facilityId = facilityId;

  String? _facilityName;
  String? get facilityName => _$this._facilityName;
  set facilityName(String? facilityName) => _$this._facilityName = facilityName;

  ListBuilder<DigitalTwinHotspotResponse>? _hotspots;
  ListBuilder<DigitalTwinHotspotResponse> get hotspots =>
      _$this._hotspots ??= new ListBuilder<DigitalTwinHotspotResponse>();
  set hotspots(ListBuilder<DigitalTwinHotspotResponse>? hotspots) =>
      _$this._hotspots = hotspots;

  String? _model3dUrl;
  String? get model3dUrl => _$this._model3dUrl;
  set model3dUrl(String? model3dUrl) => _$this._model3dUrl = model3dUrl;

  String? _sceneType;
  String? get sceneType => _$this._sceneType;
  set sceneType(String? sceneType) => _$this._sceneType = sceneType;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  DigitalTwinSceneResponseBuilder() {
    DigitalTwinSceneResponse._defaults(this);
  }

  DigitalTwinSceneResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cameraPresets = $v.cameraPresets?.toBuilder();
      _facilityId = $v.facilityId;
      _facilityName = $v.facilityName;
      _hotspots = $v.hotspots?.toBuilder();
      _model3dUrl = $v.model3dUrl;
      _sceneType = $v.sceneType;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DigitalTwinSceneResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DigitalTwinSceneResponse;
  }

  @override
  void update(void Function(DigitalTwinSceneResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DigitalTwinSceneResponse build() => _build();

  _$DigitalTwinSceneResponse _build() {
    _$DigitalTwinSceneResponse _$result;
    try {
      _$result = _$v ??
          new _$DigitalTwinSceneResponse._(
              cameraPresets: _cameraPresets?.build(),
              facilityId: BuiltValueNullFieldError.checkNotNull(
                  facilityId, r'DigitalTwinSceneResponse', 'facilityId'),
              facilityName: BuiltValueNullFieldError.checkNotNull(
                  facilityName, r'DigitalTwinSceneResponse', 'facilityName'),
              hotspots: _hotspots?.build(),
              model3dUrl: model3dUrl,
              sceneType: sceneType,
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, r'DigitalTwinSceneResponse', 'updatedAt'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'cameraPresets';
        _cameraPresets?.build();

        _$failedField = 'hotspots';
        _hotspots?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'DigitalTwinSceneResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
