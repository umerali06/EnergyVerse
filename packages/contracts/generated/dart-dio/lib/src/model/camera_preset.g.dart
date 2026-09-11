// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_preset.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CameraPreset extends CameraPreset {
  @override
  final String id;
  @override
  final String name;
  @override
  final BuiltList<num> position;
  @override
  final BuiltList<num> target;

  factory _$CameraPreset([void Function(CameraPresetBuilder)? updates]) =>
      (new CameraPresetBuilder()..update(updates))._build();

  _$CameraPreset._(
      {required this.id,
      required this.name,
      required this.position,
      required this.target})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'CameraPreset', 'id');
    BuiltValueNullFieldError.checkNotNull(name, r'CameraPreset', 'name');
    BuiltValueNullFieldError.checkNotNull(
        position, r'CameraPreset', 'position');
    BuiltValueNullFieldError.checkNotNull(target, r'CameraPreset', 'target');
  }

  @override
  CameraPreset rebuild(void Function(CameraPresetBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CameraPresetBuilder toBuilder() => new CameraPresetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CameraPreset &&
        id == other.id &&
        name == other.name &&
        position == other.position &&
        target == other.target;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, target.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CameraPreset')
          ..add('id', id)
          ..add('name', name)
          ..add('position', position)
          ..add('target', target))
        .toString();
  }
}

class CameraPresetBuilder
    implements Builder<CameraPreset, CameraPresetBuilder> {
  _$CameraPreset? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ListBuilder<num>? _position;
  ListBuilder<num> get position => _$this._position ??= new ListBuilder<num>();
  set position(ListBuilder<num>? position) => _$this._position = position;

  ListBuilder<num>? _target;
  ListBuilder<num> get target => _$this._target ??= new ListBuilder<num>();
  set target(ListBuilder<num>? target) => _$this._target = target;

  CameraPresetBuilder() {
    CameraPreset._defaults(this);
  }

  CameraPresetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _position = $v.position.toBuilder();
      _target = $v.target.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CameraPreset other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CameraPreset;
  }

  @override
  void update(void Function(CameraPresetBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CameraPreset build() => _build();

  _$CameraPreset _build() {
    _$CameraPreset _$result;
    try {
      _$result = _$v ??
          new _$CameraPreset._(
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'CameraPreset', 'id'),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'CameraPreset', 'name'),
              position: position.build(),
              target: target.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'position';
        position.build();
        _$failedField = 'target';
        target.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CameraPreset', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
