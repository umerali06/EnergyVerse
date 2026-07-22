// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuditLogEntry extends AuditLogEntry {
  @override
  final String action;
  @override
  final String? actorName;
  @override
  final String? actorRole;
  @override
  final String actorUid;
  @override
  final DateTime createdAt;
  @override
  final String id;
  @override
  final BuiltMap<String, JsonObject?>? metadata;
  @override
  final String targetId;
  @override
  final String targetType;

  factory _$AuditLogEntry([void Function(AuditLogEntryBuilder)? updates]) =>
      (new AuditLogEntryBuilder()..update(updates))._build();

  _$AuditLogEntry._(
      {required this.action,
      this.actorName,
      this.actorRole,
      required this.actorUid,
      required this.createdAt,
      required this.id,
      this.metadata,
      required this.targetId,
      required this.targetType})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(action, r'AuditLogEntry', 'action');
    BuiltValueNullFieldError.checkNotNull(
        actorUid, r'AuditLogEntry', 'actorUid');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'AuditLogEntry', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(id, r'AuditLogEntry', 'id');
    BuiltValueNullFieldError.checkNotNull(
        targetId, r'AuditLogEntry', 'targetId');
    BuiltValueNullFieldError.checkNotNull(
        targetType, r'AuditLogEntry', 'targetType');
  }

  @override
  AuditLogEntry rebuild(void Function(AuditLogEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuditLogEntryBuilder toBuilder() => new AuditLogEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuditLogEntry &&
        action == other.action &&
        actorName == other.actorName &&
        actorRole == other.actorRole &&
        actorUid == other.actorUid &&
        createdAt == other.createdAt &&
        id == other.id &&
        metadata == other.metadata &&
        targetId == other.targetId &&
        targetType == other.targetType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, actorName.hashCode);
    _$hash = $jc(_$hash, actorRole.hashCode);
    _$hash = $jc(_$hash, actorUid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, metadata.hashCode);
    _$hash = $jc(_$hash, targetId.hashCode);
    _$hash = $jc(_$hash, targetType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuditLogEntry')
          ..add('action', action)
          ..add('actorName', actorName)
          ..add('actorRole', actorRole)
          ..add('actorUid', actorUid)
          ..add('createdAt', createdAt)
          ..add('id', id)
          ..add('metadata', metadata)
          ..add('targetId', targetId)
          ..add('targetType', targetType))
        .toString();
  }
}

class AuditLogEntryBuilder
    implements Builder<AuditLogEntry, AuditLogEntryBuilder> {
  _$AuditLogEntry? _$v;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  String? _actorRole;
  String? get actorRole => _$this._actorRole;
  set actorRole(String? actorRole) => _$this._actorRole = actorRole;

  String? _actorUid;
  String? get actorUid => _$this._actorUid;
  set actorUid(String? actorUid) => _$this._actorUid = actorUid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  MapBuilder<String, JsonObject?>? _metadata;
  MapBuilder<String, JsonObject?> get metadata =>
      _$this._metadata ??= new MapBuilder<String, JsonObject?>();
  set metadata(MapBuilder<String, JsonObject?>? metadata) =>
      _$this._metadata = metadata;

  String? _targetId;
  String? get targetId => _$this._targetId;
  set targetId(String? targetId) => _$this._targetId = targetId;

  String? _targetType;
  String? get targetType => _$this._targetType;
  set targetType(String? targetType) => _$this._targetType = targetType;

  AuditLogEntryBuilder() {
    AuditLogEntry._defaults(this);
  }

  AuditLogEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _action = $v.action;
      _actorName = $v.actorName;
      _actorRole = $v.actorRole;
      _actorUid = $v.actorUid;
      _createdAt = $v.createdAt;
      _id = $v.id;
      _metadata = $v.metadata?.toBuilder();
      _targetId = $v.targetId;
      _targetType = $v.targetType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuditLogEntry other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuditLogEntry;
  }

  @override
  void update(void Function(AuditLogEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuditLogEntry build() => _build();

  _$AuditLogEntry _build() {
    _$AuditLogEntry _$result;
    try {
      _$result = _$v ??
          new _$AuditLogEntry._(
              action: BuiltValueNullFieldError.checkNotNull(
                  action, r'AuditLogEntry', 'action'),
              actorName: actorName,
              actorRole: actorRole,
              actorUid: BuiltValueNullFieldError.checkNotNull(
                  actorUid, r'AuditLogEntry', 'actorUid'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'AuditLogEntry', 'createdAt'),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'AuditLogEntry', 'id'),
              metadata: _metadata?.build(),
              targetId: BuiltValueNullFieldError.checkNotNull(
                  targetId, r'AuditLogEntry', 'targetId'),
              targetType: BuiltValueNullFieldError.checkNotNull(
                  targetType, r'AuditLogEntry', 'targetType'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'metadata';
        _metadata?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AuditLogEntry', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
