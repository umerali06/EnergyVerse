// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_deleted.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FacilityDeleted extends FacilityDeleted {
  @override
  final bool? deleted;
  @override
  final String id;

  factory _$FacilityDeleted([void Function(FacilityDeletedBuilder)? updates]) =>
      (new FacilityDeletedBuilder()..update(updates))._build();

  _$FacilityDeleted._({this.deleted, required this.id}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'FacilityDeleted', 'id');
  }

  @override
  FacilityDeleted rebuild(void Function(FacilityDeletedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FacilityDeletedBuilder toBuilder() =>
      new FacilityDeletedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FacilityDeleted &&
        deleted == other.deleted &&
        id == other.id;
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
    return (newBuiltValueToStringHelper(r'FacilityDeleted')
          ..add('deleted', deleted)
          ..add('id', id))
        .toString();
  }
}

class FacilityDeletedBuilder
    implements Builder<FacilityDeleted, FacilityDeletedBuilder> {
  _$FacilityDeleted? _$v;

  bool? _deleted;
  bool? get deleted => _$this._deleted;
  set deleted(bool? deleted) => _$this._deleted = deleted;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  FacilityDeletedBuilder() {
    FacilityDeleted._defaults(this);
  }

  FacilityDeletedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deleted = $v.deleted;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FacilityDeleted other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FacilityDeleted;
  }

  @override
  void update(void Function(FacilityDeletedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FacilityDeleted build() => _build();

  _$FacilityDeleted _build() {
    final _$result = _$v ??
        new _$FacilityDeleted._(
            deleted: deleted,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'FacilityDeleted', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
