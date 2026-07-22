//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_asset_request.g.dart';

/// UpdateAssetRequest
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
abstract class UpdateAssetRequest
    implements Built<UpdateAssetRequest, UpdateAssetRequestBuilder> {
  @BuiltValueField(wireName: r'area_id')
  String? get areaId;

  @BuiltValueField(wireName: r'asset_tag')
  String? get assetTag;

  @BuiltValueField(wireName: r'category')
  String? get category;

  @BuiltValueField(wireName: r'category_other')
  String? get categoryOther;

  @BuiltValueField(wireName: r'current_status')
  UpdateAssetRequestCurrentStatusEnum? get currentStatus;
  // enum currentStatusEnum {  Healthy,  Warning,  Critical,  };

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'facility_id')
  String? get facilityId;

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
  String? get name;

  @BuiltValueField(wireName: r'parent_asset_id')
  String? get parentAssetId;

  @BuiltValueField(wireName: r'serial_number')
  String? get serialNumber;

  UpdateAssetRequest._();

  factory UpdateAssetRequest([void updates(UpdateAssetRequestBuilder b)]) =
      _$UpdateAssetRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateAssetRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateAssetRequest> get serializer =>
      _$UpdateAssetRequestSerializer();
}

class _$UpdateAssetRequestSerializer
    implements PrimitiveSerializer<UpdateAssetRequest> {
  @override
  final Iterable<Type> types = const [UpdateAssetRequest, _$UpdateAssetRequest];

  @override
  final String wireName = r'UpdateAssetRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateAssetRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.areaId != null) {
      yield r'area_id';
      yield serializers.serialize(
        object.areaId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.assetTag != null) {
      yield r'asset_tag';
      yield serializers.serialize(
        object.assetTag,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.category != null) {
      yield r'category';
      yield serializers.serialize(
        object.category,
        specifiedType: const FullType.nullable(String),
      );
    }
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
        specifiedType:
            const FullType.nullable(UpdateAssetRequestCurrentStatusEnum),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.facilityId != null) {
      yield r'facility_id';
      yield serializers.serialize(
        object.facilityId,
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
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    UpdateAssetRequest object, {
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
    required UpdateAssetRequestBuilder result,
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assetTag = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
            specifiedType:
                const FullType.nullable(UpdateAssetRequestCurrentStatusEnum),
          ) as UpdateAssetRequestCurrentStatusEnum?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  UpdateAssetRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateAssetRequestBuilder();
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

class UpdateAssetRequestCurrentStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Healthy')
  static const UpdateAssetRequestCurrentStatusEnum healthy =
      _$updateAssetRequestCurrentStatusEnum_healthy;
  @BuiltValueEnumConst(wireName: r'Warning')
  static const UpdateAssetRequestCurrentStatusEnum warning =
      _$updateAssetRequestCurrentStatusEnum_warning;
  @BuiltValueEnumConst(wireName: r'Critical')
  static const UpdateAssetRequestCurrentStatusEnum critical =
      _$updateAssetRequestCurrentStatusEnum_critical;

  static Serializer<UpdateAssetRequestCurrentStatusEnum> get serializer =>
      _$updateAssetRequestCurrentStatusEnumSerializer;

  const UpdateAssetRequestCurrentStatusEnum._(String name) : super(name);

  static BuiltSet<UpdateAssetRequestCurrentStatusEnum> get values =>
      _$updateAssetRequestCurrentStatusEnumValues;
  static UpdateAssetRequestCurrentStatusEnum valueOf(String name) =>
      _$updateAssetRequestCurrentStatusEnumValueOf(name);
}
