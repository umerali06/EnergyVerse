// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_activity_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DashboardActivityItem extends DashboardActivityItem {
  @override
  final String action;
  @override
  final String? actorName;
  @override
  final String actorUid;
  @override
  final DateTime createdAt;
  @override
  final String id;
  @override
  final String targetId;
  @override
  final String targetType;

  factory _$DashboardActivityItem(
          [void Function(DashboardActivityItemBuilder)? updates]) =>
      (new DashboardActivityItemBuilder()..update(updates))._build();

  _$DashboardActivityItem._(
      {required this.action,
      this.actorName,
      required this.actorUid,
      required this.createdAt,
      required this.id,
      required this.targetId,
      required this.targetType})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        action, r'DashboardActivityItem', 'action');
    BuiltValueNullFieldError.checkNotNull(
        actorUid, r'DashboardActivityItem', 'actorUid');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'DashboardActivityItem', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(id, r'DashboardActivityItem', 'id');
    BuiltValueNullFieldError.checkNotNull(
        targetId, r'DashboardActivityItem', 'targetId');
    BuiltValueNullFieldError.checkNotNull(
        targetType, r'DashboardActivityItem', 'targetType');
  }

  @override
  DashboardActivityItem rebuild(
          void Function(DashboardActivityItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardActivityItemBuilder toBuilder() =>
      new DashboardActivityItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardActivityItem &&
        action == other.action &&
        actorName == other.actorName &&
        actorUid == other.actorUid &&
        createdAt == other.createdAt &&
        id == other.id &&
        targetId == other.targetId &&
        targetType == other.targetType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, actorName.hashCode);
    _$hash = $jc(_$hash, actorUid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, targetId.hashCode);
    _$hash = $jc(_$hash, targetType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DashboardActivityItem')
          ..add('action', action)
          ..add('actorName', actorName)
          ..add('actorUid', actorUid)
          ..add('createdAt', createdAt)
          ..add('id', id)
          ..add('targetId', targetId)
          ..add('targetType', targetType))
        .toString();
  }
}

class DashboardActivityItemBuilder
    implements Builder<DashboardActivityItem, DashboardActivityItemBuilder> {
  _$DashboardActivityItem? _$v;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  String? _actorUid;
  String? get actorUid => _$this._actorUid;
  set actorUid(String? actorUid) => _$this._actorUid = actorUid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _targetId;
  String? get targetId => _$this._targetId;
  set targetId(String? targetId) => _$this._targetId = targetId;

  String? _targetType;
  String? get targetType => _$this._targetType;
  set targetType(String? targetType) => _$this._targetType = targetType;

  DashboardActivityItemBuilder() {
    DashboardActivityItem._defaults(this);
  }

  DashboardActivityItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _action = $v.action;
      _actorName = $v.actorName;
      _actorUid = $v.actorUid;
      _createdAt = $v.createdAt;
      _id = $v.id;
      _targetId = $v.targetId;
      _targetType = $v.targetType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardActivityItem other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DashboardActivityItem;
  }

  @override
  void update(void Function(DashboardActivityItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardActivityItem build() => _build();

  _$DashboardActivityItem _build() {
    final _$result = _$v ??
        new _$DashboardActivityItem._(
            action: BuiltValueNullFieldError.checkNotNull(
                action, r'DashboardActivityItem', 'action'),
            actorName: actorName,
            actorUid: BuiltValueNullFieldError.checkNotNull(
                actorUid, r'DashboardActivityItem', 'actorUid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'DashboardActivityItem', 'createdAt'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'DashboardActivityItem', 'id'),
            targetId: BuiltValueNullFieldError.checkNotNull(
                targetId, r'DashboardActivityItem', 'targetId'),
            targetType: BuiltValueNullFieldError.checkNotNull(
                targetType, r'DashboardActivityItem', 'targetType'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
