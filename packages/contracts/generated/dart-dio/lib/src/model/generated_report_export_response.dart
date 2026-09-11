//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'generated_report_export_response.g.dart';

/// GeneratedReportExportResponse
///
/// Properties:
/// * [contentType]
/// * [filename]
/// * [format]
/// * [generatedAt]
/// * [generatedBy]
/// * [reportId]
/// * [size]
/// * [url]
@BuiltValue()
abstract class GeneratedReportExportResponse
    implements
        Built<GeneratedReportExportResponse,
            GeneratedReportExportResponseBuilder> {
  @BuiltValueField(wireName: r'content_type')
  String get contentType;

  @BuiltValueField(wireName: r'filename')
  String get filename;

  @BuiltValueField(wireName: r'format')
  GeneratedReportExportResponseFormatEnum get format;
  // enum formatEnum {  pdf,  docx,  xlsx,  };

  @BuiltValueField(wireName: r'generated_at')
  DateTime get generatedAt;

  @BuiltValueField(wireName: r'generated_by')
  String get generatedBy;

  @BuiltValueField(wireName: r'report_id')
  String get reportId;

  @BuiltValueField(wireName: r'size')
  int get size;

  @BuiltValueField(wireName: r'url')
  String get url;

  GeneratedReportExportResponse._();

  factory GeneratedReportExportResponse(
          [void updates(GeneratedReportExportResponseBuilder b)]) =
      _$GeneratedReportExportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeneratedReportExportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeneratedReportExportResponse> get serializer =>
      _$GeneratedReportExportResponseSerializer();
}

class _$GeneratedReportExportResponseSerializer
    implements PrimitiveSerializer<GeneratedReportExportResponse> {
  @override
  final Iterable<Type> types = const [
    GeneratedReportExportResponse,
    _$GeneratedReportExportResponse
  ];

  @override
  final String wireName = r'GeneratedReportExportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeneratedReportExportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'content_type';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(String),
    );
    yield r'filename';
    yield serializers.serialize(
      object.filename,
      specifiedType: const FullType(String),
    );
    yield r'format';
    yield serializers.serialize(
      object.format,
      specifiedType: const FullType(GeneratedReportExportResponseFormatEnum),
    );
    yield r'generated_at';
    yield serializers.serialize(
      object.generatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'generated_by';
    yield serializers.serialize(
      object.generatedBy,
      specifiedType: const FullType(String),
    );
    yield r'report_id';
    yield serializers.serialize(
      object.reportId,
      specifiedType: const FullType(String),
    );
    yield r'size';
    yield serializers.serialize(
      object.size,
      specifiedType: const FullType(int),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeneratedReportExportResponse object, {
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
    required GeneratedReportExportResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'content_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentType = valueDes;
          break;
        case r'filename':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.filename = valueDes;
          break;
        case r'format':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(GeneratedReportExportResponseFormatEnum),
          ) as GeneratedReportExportResponseFormatEnum;
          result.format = valueDes;
          break;
        case r'generated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.generatedAt = valueDes;
          break;
        case r'generated_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.generatedBy = valueDes;
          break;
        case r'report_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reportId = valueDes;
          break;
        case r'size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.size = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeneratedReportExportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeneratedReportExportResponseBuilder();
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

class GeneratedReportExportResponseFormatEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pdf')
  static const GeneratedReportExportResponseFormatEnum pdf =
      _$generatedReportExportResponseFormatEnum_pdf;
  @BuiltValueEnumConst(wireName: r'docx')
  static const GeneratedReportExportResponseFormatEnum docx =
      _$generatedReportExportResponseFormatEnum_docx;
  @BuiltValueEnumConst(wireName: r'xlsx')
  static const GeneratedReportExportResponseFormatEnum xlsx =
      _$generatedReportExportResponseFormatEnum_xlsx;

  static Serializer<GeneratedReportExportResponseFormatEnum> get serializer =>
      _$generatedReportExportResponseFormatEnumSerializer;

  const GeneratedReportExportResponseFormatEnum._(String name) : super(name);

  static BuiltSet<GeneratedReportExportResponseFormatEnum> get values =>
      _$generatedReportExportResponseFormatEnumValues;
  static GeneratedReportExportResponseFormatEnum valueOf(String name) =>
      _$generatedReportExportResponseFormatEnumValueOf(name);
}
