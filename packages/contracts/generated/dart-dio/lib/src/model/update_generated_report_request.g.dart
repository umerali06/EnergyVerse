// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_generated_report_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateGeneratedReportRequest extends UpdateGeneratedReportRequest {
  @override
  final int expectedRevision;
  @override
  final BuiltList<String>? findings;
  @override
  final BuiltList<String>? recommendations;
  @override
  final num? riskScore;
  @override
  final String? summary;
  @override
  final String? title;

  factory _$UpdateGeneratedReportRequest(
          [void Function(UpdateGeneratedReportRequestBuilder)? updates]) =>
      (new UpdateGeneratedReportRequestBuilder()..update(updates))._build();

  _$UpdateGeneratedReportRequest._(
      {required this.expectedRevision,
      this.findings,
      this.recommendations,
      this.riskScore,
      this.summary,
      this.title})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        expectedRevision, r'UpdateGeneratedReportRequest', 'expectedRevision');
  }

  @override
  UpdateGeneratedReportRequest rebuild(
          void Function(UpdateGeneratedReportRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateGeneratedReportRequestBuilder toBuilder() =>
      new UpdateGeneratedReportRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateGeneratedReportRequest &&
        expectedRevision == other.expectedRevision &&
        findings == other.findings &&
        recommendations == other.recommendations &&
        riskScore == other.riskScore &&
        summary == other.summary &&
        title == other.title;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, findings.hashCode);
    _$hash = $jc(_$hash, recommendations.hashCode);
    _$hash = $jc(_$hash, riskScore.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateGeneratedReportRequest')
          ..add('expectedRevision', expectedRevision)
          ..add('findings', findings)
          ..add('recommendations', recommendations)
          ..add('riskScore', riskScore)
          ..add('summary', summary)
          ..add('title', title))
        .toString();
  }
}

class UpdateGeneratedReportRequestBuilder
    implements
        Builder<UpdateGeneratedReportRequest,
            UpdateGeneratedReportRequestBuilder> {
  _$UpdateGeneratedReportRequest? _$v;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  ListBuilder<String>? _findings;
  ListBuilder<String> get findings =>
      _$this._findings ??= new ListBuilder<String>();
  set findings(ListBuilder<String>? findings) => _$this._findings = findings;

  ListBuilder<String>? _recommendations;
  ListBuilder<String> get recommendations =>
      _$this._recommendations ??= new ListBuilder<String>();
  set recommendations(ListBuilder<String>? recommendations) =>
      _$this._recommendations = recommendations;

  num? _riskScore;
  num? get riskScore => _$this._riskScore;
  set riskScore(num? riskScore) => _$this._riskScore = riskScore;

  String? _summary;
  String? get summary => _$this._summary;
  set summary(String? summary) => _$this._summary = summary;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  UpdateGeneratedReportRequestBuilder() {
    UpdateGeneratedReportRequest._defaults(this);
  }

  UpdateGeneratedReportRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedRevision = $v.expectedRevision;
      _findings = $v.findings?.toBuilder();
      _recommendations = $v.recommendations?.toBuilder();
      _riskScore = $v.riskScore;
      _summary = $v.summary;
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateGeneratedReportRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateGeneratedReportRequest;
  }

  @override
  void update(void Function(UpdateGeneratedReportRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateGeneratedReportRequest build() => _build();

  _$UpdateGeneratedReportRequest _build() {
    _$UpdateGeneratedReportRequest _$result;
    try {
      _$result = _$v ??
          new _$UpdateGeneratedReportRequest._(
              expectedRevision: BuiltValueNullFieldError.checkNotNull(
                  expectedRevision,
                  r'UpdateGeneratedReportRequest',
                  'expectedRevision'),
              findings: _findings?.build(),
              recommendations: _recommendations?.build(),
              riskScore: riskScore,
              summary: summary,
              title: title);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'findings';
        _findings?.build();
        _$failedField = 'recommendations';
        _recommendations?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UpdateGeneratedReportRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
