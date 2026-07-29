// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_checklist_template_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateChecklistTemplateRequest extends CreateChecklistTemplateRequest {
  @override
  final String category;
  @override
  final String? description;
  @override
  final BuiltList<ChecklistTemplateItemInput>? items;
  @override
  final String name;

  factory _$CreateChecklistTemplateRequest(
          [void Function(CreateChecklistTemplateRequestBuilder)? updates]) =>
      (new CreateChecklistTemplateRequestBuilder()..update(updates))._build();

  _$CreateChecklistTemplateRequest._(
      {required this.category,
      this.description,
      this.items,
      required this.name})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        category, r'CreateChecklistTemplateRequest', 'category');
    BuiltValueNullFieldError.checkNotNull(
        name, r'CreateChecklistTemplateRequest', 'name');
  }

  @override
  CreateChecklistTemplateRequest rebuild(
          void Function(CreateChecklistTemplateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateChecklistTemplateRequestBuilder toBuilder() =>
      new CreateChecklistTemplateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateChecklistTemplateRequest &&
        category == other.category &&
        description == other.description &&
        items == other.items &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateChecklistTemplateRequest')
          ..add('category', category)
          ..add('description', description)
          ..add('items', items)
          ..add('name', name))
        .toString();
  }
}

class CreateChecklistTemplateRequestBuilder
    implements
        Builder<CreateChecklistTemplateRequest,
            CreateChecklistTemplateRequestBuilder> {
  _$CreateChecklistTemplateRequest? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  ListBuilder<ChecklistTemplateItemInput>? _items;
  ListBuilder<ChecklistTemplateItemInput> get items =>
      _$this._items ??= new ListBuilder<ChecklistTemplateItemInput>();
  set items(ListBuilder<ChecklistTemplateItemInput>? items) =>
      _$this._items = items;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  CreateChecklistTemplateRequestBuilder() {
    CreateChecklistTemplateRequest._defaults(this);
  }

  CreateChecklistTemplateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _description = $v.description;
      _items = $v.items?.toBuilder();
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateChecklistTemplateRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateChecklistTemplateRequest;
  }

  @override
  void update(void Function(CreateChecklistTemplateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateChecklistTemplateRequest build() => _build();

  _$CreateChecklistTemplateRequest _build() {
    _$CreateChecklistTemplateRequest _$result;
    try {
      _$result = _$v ??
          new _$CreateChecklistTemplateRequest._(
              category: BuiltValueNullFieldError.checkNotNull(
                  category, r'CreateChecklistTemplateRequest', 'category'),
              description: description,
              items: _items?.build(),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'CreateChecklistTemplateRequest', 'name'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        _items?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CreateChecklistTemplateRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
