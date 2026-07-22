// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_deleted.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AreaDeleted extends AreaDeleted {
  @override
  final bool? deleted;
  @override
  final String id;

  factory _$AreaDeleted([void Function(AreaDeletedBuilder)? updates]) =>
      (new AreaDeletedBuilder()..update(updates))._build();

  _$AreaDeleted._({this.deleted, required this.id}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'AreaDeleted', 'id');
  }

  @override
  AreaDeleted rebuild(void Function(AreaDeletedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AreaDeletedBuilder toBuilder() => new AreaDeletedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AreaDeleted && deleted == other.deleted && id == other.id;
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
    return (newBuiltValueToStringHelper(r'AreaDeleted')
          ..add('deleted', deleted)
          ..add('id', id))
        .toString();
  }
}

class AreaDeletedBuilder implements Builder<AreaDeleted, AreaDeletedBuilder> {
  _$AreaDeleted? _$v;

  bool? _deleted;
  bool? get deleted => _$this._deleted;
  set deleted(bool? deleted) => _$this._deleted = deleted;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AreaDeletedBuilder() {
    AreaDeleted._defaults(this);
  }

  AreaDeletedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deleted = $v.deleted;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AreaDeleted other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AreaDeleted;
  }

  @override
  void update(void Function(AreaDeletedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AreaDeleted build() => _build();

  _$AreaDeleted _build() {
    final _$result = _$v ??
        new _$AreaDeleted._(
            deleted: deleted,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AreaDeleted', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
