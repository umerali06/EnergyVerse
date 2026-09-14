//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'legal_acceptance_response.g.dart';

/// What the signed-in user has accepted, and at which version.  `current_version` is what the deployment publishes today; when it differs from `accepted_version` the client knows to re-ask rather than assuming an older acceptance still covers a materially changed document.
///
/// Properties:
/// * [acceptanceSource]
/// * [acceptedAt]
/// * [acceptedVersion]
/// * [currentVersion]
/// * [privacyAccepted]
/// * [requiresAcceptance]
/// * [safetyDisclaimerAccepted]
/// * [termsAccepted]
@BuiltValue()
abstract class LegalAcceptanceResponse
    implements Built<LegalAcceptanceResponse, LegalAcceptanceResponseBuilder> {
  @BuiltValueField(wireName: r'acceptance_source')
  String? get acceptanceSource;

  @BuiltValueField(wireName: r'accepted_at')
  DateTime? get acceptedAt;

  @BuiltValueField(wireName: r'accepted_version')
  String? get acceptedVersion;

  @BuiltValueField(wireName: r'current_version')
  String get currentVersion;

  @BuiltValueField(wireName: r'privacy_accepted')
  bool get privacyAccepted;

  @BuiltValueField(wireName: r'requires_acceptance')
  bool get requiresAcceptance;

  @BuiltValueField(wireName: r'safety_disclaimer_accepted')
  bool get safetyDisclaimerAccepted;

  @BuiltValueField(wireName: r'terms_accepted')
  bool get termsAccepted;

  LegalAcceptanceResponse._();

  factory LegalAcceptanceResponse(
          [void updates(LegalAcceptanceResponseBuilder b)]) =
      _$LegalAcceptanceResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LegalAcceptanceResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LegalAcceptanceResponse> get serializer =>
      _$LegalAcceptanceResponseSerializer();
}

class _$LegalAcceptanceResponseSerializer
    implements PrimitiveSerializer<LegalAcceptanceResponse> {
  @override
  final Iterable<Type> types = const [
    LegalAcceptanceResponse,
    _$LegalAcceptanceResponse
  ];

  @override
  final String wireName = r'LegalAcceptanceResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LegalAcceptanceResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'acceptance_source';
    yield object.acceptanceSource == null
        ? null
        : serializers.serialize(
            object.acceptanceSource,
            specifiedType: const FullType.nullable(String),
          );
    yield r'accepted_at';
    yield object.acceptedAt == null
        ? null
        : serializers.serialize(
            object.acceptedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'accepted_version';
    yield object.acceptedVersion == null
        ? null
        : serializers.serialize(
            object.acceptedVersion,
            specifiedType: const FullType.nullable(String),
          );
    yield r'current_version';
    yield serializers.serialize(
      object.currentVersion,
      specifiedType: const FullType(String),
    );
    yield r'privacy_accepted';
    yield serializers.serialize(
      object.privacyAccepted,
      specifiedType: const FullType(bool),
    );
    yield r'requires_acceptance';
    yield serializers.serialize(
      object.requiresAcceptance,
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
    LegalAcceptanceResponse object, {
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
    required LegalAcceptanceResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'acceptance_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.acceptanceSource = valueDes;
          break;
        case r'accepted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.acceptedAt = valueDes;
          break;
        case r'accepted_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.acceptedVersion = valueDes;
          break;
        case r'current_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currentVersion = valueDes;
          break;
        case r'privacy_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.privacyAccepted = valueDes;
          break;
        case r'requires_acceptance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.requiresAcceptance = valueDes;
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
  LegalAcceptanceResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LegalAcceptanceResponseBuilder();
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
