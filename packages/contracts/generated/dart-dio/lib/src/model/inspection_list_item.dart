//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inspection_list_item.g.dart';

/// InspectionListItem
///
/// Properties:
/// * [areaId]
/// * [assetId]
/// * [checklistTemplateId]
/// * [completedAt]
/// * [createdAt]
/// * [facilityId]
/// * [id]
/// * [inspectionType]
/// * [inspectorId]
/// * [revision]
/// * [startedAt]
/// * [status]
/// * [title]
/// * [updatedAt]
@BuiltValue()
abstract class InspectionListItem
    implements Built<InspectionListItem, InspectionListItemBuilder> {
  @BuiltValueField(wireName: r'area_id')
  String? get areaId;

  @BuiltValueField(wireName: r'asset_id')
  String get assetId;

  @BuiltValueField(wireName: r'checklist_template_id')
  String? get checklistTemplateId;

  @BuiltValueField(wireName: r'completed_at')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'facility_id')
  String get facilityId;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'inspection_type')
  InspectionListItemInspectionTypeEnum get inspectionType;
  // enum inspectionTypeEnum {  routine,  scheduled,  ad_hoc,  };

  @BuiltValueField(wireName: r'inspector_id')
  String get inspectorId;

  @BuiltValueField(wireName: r'revision')
  int get revision;

  @BuiltValueField(wireName: r'started_at')
  DateTime? get startedAt;

  @BuiltValueField(wireName: r'status')
  InspectionListItemStatusEnum get status;
  // enum statusEnum {  draft,  in_progress,  completed,  cancelled,  };

  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  InspectionListItem._();

  factory InspectionListItem([void updates(InspectionListItemBuilder b)]) =
      _$InspectionListItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InspectionListItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InspectionListItem> get serializer =>
      _$InspectionListItemSerializer();
}

class _$InspectionListItemSerializer
    implements PrimitiveSerializer<InspectionListItem> {
  @override
  final Iterable<Type> types = const [InspectionListItem, _$InspectionListItem];

  @override
  final String wireName = r'InspectionListItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InspectionListItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.areaId != null) {
      yield r'area_id';
      yield serializers.serialize(
        object.areaId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'asset_id';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    if (object.checklistTemplateId != null) {
      yield r'checklist_template_id';
      yield serializers.serialize(
        object.checklistTemplateId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.completedAt != null) {
      yield r'completed_at';
      yield serializers.serialize(
        object.completedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'facility_id';
    yield serializers.serialize(
      object.facilityId,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'inspection_type';
    yield serializers.serialize(
      object.inspectionType,
      specifiedType: const FullType(InspectionListItemInspectionTypeEnum),
    );
    yield r'inspector_id';
    yield serializers.serialize(
      object.inspectorId,
      specifiedType: const FullType(String),
    );
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(int),
    );
    if (object.startedAt != null) {
      yield r'started_at';
      yield serializers.serialize(
        object.startedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(InspectionListItemStatusEnum),
    );
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InspectionListItem object, {
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
    required InspectionListItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'area_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.areaId = valueDes;
          break;
        case r'asset_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetId = valueDes;
          break;
        case r'checklist_template_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.checklistTemplateId = valueDes;
          break;
        case r'completed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.completedAt = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'facility_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.facilityId = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'inspection_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InspectionListItemInspectionTypeEnum),
          ) as InspectionListItemInspectionTypeEnum;
          result.inspectionType = valueDes;
          break;
        case r'inspector_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.inspectorId = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.revision = valueDes;
          break;
        case r'started_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.startedAt = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InspectionListItemStatusEnum),
          ) as InspectionListItemStatusEnum;
          result.status = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InspectionListItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InspectionListItemBuilder();
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

class InspectionListItemInspectionTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'routine')
  static const InspectionListItemInspectionTypeEnum routine =
      _$inspectionListItemInspectionTypeEnum_routine;
  @BuiltValueEnumConst(wireName: r'scheduled')
  static const InspectionListItemInspectionTypeEnum scheduled =
      _$inspectionListItemInspectionTypeEnum_scheduled;
  @BuiltValueEnumConst(wireName: r'ad_hoc')
  static const InspectionListItemInspectionTypeEnum adHoc =
      _$inspectionListItemInspectionTypeEnum_adHoc;

  static Serializer<InspectionListItemInspectionTypeEnum> get serializer =>
      _$inspectionListItemInspectionTypeEnumSerializer;

  const InspectionListItemInspectionTypeEnum._(String name) : super(name);

  static BuiltSet<InspectionListItemInspectionTypeEnum> get values =>
      _$inspectionListItemInspectionTypeEnumValues;
  static InspectionListItemInspectionTypeEnum valueOf(String name) =>
      _$inspectionListItemInspectionTypeEnumValueOf(name);
}

class InspectionListItemStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const InspectionListItemStatusEnum draft =
      _$inspectionListItemStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const InspectionListItemStatusEnum inProgress =
      _$inspectionListItemStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'completed')
  static const InspectionListItemStatusEnum completed =
      _$inspectionListItemStatusEnum_completed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const InspectionListItemStatusEnum cancelled =
      _$inspectionListItemStatusEnum_cancelled;

  static Serializer<InspectionListItemStatusEnum> get serializer =>
      _$inspectionListItemStatusEnumSerializer;

  const InspectionListItemStatusEnum._(String name) : super(name);

  static BuiltSet<InspectionListItemStatusEnum> get values =>
      _$inspectionListItemStatusEnumValues;
  static InspectionListItemStatusEnum valueOf(String name) =>
      _$inspectionListItemStatusEnumValueOf(name);
}
