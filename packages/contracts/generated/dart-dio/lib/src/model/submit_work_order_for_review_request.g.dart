// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_work_order_for_review_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubmitWorkOrderForReviewRequest
    extends SubmitWorkOrderForReviewRequest {
  @override
  final String completionNotes;
  @override
  final int? expectedRevision;
  @override
  final num? laborHours;
  @override
  final BuiltList<String>? materialsUsed;

  factory _$SubmitWorkOrderForReviewRequest(
          [void Function(SubmitWorkOrderForReviewRequestBuilder)? updates]) =>
      (new SubmitWorkOrderForReviewRequestBuilder()..update(updates))._build();

  _$SubmitWorkOrderForReviewRequest._(
      {required this.completionNotes,
      this.expectedRevision,
      this.laborHours,
      this.materialsUsed})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        completionNotes, r'SubmitWorkOrderForReviewRequest', 'completionNotes');
  }

  @override
  SubmitWorkOrderForReviewRequest rebuild(
          void Function(SubmitWorkOrderForReviewRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubmitWorkOrderForReviewRequestBuilder toBuilder() =>
      new SubmitWorkOrderForReviewRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubmitWorkOrderForReviewRequest &&
        completionNotes == other.completionNotes &&
        expectedRevision == other.expectedRevision &&
        laborHours == other.laborHours &&
        materialsUsed == other.materialsUsed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, completionNotes.hashCode);
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, laborHours.hashCode);
    _$hash = $jc(_$hash, materialsUsed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubmitWorkOrderForReviewRequest')
          ..add('completionNotes', completionNotes)
          ..add('expectedRevision', expectedRevision)
          ..add('laborHours', laborHours)
          ..add('materialsUsed', materialsUsed))
        .toString();
  }
}

class SubmitWorkOrderForReviewRequestBuilder
    implements
        Builder<SubmitWorkOrderForReviewRequest,
            SubmitWorkOrderForReviewRequestBuilder> {
  _$SubmitWorkOrderForReviewRequest? _$v;

  String? _completionNotes;
  String? get completionNotes => _$this._completionNotes;
  set completionNotes(String? completionNotes) =>
      _$this._completionNotes = completionNotes;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  num? _laborHours;
  num? get laborHours => _$this._laborHours;
  set laborHours(num? laborHours) => _$this._laborHours = laborHours;

  ListBuilder<String>? _materialsUsed;
  ListBuilder<String> get materialsUsed =>
      _$this._materialsUsed ??= new ListBuilder<String>();
  set materialsUsed(ListBuilder<String>? materialsUsed) =>
      _$this._materialsUsed = materialsUsed;

  SubmitWorkOrderForReviewRequestBuilder() {
    SubmitWorkOrderForReviewRequest._defaults(this);
  }

  SubmitWorkOrderForReviewRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _completionNotes = $v.completionNotes;
      _expectedRevision = $v.expectedRevision;
      _laborHours = $v.laborHours;
      _materialsUsed = $v.materialsUsed?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubmitWorkOrderForReviewRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SubmitWorkOrderForReviewRequest;
  }

  @override
  void update(void Function(SubmitWorkOrderForReviewRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubmitWorkOrderForReviewRequest build() => _build();

  _$SubmitWorkOrderForReviewRequest _build() {
    _$SubmitWorkOrderForReviewRequest _$result;
    try {
      _$result = _$v ??
          new _$SubmitWorkOrderForReviewRequest._(
              completionNotes: BuiltValueNullFieldError.checkNotNull(
                  completionNotes,
                  r'SubmitWorkOrderForReviewRequest',
                  'completionNotes'),
              expectedRevision: expectedRevision,
              laborHours: laborHours,
              materialsUsed: _materialsUsed?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'materialsUsed';
        _materialsUsed?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SubmitWorkOrderForReviewRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
