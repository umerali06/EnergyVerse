// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signature_stroke_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SignatureStrokeResponse extends SignatureStrokeResponse {
  @override
  final BuiltList<SignaturePointResponse> points;

  factory _$SignatureStrokeResponse(
          [void Function(SignatureStrokeResponseBuilder)? updates]) =>
      (new SignatureStrokeResponseBuilder()..update(updates))._build();

  _$SignatureStrokeResponse._({required this.points}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        points, r'SignatureStrokeResponse', 'points');
  }

  @override
  SignatureStrokeResponse rebuild(
          void Function(SignatureStrokeResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SignatureStrokeResponseBuilder toBuilder() =>
      new SignatureStrokeResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SignatureStrokeResponse && points == other.points;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SignatureStrokeResponse')
          ..add('points', points))
        .toString();
  }
}

class SignatureStrokeResponseBuilder
    implements
        Builder<SignatureStrokeResponse, SignatureStrokeResponseBuilder> {
  _$SignatureStrokeResponse? _$v;

  ListBuilder<SignaturePointResponse>? _points;
  ListBuilder<SignaturePointResponse> get points =>
      _$this._points ??= new ListBuilder<SignaturePointResponse>();
  set points(ListBuilder<SignaturePointResponse>? points) =>
      _$this._points = points;

  SignatureStrokeResponseBuilder() {
    SignatureStrokeResponse._defaults(this);
  }

  SignatureStrokeResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _points = $v.points.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SignatureStrokeResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SignatureStrokeResponse;
  }

  @override
  void update(void Function(SignatureStrokeResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SignatureStrokeResponse build() => _build();

  _$SignatureStrokeResponse _build() {
    _$SignatureStrokeResponse _$result;
    try {
      _$result = _$v ?? new _$SignatureStrokeResponse._(points: points.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'points';
        points.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SignatureStrokeResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
