//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/safety_report_list_item.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'safety_report_list_page.g.dart';

/// SafetyReportListPage
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class SafetyReportListPage
    implements Built<SafetyReportListPage, SafetyReportListPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<SafetyReportListItem> get items;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  SafetyReportListPage._();

  factory SafetyReportListPage([void updates(SafetyReportListPageBuilder b)]) =
      _$SafetyReportListPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SafetyReportListPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SafetyReportListPage> get serializer =>
      _$SafetyReportListPageSerializer();
}

class _$SafetyReportListPageSerializer
    implements PrimitiveSerializer<SafetyReportListPage> {
  @override
  final Iterable<Type> types = const [
    SafetyReportListPage,
    _$SafetyReportListPage
  ];

  @override
  final String wireName = r'SafetyReportListPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SafetyReportListPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType:
          const FullType(BuiltList, [FullType(SafetyReportListItem)]),
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
    SafetyReportListPage object, {
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
    required SafetyReportListPageBuilder result,
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
                const FullType(BuiltList, [FullType(SafetyReportListItem)]),
          ) as BuiltList<SafetyReportListItem>;
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
  SafetyReportListPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SafetyReportListPageBuilder();
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
