//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_document_request.g.dart';

/// UpdateDocumentRequest
///
/// Properties:
/// * [assetId]
/// * [category]
/// * [description]
/// * [documentCode]
/// * [facilityId]
/// * [status]
/// * [tags]
/// * [title]
@BuiltValue()
abstract class UpdateDocumentRequest
    implements Built<UpdateDocumentRequest, UpdateDocumentRequestBuilder> {
  @BuiltValueField(wireName: r'asset_id')
  String? get assetId;

  @BuiltValueField(wireName: r'category')
  UpdateDocumentRequestCategoryEnum? get category;
  // enum categoryEnum {  sop,  manual,  safety_policy,  certificate,  drawing,  report,  };

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'document_code')
  String? get documentCode;

  @BuiltValueField(wireName: r'facility_id')
  String? get facilityId;

  @BuiltValueField(wireName: r'status')
  UpdateDocumentRequestStatusEnum? get status;
  // enum statusEnum {  active,  archived,  under_review,  };

  @BuiltValueField(wireName: r'tags')
  BuiltList<String>? get tags;

  @BuiltValueField(wireName: r'title')
  String? get title;

  UpdateDocumentRequest._();

  factory UpdateDocumentRequest(
      [void updates(UpdateDocumentRequestBuilder b)]) = _$UpdateDocumentRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateDocumentRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateDocumentRequest> get serializer =>
      _$UpdateDocumentRequestSerializer();
}

class _$UpdateDocumentRequestSerializer
    implements PrimitiveSerializer<UpdateDocumentRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateDocumentRequest,
    _$UpdateDocumentRequest
  ];

  @override
  final String wireName = r'UpdateDocumentRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateDocumentRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.assetId != null) {
      yield r'asset_id';
      yield serializers.serialize(
        object.assetId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.category != null) {
      yield r'category';
      yield serializers.serialize(
        object.category,
        specifiedType:
            const FullType.nullable(UpdateDocumentRequestCategoryEnum),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.documentCode != null) {
      yield r'document_code';
      yield serializers.serialize(
        object.documentCode,
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
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType.nullable(UpdateDocumentRequestStatusEnum),
      );
    }
    if (object.tags != null) {
      yield r'tags';
      yield serializers.serialize(
        object.tags,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
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
    UpdateDocumentRequest object, {
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
    required UpdateDocumentRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'asset_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assetId = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(UpdateDocumentRequestCategoryEnum),
          ) as UpdateDocumentRequestCategoryEnum?;
          if (valueDes == null) continue;
          result.category = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'document_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.documentCode = valueDes;
          break;
        case r'facility_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.facilityId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(UpdateDocumentRequestStatusEnum),
          ) as UpdateDocumentRequestStatusEnum?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        case r'tags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.tags.replace(valueDes);
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
  UpdateDocumentRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateDocumentRequestBuilder();
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

class UpdateDocumentRequestCategoryEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'sop')
  static const UpdateDocumentRequestCategoryEnum sop =
      _$updateDocumentRequestCategoryEnum_sop;
  @BuiltValueEnumConst(wireName: r'manual')
  static const UpdateDocumentRequestCategoryEnum manual =
      _$updateDocumentRequestCategoryEnum_manual;
  @BuiltValueEnumConst(wireName: r'safety_policy')
  static const UpdateDocumentRequestCategoryEnum safetyPolicy =
      _$updateDocumentRequestCategoryEnum_safetyPolicy;
  @BuiltValueEnumConst(wireName: r'certificate')
  static const UpdateDocumentRequestCategoryEnum certificate =
      _$updateDocumentRequestCategoryEnum_certificate;
  @BuiltValueEnumConst(wireName: r'drawing')
  static const UpdateDocumentRequestCategoryEnum drawing =
      _$updateDocumentRequestCategoryEnum_drawing;
  @BuiltValueEnumConst(wireName: r'report')
  static const UpdateDocumentRequestCategoryEnum report =
      _$updateDocumentRequestCategoryEnum_report;

  static Serializer<UpdateDocumentRequestCategoryEnum> get serializer =>
      _$updateDocumentRequestCategoryEnumSerializer;

  const UpdateDocumentRequestCategoryEnum._(String name) : super(name);

  static BuiltSet<UpdateDocumentRequestCategoryEnum> get values =>
      _$updateDocumentRequestCategoryEnumValues;
  static UpdateDocumentRequestCategoryEnum valueOf(String name) =>
      _$updateDocumentRequestCategoryEnumValueOf(name);
}

class UpdateDocumentRequestStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const UpdateDocumentRequestStatusEnum active =
      _$updateDocumentRequestStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'archived')
  static const UpdateDocumentRequestStatusEnum archived =
      _$updateDocumentRequestStatusEnum_archived;
  @BuiltValueEnumConst(wireName: r'under_review')
  static const UpdateDocumentRequestStatusEnum underReview =
      _$updateDocumentRequestStatusEnum_underReview;

  static Serializer<UpdateDocumentRequestStatusEnum> get serializer =>
      _$updateDocumentRequestStatusEnumSerializer;

  const UpdateDocumentRequestStatusEnum._(String name) : super(name);

  static BuiltSet<UpdateDocumentRequestStatusEnum> get values =>
      _$updateDocumentRequestStatusEnumValues;
  static UpdateDocumentRequestStatusEnum valueOf(String name) =>
      _$updateDocumentRequestStatusEnumValueOf(name);
}
