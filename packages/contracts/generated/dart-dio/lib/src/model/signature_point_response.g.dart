// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signature_point_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SignaturePointResponse extends SignaturePointResponse {
  @override
  final num x;
  @override
  final num y;

  factory _$SignaturePointResponse(
          [void Function(SignaturePointResponseBuilder)? updates]) =>
      (new SignaturePointResponseBuilder()..update(updates))._build();

  _$SignaturePointResponse._({required this.x, required this.y}) : super._() {
    BuiltValueNullFieldError.checkNotNull(x, r'SignaturePointResponse', 'x');
    BuiltValueNullFieldError.checkNotNull(y, r'SignaturePointResponse', 'y');
  }

  @override
  SignaturePointResponse rebuild(
          void Function(SignaturePointResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SignaturePointResponseBuilder toBuilder() =>
      new SignaturePointResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SignaturePointResponse && x == other.x && y == other.y;
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
    return (newBuiltValueToStringHelper(r'SignaturePointResponse')
          ..add('x', x)
          ..add('y', y))
        .toString();
  }
}

class SignaturePointResponseBuilder
    implements Builder<SignaturePointResponse, SignaturePointResponseBuilder> {
  _$SignaturePointResponse? _$v;

  num? _x;
  num? get x => _$this._x;
  set x(num? x) => _$this._x = x;

  num? _y;
  num? get y => _$this._y;
  set y(num? y) => _$this._y = y;

  SignaturePointResponseBuilder() {
    SignaturePointResponse._defaults(this);
  }

  SignaturePointResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _x = $v.x;
      _y = $v.y;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SignaturePointResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SignaturePointResponse;
  }

  @override
  void update(void Function(SignaturePointResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SignaturePointResponse build() => _build();

  _$SignaturePointResponse _build() {
    final _$result = _$v ??
        new _$SignaturePointResponse._(
            x: BuiltValueNullFieldError.checkNotNull(
                x, r'SignaturePointResponse', 'x'),
            y: BuiltValueNullFieldError.checkNotNull(
                y, r'SignaturePointResponse', 'y'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
