//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'regenerate_generated_report_request.g.dart';

/// RegenerateGeneratedReportRequest
///
/// Properties:
/// * [expectedRevision]
@BuiltValue()
abstract class RegenerateGeneratedReportRequest
    implements
        Built<RegenerateGeneratedReportRequest,
            RegenerateGeneratedReportRequestBuilder> {
  @BuiltValueField(wireName: r'expected_revision')
  int get expectedRevision;

  RegenerateGeneratedReportRequest._();

  factory RegenerateGeneratedReportRequest(
          [void updates(RegenerateGeneratedReportRequestBuilder b)]) =
      _$RegenerateGeneratedReportRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegenerateGeneratedReportRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegenerateGeneratedReportRequest> get serializer =>
      _$RegenerateGeneratedReportRequestSerializer();
}

class _$RegenerateGeneratedReportRequestSerializer
    implements PrimitiveSerializer<RegenerateGeneratedReportRequest> {
  @override
  final Iterable<Type> types = const [
    RegenerateGeneratedReportRequest,
    _$RegenerateGeneratedReportRequest
  ];

  @override
  final String wireName = r'RegenerateGeneratedReportRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegenerateGeneratedReportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expected_revision';
    yield serializers.serialize(
      object.expectedRevision,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RegenerateGeneratedReportRequest object, {
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
    required RegenerateGeneratedReportRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  RegenerateGeneratedReportRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegenerateGeneratedReportRequestBuilder();
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
