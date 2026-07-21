// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoleSummary extends RoleSummary {
  @override
  final String id;
  @override
  final bool isSystem;
  @override
  final String key;
  @override
  final String name;

  factory _$RoleSummary([void Function(RoleSummaryBuilder)? updates]) =>
      (new RoleSummaryBuilder()..update(updates))._build();

  _$RoleSummary._(
      {required this.id,
      required this.isSystem,
      required this.key,
      required this.name})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'RoleSummary', 'id');
    BuiltValueNullFieldError.checkNotNull(isSystem, r'RoleSummary', 'isSystem');
    BuiltValueNullFieldError.checkNotNull(key, r'RoleSummary', 'key');
    BuiltValueNullFieldError.checkNotNull(name, r'RoleSummary', 'name');
  }

  @override
  RoleSummary rebuild(void Function(RoleSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoleSummaryBuilder toBuilder() => new RoleSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoleSummary &&
        id == other.id &&
        isSystem == other.isSystem &&
        key == other.key &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, isSystem.hashCode);
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoleSummary')
          ..add('id', id)
          ..add('isSystem', isSystem)
          ..add('key', key)
          ..add('name', name))
        .toString();
  }
}

class RoleSummaryBuilder implements Builder<RoleSummary, RoleSummaryBuilder> {
  _$RoleSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  bool? _isSystem;
  bool? get isSystem => _$this._isSystem;
  set isSystem(bool? isSystem) => _$this._isSystem = isSystem;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  RoleSummaryBuilder() {
    RoleSummary._defaults(this);
  }

  RoleSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _isSystem = $v.isSystem;
      _key = $v.key;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoleSummary other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RoleSummary;
  }

  @override
  void update(void Function(RoleSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoleSummary build() => _build();

  _$RoleSummary _build() {
    final _$result = _$v ??
        new _$RoleSummary._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'RoleSummary', 'id'),
            isSystem: BuiltValueNullFieldError.checkNotNull(
                isSystem, r'RoleSummary', 'isSystem'),
            key: BuiltValueNullFieldError.checkNotNull(
                key, r'RoleSummary', 'key'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'RoleSummary', 'name'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
