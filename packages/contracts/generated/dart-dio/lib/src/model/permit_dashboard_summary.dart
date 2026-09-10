//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_dashboard_summary.g.dart';

/// PermitDashboardSummary
///
/// Properties:
/// * [active]
@BuiltValue()
abstract class PermitDashboardSummary
    implements Built<PermitDashboardSummary, PermitDashboardSummaryBuilder> {
  @BuiltValueField(wireName: r'active')
  int get active;

  PermitDashboardSummary._();

  factory PermitDashboardSummary(
          [void updates(PermitDashboardSummaryBuilder b)]) =
      _$PermitDashboardSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitDashboardSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitDashboardSummary> get serializer =>
      _$PermitDashboardSummarySerializer();
}

class _$PermitDashboardSummarySerializer
    implements PrimitiveSerializer<PermitDashboardSummary> {
  @override
  final Iterable<Type> types = const [
    PermitDashboardSummary,
    _$PermitDashboardSummary
  ];

  @override
  final String wireName = r'PermitDashboardSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitDashboardSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PermitDashboardSummary object, {
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
    required PermitDashboardSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.active = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PermitDashboardSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitDashboardSummaryBuilder();
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
