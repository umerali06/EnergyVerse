//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'generated_report_list_item.g.dart';

/// GeneratedReportListItem
///
/// Properties:
/// * [createdAt]
/// * [createdBy]
/// * [finalizedAt]
/// * [finalizedBy]
/// * [id]
/// * [reportType]
/// * [revision]
/// * [sourceId]
/// * [status]
/// * [title]
/// * [updatedAt]
@BuiltValue()
abstract class GeneratedReportListItem
    implements Built<GeneratedReportListItem, GeneratedReportListItemBuilder> {
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'created_by')
  String get createdBy;

  @BuiltValueField(wireName: r'finalized_at')
  DateTime? get finalizedAt;

  @BuiltValueField(wireName: r'finalized_by')
  String? get finalizedBy;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'report_type')
  GeneratedReportListItemReportTypeEnum get reportType;
  // enum reportTypeEnum {  inspection,  maintenance,  safety,  executive_summary,  asset_health,  };

  @BuiltValueField(wireName: r'revision')
  int get revision;

  @BuiltValueField(wireName: r'source_id')
  String? get sourceId;

  @BuiltValueField(wireName: r'status')
  GeneratedReportListItemStatusEnum get status;
  // enum statusEnum {  draft,  finalized,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  GeneratedReportListItem._();

  factory GeneratedReportListItem(
          [void updates(GeneratedReportListItemBuilder b)]) =
      _$GeneratedReportListItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeneratedReportListItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeneratedReportListItem> get serializer =>
      _$GeneratedReportListItemSerializer();
}

class _$GeneratedReportListItemSerializer
    implements PrimitiveSerializer<GeneratedReportListItem> {
  @override
  final Iterable<Type> types = const [
    GeneratedReportListItem,
    _$GeneratedReportListItem
  ];

  @override
  final String wireName = r'GeneratedReportListItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeneratedReportListItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'created_by';
    yield serializers.serialize(
      object.createdBy,
      specifiedType: const FullType(String),
    );
    if (object.finalizedAt != null) {
      yield r'finalized_at';
      yield serializers.serialize(
        object.finalizedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.finalizedBy != null) {
      yield r'finalized_by';
      yield serializers.serialize(
        object.finalizedBy,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'report_type';
    yield serializers.serialize(
      object.reportType,
      specifiedType: const FullType(GeneratedReportListItemReportTypeEnum),
    );
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(int),
    );
    if (object.sourceId != null) {
      yield r'source_id';
      yield serializers.serialize(
        object.sourceId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(GeneratedReportListItemStatusEnum),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeneratedReportListItem object, {
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
    required GeneratedReportListItemBuilder result,
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
        case r'created_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdBy = valueDes;
          break;
        case r'finalized_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.finalizedAt = valueDes;
          break;
        case r'finalized_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.finalizedBy = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'report_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(GeneratedReportListItemReportTypeEnum),
          ) as GeneratedReportListItemReportTypeEnum;
          result.reportType = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.revision = valueDes;
          break;
        case r'source_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sourceId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeneratedReportListItemStatusEnum),
          ) as GeneratedReportListItemStatusEnum;
          result.status = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  GeneratedReportListItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeneratedReportListItemBuilder();
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

class GeneratedReportListItemReportTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'inspection')
  static const GeneratedReportListItemReportTypeEnum inspection =
      _$generatedReportListItemReportTypeEnum_inspection;
  @BuiltValueEnumConst(wireName: r'maintenance')
  static const GeneratedReportListItemReportTypeEnum maintenance =
      _$generatedReportListItemReportTypeEnum_maintenance;
  @BuiltValueEnumConst(wireName: r'safety')
  static const GeneratedReportListItemReportTypeEnum safety =
      _$generatedReportListItemReportTypeEnum_safety;
  @BuiltValueEnumConst(wireName: r'executive_summary')
  static const GeneratedReportListItemReportTypeEnum executiveSummary =
      _$generatedReportListItemReportTypeEnum_executiveSummary;
  @BuiltValueEnumConst(wireName: r'asset_health')
  static const GeneratedReportListItemReportTypeEnum assetHealth =
      _$generatedReportListItemReportTypeEnum_assetHealth;

  static Serializer<GeneratedReportListItemReportTypeEnum> get serializer =>
      _$generatedReportListItemReportTypeEnumSerializer;

  const GeneratedReportListItemReportTypeEnum._(String name) : super(name);

  static BuiltSet<GeneratedReportListItemReportTypeEnum> get values =>
      _$generatedReportListItemReportTypeEnumValues;
  static GeneratedReportListItemReportTypeEnum valueOf(String name) =>
      _$generatedReportListItemReportTypeEnumValueOf(name);
}

class GeneratedReportListItemStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const GeneratedReportListItemStatusEnum draft =
      _$generatedReportListItemStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'finalized')
  static const GeneratedReportListItemStatusEnum finalized =
      _$generatedReportListItemStatusEnum_finalized;

  static Serializer<GeneratedReportListItemStatusEnum> get serializer =>
      _$generatedReportListItemStatusEnumSerializer;

  const GeneratedReportListItemStatusEnum._(String name) : super(name);

  static BuiltSet<GeneratedReportListItemStatusEnum> get values =>
      _$generatedReportListItemStatusEnumValues;
  static GeneratedReportListItemStatusEnum valueOf(String name) =>
      _$generatedReportListItemStatusEnumValueOf(name);
}
