//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/notification_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_list_page.g.dart';

/// NotificationListPage
///
/// Properties:
/// * [items]
/// * [unreadCount]
@BuiltValue()
abstract class NotificationListPage
    implements Built<NotificationListPage, NotificationListPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<NotificationResponse>? get items;

  @BuiltValueField(wireName: r'unread_count')
  int? get unreadCount;

  NotificationListPage._();

  factory NotificationListPage([void updates(NotificationListPageBuilder b)]) =
      _$NotificationListPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationListPageBuilder b) => b..unreadCount = 0;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationListPage> get serializer =>
      _$NotificationListPageSerializer();
}

class _$NotificationListPageSerializer
    implements PrimitiveSerializer<NotificationListPage> {
  @override
  final Iterable<Type> types = const [
    NotificationListPage,
    _$NotificationListPage
  ];

  @override
  final String wireName = r'NotificationListPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationListPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.items != null) {
      yield r'items';
      yield serializers.serialize(
        object.items,
        specifiedType:
            const FullType(BuiltList, [FullType(NotificationResponse)]),
      );
    }
    if (object.unreadCount != null) {
      yield r'unread_count';
      yield serializers.serialize(
        object.unreadCount,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationListPage object, {
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
    required NotificationListPageBuilder result,
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
                const FullType(BuiltList, [FullType(NotificationResponse)]),
          ) as BuiltList<NotificationResponse>;
          result.items.replace(valueDes);
          break;
        case r'unread_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unreadCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationListPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationListPageBuilder();
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
