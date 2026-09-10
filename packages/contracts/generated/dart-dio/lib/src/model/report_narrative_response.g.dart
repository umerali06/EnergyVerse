// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_narrative_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReportNarrativeResponse extends ReportNarrativeResponse {
  @override
  final BuiltList<String>? findings;
  @override
  final BuiltList<String>? recommendations;
  @override
  final num? riskScore;
  @override
  final String summary;

  factory _$ReportNarrativeResponse(
          [void Function(ReportNarrativeResponseBuilder)? updates]) =>
      (new ReportNarrativeResponseBuilder()..update(updates))._build();

  _$ReportNarrativeResponse._(
      {this.findings,
      this.recommendations,
      this.riskScore,
      required this.summary})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        summary, r'ReportNarrativeResponse', 'summary');
  }

  @override
  ReportNarrativeResponse rebuild(
          void Function(ReportNarrativeResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReportNarrativeResponseBuilder toBuilder() =>
      new ReportNarrativeResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReportNarrativeResponse &&
        findings == other.findings &&
        recommendations == other.recommendations &&
        riskScore == other.riskScore &&
        summary == other.summary;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, findings.hashCode);
    _$hash = $jc(_$hash, recommendations.hashCode);
    _$hash = $jc(_$hash, riskScore.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReportNarrativeResponse')
          ..add('findings', findings)
          ..add('recommendations', recommendations)
          ..add('riskScore', riskScore)
          ..add('summary', summary))
        .toString();
  }
}

class ReportNarrativeResponseBuilder
    implements
        Builder<ReportNarrativeResponse, ReportNarrativeResponseBuilder> {
  _$ReportNarrativeResponse? _$v;

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

  ReportNarrativeResponseBuilder() {
    ReportNarrativeResponse._defaults(this);
  }

  ReportNarrativeResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _findings = $v.findings?.toBuilder();
      _recommendations = $v.recommendations?.toBuilder();
      _riskScore = $v.riskScore;
      _summary = $v.summary;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReportNarrativeResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ReportNarrativeResponse;
  }

  @override
  void update(void Function(ReportNarrativeResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReportNarrativeResponse build() => _build();

  _$ReportNarrativeResponse _build() {
    _$ReportNarrativeResponse _$result;
    try {
      _$result = _$v ??
          new _$ReportNarrativeResponse._(
              findings: _findings?.build(),
              recommendations: _recommendations?.build(),
              riskScore: riskScore,
              summary: BuiltValueNullFieldError.checkNotNull(
                  summary, r'ReportNarrativeResponse', 'summary'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'findings';
        _findings?.build();
        _$failedField = 'recommendations';
        _recommendations?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ReportNarrativeResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
