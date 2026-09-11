// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_checklist_template_item_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermitChecklistTemplateItemResponse
    extends PermitChecklistTemplateItemResponse {
  @override
  final String? helpText;
  @override
  final String id;
  @override
  final String label;
  @override
  final bool required_;

  factory _$PermitChecklistTemplateItemResponse(
          [void Function(PermitChecklistTemplateItemResponseBuilder)?
              updates]) =>
      (new PermitChecklistTemplateItemResponseBuilder()..update(updates))
          ._build();

  _$PermitChecklistTemplateItemResponse._(
      {this.helpText,
      required this.id,
      required this.label,
      required this.required_})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        id, r'PermitChecklistTemplateItemResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        label, r'PermitChecklistTemplateItemResponse', 'label');
    BuiltValueNullFieldError.checkNotNull(
        required_, r'PermitChecklistTemplateItemResponse', 'required_');
  }

  @override
  PermitChecklistTemplateItemResponse rebuild(
          void Function(PermitChecklistTemplateItemResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitChecklistTemplateItemResponseBuilder toBuilder() =>
      new PermitChecklistTemplateItemResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitChecklistTemplateItemResponse &&
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
    return (newBuiltValueToStringHelper(r'PermitChecklistTemplateItemResponse')
          ..add('helpText', helpText)
          ..add('id', id)
          ..add('label', label)
          ..add('required_', required_))
        .toString();
  }
}

class PermitChecklistTemplateItemResponseBuilder
    implements
        Builder<PermitChecklistTemplateItemResponse,
            PermitChecklistTemplateItemResponseBuilder> {
  _$PermitChecklistTemplateItemResponse? _$v;

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

  PermitChecklistTemplateItemResponseBuilder() {
    PermitChecklistTemplateItemResponse._defaults(this);
  }

  PermitChecklistTemplateItemResponseBuilder get _$this {
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
  void replace(PermitChecklistTemplateItemResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitChecklistTemplateItemResponse;
  }

  @override
  void update(
      void Function(PermitChecklistTemplateItemResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitChecklistTemplateItemResponse build() => _build();

  _$PermitChecklistTemplateItemResponse _build() {
    final _$result = _$v ??
        new _$PermitChecklistTemplateItemResponse._(
            helpText: helpText,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PermitChecklistTemplateItemResponse', 'id'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'PermitChecklistTemplateItemResponse', 'label'),
            required_: BuiltValueNullFieldError.checkNotNull(required_,
                r'PermitChecklistTemplateItemResponse', 'required_'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
