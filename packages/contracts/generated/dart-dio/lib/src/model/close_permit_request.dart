//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'close_permit_request.g.dart';

/// ClosePermitRequest
///
/// Properties:
/// * [closeAttestation]
/// * [closeoutNotes]
/// * [expectedRevision]
@BuiltValue()
abstract class ClosePermitRequest
    implements Built<ClosePermitRequest, ClosePermitRequestBuilder> {
  @BuiltValueField(wireName: r'close_attestation')
  ClosePermitRequestCloseAttestationEnum get closeAttestation;
  // enum closeAttestationEnum {  true,  };

  @BuiltValueField(wireName: r'closeout_notes')
  String get closeoutNotes;

  @BuiltValueField(wireName: r'expected_revision')
  int get expectedRevision;

  ClosePermitRequest._();

  factory ClosePermitRequest([void updates(ClosePermitRequestBuilder b)]) =
      _$ClosePermitRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClosePermitRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClosePermitRequest> get serializer =>
      _$ClosePermitRequestSerializer();
}

class _$ClosePermitRequestSerializer
    implements PrimitiveSerializer<ClosePermitRequest> {
  @override
  final Iterable<Type> types = const [ClosePermitRequest, _$ClosePermitRequest];

  @override
  final String wireName = r'ClosePermitRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClosePermitRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'close_attestation';
    yield serializers.serialize(
      object.closeAttestation,
      specifiedType: const FullType(ClosePermitRequestCloseAttestationEnum),
    );
    yield r'closeout_notes';
    yield serializers.serialize(
      object.closeoutNotes,
      specifiedType: const FullType(String),
    );
    yield r'expected_revision';
    yield serializers.serialize(
      object.expectedRevision,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ClosePermitRequest object, {
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
    required ClosePermitRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'close_attestation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(ClosePermitRequestCloseAttestationEnum),
          ) as ClosePermitRequestCloseAttestationEnum;
          result.closeAttestation = valueDes;
          break;
        case r'closeout_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.closeoutNotes = valueDes;
          break;
        case r'expected_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedRevision = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ClosePermitRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClosePermitRequestBuilder();
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

class ClosePermitRequestCloseAttestationEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'true')
  static const ClosePermitRequestCloseAttestationEnum true_ =
      _$closePermitRequestCloseAttestationEnum_true_;

  static Serializer<ClosePermitRequestCloseAttestationEnum> get serializer =>
      _$closePermitRequestCloseAttestationEnumSerializer;

  const ClosePermitRequestCloseAttestationEnum._(String name) : super(name);

  static BuiltSet<ClosePermitRequestCloseAttestationEnum> get values =>
      _$closePermitRequestCloseAttestationEnumValues;
  static ClosePermitRequestCloseAttestationEnum valueOf(String name) =>
      _$closePermitRequestCloseAttestationEnumValueOf(name);
}
