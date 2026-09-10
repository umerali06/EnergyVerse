//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/generated_report_list_item.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'generated_report_list_page.g.dart';

/// GeneratedReportListPage
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class GeneratedReportListPage
    implements Built<GeneratedReportListPage, GeneratedReportListPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<GeneratedReportListItem> get items;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  GeneratedReportListPage._();

  factory GeneratedReportListPage(
          [void updates(GeneratedReportListPageBuilder b)]) =
      _$GeneratedReportListPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeneratedReportListPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeneratedReportListPage> get serializer =>
      _$GeneratedReportListPageSerializer();
}

class _$GeneratedReportListPageSerializer
    implements PrimitiveSerializer<GeneratedReportListPage> {
  @override
  final Iterable<Type> types = const [
    GeneratedReportListPage,
    _$GeneratedReportListPage
  ];

  @override
  final String wireName = r'GeneratedReportListPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeneratedReportListPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType:
          const FullType(BuiltList, [FullType(GeneratedReportListItem)]),
    );
    if (object.nextCursor != null) {
      yield r'next_cursor';
      yield serializers.serialize(
        object.nextCursor,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GeneratedReportListPage object, {
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
    required GeneratedReportListPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(GeneratedReportListItem)]),
          ) as BuiltList<GeneratedReportListItem>;
          result.items.replace(valueDes);
          break;
        case r'next_cursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeneratedReportListPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeneratedReportListPageBuilder();
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
