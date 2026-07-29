// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_template_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChecklistTemplateItemItemTypeEnum
    _$checklistTemplateItemItemTypeEnum_boolean =
    const ChecklistTemplateItemItemTypeEnum._('boolean');
const ChecklistTemplateItemItemTypeEnum
    _$checklistTemplateItemItemTypeEnum_numeric =
    const ChecklistTemplateItemItemTypeEnum._('numeric');
const ChecklistTemplateItemItemTypeEnum
    _$checklistTemplateItemItemTypeEnum_text =
    const ChecklistTemplateItemItemTypeEnum._('text');
const ChecklistTemplateItemItemTypeEnum
    _$checklistTemplateItemItemTypeEnum_select =
    const ChecklistTemplateItemItemTypeEnum._('select');

ChecklistTemplateItemItemTypeEnum _$checklistTemplateItemItemTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'boolean':
      return _$checklistTemplateItemItemTypeEnum_boolean;
    case 'numeric':
      return _$checklistTemplateItemItemTypeEnum_numeric;
    case 'text':
      return _$checklistTemplateItemItemTypeEnum_text;
    case 'select':
      return _$checklistTemplateItemItemTypeEnum_select;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ChecklistTemplateItemItemTypeEnum>
    _$checklistTemplateItemItemTypeEnumValues = new BuiltSet<
        ChecklistTemplateItemItemTypeEnum>(const <ChecklistTemplateItemItemTypeEnum>[
  _$checklistTemplateItemItemTypeEnum_boolean,
  _$checklistTemplateItemItemTypeEnum_numeric,
  _$checklistTemplateItemItemTypeEnum_text,
  _$checklistTemplateItemItemTypeEnum_select,
]);

Serializer<ChecklistTemplateItemItemTypeEnum>
    _$checklistTemplateItemItemTypeEnumSerializer =
    new _$ChecklistTemplateItemItemTypeEnumSerializer();

class _$ChecklistTemplateItemItemTypeEnumSerializer
    implements PrimitiveSerializer<ChecklistTemplateItemItemTypeEnum> {
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
  final Iterable<Type> types = const <Type>[ChecklistTemplateItemItemTypeEnum];
  @override
  final String wireName = 'ChecklistTemplateItemItemTypeEnum';

  @override
  Object serialize(
          Serializers serializers, ChecklistTemplateItemItemTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChecklistTemplateItemItemTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChecklistTemplateItemItemTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChecklistTemplateItem extends ChecklistTemplateItem {
  @override
  final String? helpText;
  @override
  final String id;
  @override
  final ChecklistTemplateItemItemTypeEnum itemType;
  @override
  final String label;
  @override
  final BuiltList<String>? options;
  @override
  final bool required_;

  factory _$ChecklistTemplateItem(
          [void Function(ChecklistTemplateItemBuilder)? updates]) =>
      (new ChecklistTemplateItemBuilder()..update(updates))._build();

  _$ChecklistTemplateItem._(
      {this.helpText,
      required this.id,
      required this.itemType,
      required this.label,
      this.options,
      required this.required_})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'ChecklistTemplateItem', 'id');
    BuiltValueNullFieldError.checkNotNull(
        itemType, r'ChecklistTemplateItem', 'itemType');
    BuiltValueNullFieldError.checkNotNull(
        label, r'ChecklistTemplateItem', 'label');
    BuiltValueNullFieldError.checkNotNull(
        required_, r'ChecklistTemplateItem', 'required_');
  }

  @override
  ChecklistTemplateItem rebuild(
          void Function(ChecklistTemplateItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChecklistTemplateItemBuilder toBuilder() =>
      new ChecklistTemplateItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChecklistTemplateItem &&
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
    return (newBuiltValueToStringHelper(r'ChecklistTemplateItem')
          ..add('helpText', helpText)
          ..add('id', id)
          ..add('itemType', itemType)
          ..add('label', label)
          ..add('options', options)
          ..add('required_', required_))
        .toString();
  }
}

class ChecklistTemplateItemBuilder
    implements Builder<ChecklistTemplateItem, ChecklistTemplateItemBuilder> {
  _$ChecklistTemplateItem? _$v;

  String? _helpText;
  String? get helpText => _$this._helpText;
  set helpText(String? helpText) => _$this._helpText = helpText;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ChecklistTemplateItemItemTypeEnum? _itemType;
  ChecklistTemplateItemItemTypeEnum? get itemType => _$this._itemType;
  set itemType(ChecklistTemplateItemItemTypeEnum? itemType) =>
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

  ChecklistTemplateItemBuilder() {
    ChecklistTemplateItem._defaults(this);
  }

  ChecklistTemplateItemBuilder get _$this {
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
  void replace(ChecklistTemplateItem other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChecklistTemplateItem;
  }

  @override
  void update(void Function(ChecklistTemplateItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChecklistTemplateItem build() => _build();

  _$ChecklistTemplateItem _build() {
    _$ChecklistTemplateItem _$result;
    try {
      _$result = _$v ??
          new _$ChecklistTemplateItem._(
              helpText: helpText,
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'ChecklistTemplateItem', 'id'),
              itemType: BuiltValueNullFieldError.checkNotNull(
                  itemType, r'ChecklistTemplateItem', 'itemType'),
              label: BuiltValueNullFieldError.checkNotNull(
                  label, r'ChecklistTemplateItem', 'label'),
              options: _options?.build(),
              required_: BuiltValueNullFieldError.checkNotNull(
                  required_, r'ChecklistTemplateItem', 'required_'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        _options?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ChecklistTemplateItem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
