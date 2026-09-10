// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regenerate_generated_report_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegenerateGeneratedReportRequest
    extends RegenerateGeneratedReportRequest {
  @override
  final int expectedRevision;

  factory _$RegenerateGeneratedReportRequest(
          [void Function(RegenerateGeneratedReportRequestBuilder)? updates]) =>
      (new RegenerateGeneratedReportRequestBuilder()..update(updates))._build();

  _$RegenerateGeneratedReportRequest._({required this.expectedRevision})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(expectedRevision,
        r'RegenerateGeneratedReportRequest', 'expectedRevision');
  }

  @override
  RegenerateGeneratedReportRequest rebuild(
          void Function(RegenerateGeneratedReportRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegenerateGeneratedReportRequestBuilder toBuilder() =>
      new RegenerateGeneratedReportRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegenerateGeneratedReportRequest &&
        expectedRevision == other.expectedRevision;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegenerateGeneratedReportRequest')
          ..add('expectedRevision', expectedRevision))
        .toString();
  }
}

class RegenerateGeneratedReportRequestBuilder
    implements
        Builder<RegenerateGeneratedReportRequest,
            RegenerateGeneratedReportRequestBuilder> {
  _$RegenerateGeneratedReportRequest? _$v;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  RegenerateGeneratedReportRequestBuilder() {
    RegenerateGeneratedReportRequest._defaults(this);
  }

  RegenerateGeneratedReportRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedRevision = $v.expectedRevision;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegenerateGeneratedReportRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RegenerateGeneratedReportRequest;
  }

  @override
  void update(void Function(RegenerateGeneratedReportRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegenerateGeneratedReportRequest build() => _build();

  _$RegenerateGeneratedReportRequest _build() {
    final _$result = _$v ??
        new _$RegenerateGeneratedReportRequest._(
            expectedRevision: BuiltValueNullFieldError.checkNotNull(
                expectedRevision,
                r'RegenerateGeneratedReportRequest',
                'expectedRevision'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
