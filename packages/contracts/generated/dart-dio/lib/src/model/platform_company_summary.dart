//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_company_summary.g.dart';

/// PlatformCompanySummary
///
/// Properties:
/// * [createdAt]
/// * [id]
/// * [name]
/// * [status]
/// * [subscriptionTier]
/// * [usersTotal]
@BuiltValue()
abstract class PlatformCompanySummary
    implements Built<PlatformCompanySummary, PlatformCompanySummaryBuilder> {
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'subscription_tier')
  String get subscriptionTier;

  @BuiltValueField(wireName: r'users_total')
  int get usersTotal;

  PlatformCompanySummary._();

  factory PlatformCompanySummary(
          [void updates(PlatformCompanySummaryBuilder b)]) =
      _$PlatformCompanySummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformCompanySummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformCompanySummary> get serializer =>
      _$PlatformCompanySummarySerializer();
}

class _$PlatformCompanySummarySerializer
    implements PrimitiveSerializer<PlatformCompanySummary> {
  @override
  final Iterable<Type> types = const [
    PlatformCompanySummary,
    _$PlatformCompanySummary
  ];

  @override
  final String wireName = r'PlatformCompanySummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformCompanySummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
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
    PlatformCompanySummary object, {
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
    required PlatformCompanySummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
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
  PlatformCompanySummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformCompanySummaryBuilder();
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
