// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(AnnotationPointInput.serializer)
      ..add(AnnotationPointResponse.serializer)
      ..add(AnnotationResponse.serializer)
      ..add(AnnotationResponseDamageTypeEnum.serializer)
      ..add(AnnotationResponseShapeEnum.serializer)
      ..add(AnnotationResponseSource_Enum.serializer)
      ..add(AreaDeleted.serializer)
      ..add(AreaDetail.serializer)
      ..add(AreaListPage.serializer)
      ..add(AssetCategoryCount.serializer)
      ..add(AssetDashboardSummary.serializer)
      ..add(AssetDeleted.serializer)
      ..add(AssetDetail.serializer)
      ..add(AssetDetailCurrentStatusEnum.serializer)
      ..add(AssetFacilityCount.serializer)
      ..add(AssetHistoryEvent.serializer)
      ..add(AssetHistoryPage.serializer)
      ..add(AssetListItem.serializer)
      ..add(AssetListItemCurrentStatusEnum.serializer)
      ..add(AssetListPage.serializer)
      ..add(AssetMediaResponse.serializer)
      ..add(AssetMediaResponseKindEnum.serializer)
      ..add(AssetQrLabel.serializer)
      ..add(AssignChecklistTemplateRequest.serializer)
      ..add(AttachInspectionMediaRequest.serializer)
      ..add(AttachInspectionMediaRequestBeforeAfterTagEnum.serializer)
      ..add(AttachInspectionMediaRequestKindEnum.serializer)
      ..add(AttachVoiceNoteRequest.serializer)
      ..add(AuditLogEntry.serializer)
      ..add(AuditLogFacets.serializer)
      ..add(AuditLogPage.serializer)
      ..add(ChecklistResponse.serializer)
      ..add(ChecklistTemplateDeleted.serializer)
      ..add(ChecklistTemplateDetail.serializer)
      ..add(ChecklistTemplateItem.serializer)
      ..add(ChecklistTemplateItemInput.serializer)
      ..add(ChecklistTemplateItemInputItemTypeEnum.serializer)
      ..add(ChecklistTemplateItemItemTypeEnum.serializer)
      ..add(ChecklistTemplateListItem.serializer)
      ..add(ChecklistTemplateListPage.serializer)
      ..add(CompanyProfile.serializer)
      ..add(CompanyRegistrationRequest.serializer)
      ..add(CompanyRegistrationResponse.serializer)
      ..add(CreateAnnotationRequest.serializer)
      ..add(CreateAnnotationRequestDamageTypeEnum.serializer)
      ..add(CreateAnnotationRequestShapeEnum.serializer)
      ..add(CreateAreaRequest.serializer)
      ..add(CreateAssetRequest.serializer)
      ..add(CreateAssetRequestCurrentStatusEnum.serializer)
      ..add(CreateChecklistTemplateRequest.serializer)
      ..add(CreateFacilityRequest.serializer)
      ..add(CreateFacilityRequestStatusEnum.serializer)
      ..add(CreateInspectionRequest.serializer)
      ..add(CreateInspectionRequestInspectionTypeEnum.serializer)
      ..add(CreateRoleRequest.serializer)
      ..add(CurrentUser.serializer)
      ..add(DashboardActivityItem.serializer)
      ..add(DashboardActivityPage.serializer)
      ..add(DashboardActivitySeries.serializer)
      ..add(DashboardSeriesPoint.serializer)
      ..add(DashboardSummary.serializer)
      ..add(DemoGateResponse.serializer)
      ..add(DemoGateResponseOkEnum.serializer)
      ..add(ErrorEnvelope.serializer)
      ..add(FacilityDeleted.serializer)
      ..add(FacilityDetail.serializer)
      ..add(FacilityDetailStatusEnum.serializer)
      ..add(FacilityListPage.serializer)
      ..add(HTTPValidationError.serializer)
      ..add(HealthResponse.serializer)
      ..add(HealthResponseFirestoreEnum.serializer)
      ..add(HealthResponseServiceEnum.serializer)
      ..add(HealthResponseStatusEnum.serializer)
      ..add(InspectionDeleted.serializer)
      ..add(InspectionDetail.serializer)
      ..add(InspectionDetailInspectionTypeEnum.serializer)
      ..add(InspectionDetailStatusEnum.serializer)
      ..add(InspectionListItem.serializer)
      ..add(InspectionListItemInspectionTypeEnum.serializer)
      ..add(InspectionListItemStatusEnum.serializer)
      ..add(InspectionListPage.serializer)
      ..add(InspectionMediaResponse.serializer)
      ..add(InspectionMediaResponseBeforeAfterTagEnum.serializer)
      ..add(InspectionMediaResponseKindEnum.serializer)
      ..add(InviteUserRequest.serializer)
      ..add(PermissionCatalog.serializer)
      ..add(PermissionCatalogGroup.serializer)
      ..add(PermissionCatalogItem.serializer)
      ..add(PlatformCompanyDetail.serializer)
      ..add(PlatformCompanyPage.serializer)
      ..add(PlatformCompanySummary.serializer)
      ..add(PlatformStats.serializer)
      ..add(QrScanResult.serializer)
      ..add(ReadingsInput.serializer)
      ..add(ReadingsInputConditionEnum.serializer)
      ..add(ReadingsInputOperationalStatusEnum.serializer)
      ..add(ReadingsInputPriorityLevelEnum.serializer)
      ..add(ReadingsResponse.serializer)
      ..add(ReadingsResponseConditionEnum.serializer)
      ..add(ReadingsResponseOperationalStatusEnum.serializer)
      ..add(ReadingsResponsePriorityLevelEnum.serializer)
      ..add(RoleDeleted.serializer)
      ..add(RoleDetail.serializer)
      ..add(RoleList.serializer)
      ..add(RoleSummary.serializer)
      ..add(ServiceResponse.serializer)
      ..add(ServiceResponseServiceEnum.serializer)
      ..add(ServiceResponseStatusEnum.serializer)
      ..add(UpdateAnnotationRequest.serializer)
      ..add(UpdateAnnotationRequestDamageTypeEnum.serializer)
      ..add(UpdateAreaRequest.serializer)
      ..add(UpdateAssetRequest.serializer)
      ..add(UpdateAssetRequestCurrentStatusEnum.serializer)
      ..add(UpdateChecklistTemplateRequest.serializer)
      ..add(UpdateCompanyRequest.serializer)
      ..add(UpdateCompanyStatusRequest.serializer)
      ..add(UpdateCompanyStatusRequestStatusEnum.serializer)
      ..add(UpdateFacilityRequest.serializer)
      ..add(UpdateFacilityRequestStatusEnum.serializer)
      ..add(UpdateInspectionMediaRequest.serializer)
      ..add(UpdateInspectionMediaRequestBeforeAfterTagEnum.serializer)
      ..add(UpdateInspectionRequest.serializer)
      ..add(UpdateInspectionRequestInspectionTypeEnum.serializer)
      ..add(UpdatePlatformCompanyRequest.serializer)
      ..add(UpdatePlatformCompanyRequestSubscriptionTierEnum.serializer)
      ..add(UpdateRoleRequest.serializer)
      ..add(UpdateUserRequest.serializer)
      ..add(UpdateUserStatusRequest.serializer)
      ..add(UpdateUserStatusRequestStatusEnum.serializer)
      ..add(UpdateVoiceNoteRequest.serializer)
      ..add(UserDetail.serializer)
      ..add(UserListItem.serializer)
      ..add(UserListPage.serializer)
      ..add(ValidationError.serializer)
      ..add(ValidationErrorLocInner.serializer)
      ..add(Value.serializer)
      ..add(VoiceNoteResponse.serializer)
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(AnnotationPointInput)]),
          () => new ListBuilder<AnnotationPointInput>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(AnnotationPointInput)]),
          () => new ListBuilder<AnnotationPointInput>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(AnnotationPointResponse)]),
          () => new ListBuilder<AnnotationPointResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AreaDetail)]),
          () => new ListBuilder<AreaDetail>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AssetCategoryCount)]),
          () => new ListBuilder<AssetCategoryCount>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AssetFacilityCount)]),
          () => new ListBuilder<AssetFacilityCount>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AssetHistoryEvent)]),
          () => new ListBuilder<AssetHistoryEvent>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AssetListItem)]),
          () => new ListBuilder<AssetListItem>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AssetMediaResponse)]),
          () => new ListBuilder<AssetMediaResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AssetMediaResponse)]),
          () => new ListBuilder<AssetMediaResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AssetMediaResponse)]),
          () => new ListBuilder<AssetMediaResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AuditLogEntry)]),
          () => new ListBuilder<AuditLogEntry>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ChecklistResponse)]),
          () => new ListBuilder<ChecklistResponse>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ChecklistTemplateItem)]),
          () => new ListBuilder<ChecklistTemplateItem>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ChecklistTemplateItemInput)]),
          () => new ListBuilder<ChecklistTemplateItemInput>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ChecklistTemplateItemInput)]),
          () => new ListBuilder<ChecklistTemplateItemInput>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ChecklistTemplateListItem)]),
          () => new ListBuilder<ChecklistTemplateListItem>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DashboardActivityItem)]),
          () => new ListBuilder<DashboardActivityItem>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DashboardSeriesPoint)]),
          () => new ListBuilder<DashboardSeriesPoint>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(FacilityDetail)]),
          () => new ListBuilder<FacilityDetail>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InspectionListItem)]),
          () => new ListBuilder<InspectionListItem>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(PermissionCatalogGroup)]),
          () => new ListBuilder<PermissionCatalogGroup>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(PermissionCatalogItem)]),
          () => new ListBuilder<PermissionCatalogItem>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(PlatformCompanySummary)]),
          () => new ListBuilder<PlatformCompanySummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(RoleSummary)]),
          () => new ListBuilder<RoleSummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(UserListItem)]),
          () => new ListBuilder<UserListItem>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ValidationError)]),
          () => new ListBuilder<ValidationError>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ValidationErrorLocInner)]),
          () => new ListBuilder<ValidationErrorLocInner>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => new MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => new MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => new MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AnnotationResponse)]),
          () => new ListBuilder<AnnotationResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => new ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ChecklistTemplateItem)]),
          () => new ListBuilder<ChecklistTemplateItem>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ChecklistResponse)]),
          () => new ListBuilder<ChecklistResponse>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(InspectionMediaResponse)]),
          () => new ListBuilder<InspectionMediaResponse>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => new MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(VoiceNoteResponse)]),
          () => new ListBuilder<VoiceNoteResponse>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [const FullType(String)]),
          () => new SetBuilder<String>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
