// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_checklist_template_item_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermitChecklistTemplateItemInput
    extends PermitChecklistTemplateItemInput {
  @override
  final String? helpText;
  @override
  final String? id;
  @override
  final String label;
  @override
  final bool? required_;

  factory _$PermitChecklistTemplateItemInput(
          [void Function(PermitChecklistTemplateItemInputBuilder)? updates]) =>
      (new PermitChecklistTemplateItemInputBuilder()..update(updates))._build();

  _$PermitChecklistTemplateItemInput._(
      {this.helpText, this.id, required this.label, this.required_})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        label, r'PermitChecklistTemplateItemInput', 'label');
  }

  @override
  PermitChecklistTemplateItemInput rebuild(
          void Function(PermitChecklistTemplateItemInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitChecklistTemplateItemInputBuilder toBuilder() =>
      new PermitChecklistTemplateItemInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitChecklistTemplateItemInput &&
        helpText == other.helpText &&
        id == other.id &&
        label == other.label &&
        required_ == other.required_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, helpText.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, required_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermitChecklistTemplateItemInput')
          ..add('helpText', helpText)
          ..add('id', id)
          ..add('label', label)
          ..add('required_', required_))
        .toString();
  }
}

class PermitChecklistTemplateItemInputBuilder
    implements
        Builder<PermitChecklistTemplateItemInput,
            PermitChecklistTemplateItemInputBuilder> {
  _$PermitChecklistTemplateItemInput? _$v;

  String? _helpText;
  String? get helpText => _$this._helpText;
  set helpText(String? helpText) => _$this._helpText = helpText;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _required_;
  bool? get required_ => _$this._required_;
  set required_(bool? required_) => _$this._required_ = required_;

  PermitChecklistTemplateItemInputBuilder() {
    PermitChecklistTemplateItemInput._defaults(this);
  }

  PermitChecklistTemplateItemInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _helpText = $v.helpText;
      _id = $v.id;
      _label = $v.label;
      _required_ = $v.required_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitChecklistTemplateItemInput other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitChecklistTemplateItemInput;
  }

  @override
  void update(void Function(PermitChecklistTemplateItemInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitChecklistTemplateItemInput build() => _build();

  _$PermitChecklistTemplateItemInput _build() {
    final _$result = _$v ??
        new _$PermitChecklistTemplateItemInput._(
            helpText: helpText,
            id: id,
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'PermitChecklistTemplateItemInput', 'label'),
            required_: required_);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
