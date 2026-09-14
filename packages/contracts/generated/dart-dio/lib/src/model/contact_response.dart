//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_response.g.dart';

/// `received` is always true on a 2xx. Kept as a field so the client has a typed success body rather than an empty one.
///
/// Properties:
/// * [received]
@BuiltValue()
abstract class ContactResponse
    implements Built<ContactResponse, ContactResponseBuilder> {
  @BuiltValueField(wireName: r'received')
  bool get received;

  ContactResponse._();

  factory ContactResponse([void updates(ContactResponseBuilder b)]) =
      _$ContactResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactResponse> get serializer =>
      _$ContactResponseSerializer();
}

class _$ContactResponseSerializer
    implements PrimitiveSerializer<ContactResponse> {
  @override
  final Iterable<Type> types = const [ContactResponse, _$ContactResponse];

  @override
  final String wireName = r'ContactResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'received';
    yield serializers.serialize(
      object.received,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContactResponse object, {
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
    required ContactResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'received':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.received = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContactResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactResponseBuilder();
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
