//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'company_registration_request.g.dart';

/// CompanyRegistrationRequest
///
/// Properties:
/// * [acceptanceSource]
/// * [companyName]
/// * [displayName]
/// * [email]
/// * [legalVersion]
/// * [password]
/// * [privacyAccepted]
/// * [safetyDisclaimerAccepted]
/// * [termsAccepted]
@BuiltValue()
abstract class CompanyRegistrationRequest
    implements
        Built<CompanyRegistrationRequest, CompanyRegistrationRequestBuilder> {
  @BuiltValueField(wireName: r'acceptance_source')
  CompanyRegistrationRequestAcceptanceSourceEnum? get acceptanceSource;
  // enum acceptanceSourceEnum {  web,  mobile,  sso,  contract,  };

  @BuiltValueField(wireName: r'company_name')
  String get companyName;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'legal_version')
  String get legalVersion;

  @BuiltValueField(wireName: r'password')
  String get password;

  @BuiltValueField(wireName: r'privacy_accepted')
  bool get privacyAccepted;

  @BuiltValueField(wireName: r'safety_disclaimer_accepted')
  bool get safetyDisclaimerAccepted;

  @BuiltValueField(wireName: r'terms_accepted')
  bool get termsAccepted;

  CompanyRegistrationRequest._();

  factory CompanyRegistrationRequest(
          [void updates(CompanyRegistrationRequestBuilder b)]) =
      _$CompanyRegistrationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompanyRegistrationRequestBuilder b) => b
    ..acceptanceSource =
        const CompanyRegistrationRequestAcceptanceSourceEnum._('web');

  @BuiltValueSerializer(custom: true)
  static Serializer<CompanyRegistrationRequest> get serializer =>
      _$CompanyRegistrationRequestSerializer();
}

class _$CompanyRegistrationRequestSerializer
    implements PrimitiveSerializer<CompanyRegistrationRequest> {
  @override
  final Iterable<Type> types = const [
    CompanyRegistrationRequest,
    _$CompanyRegistrationRequest
  ];

  @override
  final String wireName = r'CompanyRegistrationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompanyRegistrationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.acceptanceSource != null) {
      yield r'acceptance_source';
      yield serializers.serialize(
        object.acceptanceSource,
        specifiedType:
            const FullType(CompanyRegistrationRequestAcceptanceSourceEnum),
      );
    }
    yield r'company_name';
    yield serializers.serialize(
      object.companyName,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'legal_version';
    yield serializers.serialize(
      object.legalVersion,
      specifiedType: const FullType(String),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
    yield r'privacy_accepted';
    yield serializers.serialize(
      object.privacyAccepted,
      specifiedType: const FullType(bool),
    );
    yield r'safety_disclaimer_accepted';
    yield serializers.serialize(
      object.safetyDisclaimerAccepted,
      specifiedType: const FullType(bool),
    );
    yield r'terms_accepted';
    yield serializers.serialize(
      object.termsAccepted,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CompanyRegistrationRequest object, {
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
    required CompanyRegistrationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'acceptance_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(CompanyRegistrationRequestAcceptanceSourceEnum),
          ) as CompanyRegistrationRequestAcceptanceSourceEnum;
          result.acceptanceSource = valueDes;
          break;
        case r'company_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyName = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'legal_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.legalVersion = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'privacy_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.privacyAccepted = valueDes;
          break;
        case r'safety_disclaimer_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.safetyDisclaimerAccepted = valueDes;
          break;
        case r'terms_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.termsAccepted = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CompanyRegistrationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompanyRegistrationRequestBuilder();
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

class CompanyRegistrationRequestAcceptanceSourceEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'web')
  static const CompanyRegistrationRequestAcceptanceSourceEnum web =
      _$companyRegistrationRequestAcceptanceSourceEnum_web;
  @BuiltValueEnumConst(wireName: r'mobile')
  static const CompanyRegistrationRequestAcceptanceSourceEnum mobile =
      _$companyRegistrationRequestAcceptanceSourceEnum_mobile;
  @BuiltValueEnumConst(wireName: r'sso')
  static const CompanyRegistrationRequestAcceptanceSourceEnum sso =
      _$companyRegistrationRequestAcceptanceSourceEnum_sso;
  @BuiltValueEnumConst(wireName: r'contract')
  static const CompanyRegistrationRequestAcceptanceSourceEnum contract =
      _$companyRegistrationRequestAcceptanceSourceEnum_contract;

  static Serializer<CompanyRegistrationRequestAcceptanceSourceEnum>
      get serializer =>
          _$companyRegistrationRequestAcceptanceSourceEnumSerializer;

  const CompanyRegistrationRequestAcceptanceSourceEnum._(String name)
      : super(name);

  static BuiltSet<CompanyRegistrationRequestAcceptanceSourceEnum> get values =>
      _$companyRegistrationRequestAcceptanceSourceEnumValues;
  static CompanyRegistrationRequestAcceptanceSourceEnum valueOf(String name) =>
      _$companyRegistrationRequestAcceptanceSourceEnumValueOf(name);
}
