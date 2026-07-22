//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:fev_api_client/src/date_serializer.dart';
import 'package:fev_api_client/src/model/date.dart';

import 'package:fev_api_client/src/model/company_profile.dart';
import 'package:fev_api_client/src/model/company_registration_request.dart';
import 'package:fev_api_client/src/model/company_registration_response.dart';
import 'package:fev_api_client/src/model/create_role_request.dart';
import 'package:fev_api_client/src/model/current_user.dart';
import 'package:fev_api_client/src/model/dashboard_activity_item.dart';
import 'package:fev_api_client/src/model/dashboard_activity_page.dart';
import 'package:fev_api_client/src/model/dashboard_activity_series.dart';
import 'package:fev_api_client/src/model/dashboard_series_point.dart';
import 'package:fev_api_client/src/model/dashboard_summary.dart';
import 'package:fev_api_client/src/model/demo_gate_response.dart';
import 'package:fev_api_client/src/model/error_envelope.dart';
import 'package:fev_api_client/src/model/health_response.dart';
import 'package:fev_api_client/src/model/invite_user_request.dart';
import 'package:fev_api_client/src/model/permission_catalog.dart';
import 'package:fev_api_client/src/model/permission_catalog_group.dart';
import 'package:fev_api_client/src/model/permission_catalog_item.dart';
import 'package:fev_api_client/src/model/role_deleted.dart';
import 'package:fev_api_client/src/model/role_detail.dart';
import 'package:fev_api_client/src/model/role_list.dart';
import 'package:fev_api_client/src/model/role_summary.dart';
import 'package:fev_api_client/src/model/service_response.dart';
import 'package:fev_api_client/src/model/update_company_request.dart';
import 'package:fev_api_client/src/model/update_role_request.dart';
import 'package:fev_api_client/src/model/update_user_request.dart';
import 'package:fev_api_client/src/model/update_user_status_request.dart';
import 'package:fev_api_client/src/model/user_detail.dart';
import 'package:fev_api_client/src/model/user_list_item.dart';
import 'package:fev_api_client/src/model/user_list_page.dart';

part 'serializers.g.dart';

@SerializersFor([
  CompanyProfile,
  CompanyRegistrationRequest,
  CompanyRegistrationResponse,
  CreateRoleRequest,
  CurrentUser,
  DashboardActivityItem,
  DashboardActivityPage,
  DashboardActivitySeries,
  DashboardSeriesPoint,
  DashboardSummary,
  DemoGateResponse,
  ErrorEnvelope,
  HealthResponse,
  InviteUserRequest,
  PermissionCatalog,
  PermissionCatalogGroup,
  PermissionCatalogItem,
  RoleDeleted,
  RoleDetail,
  RoleList,
  RoleSummary,
  ServiceResponse,
  UpdateCompanyRequest,
  UpdateRoleRequest,
  UpdateUserRequest,
  UpdateUserStatusRequest,
  UserDetail,
  UserListItem,
  UserListPage,
])
Serializers serializers = (_$serializers.toBuilder()
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
