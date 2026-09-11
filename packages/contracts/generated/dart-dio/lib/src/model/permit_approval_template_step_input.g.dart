// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_approval_template_step_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermitApprovalTemplateStepInput
    extends PermitApprovalTemplateStepInput {
  @override
  final String approverRoleId;
  @override
  final String? id;
  @override
  final String label;
  @override
  final bool? required_;

  factory _$PermitApprovalTemplateStepInput(
          [void Function(PermitApprovalTemplateStepInputBuilder)? updates]) =>
      (new PermitApprovalTemplateStepInputBuilder()..update(updates))._build();

  _$PermitApprovalTemplateStepInput._(
      {required this.approverRoleId,
      this.id,
      required this.label,
      this.required_})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        approverRoleId, r'PermitApprovalTemplateStepInput', 'approverRoleId');
    BuiltValueNullFieldError.checkNotNull(
        label, r'PermitApprovalTemplateStepInput', 'label');
  }

  @override
  PermitApprovalTemplateStepInput rebuild(
          void Function(PermitApprovalTemplateStepInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitApprovalTemplateStepInputBuilder toBuilder() =>
      new PermitApprovalTemplateStepInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitApprovalTemplateStepInput &&
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
    return (newBuiltValueToStringHelper(r'PermitApprovalTemplateStepInput')
          ..add('approverRoleId', approverRoleId)
          ..add('id', id)
          ..add('label', label)
          ..add('required_', required_))
        .toString();
  }
}

class PermitApprovalTemplateStepInputBuilder
    implements
        Builder<PermitApprovalTemplateStepInput,
            PermitApprovalTemplateStepInputBuilder> {
  _$PermitApprovalTemplateStepInput? _$v;

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

  PermitApprovalTemplateStepInputBuilder() {
    PermitApprovalTemplateStepInput._defaults(this);
  }

  PermitApprovalTemplateStepInputBuilder get _$this {
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
  void replace(PermitApprovalTemplateStepInput other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitApprovalTemplateStepInput;
  }

  @override
  void update(void Function(PermitApprovalTemplateStepInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitApprovalTemplateStepInput build() => _build();

  _$PermitApprovalTemplateStepInput _build() {
    final _$result = _$v ??
        new _$PermitApprovalTemplateStepInput._(
            approverRoleId: BuiltValueNullFieldError.checkNotNull(
                approverRoleId,
                r'PermitApprovalTemplateStepInput',
                'approverRoleId'),
            id: id,
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'PermitApprovalTemplateStepInput', 'label'),
            required_: required_);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
