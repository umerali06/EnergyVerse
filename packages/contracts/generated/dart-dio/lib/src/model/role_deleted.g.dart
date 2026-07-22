// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_deleted.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoleDeleted extends RoleDeleted {
  @override
  final bool? deleted;
  @override
  final String id;

  factory _$RoleDeleted([void Function(RoleDeletedBuilder)? updates]) =>
      (new RoleDeletedBuilder()..update(updates))._build();

  _$RoleDeleted._({this.deleted, required this.id}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'RoleDeleted', 'id');
  }

  @override
  RoleDeleted rebuild(void Function(RoleDeletedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoleDeletedBuilder toBuilder() => new RoleDeletedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoleDeleted && deleted == other.deleted && id == other.id;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, deleted.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoleDeleted')
          ..add('deleted', deleted)
          ..add('id', id))
        .toString();
  }
}

class RoleDeletedBuilder implements Builder<RoleDeleted, RoleDeletedBuilder> {
  _$RoleDeleted? _$v;

  bool? _deleted;
  bool? get deleted => _$this._deleted;
  set deleted(bool? deleted) => _$this._deleted = deleted;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  RoleDeletedBuilder() {
    RoleDeleted._defaults(this);
  }

  RoleDeletedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deleted = $v.deleted;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoleDeleted other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RoleDeleted;
  }

  @override
  void update(void Function(RoleDeletedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoleDeleted build() => _build();

  _$RoleDeleted _build() {
    final _$result = _$v ??
        new _$RoleDeleted._(
            deleted: deleted,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'RoleDeleted', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
