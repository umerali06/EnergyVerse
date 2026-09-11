//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notifications_all_read.g.dart';

/// NotificationsAllRead
///
/// Properties:
/// * [marked]
@BuiltValue()
abstract class NotificationsAllRead
    implements Built<NotificationsAllRead, NotificationsAllReadBuilder> {
  @BuiltValueField(wireName: r'marked')
  int get marked;

  NotificationsAllRead._();

  factory NotificationsAllRead([void updates(NotificationsAllReadBuilder b)]) =
      _$NotificationsAllRead;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationsAllReadBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationsAllRead> get serializer =>
      _$NotificationsAllReadSerializer();
}

class _$NotificationsAllReadSerializer
    implements PrimitiveSerializer<NotificationsAllRead> {
  @override
  final Iterable<Type> types = const [
    NotificationsAllRead,
    _$NotificationsAllRead
  ];

  @override
  final String wireName = r'NotificationsAllRead';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationsAllRead object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'marked';
    yield serializers.serialize(
      object.marked,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationsAllRead object, {
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
    required NotificationsAllReadBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'marked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.marked = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationsAllRead deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationsAllReadBuilder();
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
