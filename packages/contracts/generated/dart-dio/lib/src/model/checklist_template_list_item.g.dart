// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_template_list_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChecklistTemplateListItem extends ChecklistTemplateListItem {
  @override
  final String category;
  @override
  final DateTime createdAt;
  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime updatedAt;
  @override
  final int version;

  factory _$ChecklistTemplateListItem(
          [void Function(ChecklistTemplateListItemBuilder)? updates]) =>
      (new ChecklistTemplateListItemBuilder()..update(updates))._build();

  _$ChecklistTemplateListItem._(
      {required this.category,
      required this.createdAt,
      required this.id,
      required this.name,
      required this.updatedAt,
      required this.version})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        category, r'ChecklistTemplateListItem', 'category');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'ChecklistTemplateListItem', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        id, r'ChecklistTemplateListItem', 'id');
    BuiltValueNullFieldError.checkNotNull(
        name, r'ChecklistTemplateListItem', 'name');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'ChecklistTemplateListItem', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        version, r'ChecklistTemplateListItem', 'version');
  }

  @override
  ChecklistTemplateListItem rebuild(
          void Function(ChecklistTemplateListItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChecklistTemplateListItemBuilder toBuilder() =>
      new ChecklistTemplateListItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChecklistTemplateListItem &&
        category == other.category &&
        createdAt == other.createdAt &&
        id == other.id &&
        name == other.name &&
        updatedAt == other.updatedAt &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChecklistTemplateListItem')
          ..add('category', category)
          ..add('createdAt', createdAt)
          ..add('id', id)
          ..add('name', name)
          ..add('updatedAt', updatedAt)
          ..add('version', version))
        .toString();
  }
}

class ChecklistTemplateListItemBuilder
    implements
        Builder<ChecklistTemplateListItem, ChecklistTemplateListItemBuilder> {
  _$ChecklistTemplateListItem? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  ChecklistTemplateListItemBuilder() {
    ChecklistTemplateListItem._defaults(this);
  }

  ChecklistTemplateListItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _createdAt = $v.createdAt;
      _id = $v.id;
      _name = $v.name;
      _updatedAt = $v.updatedAt;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChecklistTemplateListItem other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChecklistTemplateListItem;
  }

  @override
  void update(void Function(ChecklistTemplateListItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChecklistTemplateListItem build() => _build();

  _$ChecklistTemplateListItem _build() {
    final _$result = _$v ??
        new _$ChecklistTemplateListItem._(
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'ChecklistTemplateListItem', 'category'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ChecklistTemplateListItem', 'createdAt'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ChecklistTemplateListItem', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'ChecklistTemplateListItem', 'name'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'ChecklistTemplateListItem', 'updatedAt'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'ChecklistTemplateListItem', 'version'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
