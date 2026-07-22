//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/platform_company_summary.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_company_page.g.dart';

/// PlatformCompanyPage
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class PlatformCompanyPage
    implements Built<PlatformCompanyPage, PlatformCompanyPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PlatformCompanySummary> get items;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  PlatformCompanyPage._();

  factory PlatformCompanyPage([void updates(PlatformCompanyPageBuilder b)]) =
      _$PlatformCompanyPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformCompanyPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformCompanyPage> get serializer =>
      _$PlatformCompanyPageSerializer();
}

class _$PlatformCompanyPageSerializer
    implements PrimitiveSerializer<PlatformCompanyPage> {
  @override
  final Iterable<Type> types = const [
    PlatformCompanyPage,
    _$PlatformCompanyPage
  ];

  @override
  final String wireName = r'PlatformCompanyPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformCompanyPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType:
          const FullType(BuiltList, [FullType(PlatformCompanySummary)]),
    );
    if (object.nextCursor != null) {
      yield r'next_cursor';
      yield serializers.serialize(
        object.nextCursor,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PlatformCompanyPage object, {
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
    required PlatformCompanyPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(PlatformCompanySummary)]),
          ) as BuiltList<PlatformCompanySummary>;
          result.items.replace(valueDes);
          break;
        case r'next_cursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlatformCompanyPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformCompanyPageBuilder();
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
