//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/training_progress_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'training_progress_list_page.g.dart';

/// TrainingProgressListPage
///
/// Properties:
/// * [items]
@BuiltValue()
abstract class TrainingProgressListPage
    implements
        Built<TrainingProgressListPage, TrainingProgressListPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<TrainingProgressResponse>? get items;

  TrainingProgressListPage._();

  factory TrainingProgressListPage(
          [void updates(TrainingProgressListPageBuilder b)]) =
      _$TrainingProgressListPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrainingProgressListPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TrainingProgressListPage> get serializer =>
      _$TrainingProgressListPageSerializer();
}

class _$TrainingProgressListPageSerializer
    implements PrimitiveSerializer<TrainingProgressListPage> {
  @override
  final Iterable<Type> types = const [
    TrainingProgressListPage,
    _$TrainingProgressListPage
  ];

  @override
  final String wireName = r'TrainingProgressListPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TrainingProgressListPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.items != null) {
      yield r'items';
      yield serializers.serialize(
        object.items,
        specifiedType:
            const FullType(BuiltList, [FullType(TrainingProgressResponse)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TrainingProgressListPage object, {
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
    required TrainingProgressListPageBuilder result,
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
                const FullType(BuiltList, [FullType(TrainingProgressResponse)]),
          ) as BuiltList<TrainingProgressResponse>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TrainingProgressListPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrainingProgressListPageBuilder();
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
