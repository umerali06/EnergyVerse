// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_approval_template_step_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermitApprovalTemplateStepResponse
    extends PermitApprovalTemplateStepResponse {
  @override
  final String approverRoleId;
  @override
  final String id;
  @override
  final String label;
  @override
  final bool required_;

  factory _$PermitApprovalTemplateStepResponse(
          [void Function(PermitApprovalTemplateStepResponseBuilder)?
              updates]) =>
      (new PermitApprovalTemplateStepResponseBuilder()..update(updates))
          ._build();

  _$PermitApprovalTemplateStepResponse._(
      {required this.approverRoleId,
      required this.id,
      required this.label,
      required this.required_})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(approverRoleId,
        r'PermitApprovalTemplateStepResponse', 'approverRoleId');
    BuiltValueNullFieldError.checkNotNull(
        id, r'PermitApprovalTemplateStepResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        label, r'PermitApprovalTemplateStepResponse', 'label');
    BuiltValueNullFieldError.checkNotNull(
        required_, r'PermitApprovalTemplateStepResponse', 'required_');
  }

  @override
  PermitApprovalTemplateStepResponse rebuild(
          void Function(PermitApprovalTemplateStepResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitApprovalTemplateStepResponseBuilder toBuilder() =>
      new PermitApprovalTemplateStepResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitApprovalTemplateStepResponse &&
        approverRoleId == other.approverRoleId &&
        id == other.id &&
        label == other.label &&
        required_ == other.required_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, approverRoleId.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, required_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermitApprovalTemplateStepResponse')
          ..add('approverRoleId', approverRoleId)
          ..add('id', id)
          ..add('label', label)
          ..add('required_', required_))
        .toString();
  }
}

class PermitApprovalTemplateStepResponseBuilder
    implements
        Builder<PermitApprovalTemplateStepResponse,
            PermitApprovalTemplateStepResponseBuilder> {
  _$PermitApprovalTemplateStepResponse? _$v;

  String? _approverRoleId;
  String? get approverRoleId => _$this._approverRoleId;
  set approverRoleId(String? approverRoleId) =>
      _$this._approverRoleId = approverRoleId;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _required_;
  bool? get required_ => _$this._required_;
  set required_(bool? required_) => _$this._required_ = required_;

  PermitApprovalTemplateStepResponseBuilder() {
    PermitApprovalTemplateStepResponse._defaults(this);
  }

  PermitApprovalTemplateStepResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _approverRoleId = $v.approverRoleId;
      _id = $v.id;
      _label = $v.label;
      _required_ = $v.required_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitApprovalTemplateStepResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitApprovalTemplateStepResponse;
  }

  @override
  void update(
      void Function(PermitApprovalTemplateStepResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitApprovalTemplateStepResponse build() => _build();

  _$PermitApprovalTemplateStepResponse _build() {
    final _$result = _$v ??
        new _$PermitApprovalTemplateStepResponse._(
            approverRoleId: BuiltValueNullFieldError.checkNotNull(
                approverRoleId,
                r'PermitApprovalTemplateStepResponse',
                'approverRoleId'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PermitApprovalTemplateStepResponse', 'id'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'PermitApprovalTemplateStepResponse', 'label'),
            required_: BuiltValueNullFieldError.checkNotNull(
                required_, r'PermitApprovalTemplateStepResponse', 'required_'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
