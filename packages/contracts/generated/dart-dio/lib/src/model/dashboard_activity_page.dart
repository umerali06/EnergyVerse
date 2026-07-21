//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/dashboard_activity_item.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard_activity_page.g.dart';

/// DashboardActivityPage
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class DashboardActivityPage
    implements Built<DashboardActivityPage, DashboardActivityPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<DashboardActivityItem> get items;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  DashboardActivityPage._();

  factory DashboardActivityPage(
      [void updates(DashboardActivityPageBuilder b)]) = _$DashboardActivityPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardActivityPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DashboardActivityPage> get serializer =>
      _$DashboardActivityPageSerializer();
}

class _$DashboardActivityPageSerializer
    implements PrimitiveSerializer<DashboardActivityPage> {
  @override
  final Iterable<Type> types = const [
    DashboardActivityPage,
    _$DashboardActivityPage
  ];

  @override
  final String wireName = r'DashboardActivityPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DashboardActivityPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType:
          const FullType(BuiltList, [FullType(DashboardActivityItem)]),
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
    DashboardActivityPage object, {
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
    required DashboardActivityPageBuilder result,
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
                const FullType(BuiltList, [FullType(DashboardActivityItem)]),
          ) as BuiltList<DashboardActivityItem>;
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
  DashboardActivityPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardActivityPageBuilder();
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
