//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_generated_report_request.g.dart';

/// CreateGeneratedReportRequest
///
/// Properties:
/// * [id]
/// * [reportType]
/// * [sourceId]
/// * [title]
@BuiltValue()
abstract class CreateGeneratedReportRequest
    implements
        Built<CreateGeneratedReportRequest,
            CreateGeneratedReportRequestBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'report_type')
  CreateGeneratedReportRequestReportTypeEnum get reportType;
  // enum reportTypeEnum {  inspection,  maintenance,  safety,  executive_summary,  asset_health,  };

  @BuiltValueField(wireName: r'source_id')
  String? get sourceId;

  @BuiltValueField(wireName: r'title')
  String? get title;

  CreateGeneratedReportRequest._();

  factory CreateGeneratedReportRequest(
          [void updates(CreateGeneratedReportRequestBuilder b)]) =
      _$CreateGeneratedReportRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateGeneratedReportRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateGeneratedReportRequest> get serializer =>
      _$CreateGeneratedReportRequestSerializer();
}

class _$CreateGeneratedReportRequestSerializer
    implements PrimitiveSerializer<CreateGeneratedReportRequest> {
  @override
  final Iterable<Type> types = const [
    CreateGeneratedReportRequest,
    _$CreateGeneratedReportRequest
  ];

  @override
  final String wireName = r'CreateGeneratedReportRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateGeneratedReportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'report_type';
    yield serializers.serialize(
      object.reportType,
      specifiedType: const FullType(CreateGeneratedReportRequestReportTypeEnum),
    );
    if (object.sourceId != null) {
      yield r'source_id';
      yield serializers.serialize(
        object.sourceId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateGeneratedReportRequest object, {
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
    required CreateGeneratedReportRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
                const FullType(CreateGeneratedReportRequestReportTypeEnum),
          ) as CreateGeneratedReportRequestReportTypeEnum;
          result.reportType = valueDes;
          break;
        case r'source_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sourceId = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateGeneratedReportRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateGeneratedReportRequestBuilder();
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

class CreateGeneratedReportRequestReportTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'inspection')
  static const CreateGeneratedReportRequestReportTypeEnum inspection =
      _$createGeneratedReportRequestReportTypeEnum_inspection;
  @BuiltValueEnumConst(wireName: r'maintenance')
  static const CreateGeneratedReportRequestReportTypeEnum maintenance =
      _$createGeneratedReportRequestReportTypeEnum_maintenance;
  @BuiltValueEnumConst(wireName: r'safety')
  static const CreateGeneratedReportRequestReportTypeEnum safety =
      _$createGeneratedReportRequestReportTypeEnum_safety;
  @BuiltValueEnumConst(wireName: r'executive_summary')
  static const CreateGeneratedReportRequestReportTypeEnum executiveSummary =
      _$createGeneratedReportRequestReportTypeEnum_executiveSummary;
  @BuiltValueEnumConst(wireName: r'asset_health')
  static const CreateGeneratedReportRequestReportTypeEnum assetHealth =
      _$createGeneratedReportRequestReportTypeEnum_assetHealth;

  static Serializer<CreateGeneratedReportRequestReportTypeEnum>
      get serializer => _$createGeneratedReportRequestReportTypeEnumSerializer;

  const CreateGeneratedReportRequestReportTypeEnum._(String name) : super(name);

  static BuiltSet<CreateGeneratedReportRequestReportTypeEnum> get values =>
      _$createGeneratedReportRequestReportTypeEnumValues;
  static CreateGeneratedReportRequestReportTypeEnum valueOf(String name) =>
      _$createGeneratedReportRequestReportTypeEnumValueOf(name);
}
