//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/signature_stroke_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'signature_response.g.dart';

/// SignatureResponse
///
/// Properties:
/// * [inspectionRevision]
/// * [signedAt]
/// * [signerName]
/// * [signerRole]
/// * [signerUid]
/// * [strokes]
@BuiltValue()
abstract class SignatureResponse
    implements Built<SignatureResponse, SignatureResponseBuilder> {
  @BuiltValueField(wireName: r'inspection_revision')
  int get inspectionRevision;

  @BuiltValueField(wireName: r'signed_at')
  DateTime get signedAt;

  @BuiltValueField(wireName: r'signer_name')
  String get signerName;

  @BuiltValueField(wireName: r'signer_role')
  String get signerRole;

  @BuiltValueField(wireName: r'signer_uid')
  String get signerUid;

  @BuiltValueField(wireName: r'strokes')
  BuiltList<SignatureStrokeResponse> get strokes;

  SignatureResponse._();

  factory SignatureResponse([void updates(SignatureResponseBuilder b)]) =
      _$SignatureResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SignatureResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SignatureResponse> get serializer =>
      _$SignatureResponseSerializer();
}

class _$SignatureResponseSerializer
    implements PrimitiveSerializer<SignatureResponse> {
  @override
  final Iterable<Type> types = const [SignatureResponse, _$SignatureResponse];

  @override
  final String wireName = r'SignatureResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SignatureResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'inspection_revision';
    yield serializers.serialize(
      object.inspectionRevision,
      specifiedType: const FullType(int),
    );
    yield r'signed_at';
    yield serializers.serialize(
      object.signedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'signer_name';
    yield serializers.serialize(
      object.signerName,
      specifiedType: const FullType(String),
    );
    yield r'signer_role';
    yield serializers.serialize(
      object.signerRole,
      specifiedType: const FullType(String),
    );
    yield r'signer_uid';
    yield serializers.serialize(
      object.signerUid,
      specifiedType: const FullType(String),
    );
    yield r'strokes';
    yield serializers.serialize(
      object.strokes,
      specifiedType:
          const FullType(BuiltList, [FullType(SignatureStrokeResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SignatureResponse object, {
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
    required SignatureResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'inspection_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.inspectionRevision = valueDes;
          break;
        case r'signed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.signedAt = valueDes;
          break;
        case r'signer_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.signerName = valueDes;
          break;
        case r'signer_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.signerRole = valueDes;
          break;
        case r'signer_uid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.signerUid = valueDes;
          break;
        case r'strokes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(SignatureStrokeResponse)]),
          ) as BuiltList<SignatureStrokeResponse>;
          result.strokes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SignatureResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SignatureResponseBuilder();
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
