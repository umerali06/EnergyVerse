// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_checklist_template_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateChecklistTemplateRequest extends UpdateChecklistTemplateRequest {
  @override
  final String? category;
  @override
  final String? description;
  @override
  final BuiltList<ChecklistTemplateItemInput>? items;
  @override
  final String? name;

  factory _$UpdateChecklistTemplateRequest(
          [void Function(UpdateChecklistTemplateRequestBuilder)? updates]) =>
      (new UpdateChecklistTemplateRequestBuilder()..update(updates))._build();

  _$UpdateChecklistTemplateRequest._(
      {this.category, this.description, this.items, this.name})
      : super._();

  @override
  UpdateChecklistTemplateRequest rebuild(
          void Function(UpdateChecklistTemplateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateChecklistTemplateRequestBuilder toBuilder() =>
      new UpdateChecklistTemplateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateChecklistTemplateRequest &&
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
    return (newBuiltValueToStringHelper(r'UpdateChecklistTemplateRequest')
          ..add('category', category)
          ..add('description', description)
          ..add('items', items)
          ..add('name', name))
        .toString();
  }
}

class UpdateChecklistTemplateRequestBuilder
    implements
        Builder<UpdateChecklistTemplateRequest,
            UpdateChecklistTemplateRequestBuilder> {
  _$UpdateChecklistTemplateRequest? _$v;

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

  UpdateChecklistTemplateRequestBuilder() {
    UpdateChecklistTemplateRequest._defaults(this);
  }

  UpdateChecklistTemplateRequestBuilder get _$this {
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
  void replace(UpdateChecklistTemplateRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateChecklistTemplateRequest;
  }

  @override
  void update(void Function(UpdateChecklistTemplateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateChecklistTemplateRequest build() => _build();

  _$UpdateChecklistTemplateRequest _build() {
    _$UpdateChecklistTemplateRequest _$result;
    try {
      _$result = _$v ??
          new _$UpdateChecklistTemplateRequest._(
              category: category,
              description: description,
              items: _items?.build(),
              name: name);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        _items?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UpdateChecklistTemplateRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
