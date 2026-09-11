// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_digital_twin_scene_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateDigitalTwinSceneRequest extends UpdateDigitalTwinSceneRequest {
  @override
  final BuiltList<CameraPreset>? cameraPresets;
  @override
  final BuiltList<UpdateDigitalTwinHotspotRequest>? hotspots;
  @override
  final String? model3dUrl;
  @override
  final String? sceneType;

  factory _$UpdateDigitalTwinSceneRequest(
          [void Function(UpdateDigitalTwinSceneRequestBuilder)? updates]) =>
      (new UpdateDigitalTwinSceneRequestBuilder()..update(updates))._build();

  _$UpdateDigitalTwinSceneRequest._(
      {this.cameraPresets, this.hotspots, this.model3dUrl, this.sceneType})
      : super._();

  @override
  UpdateDigitalTwinSceneRequest rebuild(
          void Function(UpdateDigitalTwinSceneRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateDigitalTwinSceneRequestBuilder toBuilder() =>
      new UpdateDigitalTwinSceneRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateDigitalTwinSceneRequest &&
        cameraPresets == other.cameraPresets &&
        hotspots == other.hotspots &&
        model3dUrl == other.model3dUrl &&
        sceneType == other.sceneType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cameraPresets.hashCode);
    _$hash = $jc(_$hash, hotspots.hashCode);
    _$hash = $jc(_$hash, model3dUrl.hashCode);
    _$hash = $jc(_$hash, sceneType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateDigitalTwinSceneRequest')
          ..add('cameraPresets', cameraPresets)
          ..add('hotspots', hotspots)
          ..add('model3dUrl', model3dUrl)
          ..add('sceneType', sceneType))
        .toString();
  }
}

class UpdateDigitalTwinSceneRequestBuilder
    implements
        Builder<UpdateDigitalTwinSceneRequest,
            UpdateDigitalTwinSceneRequestBuilder> {
  _$UpdateDigitalTwinSceneRequest? _$v;

  ListBuilder<CameraPreset>? _cameraPresets;
  ListBuilder<CameraPreset> get cameraPresets =>
      _$this._cameraPresets ??= new ListBuilder<CameraPreset>();
  set cameraPresets(ListBuilder<CameraPreset>? cameraPresets) =>
      _$this._cameraPresets = cameraPresets;

  ListBuilder<UpdateDigitalTwinHotspotRequest>? _hotspots;
  ListBuilder<UpdateDigitalTwinHotspotRequest> get hotspots =>
      _$this._hotspots ??= new ListBuilder<UpdateDigitalTwinHotspotRequest>();
  set hotspots(ListBuilder<UpdateDigitalTwinHotspotRequest>? hotspots) =>
      _$this._hotspots = hotspots;

  String? _model3dUrl;
  String? get model3dUrl => _$this._model3dUrl;
  set model3dUrl(String? model3dUrl) => _$this._model3dUrl = model3dUrl;

  String? _sceneType;
  String? get sceneType => _$this._sceneType;
  set sceneType(String? sceneType) => _$this._sceneType = sceneType;

  UpdateDigitalTwinSceneRequestBuilder() {
    UpdateDigitalTwinSceneRequest._defaults(this);
  }

  UpdateDigitalTwinSceneRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cameraPresets = $v.cameraPresets?.toBuilder();
      _hotspots = $v.hotspots?.toBuilder();
      _model3dUrl = $v.model3dUrl;
      _sceneType = $v.sceneType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateDigitalTwinSceneRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateDigitalTwinSceneRequest;
  }

  @override
  void update(void Function(UpdateDigitalTwinSceneRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateDigitalTwinSceneRequest build() => _build();

  _$UpdateDigitalTwinSceneRequest _build() {
    _$UpdateDigitalTwinSceneRequest _$result;
    try {
      _$result = _$v ??
          new _$UpdateDigitalTwinSceneRequest._(
              cameraPresets: _cameraPresets?.build(),
              hotspots: _hotspots?.build(),
              model3dUrl: model3dUrl,
              sceneType: sceneType);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'cameraPresets';
        _cameraPresets?.build();
        _$failedField = 'hotspots';
        _hotspots?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UpdateDigitalTwinSceneRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
