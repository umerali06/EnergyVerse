// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_template_deleted.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermitTemplateDeleted extends PermitTemplateDeleted {
  @override
  final bool? deleted;
  @override
  final String id;

  factory _$PermitTemplateDeleted(
          [void Function(PermitTemplateDeletedBuilder)? updates]) =>
      (new PermitTemplateDeletedBuilder()..update(updates))._build();

  _$PermitTemplateDeleted._({this.deleted, required this.id}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'PermitTemplateDeleted', 'id');
  }

  @override
  PermitTemplateDeleted rebuild(
          void Function(PermitTemplateDeletedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitTemplateDeletedBuilder toBuilder() =>
      new PermitTemplateDeletedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitTemplateDeleted &&
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
    return (newBuiltValueToStringHelper(r'PermitTemplateDeleted')
          ..add('deleted', deleted)
          ..add('id', id))
        .toString();
  }
}

class PermitTemplateDeletedBuilder
    implements Builder<PermitTemplateDeleted, PermitTemplateDeletedBuilder> {
  _$PermitTemplateDeleted? _$v;

  bool? _deleted;
  bool? get deleted => _$this._deleted;
  set deleted(bool? deleted) => _$this._deleted = deleted;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  PermitTemplateDeletedBuilder() {
    PermitTemplateDeleted._defaults(this);
  }

  PermitTemplateDeletedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deleted = $v.deleted;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitTemplateDeleted other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitTemplateDeleted;
  }

  @override
  void update(void Function(PermitTemplateDeletedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitTemplateDeleted build() => _build();

  _$PermitTemplateDeleted _build() {
    final _$result = _$v ??
        new _$PermitTemplateDeleted._(
            deleted: deleted,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PermitTemplateDeleted', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
