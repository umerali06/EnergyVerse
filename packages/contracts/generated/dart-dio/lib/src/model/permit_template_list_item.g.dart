// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_template_list_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PermitTemplateListItemPermitTypeEnum
    _$permitTemplateListItemPermitTypeEnum_hotWork =
    const PermitTemplateListItemPermitTypeEnum._('hotWork');
const PermitTemplateListItemPermitTypeEnum
    _$permitTemplateListItemPermitTypeEnum_confinedSpace =
    const PermitTemplateListItemPermitTypeEnum._('confinedSpace');
const PermitTemplateListItemPermitTypeEnum
    _$permitTemplateListItemPermitTypeEnum_electricalIsolationLoto =
    const PermitTemplateListItemPermitTypeEnum._('electricalIsolationLoto');
const PermitTemplateListItemPermitTypeEnum
    _$permitTemplateListItemPermitTypeEnum_excavation =
    const PermitTemplateListItemPermitTypeEnum._('excavation');
const PermitTemplateListItemPermitTypeEnum
    _$permitTemplateListItemPermitTypeEnum_workingAtHeight =
    const PermitTemplateListItemPermitTypeEnum._('workingAtHeight');
const PermitTemplateListItemPermitTypeEnum
    _$permitTemplateListItemPermitTypeEnum_generalMaintenance =
    const PermitTemplateListItemPermitTypeEnum._('generalMaintenance');

PermitTemplateListItemPermitTypeEnum
    _$permitTemplateListItemPermitTypeEnumValueOf(String name) {
  switch (name) {
    case 'hotWork':
      return _$permitTemplateListItemPermitTypeEnum_hotWork;
    case 'confinedSpace':
      return _$permitTemplateListItemPermitTypeEnum_confinedSpace;
    case 'electricalIsolationLoto':
      return _$permitTemplateListItemPermitTypeEnum_electricalIsolationLoto;
    case 'excavation':
      return _$permitTemplateListItemPermitTypeEnum_excavation;
    case 'workingAtHeight':
      return _$permitTemplateListItemPermitTypeEnum_workingAtHeight;
    case 'generalMaintenance':
      return _$permitTemplateListItemPermitTypeEnum_generalMaintenance;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<PermitTemplateListItemPermitTypeEnum>
    _$permitTemplateListItemPermitTypeEnumValues = new BuiltSet<
        PermitTemplateListItemPermitTypeEnum>(const <PermitTemplateListItemPermitTypeEnum>[
  _$permitTemplateListItemPermitTypeEnum_hotWork,
  _$permitTemplateListItemPermitTypeEnum_confinedSpace,
  _$permitTemplateListItemPermitTypeEnum_electricalIsolationLoto,
  _$permitTemplateListItemPermitTypeEnum_excavation,
  _$permitTemplateListItemPermitTypeEnum_workingAtHeight,
  _$permitTemplateListItemPermitTypeEnum_generalMaintenance,
]);

Serializer<PermitTemplateListItemPermitTypeEnum>
    _$permitTemplateListItemPermitTypeEnumSerializer =
    new _$PermitTemplateListItemPermitTypeEnumSerializer();

class _$PermitTemplateListItemPermitTypeEnumSerializer
    implements PrimitiveSerializer<PermitTemplateListItemPermitTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'hotWork': 'hot_work',
    'confinedSpace': 'confined_space',
    'electricalIsolationLoto': 'electrical_isolation_loto',
    'excavation': 'excavation',
    'workingAtHeight': 'working_at_height',
    'generalMaintenance': 'general_maintenance',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'hot_work': 'hotWork',
    'confined_space': 'confinedSpace',
    'electrical_isolation_loto': 'electricalIsolationLoto',
    'excavation': 'excavation',
    'working_at_height': 'workingAtHeight',
    'general_maintenance': 'generalMaintenance',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PermitTemplateListItemPermitTypeEnum
  ];
  @override
  final String wireName = 'PermitTemplateListItemPermitTypeEnum';

  @override
  Object serialize(
          Serializers serializers, PermitTemplateListItemPermitTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PermitTemplateListItemPermitTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PermitTemplateListItemPermitTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PermitTemplateListItem extends PermitTemplateListItem {
  @override
  final DateTime createdAt;
  @override
  final String id;
  @override
  final String name;
  @override
  final PermitTemplateListItemPermitTypeEnum permitType;
  @override
  final DateTime updatedAt;
  @override
  final int version;

  factory _$PermitTemplateListItem(
          [void Function(PermitTemplateListItemBuilder)? updates]) =>
      (new PermitTemplateListItemBuilder()..update(updates))._build();

  _$PermitTemplateListItem._(
      {required this.createdAt,
      required this.id,
      required this.name,
      required this.permitType,
      required this.updatedAt,
      required this.version})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'PermitTemplateListItem', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(id, r'PermitTemplateListItem', 'id');
    BuiltValueNullFieldError.checkNotNull(
        name, r'PermitTemplateListItem', 'name');
    BuiltValueNullFieldError.checkNotNull(
        permitType, r'PermitTemplateListItem', 'permitType');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'PermitTemplateListItem', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        version, r'PermitTemplateListItem', 'version');
  }

  @override
  PermitTemplateListItem rebuild(
          void Function(PermitTemplateListItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitTemplateListItemBuilder toBuilder() =>
      new PermitTemplateListItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitTemplateListItem &&
        createdAt == other.createdAt &&
        id == other.id &&
        name == other.name &&
        permitType == other.permitType &&
        updatedAt == other.updatedAt &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, permitType.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermitTemplateListItem')
          ..add('createdAt', createdAt)
          ..add('id', id)
          ..add('name', name)
          ..add('permitType', permitType)
          ..add('updatedAt', updatedAt)
          ..add('version', version))
        .toString();
  }
}

class PermitTemplateListItemBuilder
    implements Builder<PermitTemplateListItem, PermitTemplateListItemBuilder> {
  _$PermitTemplateListItem? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  PermitTemplateListItemPermitTypeEnum? _permitType;
  PermitTemplateListItemPermitTypeEnum? get permitType => _$this._permitType;
  set permitType(PermitTemplateListItemPermitTypeEnum? permitType) =>
      _$this._permitType = permitType;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  PermitTemplateListItemBuilder() {
    PermitTemplateListItem._defaults(this);
  }

  PermitTemplateListItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _id = $v.id;
      _name = $v.name;
      _permitType = $v.permitType;
      _updatedAt = $v.updatedAt;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitTemplateListItem other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitTemplateListItem;
  }

  @override
  void update(void Function(PermitTemplateListItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitTemplateListItem build() => _build();

  _$PermitTemplateListItem _build() {
    final _$result = _$v ??
        new _$PermitTemplateListItem._(
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'PermitTemplateListItem', 'createdAt'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PermitTemplateListItem', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'PermitTemplateListItem', 'name'),
            permitType: BuiltValueNullFieldError.checkNotNull(
                permitType, r'PermitTemplateListItem', 'permitType'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'PermitTemplateListItem', 'updatedAt'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'PermitTemplateListItem', 'version'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
