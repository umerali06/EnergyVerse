//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/checklist_template_item_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_checklist_template_request.g.dart';

/// CreateChecklistTemplateRequest
///
/// Properties:
/// * [category]
/// * [description]
/// * [items]
/// * [name]
@BuiltValue()
abstract class CreateChecklistTemplateRequest
    implements
        Built<CreateChecklistTemplateRequest,
            CreateChecklistTemplateRequestBuilder> {
  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'items')
  BuiltList<ChecklistTemplateItemInput>? get items;

  @BuiltValueField(wireName: r'name')
  String get name;

  CreateChecklistTemplateRequest._();

  factory CreateChecklistTemplateRequest(
          [void updates(CreateChecklistTemplateRequestBuilder b)]) =
      _$CreateChecklistTemplateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateChecklistTemplateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateChecklistTemplateRequest> get serializer =>
      _$CreateChecklistTemplateRequestSerializer();
}

class _$CreateChecklistTemplateRequestSerializer
    implements PrimitiveSerializer<CreateChecklistTemplateRequest> {
  @override
  final Iterable<Type> types = const [
    CreateChecklistTemplateRequest,
    _$CreateChecklistTemplateRequest
  ];

  @override
  final String wireName = r'CreateChecklistTemplateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateChecklistTemplateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.items != null) {
      yield r'items';
      yield serializers.serialize(
        object.items,
        specifiedType:
            const FullType(BuiltList, [FullType(ChecklistTemplateItemInput)]),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateChecklistTemplateRequest object, {
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
    required CreateChecklistTemplateRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(ChecklistTemplateItemInput)]),
          ) as BuiltList<ChecklistTemplateItemInput>;
          result.items.replace(valueDes);
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateChecklistTemplateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateChecklistTemplateRequestBuilder();
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
