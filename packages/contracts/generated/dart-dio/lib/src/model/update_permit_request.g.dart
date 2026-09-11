// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_permit_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdatePermitRequest extends UpdatePermitRequest {
  @override
  final String? description;
  @override
  final int expectedRevision;
  @override
  final BuiltList<PermitRiskAssessmentInput>? riskAssessment;
  @override
  final String? title;
  @override
  final DateTime? validFrom;
  @override
  final DateTime? validUntil;
  @override
  final BuiltList<String>? workerIds;

  factory _$UpdatePermitRequest(
          [void Function(UpdatePermitRequestBuilder)? updates]) =>
      (new UpdatePermitRequestBuilder()..update(updates))._build();

  _$UpdatePermitRequest._(
      {this.description,
      required this.expectedRevision,
      this.riskAssessment,
      this.title,
      this.validFrom,
      this.validUntil,
      this.workerIds})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        expectedRevision, r'UpdatePermitRequest', 'expectedRevision');
  }

  @override
  UpdatePermitRequest rebuild(
          void Function(UpdatePermitRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdatePermitRequestBuilder toBuilder() =>
      new UpdatePermitRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdatePermitRequest &&
        description == other.description &&
        expectedRevision == other.expectedRevision &&
        riskAssessment == other.riskAssessment &&
        title == other.title &&
        validFrom == other.validFrom &&
        validUntil == other.validUntil &&
        workerIds == other.workerIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, riskAssessment.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, validFrom.hashCode);
    _$hash = $jc(_$hash, validUntil.hashCode);
    _$hash = $jc(_$hash, workerIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdatePermitRequest')
          ..add('description', description)
          ..add('expectedRevision', expectedRevision)
          ..add('riskAssessment', riskAssessment)
          ..add('title', title)
          ..add('validFrom', validFrom)
          ..add('validUntil', validUntil)
          ..add('workerIds', workerIds))
        .toString();
  }
}

class UpdatePermitRequestBuilder
    implements Builder<UpdatePermitRequest, UpdatePermitRequestBuilder> {
  _$UpdatePermitRequest? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  ListBuilder<PermitRiskAssessmentInput>? _riskAssessment;
  ListBuilder<PermitRiskAssessmentInput> get riskAssessment =>
      _$this._riskAssessment ??= new ListBuilder<PermitRiskAssessmentInput>();
  set riskAssessment(ListBuilder<PermitRiskAssessmentInput>? riskAssessment) =>
      _$this._riskAssessment = riskAssessment;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  DateTime? _validFrom;
  DateTime? get validFrom => _$this._validFrom;
  set validFrom(DateTime? validFrom) => _$this._validFrom = validFrom;

  DateTime? _validUntil;
  DateTime? get validUntil => _$this._validUntil;
  set validUntil(DateTime? validUntil) => _$this._validUntil = validUntil;

  ListBuilder<String>? _workerIds;
  ListBuilder<String> get workerIds =>
      _$this._workerIds ??= new ListBuilder<String>();
  set workerIds(ListBuilder<String>? workerIds) =>
      _$this._workerIds = workerIds;

  UpdatePermitRequestBuilder() {
    UpdatePermitRequest._defaults(this);
  }

  UpdatePermitRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _expectedRevision = $v.expectedRevision;
      _riskAssessment = $v.riskAssessment?.toBuilder();
      _title = $v.title;
      _validFrom = $v.validFrom;
      _validUntil = $v.validUntil;
      _workerIds = $v.workerIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdatePermitRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdatePermitRequest;
  }

  @override
  void update(void Function(UpdatePermitRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdatePermitRequest build() => _build();

  _$UpdatePermitRequest _build() {
    _$UpdatePermitRequest _$result;
    try {
      _$result = _$v ??
          new _$UpdatePermitRequest._(
              description: description,
              expectedRevision: BuiltValueNullFieldError.checkNotNull(
                  expectedRevision, r'UpdatePermitRequest', 'expectedRevision'),
              riskAssessment: _riskAssessment?.build(),
              title: title,
              validFrom: validFrom,
              validUntil: validUntil,
              workerIds: _workerIds?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'riskAssessment';
        _riskAssessment?.build();

        _$failedField = 'workerIds';
        _workerIds?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UpdatePermitRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
