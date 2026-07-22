//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_company_detail.g.dart';

/// PlatformCompanyDetail
///
/// Properties:
/// * [contactEmail]
/// * [createdAt]
/// * [id]
/// * [industry]
/// * [name]
/// * [rolesTotal]
/// * [status]
/// * [subscriptionTier]
/// * [usersTotal]
@BuiltValue()
abstract class PlatformCompanyDetail
    implements Built<PlatformCompanyDetail, PlatformCompanyDetailBuilder> {
  @BuiltValueField(wireName: r'contact_email')
  String? get contactEmail;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'industry')
  String? get industry;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'roles_total')
  int get rolesTotal;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'subscription_tier')
  String get subscriptionTier;

  @BuiltValueField(wireName: r'users_total')
  int get usersTotal;

  PlatformCompanyDetail._();

  factory PlatformCompanyDetail(
      [void updates(PlatformCompanyDetailBuilder b)]) = _$PlatformCompanyDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformCompanyDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformCompanyDetail> get serializer =>
      _$PlatformCompanyDetailSerializer();
}

class _$PlatformCompanyDetailSerializer
    implements PrimitiveSerializer<PlatformCompanyDetail> {
  @override
  final Iterable<Type> types = const [
    PlatformCompanyDetail,
    _$PlatformCompanyDetail
  ];

  @override
  final String wireName = r'PlatformCompanyDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformCompanyDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.contactEmail != null) {
      yield r'contact_email';
      yield serializers.serialize(
        object.contactEmail,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.industry != null) {
      yield r'industry';
      yield serializers.serialize(
        object.industry,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'roles_total';
    yield serializers.serialize(
      object.rolesTotal,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'subscription_tier';
    yield serializers.serialize(
      object.subscriptionTier,
      specifiedType: const FullType(String),
    );
    yield r'users_total';
    yield serializers.serialize(
      object.usersTotal,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PlatformCompanyDetail object, {
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
    required PlatformCompanyDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'contact_email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.contactEmail = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'industry':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.industry = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'roles_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rolesTotal = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'subscription_tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subscriptionTier = valueDes;
          break;
        case r'users_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.usersTotal = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlatformCompanyDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformCompanyDetailBuilder();
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
