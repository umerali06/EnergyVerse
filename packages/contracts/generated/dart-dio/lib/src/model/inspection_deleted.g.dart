// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_deleted.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InspectionDeleted extends InspectionDeleted {
  @override
  final bool? deleted;
  @override
  final String id;

  factory _$InspectionDeleted(
          [void Function(InspectionDeletedBuilder)? updates]) =>
      (new InspectionDeletedBuilder()..update(updates))._build();

  _$InspectionDeleted._({this.deleted, required this.id}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'InspectionDeleted', 'id');
  }

  @override
  InspectionDeleted rebuild(void Function(InspectionDeletedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InspectionDeletedBuilder toBuilder() =>
      new InspectionDeletedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InspectionDeleted &&
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
    return (newBuiltValueToStringHelper(r'InspectionDeleted')
          ..add('deleted', deleted)
          ..add('id', id))
        .toString();
  }
}

class InspectionDeletedBuilder
    implements Builder<InspectionDeleted, InspectionDeletedBuilder> {
  _$InspectionDeleted? _$v;

  bool? _deleted;
  bool? get deleted => _$this._deleted;
  set deleted(bool? deleted) => _$this._deleted = deleted;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  InspectionDeletedBuilder() {
    InspectionDeleted._defaults(this);
  }

  InspectionDeletedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deleted = $v.deleted;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InspectionDeleted other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InspectionDeleted;
  }

  @override
  void update(void Function(InspectionDeletedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InspectionDeleted build() => _build();

  _$InspectionDeleted _build() {
    final _$result = _$v ??
        new _$InspectionDeleted._(
            deleted: deleted,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'InspectionDeleted', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
