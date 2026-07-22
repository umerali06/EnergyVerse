//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_detail.g.dart';

/// AssetDetail
///
/// Properties:
/// * [areaId]
/// * [assetTag]
/// * [category]
/// * [categoryOther]
/// * [createdAt]
/// * [currentStatus]
/// * [description]
/// * [documents]
/// * [facilityId]
/// * [gpsLat]
/// * [gpsLng]
/// * [id]
/// * [installationDate]
/// * [manuals]
/// * [manufacturer]
/// * [model]
/// * [model3dUrl]
/// * [name]
/// * [parentAssetId]
/// * [photos]
/// * [qrCodeId]
/// * [serialNumber]
/// * [updatedAt]
@BuiltValue()
abstract class AssetDetail implements Built<AssetDetail, AssetDetailBuilder> {
  @BuiltValueField(wireName: r'area_id')
  String? get areaId;

  @BuiltValueField(wireName: r'asset_tag')
  String get assetTag;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'category_other')
  String? get categoryOther;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'current_status')
  AssetDetailCurrentStatusEnum get currentStatus;
  // enum currentStatusEnum {  Healthy,  Warning,  Critical,  };

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'documents')
  BuiltList<String>? get documents;

  @BuiltValueField(wireName: r'facility_id')
  String get facilityId;

  @BuiltValueField(wireName: r'gps_lat')
  num? get gpsLat;

  @BuiltValueField(wireName: r'gps_lng')
  num? get gpsLng;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'installation_date')
  Date? get installationDate;

  @BuiltValueField(wireName: r'manuals')
  BuiltList<String>? get manuals;

  @BuiltValueField(wireName: r'manufacturer')
  String? get manufacturer;

  @BuiltValueField(wireName: r'model')
  String? get model;

  @BuiltValueField(wireName: r'model_3d_url')
  String? get model3dUrl;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'parent_asset_id')
  String? get parentAssetId;

  @BuiltValueField(wireName: r'photos')
  BuiltList<String>? get photos;

  @BuiltValueField(wireName: r'qr_code_id')
  String? get qrCodeId;

  @BuiltValueField(wireName: r'serial_number')
  String? get serialNumber;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  AssetDetail._();

  factory AssetDetail([void updates(AssetDetailBuilder b)]) = _$AssetDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetDetail> get serializer => _$AssetDetailSerializer();
}

class _$AssetDetailSerializer implements PrimitiveSerializer<AssetDetail> {
  @override
  final Iterable<Type> types = const [AssetDetail, _$AssetDetail];

  @override
  final String wireName = r'AssetDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetDetail object, {
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
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'current_status';
    yield serializers.serialize(
      object.currentStatus,
      specifiedType: const FullType(AssetDetailCurrentStatusEnum),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.documents != null) {
      yield r'documents';
      yield serializers.serialize(
        object.documents,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
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
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.installationDate != null) {
      yield r'installation_date';
      yield serializers.serialize(
        object.installationDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
    if (object.manuals != null) {
      yield r'manuals';
      yield serializers.serialize(
        object.manuals,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
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
    if (object.model3dUrl != null) {
      yield r'model_3d_url';
      yield serializers.serialize(
        object.model3dUrl,
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
    if (object.photos != null) {
      yield r'photos';
      yield serializers.serialize(
        object.photos,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.qrCodeId != null) {
      yield r'qr_code_id';
      yield serializers.serialize(
        object.qrCodeId,
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
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetDetail object, {
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
    required AssetDetailBuilder result,
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
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'current_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssetDetailCurrentStatusEnum),
          ) as AssetDetailCurrentStatusEnum;
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
        case r'documents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.documents.replace(valueDes);
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
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'installation_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.installationDate = valueDes;
          break;
        case r'manuals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.manuals.replace(valueDes);
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
        case r'model_3d_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.model3dUrl = valueDes;
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
        case r'photos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.photos.replace(valueDes);
          break;
        case r'qr_code_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.qrCodeId = valueDes;
          break;
        case r'serial_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.serialNumber = valueDes;
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
  AssetDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetDetailBuilder();
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

class AssetDetailCurrentStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Healthy')
  static const AssetDetailCurrentStatusEnum healthy =
      _$assetDetailCurrentStatusEnum_healthy;
  @BuiltValueEnumConst(wireName: r'Warning')
  static const AssetDetailCurrentStatusEnum warning =
      _$assetDetailCurrentStatusEnum_warning;
  @BuiltValueEnumConst(wireName: r'Critical')
  static const AssetDetailCurrentStatusEnum critical =
      _$assetDetailCurrentStatusEnum_critical;

  static Serializer<AssetDetailCurrentStatusEnum> get serializer =>
      _$assetDetailCurrentStatusEnumSerializer;

  const AssetDetailCurrentStatusEnum._(String name) : super(name);

  static BuiltSet<AssetDetailCurrentStatusEnum> get values =>
      _$assetDetailCurrentStatusEnumValues;
  static AssetDetailCurrentStatusEnum valueOf(String name) =>
      _$assetDetailCurrentStatusEnumValueOf(name);
}
