// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_safety_report_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssignSafetyReportRequest extends AssignSafetyReportRequest {
  @override
  final int? expectedRevision;
  @override
  final String managerId;

  factory _$AssignSafetyReportRequest(
          [void Function(AssignSafetyReportRequestBuilder)? updates]) =>
      (new AssignSafetyReportRequestBuilder()..update(updates))._build();

  _$AssignSafetyReportRequest._(
      {this.expectedRevision, required this.managerId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        managerId, r'AssignSafetyReportRequest', 'managerId');
  }

  @override
  AssignSafetyReportRequest rebuild(
          void Function(AssignSafetyReportRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssignSafetyReportRequestBuilder toBuilder() =>
      new AssignSafetyReportRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssignSafetyReportRequest &&
        expectedRevision == other.expectedRevision &&
        managerId == other.managerId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, managerId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssignSafetyReportRequest')
          ..add('expectedRevision', expectedRevision)
          ..add('managerId', managerId))
        .toString();
  }
}

class AssignSafetyReportRequestBuilder
    implements
        Builder<AssignSafetyReportRequest, AssignSafetyReportRequestBuilder> {
  _$AssignSafetyReportRequest? _$v;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  String? _managerId;
  String? get managerId => _$this._managerId;
  set managerId(String? managerId) => _$this._managerId = managerId;

  AssignSafetyReportRequestBuilder() {
    AssignSafetyReportRequest._defaults(this);
  }

  AssignSafetyReportRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedRevision = $v.expectedRevision;
      _managerId = $v.managerId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssignSafetyReportRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AssignSafetyReportRequest;
  }

  @override
  void update(void Function(AssignSafetyReportRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssignSafetyReportRequest build() => _build();

  _$AssignSafetyReportRequest _build() {
    final _$result = _$v ??
        new _$AssignSafetyReportRequest._(
            expectedRevision: expectedRevision,
            managerId: BuiltValueNullFieldError.checkNotNull(
                managerId, r'AssignSafetyReportRequest', 'managerId'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
