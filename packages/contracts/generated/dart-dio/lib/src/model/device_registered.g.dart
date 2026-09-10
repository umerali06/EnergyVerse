// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_registered.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeviceRegistered extends DeviceRegistered {
  @override
  final bool registered;

  factory _$DeviceRegistered(
          [void Function(DeviceRegisteredBuilder)? updates]) =>
      (new DeviceRegisteredBuilder()..update(updates))._build();

  _$DeviceRegistered._({required this.registered}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        registered, r'DeviceRegistered', 'registered');
  }

  @override
  DeviceRegistered rebuild(void Function(DeviceRegisteredBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeviceRegisteredBuilder toBuilder() =>
      new DeviceRegisteredBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeviceRegistered && registered == other.registered;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, registered.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeviceRegistered')
          ..add('registered', registered))
        .toString();
  }
}

class DeviceRegisteredBuilder
    implements Builder<DeviceRegistered, DeviceRegisteredBuilder> {
  _$DeviceRegistered? _$v;

  bool? _registered;
  bool? get registered => _$this._registered;
  set registered(bool? registered) => _$this._registered = registered;

  DeviceRegisteredBuilder() {
    DeviceRegistered._defaults(this);
  }

  DeviceRegisteredBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _registered = $v.registered;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeviceRegistered other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DeviceRegistered;
  }

  @override
  void update(void Function(DeviceRegisteredBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeviceRegistered build() => _build();

  _$DeviceRegistered _build() {
    final _$result = _$v ??
        new _$DeviceRegistered._(
            registered: BuiltValueNullFieldError.checkNotNull(
                registered, r'DeviceRegistered', 'registered'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
