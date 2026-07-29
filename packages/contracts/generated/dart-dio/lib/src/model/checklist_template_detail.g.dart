// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_template_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChecklistTemplateDetail extends ChecklistTemplateDetail {
  @override
  final String category;
  @override
  final DateTime createdAt;
  @override
  final String? description;
  @override
  final String id;
  @override
  final BuiltList<ChecklistTemplateItem>? items;
  @override
  final String name;
  @override
  final DateTime updatedAt;
  @override
  final int version;

  factory _$ChecklistTemplateDetail(
          [void Function(ChecklistTemplateDetailBuilder)? updates]) =>
      (new ChecklistTemplateDetailBuilder()..update(updates))._build();

  _$ChecklistTemplateDetail._(
      {required this.category,
      required this.createdAt,
      this.description,
      required this.id,
      this.items,
      required this.name,
      required this.updatedAt,
      required this.version})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        category, r'ChecklistTemplateDetail', 'category');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'ChecklistTemplateDetail', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(id, r'ChecklistTemplateDetail', 'id');
    BuiltValueNullFieldError.checkNotNull(
        name, r'ChecklistTemplateDetail', 'name');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'ChecklistTemplateDetail', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        version, r'ChecklistTemplateDetail', 'version');
  }

  @override
  ChecklistTemplateDetail rebuild(
          void Function(ChecklistTemplateDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChecklistTemplateDetailBuilder toBuilder() =>
      new ChecklistTemplateDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChecklistTemplateDetail &&
        category == other.category &&
        createdAt == other.createdAt &&
        description == other.description &&
        id == other.id &&
        items == other.items &&
        name == other.name &&
        updatedAt == other.updatedAt &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChecklistTemplateDetail')
          ..add('category', category)
          ..add('createdAt', createdAt)
          ..add('description', description)
          ..add('id', id)
          ..add('items', items)
          ..add('name', name)
          ..add('updatedAt', updatedAt)
          ..add('version', version))
        .toString();
  }
}

class ChecklistTemplateDetailBuilder
    implements
        Builder<ChecklistTemplateDetail, ChecklistTemplateDetailBuilder> {
  _$ChecklistTemplateDetail? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ListBuilder<ChecklistTemplateItem>? _items;
  ListBuilder<ChecklistTemplateItem> get items =>
      _$this._items ??= new ListBuilder<ChecklistTemplateItem>();
  set items(ListBuilder<ChecklistTemplateItem>? items) => _$this._items = items;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  ChecklistTemplateDetailBuilder() {
    ChecklistTemplateDetail._defaults(this);
  }

  ChecklistTemplateDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _createdAt = $v.createdAt;
      _description = $v.description;
      _id = $v.id;
      _items = $v.items?.toBuilder();
      _name = $v.name;
      _updatedAt = $v.updatedAt;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChecklistTemplateDetail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChecklistTemplateDetail;
  }

  @override
  void update(void Function(ChecklistTemplateDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChecklistTemplateDetail build() => _build();

  _$ChecklistTemplateDetail _build() {
    _$ChecklistTemplateDetail _$result;
    try {
      _$result = _$v ??
          new _$ChecklistTemplateDetail._(
              category: BuiltValueNullFieldError.checkNotNull(
                  category, r'ChecklistTemplateDetail', 'category'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'ChecklistTemplateDetail', 'createdAt'),
              description: description,
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'ChecklistTemplateDetail', 'id'),
              items: _items?.build(),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'ChecklistTemplateDetail', 'name'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, r'ChecklistTemplateDetail', 'updatedAt'),
              version: BuiltValueNullFieldError.checkNotNull(
                  version, r'ChecklistTemplateDetail', 'version'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        _items?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ChecklistTemplateDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
