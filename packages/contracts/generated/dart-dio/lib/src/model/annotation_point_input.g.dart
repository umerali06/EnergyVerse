// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotation_point_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnnotationPointInput extends AnnotationPointInput {
  @override
  final num x;
  @override
  final num y;

  factory _$AnnotationPointInput(
          [void Function(AnnotationPointInputBuilder)? updates]) =>
      (new AnnotationPointInputBuilder()..update(updates))._build();

  _$AnnotationPointInput._({required this.x, required this.y}) : super._() {
    BuiltValueNullFieldError.checkNotNull(x, r'AnnotationPointInput', 'x');
    BuiltValueNullFieldError.checkNotNull(y, r'AnnotationPointInput', 'y');
  }

  @override
  AnnotationPointInput rebuild(
          void Function(AnnotationPointInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnnotationPointInputBuilder toBuilder() =>
      new AnnotationPointInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnnotationPointInput && x == other.x && y == other.y;
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
    return (newBuiltValueToStringHelper(r'AnnotationPointInput')
          ..add('x', x)
          ..add('y', y))
        .toString();
  }
}

class AnnotationPointInputBuilder
    implements Builder<AnnotationPointInput, AnnotationPointInputBuilder> {
  _$AnnotationPointInput? _$v;

  num? _x;
  num? get x => _$this._x;
  set x(num? x) => _$this._x = x;

  num? _y;
  num? get y => _$this._y;
  set y(num? y) => _$this._y = y;

  AnnotationPointInputBuilder() {
    AnnotationPointInput._defaults(this);
  }

  AnnotationPointInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _x = $v.x;
      _y = $v.y;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnnotationPointInput other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AnnotationPointInput;
  }

  @override
  void update(void Function(AnnotationPointInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnnotationPointInput build() => _build();

  _$AnnotationPointInput _build() {
    final _$result = _$v ??
        new _$AnnotationPointInput._(
            x: BuiltValueNullFieldError.checkNotNull(
                x, r'AnnotationPointInput', 'x'),
            y: BuiltValueNullFieldError.checkNotNull(
                y, r'AnnotationPointInput', 'y'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
