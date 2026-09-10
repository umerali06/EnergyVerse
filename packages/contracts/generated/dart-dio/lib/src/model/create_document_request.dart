//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_document_request.g.dart';

/// CreateDocumentRequest
///
/// Properties:
/// * [assetId]
/// * [category]
/// * [description]
/// * [documentCode]
/// * [facilityId]
/// * [fileFormat]
/// * [filePath]
/// * [fileSizeBytes]
/// * [filename]
/// * [id]
/// * [status]
/// * [tags]
/// * [title]
@BuiltValue()
abstract class CreateDocumentRequest
    implements Built<CreateDocumentRequest, CreateDocumentRequestBuilder> {
  @BuiltValueField(wireName: r'asset_id')
  String? get assetId;

  @BuiltValueField(wireName: r'category')
  CreateDocumentRequestCategoryEnum get category;
  // enum categoryEnum {  sop,  manual,  safety_policy,  certificate,  drawing,  report,  };

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'document_code')
  String get documentCode;

  @BuiltValueField(wireName: r'facility_id')
  String? get facilityId;

  @BuiltValueField(wireName: r'file_format')
  CreateDocumentRequestFileFormatEnum? get fileFormat;
  // enum fileFormatEnum {  pdf,  docx,  png,  xlsx,  txt,  };

  @BuiltValueField(wireName: r'file_path')
  String get filePath;

  @BuiltValueField(wireName: r'file_size_bytes')
  int get fileSizeBytes;

  @BuiltValueField(wireName: r'filename')
  String get filename;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  CreateDocumentRequestStatusEnum? get status;
  // enum statusEnum {  active,  archived,  under_review,  };

  @BuiltValueField(wireName: r'tags')
  BuiltList<String>? get tags;

  @BuiltValueField(wireName: r'title')
  String get title;

  CreateDocumentRequest._();

  factory CreateDocumentRequest(
      [void updates(CreateDocumentRequestBuilder b)]) = _$CreateDocumentRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateDocumentRequestBuilder b) => b
    ..fileFormat = const CreateDocumentRequestFileFormatEnum._('pdf')
    ..status = const CreateDocumentRequestStatusEnum._('active');

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateDocumentRequest> get serializer =>
      _$CreateDocumentRequestSerializer();
}

class _$CreateDocumentRequestSerializer
    implements PrimitiveSerializer<CreateDocumentRequest> {
  @override
  final Iterable<Type> types = const [
    CreateDocumentRequest,
    _$CreateDocumentRequest
  ];

  @override
  final String wireName = r'CreateDocumentRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateDocumentRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.assetId != null) {
      yield r'asset_id';
      yield serializers.serialize(
        object.assetId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(CreateDocumentRequestCategoryEnum),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'document_code';
    yield serializers.serialize(
      object.documentCode,
      specifiedType: const FullType(String),
    );
    if (object.facilityId != null) {
      yield r'facility_id';
      yield serializers.serialize(
        object.facilityId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.fileFormat != null) {
      yield r'file_format';
      yield serializers.serialize(
        object.fileFormat,
        specifiedType: const FullType(CreateDocumentRequestFileFormatEnum),
      );
    }
    yield r'file_path';
    yield serializers.serialize(
      object.filePath,
      specifiedType: const FullType(String),
    );
    yield r'file_size_bytes';
    yield serializers.serialize(
      object.fileSizeBytes,
      specifiedType: const FullType(int),
    );
    yield r'filename';
    yield serializers.serialize(
      object.filename,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(CreateDocumentRequestStatusEnum),
      );
    }
    if (object.tags != null) {
      yield r'tags';
      yield serializers.serialize(
        object.tags,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateDocumentRequest object, {
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
    required CreateDocumentRequestBuilder result,
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
            specifiedType: const FullType(CreateDocumentRequestCategoryEnum),
          ) as CreateDocumentRequestCategoryEnum;
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
            specifiedType: const FullType(String),
          ) as String;
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
        case r'file_format':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateDocumentRequestFileFormatEnum),
          ) as CreateDocumentRequestFileFormatEnum;
          result.fileFormat = valueDes;
          break;
        case r'file_path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.filePath = valueDes;
          break;
        case r'file_size_bytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.fileSizeBytes = valueDes;
          break;
        case r'filename':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.filename = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateDocumentRequestStatusEnum),
          ) as CreateDocumentRequestStatusEnum;
          result.status = valueDes;
          break;
        case r'tags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.tags.replace(valueDes);
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
  CreateDocumentRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateDocumentRequestBuilder();
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

class CreateDocumentRequestCategoryEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'sop')
  static const CreateDocumentRequestCategoryEnum sop =
      _$createDocumentRequestCategoryEnum_sop;
  @BuiltValueEnumConst(wireName: r'manual')
  static const CreateDocumentRequestCategoryEnum manual =
      _$createDocumentRequestCategoryEnum_manual;
  @BuiltValueEnumConst(wireName: r'safety_policy')
  static const CreateDocumentRequestCategoryEnum safetyPolicy =
      _$createDocumentRequestCategoryEnum_safetyPolicy;
  @BuiltValueEnumConst(wireName: r'certificate')
  static const CreateDocumentRequestCategoryEnum certificate =
      _$createDocumentRequestCategoryEnum_certificate;
  @BuiltValueEnumConst(wireName: r'drawing')
  static const CreateDocumentRequestCategoryEnum drawing =
      _$createDocumentRequestCategoryEnum_drawing;
  @BuiltValueEnumConst(wireName: r'report')
  static const CreateDocumentRequestCategoryEnum report =
      _$createDocumentRequestCategoryEnum_report;

  static Serializer<CreateDocumentRequestCategoryEnum> get serializer =>
      _$createDocumentRequestCategoryEnumSerializer;

  const CreateDocumentRequestCategoryEnum._(String name) : super(name);

  static BuiltSet<CreateDocumentRequestCategoryEnum> get values =>
      _$createDocumentRequestCategoryEnumValues;
  static CreateDocumentRequestCategoryEnum valueOf(String name) =>
      _$createDocumentRequestCategoryEnumValueOf(name);
}

class CreateDocumentRequestFileFormatEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pdf')
  static const CreateDocumentRequestFileFormatEnum pdf =
      _$createDocumentRequestFileFormatEnum_pdf;
  @BuiltValueEnumConst(wireName: r'docx')
  static const CreateDocumentRequestFileFormatEnum docx =
      _$createDocumentRequestFileFormatEnum_docx;
  @BuiltValueEnumConst(wireName: r'png')
  static const CreateDocumentRequestFileFormatEnum png =
      _$createDocumentRequestFileFormatEnum_png;
  @BuiltValueEnumConst(wireName: r'xlsx')
  static const CreateDocumentRequestFileFormatEnum xlsx =
      _$createDocumentRequestFileFormatEnum_xlsx;
  @BuiltValueEnumConst(wireName: r'txt')
  static const CreateDocumentRequestFileFormatEnum txt =
      _$createDocumentRequestFileFormatEnum_txt;

  static Serializer<CreateDocumentRequestFileFormatEnum> get serializer =>
      _$createDocumentRequestFileFormatEnumSerializer;

  const CreateDocumentRequestFileFormatEnum._(String name) : super(name);

  static BuiltSet<CreateDocumentRequestFileFormatEnum> get values =>
      _$createDocumentRequestFileFormatEnumValues;
  static CreateDocumentRequestFileFormatEnum valueOf(String name) =>
      _$createDocumentRequestFileFormatEnumValueOf(name);
}

class CreateDocumentRequestStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const CreateDocumentRequestStatusEnum active =
      _$createDocumentRequestStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'archived')
  static const CreateDocumentRequestStatusEnum archived =
      _$createDocumentRequestStatusEnum_archived;
  @BuiltValueEnumConst(wireName: r'under_review')
  static const CreateDocumentRequestStatusEnum underReview =
      _$createDocumentRequestStatusEnum_underReview;

  static Serializer<CreateDocumentRequestStatusEnum> get serializer =>
      _$createDocumentRequestStatusEnumSerializer;

  const CreateDocumentRequestStatusEnum._(String name) : super(name);

  static BuiltSet<CreateDocumentRequestStatusEnum> get values =>
      _$createDocumentRequestStatusEnumValues;
  static CreateDocumentRequestStatusEnum valueOf(String name) =>
      _$createDocumentRequestStatusEnumValueOf(name);
}
