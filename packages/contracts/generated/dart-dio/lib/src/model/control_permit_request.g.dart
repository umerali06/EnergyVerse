// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'control_permit_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ControlPermitRequest extends ControlPermitRequest {
  @override
  final int expectedRevision;
  @override
  final String reason;

  factory _$ControlPermitRequest(
          [void Function(ControlPermitRequestBuilder)? updates]) =>
      (new ControlPermitRequestBuilder()..update(updates))._build();

  _$ControlPermitRequest._(
      {required this.expectedRevision, required this.reason})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        expectedRevision, r'ControlPermitRequest', 'expectedRevision');
    BuiltValueNullFieldError.checkNotNull(
        reason, r'ControlPermitRequest', 'reason');
  }

  @override
  ControlPermitRequest rebuild(
          void Function(ControlPermitRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ControlPermitRequestBuilder toBuilder() =>
      new ControlPermitRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ControlPermitRequest &&
        expectedRevision == other.expectedRevision &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ControlPermitRequest')
          ..add('expectedRevision', expectedRevision)
          ..add('reason', reason))
        .toString();
  }
}

class ControlPermitRequestBuilder
    implements Builder<ControlPermitRequest, ControlPermitRequestBuilder> {
  _$ControlPermitRequest? _$v;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ControlPermitRequestBuilder() {
    ControlPermitRequest._defaults(this);
  }

  ControlPermitRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedRevision = $v.expectedRevision;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ControlPermitRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ControlPermitRequest;
  }

  @override
  void update(void Function(ControlPermitRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ControlPermitRequest build() => _build();

  _$ControlPermitRequest _build() {
    final _$result = _$v ??
        new _$ControlPermitRequest._(
            expectedRevision: BuiltValueNullFieldError.checkNotNull(
                expectedRevision, r'ControlPermitRequest', 'expectedRevision'),
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'ControlPermitRequest', 'reason'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
