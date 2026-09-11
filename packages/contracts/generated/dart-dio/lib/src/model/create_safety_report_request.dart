//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_safety_report_request.g.dart';

/// CreateSafetyReportRequest
///
/// Properties:
/// * [category]
/// * [description]
/// * [gpsLat]
/// * [gpsLng]
/// * [id]
/// * [occurredAt]
/// * [severity]
/// * [title]
@BuiltValue()
abstract class CreateSafetyReportRequest
    implements
        Built<CreateSafetyReportRequest, CreateSafetyReportRequestBuilder> {
  @BuiltValueField(wireName: r'category')
  CreateSafetyReportRequestCategoryEnum get category;
  // enum categoryEnum {  near_miss,  unsafe_condition,  unsafe_behavior,  fire,  gas_leak,  chemical_spill,  environmental_incident,  equipment_failure,  injury,  };

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'gps_lat')
  num? get gpsLat;

  @BuiltValueField(wireName: r'gps_lng')
  num? get gpsLng;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'occurred_at')
  DateTime get occurredAt;

  @BuiltValueField(wireName: r'severity')
  CreateSafetyReportRequestSeverityEnum get severity;
  // enum severityEnum {  low,  medium,  high,  critical,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  CreateSafetyReportRequest._();

  factory CreateSafetyReportRequest(
          [void updates(CreateSafetyReportRequestBuilder b)]) =
      _$CreateSafetyReportRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateSafetyReportRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateSafetyReportRequest> get serializer =>
      _$CreateSafetyReportRequestSerializer();
}

class _$CreateSafetyReportRequestSerializer
    implements PrimitiveSerializer<CreateSafetyReportRequest> {
  @override
  final Iterable<Type> types = const [
    CreateSafetyReportRequest,
    _$CreateSafetyReportRequest
  ];

  @override
  final String wireName = r'CreateSafetyReportRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateSafetyReportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(CreateSafetyReportRequestCategoryEnum),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    if (object.gpsLat != null) {
      yield r'gps_lat';
      yield serializers.serialize(
        object.gpsLat,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.gpsLng != null) {
      yield r'gps_lng';
      yield serializers.serialize(
        object.gpsLng,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'occurred_at';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'severity';
    yield serializers.serialize(
      object.severity,
      specifiedType: const FullType(CreateSafetyReportRequestSeverityEnum),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateSafetyReportRequest object, {
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
    required CreateSafetyReportRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(CreateSafetyReportRequestCategoryEnum),
          ) as CreateSafetyReportRequestCategoryEnum;
          result.category = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'gps_lat':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.gpsLat = valueDes;
          break;
        case r'gps_lng':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.gpsLng = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'occurred_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.occurredAt = valueDes;
          break;
        case r'severity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(CreateSafetyReportRequestSeverityEnum),
          ) as CreateSafetyReportRequestSeverityEnum;
          result.severity = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  CreateSafetyReportRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateSafetyReportRequestBuilder();
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

class CreateSafetyReportRequestCategoryEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'near_miss')
  static const CreateSafetyReportRequestCategoryEnum nearMiss =
      _$createSafetyReportRequestCategoryEnum_nearMiss;
  @BuiltValueEnumConst(wireName: r'unsafe_condition')
  static const CreateSafetyReportRequestCategoryEnum unsafeCondition =
      _$createSafetyReportRequestCategoryEnum_unsafeCondition;
  @BuiltValueEnumConst(wireName: r'unsafe_behavior')
  static const CreateSafetyReportRequestCategoryEnum unsafeBehavior =
      _$createSafetyReportRequestCategoryEnum_unsafeBehavior;
  @BuiltValueEnumConst(wireName: r'fire')
  static const CreateSafetyReportRequestCategoryEnum fire =
      _$createSafetyReportRequestCategoryEnum_fire;
  @BuiltValueEnumConst(wireName: r'gas_leak')
  static const CreateSafetyReportRequestCategoryEnum gasLeak =
      _$createSafetyReportRequestCategoryEnum_gasLeak;
  @BuiltValueEnumConst(wireName: r'chemical_spill')
  static const CreateSafetyReportRequestCategoryEnum chemicalSpill =
      _$createSafetyReportRequestCategoryEnum_chemicalSpill;
  @BuiltValueEnumConst(wireName: r'environmental_incident')
  static const CreateSafetyReportRequestCategoryEnum environmentalIncident =
      _$createSafetyReportRequestCategoryEnum_environmentalIncident;
  @BuiltValueEnumConst(wireName: r'equipment_failure')
  static const CreateSafetyReportRequestCategoryEnum equipmentFailure =
      _$createSafetyReportRequestCategoryEnum_equipmentFailure;
  @BuiltValueEnumConst(wireName: r'injury')
  static const CreateSafetyReportRequestCategoryEnum injury =
      _$createSafetyReportRequestCategoryEnum_injury;

  static Serializer<CreateSafetyReportRequestCategoryEnum> get serializer =>
      _$createSafetyReportRequestCategoryEnumSerializer;

  const CreateSafetyReportRequestCategoryEnum._(String name) : super(name);

  static BuiltSet<CreateSafetyReportRequestCategoryEnum> get values =>
      _$createSafetyReportRequestCategoryEnumValues;
  static CreateSafetyReportRequestCategoryEnum valueOf(String name) =>
      _$createSafetyReportRequestCategoryEnumValueOf(name);
}

class CreateSafetyReportRequestSeverityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'low')
  static const CreateSafetyReportRequestSeverityEnum low =
      _$createSafetyReportRequestSeverityEnum_low;
  @BuiltValueEnumConst(wireName: r'medium')
  static const CreateSafetyReportRequestSeverityEnum medium =
      _$createSafetyReportRequestSeverityEnum_medium;
  @BuiltValueEnumConst(wireName: r'high')
  static const CreateSafetyReportRequestSeverityEnum high =
      _$createSafetyReportRequestSeverityEnum_high;
  @BuiltValueEnumConst(wireName: r'critical')
  static const CreateSafetyReportRequestSeverityEnum critical =
      _$createSafetyReportRequestSeverityEnum_critical;

  static Serializer<CreateSafetyReportRequestSeverityEnum> get serializer =>
      _$createSafetyReportRequestSeverityEnumSerializer;

  const CreateSafetyReportRequestSeverityEnum._(String name) : super(name);

  static BuiltSet<CreateSafetyReportRequestSeverityEnum> get values =>
      _$createSafetyReportRequestSeverityEnumValues;
  static CreateSafetyReportRequestSeverityEnum valueOf(String name) =>
      _$createSafetyReportRequestSeverityEnumValueOf(name);
}
