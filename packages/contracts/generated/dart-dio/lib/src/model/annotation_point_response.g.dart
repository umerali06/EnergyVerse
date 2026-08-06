// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotation_point_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnnotationPointResponse extends AnnotationPointResponse {
  @override
  final num x;
  @override
  final num y;

  factory _$AnnotationPointResponse(
          [void Function(AnnotationPointResponseBuilder)? updates]) =>
      (new AnnotationPointResponseBuilder()..update(updates))._build();

  _$AnnotationPointResponse._({required this.x, required this.y}) : super._() {
    BuiltValueNullFieldError.checkNotNull(x, r'AnnotationPointResponse', 'x');
    BuiltValueNullFieldError.checkNotNull(y, r'AnnotationPointResponse', 'y');
  }

  @override
  AnnotationPointResponse rebuild(
          void Function(AnnotationPointResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnnotationPointResponseBuilder toBuilder() =>
      new AnnotationPointResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnnotationPointResponse && x == other.x && y == other.y;
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
    return (newBuiltValueToStringHelper(r'AnnotationPointResponse')
          ..add('x', x)
          ..add('y', y))
        .toString();
  }
}

class AnnotationPointResponseBuilder
    implements
        Builder<AnnotationPointResponse, AnnotationPointResponseBuilder> {
  _$AnnotationPointResponse? _$v;

  num? _x;
  num? get x => _$this._x;
  set x(num? x) => _$this._x = x;

  num? _y;
  num? get y => _$this._y;
  set y(num? y) => _$this._y = y;

  AnnotationPointResponseBuilder() {
    AnnotationPointResponse._defaults(this);
  }

  AnnotationPointResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _x = $v.x;
      _y = $v.y;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnnotationPointResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AnnotationPointResponse;
  }

  @override
  void update(void Function(AnnotationPointResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnnotationPointResponse build() => _build();

  _$AnnotationPointResponse _build() {
    final _$result = _$v ??
        new _$AnnotationPointResponse._(
            x: BuiltValueNullFieldError.checkNotNull(
                x, r'AnnotationPointResponse', 'x'),
            y: BuiltValueNullFieldError.checkNotNull(
                y, r'AnnotationPointResponse', 'y'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
