// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_read.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationRead extends NotificationRead {
  @override
  final String id;
  @override
  final DateTime? readAt;

  factory _$NotificationRead(
          [void Function(NotificationReadBuilder)? updates]) =>
      (new NotificationReadBuilder()..update(updates))._build();

  _$NotificationRead._({required this.id, this.readAt}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'NotificationRead', 'id');
  }

  @override
  NotificationRead rebuild(void Function(NotificationReadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationReadBuilder toBuilder() =>
      new NotificationReadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationRead &&
        id == other.id &&
        readAt == other.readAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, readAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationRead')
          ..add('id', id)
          ..add('readAt', readAt))
        .toString();
  }
}

class NotificationReadBuilder
    implements Builder<NotificationRead, NotificationReadBuilder> {
  _$NotificationRead? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _readAt;
  DateTime? get readAt => _$this._readAt;
  set readAt(DateTime? readAt) => _$this._readAt = readAt;

  NotificationReadBuilder() {
    NotificationRead._defaults(this);
  }

  NotificationReadBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _readAt = $v.readAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationRead other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NotificationRead;
  }

  @override
  void update(void Function(NotificationReadBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationRead build() => _build();

  _$NotificationRead _build() {
    final _$result = _$v ??
        new _$NotificationRead._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'NotificationRead', 'id'),
            readAt: readAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
