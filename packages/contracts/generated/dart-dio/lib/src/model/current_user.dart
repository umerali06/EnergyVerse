//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'current_user.g.dart';

/// CurrentUser
///
/// Properties:
/// * [companyId]
/// * [companyLocale]
/// * [companyName]
/// * [companyTimezone]
/// * [email]
/// * [emailVerified]
/// * [permissions]
/// * [roleKey]
/// * [uid]
@BuiltValue()
abstract class CurrentUser implements Built<CurrentUser, CurrentUserBuilder> {
  @BuiltValueField(wireName: r'company_id')
  String get companyId;

  @BuiltValueField(wireName: r'company_locale')
  String? get companyLocale;

  @BuiltValueField(wireName: r'company_name')
  String get companyName;

  @BuiltValueField(wireName: r'company_timezone')
  String? get companyTimezone;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'email_verified')
  bool get emailVerified;

  @BuiltValueField(wireName: r'permissions')
  BuiltSet<String> get permissions;

  @BuiltValueField(wireName: r'role_key')
  String get roleKey;

  @BuiltValueField(wireName: r'uid')
  String get uid;

  CurrentUser._();

  factory CurrentUser([void updates(CurrentUserBuilder b)]) = _$CurrentUser;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CurrentUserBuilder b) => b
    ..companyLocale = 'en-US'
    ..companyTimezone = 'UTC';

  @BuiltValueSerializer(custom: true)
  static Serializer<CurrentUser> get serializer => _$CurrentUserSerializer();
}

class _$CurrentUserSerializer implements PrimitiveSerializer<CurrentUser> {
  @override
  final Iterable<Type> types = const [CurrentUser, _$CurrentUser];

  @override
  final String wireName = r'CurrentUser';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CurrentUser object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'company_id';
    yield serializers.serialize(
      object.companyId,
      specifiedType: const FullType(String),
    );
    if (object.companyLocale != null) {
      yield r'company_locale';
      yield serializers.serialize(
        object.companyLocale,
        specifiedType: const FullType(String),
      );
    }
    yield r'company_name';
    yield serializers.serialize(
      object.companyName,
      specifiedType: const FullType(String),
    );
    if (object.companyTimezone != null) {
      yield r'company_timezone';
      yield serializers.serialize(
        object.companyTimezone,
        specifiedType: const FullType(String),
      );
    }
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
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltSet, [FullType(String)]),
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
    CurrentUser object, {
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
    required CurrentUserBuilder result,
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
        case r'company_locale':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyLocale = valueDes;
          break;
        case r'company_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyName = valueDes;
          break;
        case r'company_timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyTimezone = valueDes;
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
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(String)]),
          ) as BuiltSet<String>;
          result.permissions.replace(valueDes);
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
  CurrentUser deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CurrentUserBuilder();
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
