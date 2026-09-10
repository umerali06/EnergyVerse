// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_deleted.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DocumentDeleted extends DocumentDeleted {
  @override
  final bool? deleted;
  @override
  final String id;

  factory _$DocumentDeleted([void Function(DocumentDeletedBuilder)? updates]) =>
      (new DocumentDeletedBuilder()..update(updates))._build();

  _$DocumentDeleted._({this.deleted, required this.id}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'DocumentDeleted', 'id');
  }

  @override
  DocumentDeleted rebuild(void Function(DocumentDeletedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DocumentDeletedBuilder toBuilder() =>
      new DocumentDeletedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DocumentDeleted &&
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
    return (newBuiltValueToStringHelper(r'DocumentDeleted')
          ..add('deleted', deleted)
          ..add('id', id))
        .toString();
  }
}

class DocumentDeletedBuilder
    implements Builder<DocumentDeleted, DocumentDeletedBuilder> {
  _$DocumentDeleted? _$v;

  bool? _deleted;
  bool? get deleted => _$this._deleted;
  set deleted(bool? deleted) => _$this._deleted = deleted;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DocumentDeletedBuilder() {
    DocumentDeleted._defaults(this);
  }

  DocumentDeletedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deleted = $v.deleted;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DocumentDeleted other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DocumentDeleted;
  }

  @override
  void update(void Function(DocumentDeletedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DocumentDeleted build() => _build();

  _$DocumentDeleted _build() {
    final _$result = _$v ??
        new _$DocumentDeleted._(
            deleted: deleted,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'DocumentDeleted', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
