// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated_report_deleted.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeneratedReportDeleted extends GeneratedReportDeleted {
  @override
  final bool? deleted;
  @override
  final String id;

  factory _$GeneratedReportDeleted(
          [void Function(GeneratedReportDeletedBuilder)? updates]) =>
      (new GeneratedReportDeletedBuilder()..update(updates))._build();

  _$GeneratedReportDeleted._({this.deleted, required this.id}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'GeneratedReportDeleted', 'id');
  }

  @override
  GeneratedReportDeleted rebuild(
          void Function(GeneratedReportDeletedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeneratedReportDeletedBuilder toBuilder() =>
      new GeneratedReportDeletedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeneratedReportDeleted &&
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
    return (newBuiltValueToStringHelper(r'GeneratedReportDeleted')
          ..add('deleted', deleted)
          ..add('id', id))
        .toString();
  }
}

class GeneratedReportDeletedBuilder
    implements Builder<GeneratedReportDeleted, GeneratedReportDeletedBuilder> {
  _$GeneratedReportDeleted? _$v;

  bool? _deleted;
  bool? get deleted => _$this._deleted;
  set deleted(bool? deleted) => _$this._deleted = deleted;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  GeneratedReportDeletedBuilder() {
    GeneratedReportDeleted._defaults(this);
  }

  GeneratedReportDeletedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deleted = $v.deleted;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeneratedReportDeleted other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GeneratedReportDeleted;
  }

  @override
  void update(void Function(GeneratedReportDeletedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeneratedReportDeleted build() => _build();

  _$GeneratedReportDeleted _build() {
    final _$result = _$v ??
        new _$GeneratedReportDeleted._(
            deleted: deleted,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'GeneratedReportDeleted', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
