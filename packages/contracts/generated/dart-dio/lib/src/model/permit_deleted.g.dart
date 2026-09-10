// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_deleted.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermitDeleted extends PermitDeleted {
  @override
  final bool? deleted;
  @override
  final String id;

  factory _$PermitDeleted([void Function(PermitDeletedBuilder)? updates]) =>
      (new PermitDeletedBuilder()..update(updates))._build();

  _$PermitDeleted._({this.deleted, required this.id}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'PermitDeleted', 'id');
  }

  @override
  PermitDeleted rebuild(void Function(PermitDeletedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitDeletedBuilder toBuilder() => new PermitDeletedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitDeleted && deleted == other.deleted && id == other.id;
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
    return (newBuiltValueToStringHelper(r'PermitDeleted')
          ..add('deleted', deleted)
          ..add('id', id))
        .toString();
  }
}

class PermitDeletedBuilder
    implements Builder<PermitDeleted, PermitDeletedBuilder> {
  _$PermitDeleted? _$v;

  bool? _deleted;
  bool? get deleted => _$this._deleted;
  set deleted(bool? deleted) => _$this._deleted = deleted;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  PermitDeletedBuilder() {
    PermitDeleted._defaults(this);
  }

  PermitDeletedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deleted = $v.deleted;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitDeleted other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitDeleted;
  }

  @override
  void update(void Function(PermitDeletedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitDeleted build() => _build();

  _$PermitDeleted _build() {
    final _$result = _$v ??
        new _$PermitDeleted._(
            deleted: deleted,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PermitDeleted', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
