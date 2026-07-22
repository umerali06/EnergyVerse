//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_asset_request.g.dart';

/// CreateAssetRequest
///
/// Properties:
/// * [areaId]
/// * [assetTag]
/// * [category]
/// * [categoryOther]
/// * [currentStatus]
/// * [description]
/// * [facilityId]
/// * [gpsLat]
/// * [gpsLng]
/// * [installationDate]
/// * [manufacturer]
/// * [model]
/// * [name]
/// * [parentAssetId]
/// * [serialNumber]
@BuiltValue()
abstract class CreateAssetRequest
    implements Built<CreateAssetRequest, CreateAssetRequestBuilder> {
  @BuiltValueField(wireName: r'area_id')
  String? get areaId;

  @BuiltValueField(wireName: r'asset_tag')
  String get assetTag;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'category_other')
  String? get categoryOther;

  @BuiltValueField(wireName: r'current_status')
  CreateAssetRequestCurrentStatusEnum? get currentStatus;
  // enum currentStatusEnum {  Healthy,  Warning,  Critical,  };

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'facility_id')
  String get facilityId;

  @BuiltValueField(wireName: r'gps_lat')
  num? get gpsLat;

  @BuiltValueField(wireName: r'gps_lng')
  num? get gpsLng;

  @BuiltValueField(wireName: r'installation_date')
  Date? get installationDate;

  @BuiltValueField(wireName: r'manufacturer')
  String? get manufacturer;

  @BuiltValueField(wireName: r'model')
  String? get model;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'parent_asset_id')
  String? get parentAssetId;

  @BuiltValueField(wireName: r'serial_number')
  String? get serialNumber;

  CreateAssetRequest._();

  factory CreateAssetRequest([void updates(CreateAssetRequestBuilder b)]) =
      _$CreateAssetRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateAssetRequestBuilder b) =>
      b..currentStatus = const CreateAssetRequestCurrentStatusEnum._('Healthy');

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateAssetRequest> get serializer =>
      _$CreateAssetRequestSerializer();
}

class _$CreateAssetRequestSerializer
    implements PrimitiveSerializer<CreateAssetRequest> {
  @override
  final Iterable<Type> types = const [CreateAssetRequest, _$CreateAssetRequest];

  @override
  final String wireName = r'CreateAssetRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateAssetRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.areaId != null) {
      yield r'area_id';
      yield serializers.serialize(
        object.areaId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'asset_tag';
    yield serializers.serialize(
      object.assetTag,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    if (object.categoryOther != null) {
      yield r'category_other';
      yield serializers.serialize(
        object.categoryOther,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.currentStatus != null) {
      yield r'current_status';
      yield serializers.serialize(
        object.currentStatus,
        specifiedType: const FullType(CreateAssetRequestCurrentStatusEnum),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'facility_id';
    yield serializers.serialize(
      object.facilityId,
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
    if (object.installationDate != null) {
      yield r'installation_date';
      yield serializers.serialize(
        object.installationDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
    if (object.manufacturer != null) {
      yield r'manufacturer';
      yield serializers.serialize(
        object.manufacturer,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.model != null) {
      yield r'model';
      yield serializers.serialize(
        object.model,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.parentAssetId != null) {
      yield r'parent_asset_id';
      yield serializers.serialize(
        object.parentAssetId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.serialNumber != null) {
      yield r'serial_number';
      yield serializers.serialize(
        object.serialNumber,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateAssetRequest object, {
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
    required CreateAssetRequestBuilder result,
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
        case r'asset_tag':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetTag = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'category_other':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.categoryOther = valueDes;
          break;
        case r'current_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateAssetRequestCurrentStatusEnum),
          ) as CreateAssetRequestCurrentStatusEnum;
          result.currentStatus = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'facility_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.facilityId = valueDes;
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
        case r'installation_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.installationDate = valueDes;
          break;
        case r'manufacturer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.manufacturer = valueDes;
          break;
        case r'model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.model = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'parent_asset_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.parentAssetId = valueDes;
          break;
        case r'serial_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.serialNumber = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateAssetRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateAssetRequestBuilder();
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

class CreateAssetRequestCurrentStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Healthy')
  static const CreateAssetRequestCurrentStatusEnum healthy =
      _$createAssetRequestCurrentStatusEnum_healthy;
  @BuiltValueEnumConst(wireName: r'Warning')
  static const CreateAssetRequestCurrentStatusEnum warning =
      _$createAssetRequestCurrentStatusEnum_warning;
  @BuiltValueEnumConst(wireName: r'Critical')
  static const CreateAssetRequestCurrentStatusEnum critical =
      _$createAssetRequestCurrentStatusEnum_critical;

  static Serializer<CreateAssetRequestCurrentStatusEnum> get serializer =>
      _$createAssetRequestCurrentStatusEnumSerializer;

  const CreateAssetRequestCurrentStatusEnum._(String name) : super(name);

  static BuiltSet<CreateAssetRequestCurrentStatusEnum> get values =>
      _$createAssetRequestCurrentStatusEnumValues;
  static CreateAssetRequestCurrentStatusEnum valueOf(String name) =>
      _$createAssetRequestCurrentStatusEnumValueOf(name);
}
