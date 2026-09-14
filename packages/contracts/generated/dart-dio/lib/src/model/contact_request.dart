//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_request.g.dart';

/// A public contact-form submission.  Every field is length-bounded because this endpoint is unauthenticated. The form tells senders not to include passwords, tokens, or full card numbers; nothing here is stored, only forwarded to the support inbox.
///
/// Properties:
/// * [category]
/// * [company]
/// * [email]
/// * [message]
/// * [name]
/// * [subject]
@BuiltValue()
abstract class ContactRequest
    implements Built<ContactRequest, ContactRequestBuilder> {
  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'company')
  String? get company;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'message')
  String get message;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'subject')
  String get subject;

  ContactRequest._();

  factory ContactRequest([void updates(ContactRequestBuilder b)]) =
      _$ContactRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactRequest> get serializer =>
      _$ContactRequestSerializer();
}

class _$ContactRequestSerializer
    implements PrimitiveSerializer<ContactRequest> {
  @override
  final Iterable<Type> types = const [ContactRequest, _$ContactRequest];

  @override
  final String wireName = r'ContactRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    if (object.company != null) {
      yield r'company';
      yield serializers.serialize(
        object.company,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'subject';
    yield serializers.serialize(
      object.subject,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContactRequest object, {
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
    required ContactRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'company':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.company = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'subject':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subject = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContactRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactRequestBuilder();
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
