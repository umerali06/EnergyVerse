// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_inspection_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompleteInspectionRequest extends CompleteInspectionRequest {
  @override
  final int expectedRevision;
  @override
  final BuiltList<SignatureStrokeInput> strokes;

  factory _$CompleteInspectionRequest(
          [void Function(CompleteInspectionRequestBuilder)? updates]) =>
      (new CompleteInspectionRequestBuilder()..update(updates))._build();

  _$CompleteInspectionRequest._(
      {required this.expectedRevision, required this.strokes})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        expectedRevision, r'CompleteInspectionRequest', 'expectedRevision');
    BuiltValueNullFieldError.checkNotNull(
        strokes, r'CompleteInspectionRequest', 'strokes');
  }

  @override
  CompleteInspectionRequest rebuild(
          void Function(CompleteInspectionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompleteInspectionRequestBuilder toBuilder() =>
      new CompleteInspectionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompleteInspectionRequest &&
        expectedRevision == other.expectedRevision &&
        strokes == other.strokes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, strokes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompleteInspectionRequest')
          ..add('expectedRevision', expectedRevision)
          ..add('strokes', strokes))
        .toString();
  }
}

class CompleteInspectionRequestBuilder
    implements
        Builder<CompleteInspectionRequest, CompleteInspectionRequestBuilder> {
  _$CompleteInspectionRequest? _$v;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  ListBuilder<SignatureStrokeInput>? _strokes;
  ListBuilder<SignatureStrokeInput> get strokes =>
      _$this._strokes ??= new ListBuilder<SignatureStrokeInput>();
  set strokes(ListBuilder<SignatureStrokeInput>? strokes) =>
      _$this._strokes = strokes;

  CompleteInspectionRequestBuilder() {
    CompleteInspectionRequest._defaults(this);
  }

  CompleteInspectionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedRevision = $v.expectedRevision;
      _strokes = $v.strokes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompleteInspectionRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CompleteInspectionRequest;
  }

  @override
  void update(void Function(CompleteInspectionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompleteInspectionRequest build() => _build();

  _$CompleteInspectionRequest _build() {
    _$CompleteInspectionRequest _$result;
    try {
      _$result = _$v ??
          new _$CompleteInspectionRequest._(
              expectedRevision: BuiltValueNullFieldError.checkNotNull(
                  expectedRevision,
                  r'CompleteInspectionRequest',
                  'expectedRevision'),
              strokes: strokes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'strokes';
        strokes.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CompleteInspectionRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
