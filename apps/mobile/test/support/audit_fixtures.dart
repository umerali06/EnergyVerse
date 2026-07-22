import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:fev_api_client/fev_api_client.dart';

AuditLogEntry auditLogEntryFixture({
  String id = 'event-1',
  String actorUid = 'demo-acme-field_inspector',
  String? actorName = 'Acme Field Inspector',
  String? actorRole = 'Field Inspector',
  String action = 'user.updated',
  String targetType = 'user',
  String targetId = 'demo-acme-field_inspector',
  DateTime? createdAt,
  Map<String, dynamic>? metadata,
}) {
  return AuditLogEntry(
    (builder) => builder
      ..id = id
      ..actorUid = actorUid
      ..actorName = actorName
      ..actorRole = actorRole
      ..action = action
      ..targetType = targetType
      ..targetId = targetId
      ..createdAt = createdAt ?? DateTime.now().subtract(const Duration(minutes: 5))
      ..metadata = MapBuilder(
        (metadata ??
                {
                  'before': {'status': 'inactive'},
                  'after': {'status': 'active'},
                })
            .map((key, value) => MapEntry(key, JsonObject(value))),
      ),
  );
}

AuditLogPage auditLogPageFixture({
  List<AuditLogEntry>? items,
  String? nextCursor,
  bool truncated = false,
}) {
  return AuditLogPage(
    (builder) => builder
      ..items = ListBuilder(items ?? [auditLogEntryFixture()])
      ..nextCursor = nextCursor
      ..truncated = truncated,
  );
}

AuditLogFacets auditLogFacetsFixture({
  List<String>? actions,
  List<String>? targetTypes,
}) {
  return AuditLogFacets(
    (builder) => builder
      ..actions = ListBuilder(actions ?? ['user.updated'])
      ..targetTypes = ListBuilder(targetTypes ?? ['user']),
  );
}
