// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_work_order_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssignWorkOrderRequest extends AssignWorkOrderRequest {
  @override
  final DateTime? dueDate;
  @override
  final int? expectedRevision;
  @override
  final String technicianId;

  factory _$AssignWorkOrderRequest(
          [void Function(AssignWorkOrderRequestBuilder)? updates]) =>
      (new AssignWorkOrderRequestBuilder()..update(updates))._build();

  _$AssignWorkOrderRequest._(
      {this.dueDate, this.expectedRevision, required this.technicianId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        technicianId, r'AssignWorkOrderRequest', 'technicianId');
  }

  @override
  AssignWorkOrderRequest rebuild(
          void Function(AssignWorkOrderRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssignWorkOrderRequestBuilder toBuilder() =>
      new AssignWorkOrderRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssignWorkOrderRequest &&
        dueDate == other.dueDate &&
        expectedRevision == other.expectedRevision &&
        technicianId == other.technicianId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dueDate.hashCode);
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, technicianId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssignWorkOrderRequest')
          ..add('dueDate', dueDate)
          ..add('expectedRevision', expectedRevision)
          ..add('technicianId', technicianId))
        .toString();
  }
}

class AssignWorkOrderRequestBuilder
    implements Builder<AssignWorkOrderRequest, AssignWorkOrderRequestBuilder> {
  _$AssignWorkOrderRequest? _$v;

  DateTime? _dueDate;
  DateTime? get dueDate => _$this._dueDate;
  set dueDate(DateTime? dueDate) => _$this._dueDate = dueDate;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  String? _technicianId;
  String? get technicianId => _$this._technicianId;
  set technicianId(String? technicianId) => _$this._technicianId = technicianId;

  AssignWorkOrderRequestBuilder() {
    AssignWorkOrderRequest._defaults(this);
  }

  AssignWorkOrderRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dueDate = $v.dueDate;
      _expectedRevision = $v.expectedRevision;
      _technicianId = $v.technicianId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssignWorkOrderRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AssignWorkOrderRequest;
  }

  @override
  void update(void Function(AssignWorkOrderRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssignWorkOrderRequest build() => _build();

  _$AssignWorkOrderRequest _build() {
    final _$result = _$v ??
        new _$AssignWorkOrderRequest._(
            dueDate: dueDate,
            expectedRevision: expectedRevision,
            technicianId: BuiltValueNullFieldError.checkNotNull(
                technicianId, r'AssignWorkOrderRequest', 'technicianId'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
