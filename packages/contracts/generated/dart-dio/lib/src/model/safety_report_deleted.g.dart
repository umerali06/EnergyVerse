// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_report_deleted.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SafetyReportDeleted extends SafetyReportDeleted {
  @override
  final bool? deleted;
  @override
  final String id;

  factory _$SafetyReportDeleted(
          [void Function(SafetyReportDeletedBuilder)? updates]) =>
      (new SafetyReportDeletedBuilder()..update(updates))._build();

  _$SafetyReportDeleted._({this.deleted, required this.id}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'SafetyReportDeleted', 'id');
  }

  @override
  SafetyReportDeleted rebuild(
          void Function(SafetyReportDeletedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SafetyReportDeletedBuilder toBuilder() =>
      new SafetyReportDeletedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SafetyReportDeleted &&
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
    return (newBuiltValueToStringHelper(r'SafetyReportDeleted')
          ..add('deleted', deleted)
          ..add('id', id))
        .toString();
  }
}

class SafetyReportDeletedBuilder
    implements Builder<SafetyReportDeleted, SafetyReportDeletedBuilder> {
  _$SafetyReportDeleted? _$v;

  bool? _deleted;
  bool? get deleted => _$this._deleted;
  set deleted(bool? deleted) => _$this._deleted = deleted;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  SafetyReportDeletedBuilder() {
    SafetyReportDeleted._defaults(this);
  }

  SafetyReportDeletedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deleted = $v.deleted;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SafetyReportDeleted other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SafetyReportDeleted;
  }

  @override
  void update(void Function(SafetyReportDeletedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SafetyReportDeleted build() => _build();

  _$SafetyReportDeleted _build() {
    final _$result = _$v ??
        new _$SafetyReportDeleted._(
            deleted: deleted,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'SafetyReportDeleted', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
