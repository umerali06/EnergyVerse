//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'document_list_item.g.dart';

/// DocumentListItem
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
abstract class DocumentListItem
    implements Built<DocumentListItem, DocumentListItemBuilder> {
  @BuiltValueField(wireName: r'asset_id')
  String? get assetId;

  @BuiltValueField(wireName: r'category')
  DocumentListItemCategoryEnum get category;
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
  DocumentListItemFileFormatEnum get fileFormat;
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
  DocumentListItemStatusEnum get status;
  // enum statusEnum {  active,  archived,  under_review,  };

  @BuiltValueField(wireName: r'tags')
  BuiltList<String>? get tags;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'version')
  int get version;

  DocumentListItem._();

  factory DocumentListItem([void updates(DocumentListItemBuilder b)]) =
      _$DocumentListItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DocumentListItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DocumentListItem> get serializer =>
      _$DocumentListItemSerializer();
}

class _$DocumentListItemSerializer
    implements PrimitiveSerializer<DocumentListItem> {
  @override
  final Iterable<Type> types = const [DocumentListItem, _$DocumentListItem];

  @override
  final String wireName = r'DocumentListItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DocumentListItem object, {
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
      specifiedType: const FullType(DocumentListItemCategoryEnum),
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
      specifiedType: const FullType(DocumentListItemFileFormatEnum),
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
      specifiedType: const FullType(DocumentListItemStatusEnum),
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
    DocumentListItem object, {
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
    required DocumentListItemBuilder result,
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
            specifiedType: const FullType(DocumentListItemCategoryEnum),
          ) as DocumentListItemCategoryEnum;
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
            specifiedType: const FullType(DocumentListItemFileFormatEnum),
          ) as DocumentListItemFileFormatEnum;
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
            specifiedType: const FullType(DocumentListItemStatusEnum),
          ) as DocumentListItemStatusEnum;
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
  DocumentListItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DocumentListItemBuilder();
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

class DocumentListItemCategoryEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'sop')
  static const DocumentListItemCategoryEnum sop =
      _$documentListItemCategoryEnum_sop;
  @BuiltValueEnumConst(wireName: r'manual')
  static const DocumentListItemCategoryEnum manual =
      _$documentListItemCategoryEnum_manual;
  @BuiltValueEnumConst(wireName: r'safety_policy')
  static const DocumentListItemCategoryEnum safetyPolicy =
      _$documentListItemCategoryEnum_safetyPolicy;
  @BuiltValueEnumConst(wireName: r'certificate')
  static const DocumentListItemCategoryEnum certificate =
      _$documentListItemCategoryEnum_certificate;
  @BuiltValueEnumConst(wireName: r'drawing')
  static const DocumentListItemCategoryEnum drawing =
      _$documentListItemCategoryEnum_drawing;
  @BuiltValueEnumConst(wireName: r'report')
  static const DocumentListItemCategoryEnum report =
      _$documentListItemCategoryEnum_report;

  static Serializer<DocumentListItemCategoryEnum> get serializer =>
      _$documentListItemCategoryEnumSerializer;

  const DocumentListItemCategoryEnum._(String name) : super(name);

  static BuiltSet<DocumentListItemCategoryEnum> get values =>
      _$documentListItemCategoryEnumValues;
  static DocumentListItemCategoryEnum valueOf(String name) =>
      _$documentListItemCategoryEnumValueOf(name);
}

class DocumentListItemFileFormatEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pdf')
  static const DocumentListItemFileFormatEnum pdf =
      _$documentListItemFileFormatEnum_pdf;
  @BuiltValueEnumConst(wireName: r'docx')
  static const DocumentListItemFileFormatEnum docx =
      _$documentListItemFileFormatEnum_docx;
  @BuiltValueEnumConst(wireName: r'png')
  static const DocumentListItemFileFormatEnum png =
      _$documentListItemFileFormatEnum_png;
  @BuiltValueEnumConst(wireName: r'xlsx')
  static const DocumentListItemFileFormatEnum xlsx =
      _$documentListItemFileFormatEnum_xlsx;
  @BuiltValueEnumConst(wireName: r'txt')
  static const DocumentListItemFileFormatEnum txt =
      _$documentListItemFileFormatEnum_txt;

  static Serializer<DocumentListItemFileFormatEnum> get serializer =>
      _$documentListItemFileFormatEnumSerializer;

  const DocumentListItemFileFormatEnum._(String name) : super(name);

  static BuiltSet<DocumentListItemFileFormatEnum> get values =>
      _$documentListItemFileFormatEnumValues;
  static DocumentListItemFileFormatEnum valueOf(String name) =>
      _$documentListItemFileFormatEnumValueOf(name);
}

class DocumentListItemStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const DocumentListItemStatusEnum active =
      _$documentListItemStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'archived')
  static const DocumentListItemStatusEnum archived =
      _$documentListItemStatusEnum_archived;
  @BuiltValueEnumConst(wireName: r'under_review')
  static const DocumentListItemStatusEnum underReview =
      _$documentListItemStatusEnum_underReview;

  static Serializer<DocumentListItemStatusEnum> get serializer =>
      _$documentListItemStatusEnumSerializer;

  const DocumentListItemStatusEnum._(String name) : super(name);

  static BuiltSet<DocumentListItemStatusEnum> get values =>
      _$documentListItemStatusEnumValues;
  static DocumentListItemStatusEnum valueOf(String name) =>
      _$documentListItemStatusEnumValueOf(name);
}
