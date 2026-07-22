// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoleDetail extends RoleDetail {
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
  final BuiltList<String> permissionKeys;

  factory _$RoleDetail([void Function(RoleDetailBuilder)? updates]) =>
      (new RoleDetailBuilder()..update(updates))._build();

  _$RoleDetail._(
      {required this.assignedUserCount,
      required this.description,
      required this.id,
      required this.isSystem,
      required this.key,
      required this.name,
      required this.permissionKeys})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        assignedUserCount, r'RoleDetail', 'assignedUserCount');
    BuiltValueNullFieldError.checkNotNull(
        description, r'RoleDetail', 'description');
    BuiltValueNullFieldError.checkNotNull(id, r'RoleDetail', 'id');
    BuiltValueNullFieldError.checkNotNull(isSystem, r'RoleDetail', 'isSystem');
    BuiltValueNullFieldError.checkNotNull(key, r'RoleDetail', 'key');
    BuiltValueNullFieldError.checkNotNull(name, r'RoleDetail', 'name');
    BuiltValueNullFieldError.checkNotNull(
        permissionKeys, r'RoleDetail', 'permissionKeys');
  }

  @override
  RoleDetail rebuild(void Function(RoleDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoleDetailBuilder toBuilder() => new RoleDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoleDetail &&
        assignedUserCount == other.assignedUserCount &&
        description == other.description &&
        id == other.id &&
        isSystem == other.isSystem &&
        key == other.key &&
        name == other.name &&
        permissionKeys == other.permissionKeys;
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
    _$hash = $jc(_$hash, permissionKeys.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoleDetail')
          ..add('assignedUserCount', assignedUserCount)
          ..add('description', description)
          ..add('id', id)
          ..add('isSystem', isSystem)
          ..add('key', key)
          ..add('name', name)
          ..add('permissionKeys', permissionKeys))
        .toString();
  }
}

class RoleDetailBuilder implements Builder<RoleDetail, RoleDetailBuilder> {
  _$RoleDetail? _$v;

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

  ListBuilder<String>? _permissionKeys;
  ListBuilder<String> get permissionKeys =>
      _$this._permissionKeys ??= new ListBuilder<String>();
  set permissionKeys(ListBuilder<String>? permissionKeys) =>
      _$this._permissionKeys = permissionKeys;

  RoleDetailBuilder() {
    RoleDetail._defaults(this);
  }

  RoleDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assignedUserCount = $v.assignedUserCount;
      _description = $v.description;
      _id = $v.id;
      _isSystem = $v.isSystem;
      _key = $v.key;
      _name = $v.name;
      _permissionKeys = $v.permissionKeys.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoleDetail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RoleDetail;
  }

  @override
  void update(void Function(RoleDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoleDetail build() => _build();

  _$RoleDetail _build() {
    _$RoleDetail _$result;
    try {
      _$result = _$v ??
          new _$RoleDetail._(
              assignedUserCount: BuiltValueNullFieldError.checkNotNull(
                  assignedUserCount, r'RoleDetail', 'assignedUserCount'),
              description: BuiltValueNullFieldError.checkNotNull(
                  description, r'RoleDetail', 'description'),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'RoleDetail', 'id'),
              isSystem: BuiltValueNullFieldError.checkNotNull(
                  isSystem, r'RoleDetail', 'isSystem'),
              key: BuiltValueNullFieldError.checkNotNull(
                  key, r'RoleDetail', 'key'),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'RoleDetail', 'name'),
              permissionKeys: permissionKeys.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissionKeys';
        permissionKeys.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'RoleDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
