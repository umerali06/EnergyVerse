//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/training_module_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'training_module_list_page.g.dart';

/// TrainingModuleListPage
///
/// Properties:
/// * [items]
@BuiltValue()
abstract class TrainingModuleListPage
    implements Built<TrainingModuleListPage, TrainingModuleListPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<TrainingModuleResponse>? get items;

  TrainingModuleListPage._();

  factory TrainingModuleListPage(
          [void updates(TrainingModuleListPageBuilder b)]) =
      _$TrainingModuleListPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrainingModuleListPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TrainingModuleListPage> get serializer =>
      _$TrainingModuleListPageSerializer();
}

class _$TrainingModuleListPageSerializer
    implements PrimitiveSerializer<TrainingModuleListPage> {
  @override
  final Iterable<Type> types = const [
    TrainingModuleListPage,
    _$TrainingModuleListPage
  ];

  @override
  final String wireName = r'TrainingModuleListPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TrainingModuleListPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.items != null) {
      yield r'items';
      yield serializers.serialize(
        object.items,
        specifiedType:
            const FullType(BuiltList, [FullType(TrainingModuleResponse)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TrainingModuleListPage object, {
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
    required TrainingModuleListPageBuilder result,
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
                const FullType(BuiltList, [FullType(TrainingModuleResponse)]),
          ) as BuiltList<TrainingModuleResponse>;
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
  TrainingModuleListPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrainingModuleListPageBuilder();
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
