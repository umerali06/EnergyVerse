// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signature_point_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SignaturePointInput extends SignaturePointInput {
  @override
  final num x;
  @override
  final num y;

  factory _$SignaturePointInput(
          [void Function(SignaturePointInputBuilder)? updates]) =>
      (new SignaturePointInputBuilder()..update(updates))._build();

  _$SignaturePointInput._({required this.x, required this.y}) : super._() {
    BuiltValueNullFieldError.checkNotNull(x, r'SignaturePointInput', 'x');
    BuiltValueNullFieldError.checkNotNull(y, r'SignaturePointInput', 'y');
  }

  @override
  SignaturePointInput rebuild(
          void Function(SignaturePointInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SignaturePointInputBuilder toBuilder() =>
      new SignaturePointInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SignaturePointInput && x == other.x && y == other.y;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, x.hashCode);
    _$hash = $jc(_$hash, y.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SignaturePointInput')
          ..add('x', x)
          ..add('y', y))
        .toString();
  }
}

class SignaturePointInputBuilder
    implements Builder<SignaturePointInput, SignaturePointInputBuilder> {
  _$SignaturePointInput? _$v;

  num? _x;
  num? get x => _$this._x;
  set x(num? x) => _$this._x = x;

  num? _y;
  num? get y => _$this._y;
  set y(num? y) => _$this._y = y;

  SignaturePointInputBuilder() {
    SignaturePointInput._defaults(this);
  }

  SignaturePointInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _x = $v.x;
      _y = $v.y;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SignaturePointInput other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SignaturePointInput;
  }

  @override
  void update(void Function(SignaturePointInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SignaturePointInput build() => _build();

  _$SignaturePointInput _build() {
    final _$result = _$v ??
        new _$SignaturePointInput._(
            x: BuiltValueNullFieldError.checkNotNull(
                x, r'SignaturePointInput', 'x'),
            y: BuiltValueNullFieldError.checkNotNull(
                y, r'SignaturePointInput', 'y'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
