//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'document_detail.g.dart';

/// DocumentDetail
///
/// Properties:
/// * [assetId]
/// * [category]
/// * [createdAt]
/// * [createdBy]
/// * [description]
/// * [documentCode]
/// * [downloadUrl]
/// * [facilityId]
/// * [fileFormat]
/// * [filePath]
/// * [fileSizeBytes]
/// * [filename]
/// * [id]
/// * [status]
/// * [tags]
/// * [title]
/// * [updatedAt]
/// * [version]
@BuiltValue()
abstract class DocumentDetail
    implements Built<DocumentDetail, DocumentDetailBuilder> {
  @BuiltValueField(wireName: r'asset_id')
  String? get assetId;

  @BuiltValueField(wireName: r'category')
  DocumentDetailCategoryEnum get category;
  // enum categoryEnum {  sop,  manual,  safety_policy,  certificate,  drawing,  report,  };

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'created_by')
  String get createdBy;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'document_code')
  String get documentCode;

  @BuiltValueField(wireName: r'download_url')
  String? get downloadUrl;

  @BuiltValueField(wireName: r'facility_id')
  String? get facilityId;

  @BuiltValueField(wireName: r'file_format')
  DocumentDetailFileFormatEnum get fileFormat;
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
  DocumentDetailStatusEnum get status;
  // enum statusEnum {  active,  archived,  under_review,  };

  @BuiltValueField(wireName: r'tags')
  BuiltList<String>? get tags;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'version')
  int get version;

  DocumentDetail._();

  factory DocumentDetail([void updates(DocumentDetailBuilder b)]) =
      _$DocumentDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DocumentDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DocumentDetail> get serializer =>
      _$DocumentDetailSerializer();
}

class _$DocumentDetailSerializer
    implements PrimitiveSerializer<DocumentDetail> {
  @override
  final Iterable<Type> types = const [DocumentDetail, _$DocumentDetail];

  @override
  final String wireName = r'DocumentDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DocumentDetail object, {
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
      specifiedType: const FullType(DocumentDetailCategoryEnum),
    );
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
    if (object.downloadUrl != null) {
      yield r'download_url';
      yield serializers.serialize(
        object.downloadUrl,
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
    yield r'file_format';
    yield serializers.serialize(
      object.fileFormat,
      specifiedType: const FullType(DocumentDetailFileFormatEnum),
    );
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DocumentDetailStatusEnum),
    );
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
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DocumentDetail object, {
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
    required DocumentDetailBuilder result,
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
            specifiedType: const FullType(DocumentDetailCategoryEnum),
          ) as DocumentDetailCategoryEnum;
          result.category = valueDes;
          break;
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
        case r'download_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.downloadUrl = valueDes;
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
            specifiedType: const FullType(DocumentDetailFileFormatEnum),
          ) as DocumentDetailFileFormatEnum;
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
            specifiedType: const FullType(DocumentDetailStatusEnum),
          ) as DocumentDetailStatusEnum;
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
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DocumentDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DocumentDetailBuilder();
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

class DocumentDetailCategoryEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'sop')
  static const DocumentDetailCategoryEnum sop =
      _$documentDetailCategoryEnum_sop;
  @BuiltValueEnumConst(wireName: r'manual')
  static const DocumentDetailCategoryEnum manual =
      _$documentDetailCategoryEnum_manual;
  @BuiltValueEnumConst(wireName: r'safety_policy')
  static const DocumentDetailCategoryEnum safetyPolicy =
      _$documentDetailCategoryEnum_safetyPolicy;
  @BuiltValueEnumConst(wireName: r'certificate')
  static const DocumentDetailCategoryEnum certificate =
      _$documentDetailCategoryEnum_certificate;
  @BuiltValueEnumConst(wireName: r'drawing')
  static const DocumentDetailCategoryEnum drawing =
      _$documentDetailCategoryEnum_drawing;
  @BuiltValueEnumConst(wireName: r'report')
  static const DocumentDetailCategoryEnum report =
      _$documentDetailCategoryEnum_report;

  static Serializer<DocumentDetailCategoryEnum> get serializer =>
      _$documentDetailCategoryEnumSerializer;

  const DocumentDetailCategoryEnum._(String name) : super(name);

  static BuiltSet<DocumentDetailCategoryEnum> get values =>
      _$documentDetailCategoryEnumValues;
  static DocumentDetailCategoryEnum valueOf(String name) =>
      _$documentDetailCategoryEnumValueOf(name);
}

class DocumentDetailFileFormatEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pdf')
  static const DocumentDetailFileFormatEnum pdf =
      _$documentDetailFileFormatEnum_pdf;
  @BuiltValueEnumConst(wireName: r'docx')
  static const DocumentDetailFileFormatEnum docx =
      _$documentDetailFileFormatEnum_docx;
  @BuiltValueEnumConst(wireName: r'png')
  static const DocumentDetailFileFormatEnum png =
      _$documentDetailFileFormatEnum_png;
  @BuiltValueEnumConst(wireName: r'xlsx')
  static const DocumentDetailFileFormatEnum xlsx =
      _$documentDetailFileFormatEnum_xlsx;
  @BuiltValueEnumConst(wireName: r'txt')
  static const DocumentDetailFileFormatEnum txt =
      _$documentDetailFileFormatEnum_txt;

  static Serializer<DocumentDetailFileFormatEnum> get serializer =>
      _$documentDetailFileFormatEnumSerializer;

  const DocumentDetailFileFormatEnum._(String name) : super(name);

  static BuiltSet<DocumentDetailFileFormatEnum> get values =>
      _$documentDetailFileFormatEnumValues;
  static DocumentDetailFileFormatEnum valueOf(String name) =>
      _$documentDetailFileFormatEnumValueOf(name);
}

class DocumentDetailStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const DocumentDetailStatusEnum active =
      _$documentDetailStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'archived')
  static const DocumentDetailStatusEnum archived =
      _$documentDetailStatusEnum_archived;
  @BuiltValueEnumConst(wireName: r'under_review')
  static const DocumentDetailStatusEnum underReview =
      _$documentDetailStatusEnum_underReview;

  static Serializer<DocumentDetailStatusEnum> get serializer =>
      _$documentDetailStatusEnumSerializer;

  const DocumentDetailStatusEnum._(String name) : super(name);

  static BuiltSet<DocumentDetailStatusEnum> get values =>
      _$documentDetailStatusEnumValues;
  static DocumentDetailStatusEnum valueOf(String name) =>
      _$documentDetailStatusEnumValueOf(name);
}
