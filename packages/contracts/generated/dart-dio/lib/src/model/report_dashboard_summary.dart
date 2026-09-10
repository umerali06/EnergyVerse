//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'report_dashboard_summary.g.dart';

/// ReportDashboardSummary
///
/// Properties:
/// * [drafts]
/// * [finalized]
/// * [total]
@BuiltValue()
abstract class ReportDashboardSummary
    implements Built<ReportDashboardSummary, ReportDashboardSummaryBuilder> {
  @BuiltValueField(wireName: r'drafts')
  int get drafts;

  @BuiltValueField(wireName: r'finalized')
  int get finalized;

  @BuiltValueField(wireName: r'total')
  int get total;

  ReportDashboardSummary._();

  factory ReportDashboardSummary(
          [void updates(ReportDashboardSummaryBuilder b)]) =
      _$ReportDashboardSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReportDashboardSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReportDashboardSummary> get serializer =>
      _$ReportDashboardSummarySerializer();
}

class _$ReportDashboardSummarySerializer
    implements PrimitiveSerializer<ReportDashboardSummary> {
  @override
  final Iterable<Type> types = const [
    ReportDashboardSummary,
    _$ReportDashboardSummary
  ];

  @override
  final String wireName = r'ReportDashboardSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReportDashboardSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'drafts';
    yield serializers.serialize(
      object.drafts,
      specifiedType: const FullType(int),
    );
    yield r'finalized';
    yield serializers.serialize(
      object.finalized,
      specifiedType: const FullType(int),
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
    ReportDashboardSummary object, {
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
    required ReportDashboardSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'drafts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.drafts = valueDes;
          break;
        case r'finalized':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.finalized = valueDes;
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
  ReportDashboardSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReportDashboardSummaryBuilder();
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
