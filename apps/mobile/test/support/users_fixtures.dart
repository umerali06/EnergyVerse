import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/fev_api_client.dart';

UserListItem userListItemFixture({
  String id = 'demo-acme-field_inspector',
  String email = 'field_inspector@acme.example.invalid',
  String displayName = 'Acme Field Inspector',
  String roleId = 'role-field-inspector',
  String roleKey = 'field_inspector',
  String roleName = 'Field Inspector',
  String status = 'active',
  DateTime? updatedAt,
}) {
  return UserListItem(
    (builder) => builder
      ..id = id
      ..email = email
      ..displayName = displayName
      ..roleId = roleId
      ..roleKey = roleKey
      ..roleName = roleName
      ..status = status
      ..createdAt = DateTime.utc(2026, 1, 1)
      ..updatedAt = updatedAt ?? DateTime.now().subtract(const Duration(minutes: 5)),
  );
}

UserListPage userListPageFixture({
  List<UserListItem>? items,
  String? nextCursor,
}) {
  return UserListPage(
    (builder) => builder
      ..items = ListBuilder(items ?? [userListItemFixture()])
      ..nextCursor = nextCursor,
  );
}

UserDetail userDetailFixture({
  String id = 'demo-acme-field_inspector',
  String email = 'field_inspector@acme.example.invalid',
  String displayName = 'Acme Field Inspector',
  String roleId = 'role-field-inspector',
  String roleKey = 'field_inspector',
  String roleName = 'Field Inspector',
  String status = 'active',
  List<String>? permissions,
}) {
  return UserDetail(
    (builder) => builder
      ..id = id
      ..email = email
      ..displayName = displayName
      ..roleId = roleId
      ..roleKey = roleKey
      ..roleName = roleName
      ..status = status
      ..createdAt = DateTime.utc(2026, 1, 1)
      ..updatedAt = DateTime.now().subtract(const Duration(minutes: 5))
      ..permissions.addAll(permissions ?? ['assets.read', 'reports.read']),
  );
}
