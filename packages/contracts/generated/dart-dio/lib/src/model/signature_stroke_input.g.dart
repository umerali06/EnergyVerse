// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signature_stroke_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SignatureStrokeInput extends SignatureStrokeInput {
  @override
  final BuiltList<SignaturePointInput> points;

  factory _$SignatureStrokeInput(
          [void Function(SignatureStrokeInputBuilder)? updates]) =>
      (new SignatureStrokeInputBuilder()..update(updates))._build();

  _$SignatureStrokeInput._({required this.points}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        points, r'SignatureStrokeInput', 'points');
  }

  @override
  SignatureStrokeInput rebuild(
          void Function(SignatureStrokeInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SignatureStrokeInputBuilder toBuilder() =>
      new SignatureStrokeInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SignatureStrokeInput && points == other.points;
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
    return (newBuiltValueToStringHelper(r'SignatureStrokeInput')
          ..add('points', points))
        .toString();
  }
}

class SignatureStrokeInputBuilder
    implements Builder<SignatureStrokeInput, SignatureStrokeInputBuilder> {
  _$SignatureStrokeInput? _$v;

  ListBuilder<SignaturePointInput>? _points;
  ListBuilder<SignaturePointInput> get points =>
      _$this._points ??= new ListBuilder<SignaturePointInput>();
  set points(ListBuilder<SignaturePointInput>? points) =>
      _$this._points = points;

  SignatureStrokeInputBuilder() {
    SignatureStrokeInput._defaults(this);
  }

  SignatureStrokeInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _points = $v.points.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SignatureStrokeInput other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SignatureStrokeInput;
  }

  @override
  void update(void Function(SignatureStrokeInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SignatureStrokeInput build() => _build();

  _$SignatureStrokeInput _build() {
    _$SignatureStrokeInput _$result;
    try {
      _$result = _$v ?? new _$SignatureStrokeInput._(points: points.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'points';
        points.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SignatureStrokeInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
