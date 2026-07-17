//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'company_registration_response.g.dart';

/// CompanyRegistrationResponse
///
/// Properties:
/// * [companyId]
/// * [email]
/// * [emailVerified]
/// * [roleKey]
/// * [uid]
@BuiltValue()
abstract class CompanyRegistrationResponse
    implements
        Built<CompanyRegistrationResponse, CompanyRegistrationResponseBuilder> {
  @BuiltValueField(wireName: r'company_id')
  String get companyId;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'email_verified')
  bool get emailVerified;

  @BuiltValueField(wireName: r'role_key')
  String get roleKey;

  @BuiltValueField(wireName: r'uid')
  String get uid;

  CompanyRegistrationResponse._();

  factory CompanyRegistrationResponse(
          [void updates(CompanyRegistrationResponseBuilder b)]) =
      _$CompanyRegistrationResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompanyRegistrationResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompanyRegistrationResponse> get serializer =>
      _$CompanyRegistrationResponseSerializer();
}

class _$CompanyRegistrationResponseSerializer
    implements PrimitiveSerializer<CompanyRegistrationResponse> {
  @override
  final Iterable<Type> types = const [
    CompanyRegistrationResponse,
    _$CompanyRegistrationResponse
  ];

  @override
  final String wireName = r'CompanyRegistrationResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompanyRegistrationResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'company_id';
    yield serializers.serialize(
      object.companyId,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'email_verified';
    yield serializers.serialize(
      object.emailVerified,
      specifiedType: const FullType(bool),
    );
    yield r'role_key';
    yield serializers.serialize(
      object.roleKey,
      specifiedType: const FullType(String),
    );
    yield r'uid';
    yield serializers.serialize(
      object.uid,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CompanyRegistrationResponse object, {
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
    required CompanyRegistrationResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'company_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyId = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'email_verified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.emailVerified = valueDes;
          break;
        case r'role_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.roleKey = valueDes;
          break;
        case r'uid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uid = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CompanyRegistrationResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompanyRegistrationResponseBuilder();
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
