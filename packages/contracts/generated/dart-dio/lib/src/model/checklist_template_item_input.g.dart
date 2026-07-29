// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_template_item_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChecklistTemplateItemInputItemTypeEnum
    _$checklistTemplateItemInputItemTypeEnum_boolean =
    const ChecklistTemplateItemInputItemTypeEnum._('boolean');
const ChecklistTemplateItemInputItemTypeEnum
    _$checklistTemplateItemInputItemTypeEnum_numeric =
    const ChecklistTemplateItemInputItemTypeEnum._('numeric');
const ChecklistTemplateItemInputItemTypeEnum
    _$checklistTemplateItemInputItemTypeEnum_text =
    const ChecklistTemplateItemInputItemTypeEnum._('text');
const ChecklistTemplateItemInputItemTypeEnum
    _$checklistTemplateItemInputItemTypeEnum_select =
    const ChecklistTemplateItemInputItemTypeEnum._('select');

ChecklistTemplateItemInputItemTypeEnum
    _$checklistTemplateItemInputItemTypeEnumValueOf(String name) {
  switch (name) {
    case 'boolean':
      return _$checklistTemplateItemInputItemTypeEnum_boolean;
    case 'numeric':
      return _$checklistTemplateItemInputItemTypeEnum_numeric;
    case 'text':
      return _$checklistTemplateItemInputItemTypeEnum_text;
    case 'select':
      return _$checklistTemplateItemInputItemTypeEnum_select;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ChecklistTemplateItemInputItemTypeEnum>
    _$checklistTemplateItemInputItemTypeEnumValues = new BuiltSet<
        ChecklistTemplateItemInputItemTypeEnum>(const <ChecklistTemplateItemInputItemTypeEnum>[
  _$checklistTemplateItemInputItemTypeEnum_boolean,
  _$checklistTemplateItemInputItemTypeEnum_numeric,
  _$checklistTemplateItemInputItemTypeEnum_text,
  _$checklistTemplateItemInputItemTypeEnum_select,
]);

Serializer<ChecklistTemplateItemInputItemTypeEnum>
    _$checklistTemplateItemInputItemTypeEnumSerializer =
    new _$ChecklistTemplateItemInputItemTypeEnumSerializer();

class _$ChecklistTemplateItemInputItemTypeEnumSerializer
    implements PrimitiveSerializer<ChecklistTemplateItemInputItemTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'boolean': 'boolean',
    'numeric': 'numeric',
    'text': 'text',
    'select': 'select',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'boolean': 'boolean',
    'numeric': 'numeric',
    'text': 'text',
    'select': 'select',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ChecklistTemplateItemInputItemTypeEnum
  ];
  @override
  final String wireName = 'ChecklistTemplateItemInputItemTypeEnum';

  @override
  Object serialize(Serializers serializers,
          ChecklistTemplateItemInputItemTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChecklistTemplateItemInputItemTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChecklistTemplateItemInputItemTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChecklistTemplateItemInput extends ChecklistTemplateItemInput {
  @override
  final String? helpText;
  @override
  final String? id;
  @override
  final ChecklistTemplateItemInputItemTypeEnum itemType;
  @override
  final String label;
  @override
  final BuiltList<String>? options;
  @override
  final bool? required_;

  factory _$ChecklistTemplateItemInput(
          [void Function(ChecklistTemplateItemInputBuilder)? updates]) =>
      (new ChecklistTemplateItemInputBuilder()..update(updates))._build();

  _$ChecklistTemplateItemInput._(
      {this.helpText,
      this.id,
      required this.itemType,
      required this.label,
      this.options,
      this.required_})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        itemType, r'ChecklistTemplateItemInput', 'itemType');
    BuiltValueNullFieldError.checkNotNull(
        label, r'ChecklistTemplateItemInput', 'label');
  }

  @override
  ChecklistTemplateItemInput rebuild(
          void Function(ChecklistTemplateItemInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChecklistTemplateItemInputBuilder toBuilder() =>
      new ChecklistTemplateItemInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChecklistTemplateItemInput &&
        helpText == other.helpText &&
        id == other.id &&
        itemType == other.itemType &&
        label == other.label &&
        options == other.options &&
        required_ == other.required_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, helpText.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, itemType.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jc(_$hash, required_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChecklistTemplateItemInput')
          ..add('helpText', helpText)
          ..add('id', id)
          ..add('itemType', itemType)
          ..add('label', label)
          ..add('options', options)
          ..add('required_', required_))
        .toString();
  }
}

class ChecklistTemplateItemInputBuilder
    implements
        Builder<ChecklistTemplateItemInput, ChecklistTemplateItemInputBuilder> {
  _$ChecklistTemplateItemInput? _$v;

  String? _helpText;
  String? get helpText => _$this._helpText;
  set helpText(String? helpText) => _$this._helpText = helpText;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ChecklistTemplateItemInputItemTypeEnum? _itemType;
  ChecklistTemplateItemInputItemTypeEnum? get itemType => _$this._itemType;
  set itemType(ChecklistTemplateItemInputItemTypeEnum? itemType) =>
      _$this._itemType = itemType;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  ListBuilder<String>? _options;
  ListBuilder<String> get options =>
      _$this._options ??= new ListBuilder<String>();
  set options(ListBuilder<String>? options) => _$this._options = options;

  bool? _required_;
  bool? get required_ => _$this._required_;
  set required_(bool? required_) => _$this._required_ = required_;

  ChecklistTemplateItemInputBuilder() {
    ChecklistTemplateItemInput._defaults(this);
  }

  ChecklistTemplateItemInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _helpText = $v.helpText;
      _id = $v.id;
      _itemType = $v.itemType;
      _label = $v.label;
      _options = $v.options?.toBuilder();
      _required_ = $v.required_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChecklistTemplateItemInput other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChecklistTemplateItemInput;
  }

  @override
  void update(void Function(ChecklistTemplateItemInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChecklistTemplateItemInput build() => _build();

  _$ChecklistTemplateItemInput _build() {
    _$ChecklistTemplateItemInput _$result;
    try {
      _$result = _$v ??
          new _$ChecklistTemplateItemInput._(
              helpText: helpText,
              id: id,
              itemType: BuiltValueNullFieldError.checkNotNull(
                  itemType, r'ChecklistTemplateItemInput', 'itemType'),
              label: BuiltValueNullFieldError.checkNotNull(
                  label, r'ChecklistTemplateItemInput', 'label'),
              options: _options?.build(),
              required_: required_);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        _options?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ChecklistTemplateItemInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
