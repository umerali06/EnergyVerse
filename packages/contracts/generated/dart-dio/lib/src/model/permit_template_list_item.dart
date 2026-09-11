//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_template_list_item.g.dart';

/// PermitTemplateListItem
///
/// Properties:
/// * [createdAt]
/// * [id]
/// * [name]
/// * [permitType]
/// * [updatedAt]
/// * [version]
@BuiltValue()
abstract class PermitTemplateListItem
    implements Built<PermitTemplateListItem, PermitTemplateListItemBuilder> {
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'permit_type')
  PermitTemplateListItemPermitTypeEnum get permitType;
  // enum permitTypeEnum {  hot_work,  confined_space,  electrical_isolation_loto,  excavation,  working_at_height,  general_maintenance,  };

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'version')
  int get version;

  PermitTemplateListItem._();

  factory PermitTemplateListItem(
          [void updates(PermitTemplateListItemBuilder b)]) =
      _$PermitTemplateListItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitTemplateListItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitTemplateListItem> get serializer =>
      _$PermitTemplateListItemSerializer();
}

class _$PermitTemplateListItemSerializer
    implements PrimitiveSerializer<PermitTemplateListItem> {
  @override
  final Iterable<Type> types = const [
    PermitTemplateListItem,
    _$PermitTemplateListItem
  ];

  @override
  final String wireName = r'PermitTemplateListItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitTemplateListItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'permit_type';
    yield serializers.serialize(
      object.permitType,
      specifiedType: const FullType(PermitTemplateListItemPermitTypeEnum),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PermitTemplateListItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PermitTemplateListItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'permit_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PermitTemplateListItemPermitTypeEnum),
          ) as PermitTemplateListItemPermitTypeEnum;
          result.permitType = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PermitTemplateListItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitTemplateListItemBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class PermitTemplateListItemPermitTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'hot_work')
  static const PermitTemplateListItemPermitTypeEnum hotWork =
      _$permitTemplateListItemPermitTypeEnum_hotWork;
  @BuiltValueEnumConst(wireName: r'confined_space')
  static const PermitTemplateListItemPermitTypeEnum confinedSpace =
      _$permitTemplateListItemPermitTypeEnum_confinedSpace;
  @BuiltValueEnumConst(wireName: r'electrical_isolation_loto')
  static const PermitTemplateListItemPermitTypeEnum electricalIsolationLoto =
      _$permitTemplateListItemPermitTypeEnum_electricalIsolationLoto;
  @BuiltValueEnumConst(wireName: r'excavation')
  static const PermitTemplateListItemPermitTypeEnum excavation =
      _$permitTemplateListItemPermitTypeEnum_excavation;
  @BuiltValueEnumConst(wireName: r'working_at_height')
  static const PermitTemplateListItemPermitTypeEnum workingAtHeight =
      _$permitTemplateListItemPermitTypeEnum_workingAtHeight;
  @BuiltValueEnumConst(wireName: r'general_maintenance')
  static const PermitTemplateListItemPermitTypeEnum generalMaintenance =
      _$permitTemplateListItemPermitTypeEnum_generalMaintenance;

  static Serializer<PermitTemplateListItemPermitTypeEnum> get serializer =>
      _$permitTemplateListItemPermitTypeEnumSerializer;

  const PermitTemplateListItemPermitTypeEnum._(String name) : super(name);

  static BuiltSet<PermitTemplateListItemPermitTypeEnum> get values =>
      _$permitTemplateListItemPermitTypeEnumValues;
  static PermitTemplateListItemPermitTypeEnum valueOf(String name) =>
      _$permitTemplateListItemPermitTypeEnumValueOf(name);
}
