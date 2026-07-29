// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_template_deleted.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChecklistTemplateDeleted extends ChecklistTemplateDeleted {
  @override
  final bool? deleted;
  @override
  final String id;

  factory _$ChecklistTemplateDeleted(
          [void Function(ChecklistTemplateDeletedBuilder)? updates]) =>
      (new ChecklistTemplateDeletedBuilder()..update(updates))._build();

  _$ChecklistTemplateDeleted._({this.deleted, required this.id}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        id, r'ChecklistTemplateDeleted', 'id');
  }

  @override
  ChecklistTemplateDeleted rebuild(
          void Function(ChecklistTemplateDeletedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChecklistTemplateDeletedBuilder toBuilder() =>
      new ChecklistTemplateDeletedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChecklistTemplateDeleted &&
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
    return (newBuiltValueToStringHelper(r'ChecklistTemplateDeleted')
          ..add('deleted', deleted)
          ..add('id', id))
        .toString();
  }
}

class ChecklistTemplateDeletedBuilder
    implements
        Builder<ChecklistTemplateDeleted, ChecklistTemplateDeletedBuilder> {
  _$ChecklistTemplateDeleted? _$v;

  bool? _deleted;
  bool? get deleted => _$this._deleted;
  set deleted(bool? deleted) => _$this._deleted = deleted;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ChecklistTemplateDeletedBuilder() {
    ChecklistTemplateDeleted._defaults(this);
  }

  ChecklistTemplateDeletedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deleted = $v.deleted;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChecklistTemplateDeleted other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChecklistTemplateDeleted;
  }

  @override
  void update(void Function(ChecklistTemplateDeletedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChecklistTemplateDeleted build() => _build();

  _$ChecklistTemplateDeleted _build() {
    final _$result = _$v ??
        new _$ChecklistTemplateDeleted._(
            deleted: deleted,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ChecklistTemplateDeleted', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
