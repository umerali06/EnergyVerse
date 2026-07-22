//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/audit_log_entry.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'audit_log_page.g.dart';

/// AuditLogPage
///
/// Properties:
/// * [items]
/// * [nextCursor]
/// * [truncated] - True when the underlying date range held more events than the server-side read cap; narrow the range for a complete view
@BuiltValue()
abstract class AuditLogPage
    implements Built<AuditLogPage, AuditLogPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AuditLogEntry> get items;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  /// True when the underlying date range held more events than the server-side read cap; narrow the range for a complete view
  @BuiltValueField(wireName: r'truncated')
  bool get truncated;

  AuditLogPage._();

  factory AuditLogPage([void updates(AuditLogPageBuilder b)]) = _$AuditLogPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuditLogPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuditLogPage> get serializer => _$AuditLogPageSerializer();
}

class _$AuditLogPageSerializer implements PrimitiveSerializer<AuditLogPage> {
  @override
  final Iterable<Type> types = const [AuditLogPage, _$AuditLogPage];

  @override
  final String wireName = r'AuditLogPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuditLogPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AuditLogEntry)]),
    );
    if (object.nextCursor != null) {
      yield r'next_cursor';
      yield serializers.serialize(
        object.nextCursor,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'truncated';
    yield serializers.serialize(
      object.truncated,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AuditLogPage object, {
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
    required AuditLogPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AuditLogEntry)]),
          ) as BuiltList<AuditLogEntry>;
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
        case r'truncated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.truncated = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuditLogPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuditLogPageBuilder();
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
