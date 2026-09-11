//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/safety_category_count.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'safety_dashboard_summary.g.dart';

/// SafetyDashboardSummary
///
/// Properties:
/// * [byCategory]
/// * [total]
@BuiltValue()
abstract class SafetyDashboardSummary
    implements Built<SafetyDashboardSummary, SafetyDashboardSummaryBuilder> {
  @BuiltValueField(wireName: r'by_category')
  BuiltList<SafetyCategoryCount> get byCategory;

  @BuiltValueField(wireName: r'total')
  int get total;

  SafetyDashboardSummary._();

  factory SafetyDashboardSummary(
          [void updates(SafetyDashboardSummaryBuilder b)]) =
      _$SafetyDashboardSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SafetyDashboardSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SafetyDashboardSummary> get serializer =>
      _$SafetyDashboardSummarySerializer();
}

class _$SafetyDashboardSummarySerializer
    implements PrimitiveSerializer<SafetyDashboardSummary> {
  @override
  final Iterable<Type> types = const [
    SafetyDashboardSummary,
    _$SafetyDashboardSummary
  ];

  @override
  final String wireName = r'SafetyDashboardSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SafetyDashboardSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'by_category';
    yield serializers.serialize(
      object.byCategory,
      specifiedType: const FullType(BuiltList, [FullType(SafetyCategoryCount)]),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SafetyDashboardSummary object, {
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
    required SafetyDashboardSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'by_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(SafetyCategoryCount)]),
          ) as BuiltList<SafetyCategoryCount>;
          result.byCategory.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SafetyDashboardSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SafetyDashboardSummaryBuilder();
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
