//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_inspection_request.g.dart';

/// CreateInspectionRequest
///
/// Properties:
/// * [assetId]
/// * [clientCreatedAt]
/// * [deviceId]
/// * [gpsLat]
/// * [gpsLng]
/// * [id]
/// * [inspectionType]
/// * [notes]
/// * [origin]
/// * [title]
@BuiltValue()
abstract class CreateInspectionRequest
    implements Built<CreateInspectionRequest, CreateInspectionRequestBuilder> {
  @BuiltValueField(wireName: r'asset_id')
  String get assetId;

  @BuiltValueField(wireName: r'client_created_at')
  DateTime get clientCreatedAt;

  @BuiltValueField(wireName: r'device_id')
  String? get deviceId;

  @BuiltValueField(wireName: r'gps_lat')
  num? get gpsLat;

  @BuiltValueField(wireName: r'gps_lng')
  num? get gpsLng;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'inspection_type')
  CreateInspectionRequestInspectionTypeEnum get inspectionType;
  // enum inspectionTypeEnum {  routine,  scheduled,  ad_hoc,  };

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  @BuiltValueField(wireName: r'origin')
  String? get origin;

  @BuiltValueField(wireName: r'title')
  String? get title;

  CreateInspectionRequest._();

  factory CreateInspectionRequest(
          [void updates(CreateInspectionRequestBuilder b)]) =
      _$CreateInspectionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateInspectionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateInspectionRequest> get serializer =>
      _$CreateInspectionRequestSerializer();
}

class _$CreateInspectionRequestSerializer
    implements PrimitiveSerializer<CreateInspectionRequest> {
  @override
  final Iterable<Type> types = const [
    CreateInspectionRequest,
    _$CreateInspectionRequest
  ];

  @override
  final String wireName = r'CreateInspectionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateInspectionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'asset_id';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'client_created_at';
    yield serializers.serialize(
      object.clientCreatedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.deviceId != null) {
      yield r'device_id';
      yield serializers.serialize(
        object.deviceId,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    yield r'inspection_type';
    yield serializers.serialize(
      object.inspectionType,
      specifiedType: const FullType(CreateInspectionRequestInspectionTypeEnum),
    );
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.origin != null) {
      yield r'origin';
      yield serializers.serialize(
        object.origin,
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
    CreateInspectionRequest object, {
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
    required CreateInspectionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'asset_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetId = valueDes;
          break;
        case r'client_created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.clientCreatedAt = valueDes;
          break;
        case r'device_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.deviceId = valueDes;
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
        case r'inspection_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(CreateInspectionRequestInspectionTypeEnum),
          ) as CreateInspectionRequestInspectionTypeEnum;
          result.inspectionType = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.origin = valueDes;
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
  CreateInspectionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateInspectionRequestBuilder();
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

class CreateInspectionRequestInspectionTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'routine')
  static const CreateInspectionRequestInspectionTypeEnum routine =
      _$createInspectionRequestInspectionTypeEnum_routine;
  @BuiltValueEnumConst(wireName: r'scheduled')
  static const CreateInspectionRequestInspectionTypeEnum scheduled =
      _$createInspectionRequestInspectionTypeEnum_scheduled;
  @BuiltValueEnumConst(wireName: r'ad_hoc')
  static const CreateInspectionRequestInspectionTypeEnum adHoc =
      _$createInspectionRequestInspectionTypeEnum_adHoc;

  static Serializer<CreateInspectionRequestInspectionTypeEnum> get serializer =>
      _$createInspectionRequestInspectionTypeEnumSerializer;

  const CreateInspectionRequestInspectionTypeEnum._(String name) : super(name);

  static BuiltSet<CreateInspectionRequestInspectionTypeEnum> get values =>
      _$createInspectionRequestInspectionTypeEnumValues;
  static CreateInspectionRequestInspectionTypeEnum valueOf(String name) =>
      _$createInspectionRequestInspectionTypeEnumValueOf(name);
}
