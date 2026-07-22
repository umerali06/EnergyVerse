// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoleSummary extends RoleSummary {
  @override
  final int assignedUserCount;
  @override
  final String description;
  @override
  final String id;
  @override
  final bool isSystem;
  @override
  final String key;
  @override
  final String name;
  @override
  final int permissionCount;

  factory _$RoleSummary([void Function(RoleSummaryBuilder)? updates]) =>
      (new RoleSummaryBuilder()..update(updates))._build();

  _$RoleSummary._(
      {required this.assignedUserCount,
      required this.description,
      required this.id,
      required this.isSystem,
      required this.key,
      required this.name,
      required this.permissionCount})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        assignedUserCount, r'RoleSummary', 'assignedUserCount');
    BuiltValueNullFieldError.checkNotNull(
        description, r'RoleSummary', 'description');
    BuiltValueNullFieldError.checkNotNull(id, r'RoleSummary', 'id');
    BuiltValueNullFieldError.checkNotNull(isSystem, r'RoleSummary', 'isSystem');
    BuiltValueNullFieldError.checkNotNull(key, r'RoleSummary', 'key');
    BuiltValueNullFieldError.checkNotNull(name, r'RoleSummary', 'name');
    BuiltValueNullFieldError.checkNotNull(
        permissionCount, r'RoleSummary', 'permissionCount');
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
        assignedUserCount == other.assignedUserCount &&
        description == other.description &&
        id == other.id &&
        isSystem == other.isSystem &&
        key == other.key &&
        name == other.name &&
        permissionCount == other.permissionCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assignedUserCount.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, isSystem.hashCode);
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, permissionCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoleSummary')
          ..add('assignedUserCount', assignedUserCount)
          ..add('description', description)
          ..add('id', id)
          ..add('isSystem', isSystem)
          ..add('key', key)
          ..add('name', name)
          ..add('permissionCount', permissionCount))
        .toString();
  }
}

class RoleSummaryBuilder implements Builder<RoleSummary, RoleSummaryBuilder> {
  _$RoleSummary? _$v;

  int? _assignedUserCount;
  int? get assignedUserCount => _$this._assignedUserCount;
  set assignedUserCount(int? assignedUserCount) =>
      _$this._assignedUserCount = assignedUserCount;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

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

  int? _permissionCount;
  int? get permissionCount => _$this._permissionCount;
  set permissionCount(int? permissionCount) =>
      _$this._permissionCount = permissionCount;

  RoleSummaryBuilder() {
    RoleSummary._defaults(this);
  }

  RoleSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assignedUserCount = $v.assignedUserCount;
      _description = $v.description;
      _id = $v.id;
      _isSystem = $v.isSystem;
      _key = $v.key;
      _name = $v.name;
      _permissionCount = $v.permissionCount;
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
            assignedUserCount: BuiltValueNullFieldError.checkNotNull(
                assignedUserCount, r'RoleSummary', 'assignedUserCount'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'RoleSummary', 'description'),
            id: BuiltValueNullFieldError.checkNotNull(id, r'RoleSummary', 'id'),
            isSystem: BuiltValueNullFieldError.checkNotNull(
                isSystem, r'RoleSummary', 'isSystem'),
            key: BuiltValueNullFieldError.checkNotNull(
                key, r'RoleSummary', 'key'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'RoleSummary', 'name'),
            permissionCount: BuiltValueNullFieldError.checkNotNull(
                permissionCount, r'RoleSummary', 'permissionCount'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
