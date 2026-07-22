//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/facility_detail.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'facility_list_page.g.dart';

/// FacilityListPage
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class FacilityListPage
    implements Built<FacilityListPage, FacilityListPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<FacilityDetail> get items;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  FacilityListPage._();

  factory FacilityListPage([void updates(FacilityListPageBuilder b)]) =
      _$FacilityListPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FacilityListPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FacilityListPage> get serializer =>
      _$FacilityListPageSerializer();
}

class _$FacilityListPageSerializer
    implements PrimitiveSerializer<FacilityListPage> {
  @override
  final Iterable<Type> types = const [FacilityListPage, _$FacilityListPage];

  @override
  final String wireName = r'FacilityListPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FacilityListPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(FacilityDetail)]),
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
    FacilityListPage object, {
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
    required FacilityListPageBuilder result,
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
                const FullType(BuiltList, [FullType(FacilityDetail)]),
          ) as BuiltList<FacilityDetail>;
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
  FacilityListPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FacilityListPageBuilder();
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
