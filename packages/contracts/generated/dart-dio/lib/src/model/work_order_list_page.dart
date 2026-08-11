//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/work_order_list_item.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_order_list_page.g.dart';

/// WorkOrderListPage
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class WorkOrderListPage
    implements Built<WorkOrderListPage, WorkOrderListPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<WorkOrderListItem> get items;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  WorkOrderListPage._();

  factory WorkOrderListPage([void updates(WorkOrderListPageBuilder b)]) =
      _$WorkOrderListPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkOrderListPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkOrderListPage> get serializer =>
      _$WorkOrderListPageSerializer();
}

class _$WorkOrderListPageSerializer
    implements PrimitiveSerializer<WorkOrderListPage> {
  @override
  final Iterable<Type> types = const [WorkOrderListPage, _$WorkOrderListPage];

  @override
  final String wireName = r'WorkOrderListPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkOrderListPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(WorkOrderListItem)]),
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
    WorkOrderListPage object, {
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
    required WorkOrderListPageBuilder result,
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
                const FullType(BuiltList, [FullType(WorkOrderListItem)]),
          ) as BuiltList<WorkOrderListItem>;
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
  WorkOrderListPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkOrderListPageBuilder();
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
