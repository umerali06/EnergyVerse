// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_all_read.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationsAllRead extends NotificationsAllRead {
  @override
  final int marked;

  factory _$NotificationsAllRead(
          [void Function(NotificationsAllReadBuilder)? updates]) =>
      (new NotificationsAllReadBuilder()..update(updates))._build();

  _$NotificationsAllRead._({required this.marked}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        marked, r'NotificationsAllRead', 'marked');
  }

  @override
  NotificationsAllRead rebuild(
          void Function(NotificationsAllReadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationsAllReadBuilder toBuilder() =>
      new NotificationsAllReadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationsAllRead && marked == other.marked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, marked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationsAllRead')
          ..add('marked', marked))
        .toString();
  }
}

class NotificationsAllReadBuilder
    implements Builder<NotificationsAllRead, NotificationsAllReadBuilder> {
  _$NotificationsAllRead? _$v;

  int? _marked;
  int? get marked => _$this._marked;
  set marked(int? marked) => _$this._marked = marked;

  NotificationsAllReadBuilder() {
    NotificationsAllRead._defaults(this);
  }

  NotificationsAllReadBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _marked = $v.marked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationsAllRead other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NotificationsAllRead;
  }

  @override
  void update(void Function(NotificationsAllReadBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationsAllRead build() => _build();

  _$NotificationsAllRead _build() {
    final _$result = _$v ??
        new _$NotificationsAllRead._(
            marked: BuiltValueNullFieldError.checkNotNull(
                marked, r'NotificationsAllRead', 'marked'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
