// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order_deleted.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkOrderDeleted extends WorkOrderDeleted {
  @override
  final bool? deleted;
  @override
  final String id;

  factory _$WorkOrderDeleted(
          [void Function(WorkOrderDeletedBuilder)? updates]) =>
      (new WorkOrderDeletedBuilder()..update(updates))._build();

  _$WorkOrderDeleted._({this.deleted, required this.id}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'WorkOrderDeleted', 'id');
  }

  @override
  WorkOrderDeleted rebuild(void Function(WorkOrderDeletedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkOrderDeletedBuilder toBuilder() =>
      new WorkOrderDeletedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkOrderDeleted &&
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
    return (newBuiltValueToStringHelper(r'WorkOrderDeleted')
          ..add('deleted', deleted)
          ..add('id', id))
        .toString();
  }
}

class WorkOrderDeletedBuilder
    implements Builder<WorkOrderDeleted, WorkOrderDeletedBuilder> {
  _$WorkOrderDeleted? _$v;

  bool? _deleted;
  bool? get deleted => _$this._deleted;
  set deleted(bool? deleted) => _$this._deleted = deleted;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  WorkOrderDeletedBuilder() {
    WorkOrderDeleted._defaults(this);
  }

  WorkOrderDeletedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deleted = $v.deleted;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkOrderDeleted other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WorkOrderDeleted;
  }

  @override
  void update(void Function(WorkOrderDeletedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkOrderDeleted build() => _build();

  _$WorkOrderDeleted _build() {
    final _$result = _$v ??
        new _$WorkOrderDeleted._(
            deleted: deleted,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'WorkOrderDeleted', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
