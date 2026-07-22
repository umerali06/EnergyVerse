import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/fev_api_client.dart';

RoleSummary roleSummaryFixture({
  String id = 'role-hse',
  String key = 'hse_manager',
  String name = 'HSE Manager',
  String description = 'Manage health, safety, and environmental oversight',
  bool isSystem = true,
  int permissionCount = 9,
  int assignedUserCount = 1,
}) {
  return RoleSummary(
    (builder) => builder
      ..id = id
      ..key = key
      ..name = name
      ..description = description
      ..isSystem = isSystem
      ..permissionCount = permissionCount
      ..assignedUserCount = assignedUserCount,
  );
}

RoleList roleListFixture({List<RoleSummary>? items}) {
  return RoleList(
    (builder) => builder..items = ListBuilder(items ?? [roleSummaryFixture()]),
  );
}

RoleDetail roleDetailFixture({
  String id = 'role-hse',
  String key = 'hse_manager',
  String name = 'HSE Manager',
  String description = 'Manage health, safety, and environmental oversight',
  bool isSystem = true,
  int assignedUserCount = 1,
  List<String>? permissionKeys,
}) {
  return RoleDetail(
    (builder) => builder
      ..id = id
      ..key = key
      ..name = name
      ..description = description
      ..isSystem = isSystem
      ..assignedUserCount = assignedUserCount
      ..permissionKeys.addAll(
        permissionKeys ?? ['assets.read', 'permits.read', 'permits.approve', 'safety.read'],
      ),
  );
}
