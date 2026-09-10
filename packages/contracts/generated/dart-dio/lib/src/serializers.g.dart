// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(AcknowledgePermitRequest.serializer)
      ..add(AcknowledgePermitRequestWorkerAttestationEnum.serializer)
      ..add(ActivatePermitRequest.serializer)
      ..add(ActivatePermitRequestActivationAttestationEnum.serializer)
      ..add(AiAnalysisResponse.serializer)
      ..add(AiAnalysisResponseMediaKindEnum.serializer)
      ..add(AiAnalysisResponseRiskLevelEnum.serializer)
      ..add(AnnotationPointInput.serializer)
      ..add(AnnotationPointResponse.serializer)
      ..add(AnnotationResponse.serializer)
      ..add(AnnotationResponseDamageTypeEnum.serializer)
      ..add(AnnotationResponseShapeEnum.serializer)
      ..add(AnnotationResponseSource_Enum.serializer)
      ..add(ArMeasurementResponse.serializer)
      ..add(ArMeasurementResponseMethodEnum.serializer)
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
      ..add(AssignSafetyReportRequest.serializer)
      ..add(AssignWorkOrderRequest.serializer)
      ..add(AttachInspectionMediaRequest.serializer)
      ..add(AttachInspectionMediaRequestBeforeAfterTagEnum.serializer)
      ..add(AttachInspectionMediaRequestKindEnum.serializer)
      ..add(AttachVoiceNoteRequest.serializer)
      ..add(AuditLogEntry.serializer)
      ..add(AuditLogFacets.serializer)
      ..add(AuditLogPage.serializer)
      ..add(BillingCatalogResponse.serializer)
      ..add(BillingPlanQuotasResponse.serializer)
      ..add(BillingPlanResponse.serializer)
      ..add(CameraPreset.serializer)
      ..add(CancelCorrectiveActionRequest.serializer)
      ..add(ChecklistResponse.serializer)
      ..add(ChecklistTemplateDeleted.serializer)
      ..add(ChecklistTemplateDetail.serializer)
      ..add(ChecklistTemplateItem.serializer)
      ..add(ChecklistTemplateItemInput.serializer)
      ..add(ChecklistTemplateItemInputItemTypeEnum.serializer)
      ..add(ChecklistTemplateItemItemTypeEnum.serializer)
      ..add(ChecklistTemplateListItem.serializer)
      ..add(ChecklistTemplateListPage.serializer)
      ..add(CheckoutSessionRequest.serializer)
      ..add(CheckoutSessionResponse.serializer)
      ..add(ClosePermitRequest.serializer)
      ..add(ClosePermitRequestCloseAttestationEnum.serializer)
      ..add(CompanyProfile.serializer)
      ..add(CompanyRegistrationRequest.serializer)
      ..add(CompanyRegistrationResponse.serializer)
      ..add(CompleteInspectionRequest.serializer)
      ..add(ControlPermitRequest.serializer)
      ..add(CorrectiveActionResponse.serializer)
      ..add(CorrectiveActionResponsePriorityEnum.serializer)
      ..add(CorrectiveActionResponseStatusEnum.serializer)
      ..add(CreateAnnotationRequest.serializer)
      ..add(CreateAnnotationRequestDamageTypeEnum.serializer)
      ..add(CreateAnnotationRequestShapeEnum.serializer)
      ..add(CreateArMeasurementRequest.serializer)
      ..add(CreateArMeasurementRequestMethodEnum.serializer)
      ..add(CreateAreaRequest.serializer)
      ..add(CreateAssetRequest.serializer)
      ..add(CreateAssetRequestCurrentStatusEnum.serializer)
      ..add(CreateChecklistTemplateRequest.serializer)
      ..add(CreateCorrectiveActionRequest.serializer)
      ..add(CreateCorrectiveActionRequestPriorityEnum.serializer)
      ..add(CreateDocumentRequest.serializer)
      ..add(CreateDocumentRequestCategoryEnum.serializer)
      ..add(CreateDocumentRequestFileFormatEnum.serializer)
      ..add(CreateDocumentRequestStatusEnum.serializer)
      ..add(CreateFacilityRequest.serializer)
      ..add(CreateFacilityRequestStatusEnum.serializer)
      ..add(CreateGeneratedReportRequest.serializer)
      ..add(CreateGeneratedReportRequestReportTypeEnum.serializer)
      ..add(CreateInspectionRequest.serializer)
      ..add(CreateInspectionRequestInspectionTypeEnum.serializer)
      ..add(CreatePermitRequest.serializer)
      ..add(CreatePermitRequestPermitTypeEnum.serializer)
      ..add(CreatePermitTemplateRequest.serializer)
      ..add(CreatePermitTemplateRequestPermitTypeEnum.serializer)
      ..add(CreateRoleRequest.serializer)
      ..add(CreateSafetyReportRequest.serializer)
      ..add(CreateSafetyReportRequestCategoryEnum.serializer)
      ..add(CreateSafetyReportRequestSeverityEnum.serializer)
      ..add(CreateWorkOrderRequest.serializer)
      ..add(CreateWorkOrderRequestPriorityEnum.serializer)
      ..add(CurrentUser.serializer)
      ..add(DashboardActivityItem.serializer)
      ..add(DashboardActivityPage.serializer)
      ..add(DashboardActivitySeries.serializer)
      ..add(DashboardSeriesPoint.serializer)
      ..add(DashboardSummary.serializer)
      ..add(DecidePermitApprovalRequest.serializer)
      ..add(DecidePermitApprovalRequestDecisionEnum.serializer)
      ..add(
          DecidePermitApprovalRequestDigitalSignatureAttestationEnum.serializer)
      ..add(DemoGateResponse.serializer)
      ..add(DemoGateResponseOkEnum.serializer)
      ..add(DigitalTwinHotspotResponse.serializer)
      ..add(DigitalTwinHotspotResponseCurrentStatusEnum.serializer)
      ..add(DigitalTwinSceneResponse.serializer)
      ..add(DocumentDeleted.serializer)
      ..add(DocumentDetail.serializer)
      ..add(DocumentDetailCategoryEnum.serializer)
      ..add(DocumentDetailFileFormatEnum.serializer)
      ..add(DocumentDetailStatusEnum.serializer)
      ..add(DocumentListItem.serializer)
      ..add(DocumentListItemCategoryEnum.serializer)
      ..add(DocumentListItemFileFormatEnum.serializer)
      ..add(DocumentListItemStatusEnum.serializer)
      ..add(DocumentListPage.serializer)
      ..add(ErrorEnvelope.serializer)
      ..add(FacilityDeleted.serializer)
      ..add(FacilityDetail.serializer)
      ..add(FacilityDetailStatusEnum.serializer)
      ..add(FacilityListPage.serializer)
      ..add(FinalizeGeneratedReportRequest.serializer)
      ..add(
          FinalizeGeneratedReportRequestFinalizationAttestationEnum.serializer)
      ..add(GeneratedReportDeleted.serializer)
      ..add(GeneratedReportDetail.serializer)
      ..add(GeneratedReportDetailReportTypeEnum.serializer)
      ..add(GeneratedReportDetailStatusEnum.serializer)
      ..add(GeneratedReportExportResponse.serializer)
      ..add(GeneratedReportExportResponseFormatEnum.serializer)
      ..add(GeneratedReportListItem.serializer)
      ..add(GeneratedReportListItemReportTypeEnum.serializer)
      ..add(GeneratedReportListItemStatusEnum.serializer)
      ..add(GeneratedReportListPage.serializer)
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
      ..add(PermitApprovalSnapshotResponse.serializer)
      ..add(PermitApprovalSnapshotResponseStatusEnum.serializer)
      ..add(PermitApprovalTemplateStepInput.serializer)
      ..add(PermitApprovalTemplateStepResponse.serializer)
      ..add(PermitChecklistSnapshotResponse.serializer)
      ..add(PermitChecklistTemplateItemInput.serializer)
      ..add(PermitChecklistTemplateItemResponse.serializer)
      ..add(PermitDashboardSummary.serializer)
      ..add(PermitDeleted.serializer)
      ..add(PermitDetail.serializer)
      ..add(PermitDetailHighestResidualRiskEnum.serializer)
      ..add(PermitDetailPermitTypeEnum.serializer)
      ..add(PermitDetailStatusEnum.serializer)
      ..add(PermitDigitalSignatureResponse.serializer)
      ..add(PermitListItem.serializer)
      ..add(PermitListItemHighestResidualRiskEnum.serializer)
      ..add(PermitListItemPermitTypeEnum.serializer)
      ..add(PermitListItemStatusEnum.serializer)
      ..add(PermitListPage.serializer)
      ..add(PermitRiskAssessmentInput.serializer)
      ..add(PermitRiskAssessmentResponse.serializer)
      ..add(PermitRiskAssessmentResponseInitialBandEnum.serializer)
      ..add(PermitRiskAssessmentResponseResidualBandEnum.serializer)
      ..add(PermitTemplateDeleted.serializer)
      ..add(PermitTemplateDetail.serializer)
      ..add(PermitTemplateDetailPermitTypeEnum.serializer)
      ..add(PermitTemplateListItem.serializer)
      ..add(PermitTemplateListItemPermitTypeEnum.serializer)
      ..add(PermitTemplateListPage.serializer)
      ..add(PermitWorkerAcknowledgementResponse.serializer)
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
      ..add(RegenerateGeneratedReportRequest.serializer)
      ..add(ReportDashboardSummary.serializer)
      ..add(ReportNarrativeResponse.serializer)
      ..add(ResumePermitRequest.serializer)
      ..add(ResumePermitRequestResumeAttestationEnum.serializer)
      ..add(RoleDeleted.serializer)
      ..add(RoleDetail.serializer)
      ..add(RoleList.serializer)
      ..add(RoleSummary.serializer)
      ..add(SafetyCategoryCount.serializer)
      ..add(SafetyCategoryCountCategoryEnum.serializer)
      ..add(SafetyDashboardSummary.serializer)
      ..add(SafetyEvidenceResponse.serializer)
      ..add(SafetyEvidenceResponseKindEnum.serializer)
      ..add(SafetyReportDeleted.serializer)
      ..add(SafetyReportDetail.serializer)
      ..add(SafetyReportDetailCategoryEnum.serializer)
      ..add(SafetyReportDetailSeverityEnum.serializer)
      ..add(SafetyReportDetailStatusEnum.serializer)
      ..add(SafetyReportListItem.serializer)
      ..add(SafetyReportListItemCategoryEnum.serializer)
      ..add(SafetyReportListItemSeverityEnum.serializer)
      ..add(SafetyReportListItemStatusEnum.serializer)
      ..add(SafetyReportListPage.serializer)
      ..add(ServiceResponse.serializer)
      ..add(ServiceResponseServiceEnum.serializer)
      ..add(ServiceResponseStatusEnum.serializer)
      ..add(SignaturePointInput.serializer)
      ..add(SignaturePointResponse.serializer)
      ..add(SignatureResponse.serializer)
      ..add(SignatureStrokeInput.serializer)
      ..add(SignatureStrokeResponse.serializer)
      ..add(SubmitPermitRequest.serializer)
      ..add(SubmitPermitRequestIssuerAttestationEnum.serializer)
      ..add(SubmitWorkOrderForReviewRequest.serializer)
      ..add(SubscriptionResponse.serializer)
      ..add(TransitionSafetyReportRequest.serializer)
      ..add(TransitionSafetyReportRequestStatusEnum.serializer)
      ..add(UpdateAnnotationRequest.serializer)
      ..add(UpdateAnnotationRequestDamageTypeEnum.serializer)
      ..add(UpdateArMeasurementRequest.serializer)
      ..add(UpdateAreaRequest.serializer)
      ..add(UpdateAssetRequest.serializer)
      ..add(UpdateAssetRequestCurrentStatusEnum.serializer)
      ..add(UpdateChecklistTemplateRequest.serializer)
      ..add(UpdateCompanyRequest.serializer)
      ..add(UpdateCompanyStatusRequest.serializer)
      ..add(UpdateCompanyStatusRequestStatusEnum.serializer)
      ..add(UpdateCorrectiveActionRequest.serializer)
      ..add(UpdateCorrectiveActionRequestStatusEnum.serializer)
      ..add(UpdateDigitalTwinHotspotRequest.serializer)
      ..add(UpdateDigitalTwinSceneRequest.serializer)
      ..add(UpdateDocumentRequest.serializer)
      ..add(UpdateDocumentRequestCategoryEnum.serializer)
      ..add(UpdateDocumentRequestStatusEnum.serializer)
      ..add(UpdateFacilityRequest.serializer)
      ..add(UpdateFacilityRequestStatusEnum.serializer)
      ..add(UpdateGeneratedReportRequest.serializer)
      ..add(UpdateInspectionMediaRequest.serializer)
      ..add(UpdateInspectionMediaRequestBeforeAfterTagEnum.serializer)
      ..add(UpdateInspectionRequest.serializer)
      ..add(UpdateInspectionRequestInspectionTypeEnum.serializer)
      ..add(UpdatePermitRequest.serializer)
      ..add(UpdatePermitTemplateRequest.serializer)
      ..add(UpdatePermitTemplateRequestPermitTypeEnum.serializer)
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
      ..add(WorkOrderDeleted.serializer)
      ..add(WorkOrderDetail.serializer)
      ..add(WorkOrderDetailPriorityEnum.serializer)
      ..add(WorkOrderDetailStatusEnum.serializer)
      ..add(WorkOrderListItem.serializer)
      ..add(WorkOrderListItemPriorityEnum.serializer)
      ..add(WorkOrderListItemStatusEnum.serializer)
      ..add(WorkOrderListPage.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AiAnalysisResponse)]),
          () => new ListBuilder<AiAnalysisResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AnnotationResponse)]),
          () => new ListBuilder<AnnotationResponse>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ArMeasurementResponse)]),
          () => new ListBuilder<ArMeasurementResponse>())
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
          const FullType(BuiltList, const [const FullType(VoiceNoteResponse)]),
          () => new ListBuilder<VoiceNoteResponse>())
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
              BuiltList, const [const FullType(AnnotationPointInput)]),
          () => new ListBuilder<AnnotationPointInput>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(AnnotationPointResponse)]),
          () => new ListBuilder<AnnotationPointResponse>())
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
          const FullType(
              BuiltList, const [const FullType(BillingPlanResponse)]),
          () => new ListBuilder<BillingPlanResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CameraPreset)]),
          () => new ListBuilder<CameraPreset>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DigitalTwinHotspotResponse)]),
          () => new ListBuilder<DigitalTwinHotspotResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CameraPreset)]),
          () => new ListBuilder<CameraPreset>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(UpdateDigitalTwinHotspotRequest)]),
          () => new ListBuilder<UpdateDigitalTwinHotspotRequest>())
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
              BuiltList, const [const FullType(CorrectiveActionResponse)]),
          () => new ListBuilder<CorrectiveActionResponse>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(SafetyEvidenceResponse)]),
          () => new ListBuilder<SafetyEvidenceResponse>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DashboardActivityItem)]),
          () => new ListBuilder<DashboardActivityItem>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DashboardSeriesPoint)]),
          () => new ListBuilder<DashboardSeriesPoint>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DocumentListItem)]),
          () => new ListBuilder<DocumentListItem>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(FacilityDetail)]),
          () => new ListBuilder<FacilityDetail>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(GeneratedReportListItem)]),
          () => new ListBuilder<GeneratedReportListItem>())
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
          const FullType(BuiltList,
              const [const FullType(PermitApprovalSnapshotResponse)]),
          () => new ListBuilder<PermitApprovalSnapshotResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(PermitChecklistSnapshotResponse)]),
          () => new ListBuilder<PermitChecklistSnapshotResponse>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(PermitRiskAssessmentResponse)]),
          () => new ListBuilder<PermitRiskAssessmentResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(PermitWorkerAcknowledgementResponse)]),
          () => new ListBuilder<PermitWorkerAcknowledgementResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(PermitApprovalTemplateStepInput)]),
          () => new ListBuilder<PermitApprovalTemplateStepInput>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(PermitChecklistTemplateItemInput)]),
          () => new ListBuilder<PermitChecklistTemplateItemInput>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(PermitApprovalTemplateStepInput)]),
          () => new ListBuilder<PermitApprovalTemplateStepInput>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(PermitChecklistTemplateItemInput)]),
          () => new ListBuilder<PermitChecklistTemplateItemInput>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(PermitApprovalTemplateStepResponse)]),
          () => new ListBuilder<PermitApprovalTemplateStepResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(PermitChecklistTemplateItemResponse)]),
          () => new ListBuilder<PermitChecklistTemplateItemResponse>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PermitListItem)]),
          () => new ListBuilder<PermitListItem>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(PermitRiskAssessmentInput)]),
          () => new ListBuilder<PermitRiskAssessmentInput>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(PermitRiskAssessmentInput)]),
          () => new ListBuilder<PermitRiskAssessmentInput>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(PermitTemplateListItem)]),
          () => new ListBuilder<PermitTemplateListItem>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(PlatformCompanySummary)]),
          () => new ListBuilder<PlatformCompanySummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(RoleSummary)]),
          () => new ListBuilder<RoleSummary>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(SafetyCategoryCount)]),
          () => new ListBuilder<SafetyCategoryCount>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(SafetyReportListItem)]),
          () => new ListBuilder<SafetyReportListItem>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(SignaturePointInput)]),
          () => new ListBuilder<SignaturePointInput>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(SignaturePointResponse)]),
          () => new ListBuilder<SignaturePointResponse>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(SignatureStrokeInput)]),
          () => new ListBuilder<SignatureStrokeInput>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(SignatureStrokeResponse)]),
          () => new ListBuilder<SignatureStrokeResponse>())
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
          const FullType(BuiltList, const [const FullType(WorkOrderListItem)]),
          () => new ListBuilder<WorkOrderListItem>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(num)]),
          () => new ListBuilder<num>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(num)]),
          () => new ListBuilder<num>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(num)]),
          () => new ListBuilder<num>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(num)]),
          () => new ListBuilder<num>())
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
          const FullType(BuiltSet, const [const FullType(String)]),
          () => new SetBuilder<String>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
