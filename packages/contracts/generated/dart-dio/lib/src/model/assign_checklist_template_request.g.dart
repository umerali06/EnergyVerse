// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_checklist_template_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssignChecklistTemplateRequest extends AssignChecklistTemplateRequest {
  @override
  final String checklistTemplateId;
  @override
  final int? expectedRevision;

  factory _$AssignChecklistTemplateRequest(
          [void Function(AssignChecklistTemplateRequestBuilder)? updates]) =>
      (new AssignChecklistTemplateRequestBuilder()..update(updates))._build();

  _$AssignChecklistTemplateRequest._(
      {required this.checklistTemplateId, this.expectedRevision})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(checklistTemplateId,
        r'AssignChecklistTemplateRequest', 'checklistTemplateId');
  }

  @override
  AssignChecklistTemplateRequest rebuild(
          void Function(AssignChecklistTemplateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssignChecklistTemplateRequestBuilder toBuilder() =>
      new AssignChecklistTemplateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssignChecklistTemplateRequest &&
        checklistTemplateId == other.checklistTemplateId &&
        expectedRevision == other.expectedRevision;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, checklistTemplateId.hashCode);
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssignChecklistTemplateRequest')
          ..add('checklistTemplateId', checklistTemplateId)
          ..add('expectedRevision', expectedRevision))
        .toString();
  }
}

class AssignChecklistTemplateRequestBuilder
    implements
        Builder<AssignChecklistTemplateRequest,
            AssignChecklistTemplateRequestBuilder> {
  _$AssignChecklistTemplateRequest? _$v;

  String? _checklistTemplateId;
  String? get checklistTemplateId => _$this._checklistTemplateId;
  set checklistTemplateId(String? checklistTemplateId) =>
      _$this._checklistTemplateId = checklistTemplateId;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  AssignChecklistTemplateRequestBuilder() {
    AssignChecklistTemplateRequest._defaults(this);
  }

  AssignChecklistTemplateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _checklistTemplateId = $v.checklistTemplateId;
      _expectedRevision = $v.expectedRevision;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssignChecklistTemplateRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AssignChecklistTemplateRequest;
  }

  @override
  void update(void Function(AssignChecklistTemplateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssignChecklistTemplateRequest build() => _build();

  _$AssignChecklistTemplateRequest _build() {
    final _$result = _$v ??
        new _$AssignChecklistTemplateRequest._(
            checklistTemplateId: BuiltValueNullFieldError.checkNotNull(
                checklistTemplateId,
                r'AssignChecklistTemplateRequest',
                'checklistTemplateId'),
            expectedRevision: expectedRevision);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
