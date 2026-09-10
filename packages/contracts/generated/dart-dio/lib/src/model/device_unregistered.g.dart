// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_unregistered.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeviceUnregistered extends DeviceUnregistered {
  @override
  final bool unregistered;

  factory _$DeviceUnregistered(
          [void Function(DeviceUnregisteredBuilder)? updates]) =>
      (new DeviceUnregisteredBuilder()..update(updates))._build();

  _$DeviceUnregistered._({required this.unregistered}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        unregistered, r'DeviceUnregistered', 'unregistered');
  }

  @override
  DeviceUnregistered rebuild(
          void Function(DeviceUnregisteredBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeviceUnregisteredBuilder toBuilder() =>
      new DeviceUnregisteredBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeviceUnregistered && unregistered == other.unregistered;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, unregistered.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeviceUnregistered')
          ..add('unregistered', unregistered))
        .toString();
  }
}

class DeviceUnregisteredBuilder
    implements Builder<DeviceUnregistered, DeviceUnregisteredBuilder> {
  _$DeviceUnregistered? _$v;

  bool? _unregistered;
  bool? get unregistered => _$this._unregistered;
  set unregistered(bool? unregistered) => _$this._unregistered = unregistered;

  DeviceUnregisteredBuilder() {
    DeviceUnregistered._defaults(this);
  }

  DeviceUnregisteredBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _unregistered = $v.unregistered;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeviceUnregistered other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DeviceUnregistered;
  }

  @override
  void update(void Function(DeviceUnregisteredBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeviceUnregistered build() => _build();

  _$DeviceUnregistered _build() {
    final _$result = _$v ??
        new _$DeviceUnregistered._(
            unregistered: BuiltValueNullFieldError.checkNotNull(
                unregistered, r'DeviceUnregistered', 'unregistered'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
