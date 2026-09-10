import {
  AreasApi,
  AssetsApi,
  AuditApi,
  AuthApi,
  BillingApi,
  ChecklistTemplatesApi,
  CompanyApi,
  Configuration,
  DashboardApi,
  DocumentsApi,
  FacilitiesApi,
  FetchError,
  GeneratedReportsApi,
  InspectionsApi,
  PermissionsApi,
  PermitTemplatesApi,
  PermitsApi,
  PlatformApi,
  QrApi,
  RbacDemoApi,
  ResponseError,
  RolesApi,
  SafetyReportsApi,
  SystemApi,
  UsersApi,
  WorkOrdersApi,
  type AreaDetail,
  type AreaListPage,
  type AssetDashboardSummary,
  type AssetDetail,
  type AssetHistoryPage,
  type AssetListPage,
  type AssetQrLabel,
  type AssignChecklistTemplateRequest,
  type AssignWorkOrderRequest,
  type AuditLogFacets,
  type AuditLogPage,
  type ChecklistTemplateDeleted,
  type ChecklistTemplateDetail,
  type ChecklistTemplateListPage,
  type CompanyProfile,
  type CreateGeneratedReportRequest,
  type CompleteInspectionRequest,
  type CompanyRegistrationRequest,
  type CompanyRegistrationResponse,
  type CreateAssetRequest,
  type CreateChecklistTemplateRequest,
  type CreateInspectionRequest,
  type CreatePermitTemplateRequest,
  type CreatePermitRequest,
  type ActivatePermitRequest,
  type ClosePermitRequest,
  type ControlPermitRequest,
  type DecidePermitApprovalRequest,
  type CreateRoleRequest,
  type CreateSafetyReportRequest,
  type CreateCorrectiveActionRequest,
  type AssignSafetyReportRequest,
  type TransitionSafetyReportRequest,
  type UpdateCorrectiveActionRequest,
  type CancelCorrectiveActionRequest,
  type CreateWorkOrderRequest,
  type CurrentUser,
  type CreateDocumentRequest,
  type DocumentDetail,
  type DocumentListPage,
  type BillingCatalogResponse,
  type CheckoutSessionRequest,
  type CheckoutSessionResponse,
  type SubscriptionResponse,
  type DashboardActivityPage,
  type DashboardActivitySeries,
  type DashboardSummary,
  type DemoGateResponse,
  type FacilityDetail,
  type FacilityListPage,
  type HealthResponse,
  type GeneratedReportExportResponse,
  type GeneratedReportExportResponseFormatEnum,
  type GeneratedReportListPage,
  type GeneratedReportDetail,
  type GeneratedReportDeleted,
  type UpdateGeneratedReportRequest,
  type InspectionDeleted,
  type InspectionDetail,
  type InspectionListPage,
  type InviteUserRequest,
  type PermissionCatalog,
  type PermitTemplateDeleted,
  type PermitTemplateDetail,
  type PermitTemplateListPage,
  type PermitDetail,
  type PermitDashboardSummary,
  type PermitListPage,
  type ResumePermitRequest,
  type SubmitPermitRequest,
  type PlatformCompanyDetail,
  type PlatformCompanyPage,
  type UpdateAssetRequest,
  type PlatformStats,
  type QrScanResult,
  type DigitalTwinSceneResponse,
  type ReportDashboardSummary,
  type RoleDeleted,
  type RoleDetail,
  type RoleList,
  type SafetyReportDetail,
  type SafetyDashboardSummary,
  type SafetyReportListPage,
  type UpdateChecklistTemplateRequest,
  type UpdateCompanyRequest,
  type UpdateCompanyStatusRequest,
  type UpdateInspectionRequest,
  type UpdatePermitTemplateRequest,
  type UpdatePlatformCompanyRequest,
  type UpdateRoleRequest,
  type UpdateUserRequest,
  type UpdateUserStatusRequest,
  type UserDetail,
  type UserListPage,
  type WorkOrderDeleted,
  type WorkOrderDetail,
  type WorkOrderListPage,
} from "@fev/api-client";

import type { ToastApi } from "@/design-system/toast";

export type TokenProvider = () => Promise<string | undefined> | string | undefined;
export type UnauthorizedHook = () => Promise<void> | void;
export type ErrorToast = Pick<ToastApi, "error">;

export class ApiClientError extends Error {
  constructor(
    public readonly code: string,
    message: string,
    public readonly status?: number,
    public readonly details?: Record<string, unknown>,
    public readonly requestId?: string,
  ) {
    super(message);
    this.name = "ApiClientError";
  }
}

export type FevApiClientOptions = {
  baseUrl?: string;
  fetchApi?: typeof fetch;
  getIdToken?: TokenProvider;
  onUnauthorized?: UnauthorizedHook;
  refreshIdToken?: TokenProvider;
  toast?: ErrorToast;
};

const defaultBaseUrl = process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:8000";

type WireErrorEnvelope = {
  error: string;
  message: string;
  details?: Record<string, unknown>;
  request_id: string;
};

function isEnvelope(value: unknown): value is WireErrorEnvelope {
  if (typeof value !== "object" || value === null) return false;
  const candidate = value as Record<string, unknown>;
  return (
    typeof candidate.error === "string" &&
    typeof candidate.message === "string" &&
    typeof candidate.request_id === "string"
  );
}

export type ActivityWindowDays = 7 | 30 | 90;

export type ListUsersOptions = {
  search?: string;
  roleId?: string;
  status?: string;
  sort?: string;
  cursor?: string;
  limit?: number;
};

export type AuditLogFilterOptions = {
  fromDate?: string;
  toDate?: string;
  actorUid?: string;
  action?: string;
  targetType?: string;
  q?: string;
};

export type ListAuditLogsOptions = AuditLogFilterOptions & {
  cursor?: string;
  limit?: number;
};

export type ListAssetsOptions = {
  facilityId?: string;
  areaId?: string;
  category?: string;
  currentStatus?: string;
  parentAssetId?: string;
  search?: string;
  sort?: string;
  cursor?: string;
  limit?: number;
};

export type ListFacilitiesOptions = {
  search?: string;
  status?: string;
  sort?: string;
  cursor?: string;
  limit?: number;
};

export type ListAreasOptions = {
  facilityId?: string;
  search?: string;
  sort?: string;
  cursor?: string;
  limit?: number;
};

export type ListInspectionsOptions = {
  assetId?: string;
  facilityId?: string;
  status?: string;
  inspectorId?: string;
  fromDate?: string;
  toDate?: string;
  cursor?: string;
  limit?: number;
};

export type ListChecklistTemplatesOptions = {
  category?: string;
  cursor?: string;
  limit?: number;
};

export type ListPermitTemplatesOptions = {
  permitType?: string;
  cursor?: string;
  limit?: number;
};

export type ListPermitsOptions = {
  permitType?: string;
  facilityId?: string;
  workerId?: string;
  cursor?: string;
  limit?: number;
};

export type ListWorkOrdersOptions = {
  assetId?: string;
  facilityId?: string;
  status?: string;
  technicianId?: string;
  cursor?: string;
  limit?: number;
};

export type ListSafetyReportsOptions = {
  status?: string;
  category?: string;
  severity?: string;
  reporterId?: string;
  cursor?: string;
  limit?: number;
};

export type ListGeneratedReportsOptions = {
  reportType?: string;
  status?: string;
  cursor?: string;
  limit?: number;
};

function toDate(value?: string): Date | undefined {
  return value ? new Date(value) : undefined;
}

export type ListDocumentsOptions = {
  category?: string | null;
  facilityId?: string | null;
  status?: string | null;
  search?: string | null;
  cursor?: string | null;
  limit?: number;
};

export class FevApiClient {
  private readonly areas: AreasApi;
  private readonly assets: AssetsApi;
  private readonly audit: AuditApi;
  private readonly auth: AuthApi;
  private readonly billing: BillingApi;
  private readonly checklistTemplates: ChecklistTemplatesApi;
  private readonly company: CompanyApi;
  private readonly dashboard: DashboardApi;
  private readonly documents: DocumentsApi;
  private readonly facilities: FacilitiesApi;
  private readonly generatedReports: GeneratedReportsApi;
  private readonly inspections: InspectionsApi;
  private readonly permissions: PermissionsApi;
  private readonly permitTemplates: PermitTemplatesApi;
  private readonly permits: PermitsApi;
  private readonly platform: PlatformApi;
  private readonly qr: QrApi;
  private readonly rbacDemo: RbacDemoApi;
  private readonly roles: RolesApi;
  private readonly safetyReports: SafetyReportsApi;
  private readonly system: SystemApi;
  private readonly users: UsersApi;
  private readonly workOrders: WorkOrdersApi;
  private readonly onUnauthorized: UnauthorizedHook;
  private readonly refreshIdToken?: TokenProvider;
  private readonly toast?: ErrorToast;

  constructor(options: FevApiClientOptions = {}) {
    const getIdToken = options.getIdToken ?? (() => undefined);
    const configuration = new Configuration({
      accessToken: async () => (await getIdToken()) ?? "",
      basePath: (options.baseUrl ?? defaultBaseUrl).replace(/\/$/, ""),
      fetchApi: options.fetchApi,
    });
    this.areas = new AreasApi(configuration);
    this.assets = new AssetsApi(configuration);
    this.audit = new AuditApi(configuration);
    this.auth = new AuthApi(configuration);
    this.billing = new BillingApi(configuration);
    this.checklistTemplates = new ChecklistTemplatesApi(configuration);
    this.company = new CompanyApi(configuration);
    this.dashboard = new DashboardApi(configuration);
    this.documents = new DocumentsApi(configuration);
    this.facilities = new FacilitiesApi(configuration);
    this.generatedReports = new GeneratedReportsApi(configuration);
    this.inspections = new InspectionsApi(configuration);
    this.permissions = new PermissionsApi(configuration);
    this.permitTemplates = new PermitTemplatesApi(configuration);
    this.permits = new PermitsApi(configuration);
    this.platform = new PlatformApi(configuration);
    this.qr = new QrApi(configuration);
    this.rbacDemo = new RbacDemoApi(configuration);
    this.roles = new RolesApi(configuration);
    this.safetyReports = new SafetyReportsApi(configuration);
    this.system = new SystemApi(configuration);
    this.users = new UsersApi(configuration);
    this.workOrders = new WorkOrdersApi(configuration);
    this.onUnauthorized = options.onUnauthorized ?? (() => undefined);
    this.refreshIdToken = options.refreshIdToken;
    this.toast = options.toast;
  }

  getHealth(signal?: AbortSignal): Promise<HealthResponse> {
    return this.execute(() => this.system.getHealth(signal ? { signal } : undefined));
  }

  getCurrentUser(signal?: AbortSignal): Promise<CurrentUser> {
    return this.execute(() => this.auth.getCurrentUser(signal ? { signal } : undefined));
  }

  /** Public: the pricing page and signup plan picker read the same catalog the
   * API enforces against, so a client can never offer a tier the server will
   * not honour. */
  getBillingCatalog(signal?: AbortSignal): Promise<BillingCatalogResponse> {
    return this.execute(() => this.billing.getBillingCatalog(signal ? { signal } : undefined));
  }

  /** The authoritative feature list for the signed-in company. The shell
   * decides which modules to render from this, never from the tier name. */
  getSubscription(signal?: AbortSignal): Promise<SubscriptionResponse> {
    return this.execute(() => this.billing.getSubscription(signal ? { signal } : undefined));
  }

  /** Phase 11 documents. The page and its data hook shipped without these,
   * so `apiClient.listDocuments` was undefined and the list rendered its error
   * state on every load. */
  listDocuments(
    options: ListDocumentsOptions = {},
    signal?: AbortSignal,
  ): Promise<DocumentListPage> {
    return this.execute(() => this.documents.listDocuments(options, signal ? { signal } : undefined));
  }

  createDocument(
    body: CreateDocumentRequest,
    signal?: AbortSignal,
  ): Promise<DocumentDetail> {
    return this.execute(() =>
      this.documents.createDocument({ createDocumentRequest: body }, signal ? { signal } : undefined),
    );
  }

  createCheckoutSession(
    body: CheckoutSessionRequest,
    signal?: AbortSignal,
  ): Promise<CheckoutSessionResponse> {
    return this.execute(() =>
      this.billing.createCheckoutSession(
        { checkoutSessionRequest: body },
        signal ? { signal } : undefined,
      ),
    );
  }

  listGeneratedReports(
    options: ListGeneratedReportsOptions = {},
    signal?: AbortSignal,
  ): Promise<GeneratedReportListPage> {
    return this.execute(() =>
      this.generatedReports.listGeneratedReports(options, signal ? { signal } : undefined),
    );
  }

  exportGeneratedReport(
    reportId: string,
    format: GeneratedReportExportResponseFormatEnum,
    signal?: AbortSignal,
  ): Promise<GeneratedReportExportResponse> {
    return this.execute(() =>
      this.generatedReports.exportGeneratedReport(
        { reportId, format },
        signal ? { signal } : undefined,
      ),
    );
  }

  generateReport(
    request: CreateGeneratedReportRequest,
    signal?: AbortSignal,
  ): Promise<GeneratedReportDetail> {
    return this.execute(() =>
      this.generatedReports.generateReport(
        { createGeneratedReportRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  getGeneratedReport(reportId: string, signal?: AbortSignal): Promise<GeneratedReportDetail> {
    return this.execute(() =>
      this.generatedReports.getGeneratedReport({ reportId }, signal ? { signal } : undefined),
    );
  }

  updateGeneratedReport(
    reportId: string,
    request: UpdateGeneratedReportRequest,
    signal?: AbortSignal,
  ): Promise<GeneratedReportDetail> {
    return this.execute(() =>
      this.generatedReports.updateGeneratedReport(
        { reportId, updateGeneratedReportRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  regenerateGeneratedReport(reportId: string, expectedRevision: number, signal?: AbortSignal): Promise<GeneratedReportDetail> {
    return this.execute(() =>
      this.generatedReports.regenerateGeneratedReport(
        { reportId, regenerateGeneratedReportRequest: { expectedRevision } },
        signal ? { signal } : undefined,
      ),
    );
  }

  finalizeGeneratedReport(reportId: string, expectedRevision: number, signal?: AbortSignal): Promise<GeneratedReportDetail> {
    return this.execute(() =>
      this.generatedReports.finalizeGeneratedReport(
        { reportId, finalizeGeneratedReportRequest: { expectedRevision, finalizationAttestation: true } },
        signal ? { signal } : undefined,
      ),
    );
  }

  deleteGeneratedReport(reportId: string, signal?: AbortSignal): Promise<GeneratedReportDeleted> {
    return this.execute(() =>
      this.generatedReports.deleteGeneratedReport({ reportId }, signal ? { signal } : undefined),
    );
  }

  getRbacDemoSingle(signal?: AbortSignal): Promise<DemoGateResponse> {
    return this.execute(() =>
      this.rbacDemo.rbacDemoSinglePermission(signal ? { signal } : undefined),
    );
  }

  registerCompanyAdmin(
    request: CompanyRegistrationRequest,
    signal?: AbortSignal,
  ): Promise<CompanyRegistrationResponse> {
    return this.execute(() =>
      this.auth.registerCompanyAdmin(
        { companyRegistrationRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  getDashboardSummary(
    window: ActivityWindowDays = 30,
    signal?: AbortSignal,
  ): Promise<DashboardSummary> {
    return this.execute(() =>
      this.dashboard.getDashboardSummary({ window }, signal ? { signal } : undefined),
    );
  }

  getDashboardAssetsSummary(signal?: AbortSignal): Promise<AssetDashboardSummary> {
    return this.execute(() =>
      this.dashboard.getDashboardAssetsSummary(signal ? { signal } : undefined),
    );
  }

  getDashboardSafetySummary(signal?: AbortSignal): Promise<SafetyDashboardSummary> {
    return this.execute(() =>
      this.dashboard.getDashboardSafetySummary(signal ? { signal } : undefined),
    );
  }

  getDashboardPermitsSummary(signal?: AbortSignal): Promise<PermitDashboardSummary> {
    return this.execute(() =>
      this.dashboard.getDashboardPermitsSummary(signal ? { signal } : undefined),
    );
  }

  getDashboardReportsSummary(signal?: AbortSignal): Promise<ReportDashboardSummary> {
    return this.execute(() =>
      this.dashboard.getDashboardReportsSummary(signal ? { signal } : undefined),
    );
  }

  getDashboardActivity(
    options: { limit?: number; cursor?: string; action?: string } = {},
    signal?: AbortSignal,
  ): Promise<DashboardActivityPage> {
    return this.execute(() =>
      this.dashboard.getDashboardActivity(
        { limit: options.limit, cursor: options.cursor, action: options.action },
        signal ? { signal } : undefined,
      ),
    );
  }

  getDashboardActivitySeries(
    window: ActivityWindowDays = 30,
    signal?: AbortSignal,
  ): Promise<DashboardActivitySeries> {
    return this.execute(() =>
      this.dashboard.getDashboardActivitySeries({ window }, signal ? { signal } : undefined),
    );
  }

  listUsers(options: ListUsersOptions = {}, signal?: AbortSignal): Promise<UserListPage> {
    return this.execute(() =>
      this.users.listUsers(
        {
          search: options.search,
          roleId: options.roleId,
          status: options.status,
          sort: options.sort,
          cursor: options.cursor,
          limit: options.limit,
        },
        signal ? { signal } : undefined,
      ),
    );
  }

  getUser(userId: string, signal?: AbortSignal): Promise<UserDetail> {
    return this.execute(() => this.users.getUser({ userId }, signal ? { signal } : undefined));
  }

  listAssets(options: ListAssetsOptions = {}, signal?: AbortSignal): Promise<AssetListPage> {
    return this.execute(() =>
      this.assets.listAssets(
        {
          facilityId: options.facilityId,
          areaId: options.areaId,
          category: options.category,
          currentStatus: options.currentStatus,
          parentAssetId: options.parentAssetId,
          search: options.search,
          sort: options.sort,
          cursor: options.cursor,
          limit: options.limit,
        },
        signal ? { signal } : undefined,
      ),
    );
  }

  getAsset(assetId: string, signal?: AbortSignal): Promise<AssetDetail> {
    return this.execute(() => this.assets.getAsset({ assetId }, signal ? { signal } : undefined));
  }

  getAssetHistory(assetId: string, signal?: AbortSignal): Promise<AssetHistoryPage> {
    return this.execute(() =>
      this.assets.getAssetHistory({ assetId }, signal ? { signal } : undefined),
    );
  }

  createAsset(request: CreateAssetRequest, signal?: AbortSignal): Promise<AssetDetail> {
    return this.execute(() =>
      this.assets.createAsset({ createAssetRequest: request }, signal ? { signal } : undefined),
    );
  }

  updateAsset(
    assetId: string,
    request: UpdateAssetRequest,
    signal?: AbortSignal,
  ): Promise<AssetDetail> {
    return this.execute(() =>
      this.assets.updateAsset(
        { assetId, updateAssetRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  uploadAssetMedia(
    assetId: string,
    kind: "photo" | "document" | "manual",
    file: File,
    signal?: AbortSignal,
  ): Promise<AssetDetail> {
    return this.execute(() =>
      this.assets.uploadAssetMedia({ assetId, kind, file }, signal ? { signal } : undefined),
    );
  }

  deleteAssetMedia(assetId: string, mediaId: string, signal?: AbortSignal): Promise<AssetDetail> {
    return this.execute(() =>
      this.assets.deleteAssetMedia({ assetId, mediaId }, signal ? { signal } : undefined),
    );
  }

  getAssetQrLabel(assetId: string, signal?: AbortSignal): Promise<AssetQrLabel> {
    return this.execute(() =>
      this.assets.getAssetQrLabel({ assetId }, signal ? { signal } : undefined),
    );
  }

  resolveQrCode(code: string, signal?: AbortSignal): Promise<QrScanResult> {
    return this.execute(() => this.qr.resolveQrCode({ code }, signal ? { signal } : undefined));
  }

  getFacility3dScene(facilityId: string, signal?: AbortSignal): Promise<DigitalTwinSceneResponse> {
    return this.execute(() =>
      this.facilities.getFacility3dScene({ facilityId }, signal ? { signal } : undefined),
    );
  }

  listFacilities(
    options: ListFacilitiesOptions = {},
    signal?: AbortSignal,
  ): Promise<FacilityListPage> {
    return this.execute(() =>
      this.facilities.listFacilities(
        {
          search: options.search,
          status: options.status,
          sort: options.sort,
          cursor: options.cursor,
          limit: options.limit,
        },
        signal ? { signal } : undefined,
      ),
    );
  }

  getFacility(facilityId: string, signal?: AbortSignal): Promise<FacilityDetail> {
    return this.execute(() =>
      this.facilities.getFacility({ facilityId }, signal ? { signal } : undefined),
    );
  }

  listAreas(options: ListAreasOptions = {}, signal?: AbortSignal): Promise<AreaListPage> {
    return this.execute(() =>
      this.areas.listAreas(
        {
          facilityId: options.facilityId,
          search: options.search,
          sort: options.sort,
          cursor: options.cursor,
          limit: options.limit,
        },
        signal ? { signal } : undefined,
      ),
    );
  }

  getArea(areaId: string, signal?: AbortSignal): Promise<AreaDetail> {
    return this.execute(() => this.areas.getArea({ areaId }, signal ? { signal } : undefined));
  }

  listInspections(
    options: ListInspectionsOptions = {},
    signal?: AbortSignal,
  ): Promise<InspectionListPage> {
    return this.execute(() =>
      this.inspections.listInspections(
        {
          assetId: options.assetId,
          facilityId: options.facilityId,
          status: options.status,
          inspectorId: options.inspectorId,
          fromDate: toDate(options.fromDate),
          toDate: toDate(options.toDate),
          cursor: options.cursor,
          limit: options.limit,
        },
        signal ? { signal } : undefined,
      ),
    );
  }

  getInspection(inspectionId: string, signal?: AbortSignal): Promise<InspectionDetail> {
    return this.execute(() =>
      this.inspections.getInspection({ inspectionId }, signal ? { signal } : undefined),
    );
  }

  createInspection(
    request: CreateInspectionRequest,
    signal?: AbortSignal,
  ): Promise<InspectionDetail> {
    return this.execute(() =>
      this.inspections.createInspection(
        { createInspectionRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  updateInspection(
    inspectionId: string,
    request: UpdateInspectionRequest,
    signal?: AbortSignal,
  ): Promise<InspectionDetail> {
    return this.execute(() =>
      this.inspections.updateInspection(
        { inspectionId, updateInspectionRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  deleteInspection(inspectionId: string, signal?: AbortSignal): Promise<InspectionDeleted> {
    return this.execute(() =>
      this.inspections.deleteInspection({ inspectionId }, signal ? { signal } : undefined),
    );
  }

  assignInspectionChecklistTemplate(
    inspectionId: string,
    request: AssignChecklistTemplateRequest,
    signal?: AbortSignal,
  ): Promise<InspectionDetail> {
    return this.execute(() =>
      this.inspections.assignInspectionChecklistTemplate(
        { inspectionId, assignChecklistTemplateRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  startInspection(inspectionId: string, signal?: AbortSignal): Promise<InspectionDetail> {
    return this.execute(() =>
      this.inspections.startInspection({ inspectionId }, signal ? { signal } : undefined),
    );
  }

  completeInspection(
    inspectionId: string,
    request: CompleteInspectionRequest,
    signal?: AbortSignal,
  ): Promise<InspectionDetail> {
    return this.execute(() =>
      this.inspections.completeInspection(
        { inspectionId, completeInspectionRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  cancelInspection(inspectionId: string, signal?: AbortSignal): Promise<InspectionDetail> {
    return this.execute(() =>
      this.inspections.cancelInspection({ inspectionId }, signal ? { signal } : undefined),
    );
  }

  listChecklistTemplates(
    options: ListChecklistTemplatesOptions = {},
    signal?: AbortSignal,
  ): Promise<ChecklistTemplateListPage> {
    return this.execute(() =>
      this.checklistTemplates.listChecklistTemplates(
        { category: options.category, cursor: options.cursor, limit: options.limit },
        signal ? { signal } : undefined,
      ),
    );
  }

  getChecklistTemplate(templateId: string, signal?: AbortSignal): Promise<ChecklistTemplateDetail> {
    return this.execute(() =>
      this.checklistTemplates.getChecklistTemplate({ templateId }, signal ? { signal } : undefined),
    );
  }

  createChecklistTemplate(
    request: CreateChecklistTemplateRequest,
    signal?: AbortSignal,
  ): Promise<ChecklistTemplateDetail> {
    return this.execute(() =>
      this.checklistTemplates.createChecklistTemplate(
        { createChecklistTemplateRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  updateChecklistTemplate(
    templateId: string,
    request: UpdateChecklistTemplateRequest,
    signal?: AbortSignal,
  ): Promise<ChecklistTemplateDetail> {
    return this.execute(() =>
      this.checklistTemplates.updateChecklistTemplate(
        { templateId, updateChecklistTemplateRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  deleteChecklistTemplate(
    templateId: string,
    signal?: AbortSignal,
  ): Promise<ChecklistTemplateDeleted> {
    return this.execute(() =>
      this.checklistTemplates.deleteChecklistTemplate(
        { templateId },
        signal ? { signal } : undefined,
      ),
    );
  }

  listPermitTemplates(
    options: ListPermitTemplatesOptions = {},
    signal?: AbortSignal,
  ): Promise<PermitTemplateListPage> {
    return this.execute(() =>
      this.permitTemplates.listPermitTemplates(
        { permitType: options.permitType, cursor: options.cursor, limit: options.limit },
        signal ? { signal } : undefined,
      ),
    );
  }

  getPermitTemplate(templateId: string, signal?: AbortSignal): Promise<PermitTemplateDetail> {
    return this.execute(() =>
      this.permitTemplates.getPermitTemplate({ templateId }, signal ? { signal } : undefined),
    );
  }

  createPermitTemplate(
    request: CreatePermitTemplateRequest,
    signal?: AbortSignal,
  ): Promise<PermitTemplateDetail> {
    return this.execute(() =>
      this.permitTemplates.createPermitTemplate(
        { createPermitTemplateRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  updatePermitTemplate(
    templateId: string,
    request: UpdatePermitTemplateRequest,
    signal?: AbortSignal,
  ): Promise<PermitTemplateDetail> {
    return this.execute(() =>
      this.permitTemplates.updatePermitTemplate(
        { templateId, updatePermitTemplateRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  deletePermitTemplate(templateId: string, signal?: AbortSignal): Promise<PermitTemplateDeleted> {
    return this.execute(() =>
      this.permitTemplates.deletePermitTemplate({ templateId }, signal ? { signal } : undefined),
    );
  }

  listPermits(options: ListPermitsOptions = {}, signal?: AbortSignal): Promise<PermitListPage> {
    return this.execute(() =>
      this.permits.listPermits(
        {
          permitType: options.permitType,
          facilityId: options.facilityId,
          workerId: options.workerId,
          cursor: options.cursor,
          limit: options.limit,
        },
        signal ? { signal } : undefined,
      ),
    );
  }

  getPermit(permitId: string, signal?: AbortSignal): Promise<PermitDetail> {
    return this.execute(() =>
      this.permits.getPermit({ permitId }, signal ? { signal } : undefined),
    );
  }

  createPermit(request: CreatePermitRequest, signal?: AbortSignal): Promise<PermitDetail> {
    return this.execute(() =>
      this.permits.createPermit({ createPermitRequest: request }, signal ? { signal } : undefined),
    );
  }

  submitPermit(
    permitId: string,
    request: SubmitPermitRequest,
    signal?: AbortSignal,
  ): Promise<PermitDetail> {
    return this.execute(() =>
      this.permits.submitPermit(
        { permitId, submitPermitRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  decidePermitApproval(
    permitId: string,
    request: DecidePermitApprovalRequest,
    signal?: AbortSignal,
  ): Promise<PermitDetail> {
    return this.execute(() =>
      this.permits.decidePermitApproval(
        { permitId, decidePermitApprovalRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  activatePermit(
    permitId: string,
    request: ActivatePermitRequest,
    signal?: AbortSignal,
  ): Promise<PermitDetail> {
    return this.execute(() =>
      this.permits.activatePermit(
        { permitId, activatePermitRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  suspendPermit(
    permitId: string,
    request: ControlPermitRequest,
    signal?: AbortSignal,
  ): Promise<PermitDetail> {
    return this.execute(() =>
      this.permits.suspendPermit(
        { permitId, controlPermitRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  resumePermit(
    permitId: string,
    request: ResumePermitRequest,
    signal?: AbortSignal,
  ): Promise<PermitDetail> {
    return this.execute(() =>
      this.permits.resumePermit(
        { permitId, resumePermitRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  revokePermit(
    permitId: string,
    request: ControlPermitRequest,
    signal?: AbortSignal,
  ): Promise<PermitDetail> {
    return this.execute(() =>
      this.permits.revokePermit(
        { permitId, controlPermitRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  closePermit(
    permitId: string,
    request: ClosePermitRequest,
    signal?: AbortSignal,
  ): Promise<PermitDetail> {
    return this.execute(() =>
      this.permits.closePermit(
        { permitId, closePermitRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  listWorkOrders(
    options: ListWorkOrdersOptions = {},
    signal?: AbortSignal,
  ): Promise<WorkOrderListPage> {
    return this.execute(() =>
      this.workOrders.listWorkOrders(
        {
          assetId: options.assetId,
          facilityId: options.facilityId,
          status: options.status,
          technicianId: options.technicianId,
          cursor: options.cursor,
          limit: options.limit,
        },
        signal ? { signal } : undefined,
      ),
    );
  }

  getWorkOrder(workOrderId: string, signal?: AbortSignal): Promise<WorkOrderDetail> {
    return this.execute(() =>
      this.workOrders.getWorkOrder({ workOrderId }, signal ? { signal } : undefined),
    );
  }

  createWorkOrder(request: CreateWorkOrderRequest, signal?: AbortSignal): Promise<WorkOrderDetail> {
    return this.execute(() =>
      this.workOrders.createWorkOrder(
        { createWorkOrderRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  assignWorkOrder(
    workOrderId: string,
    request: AssignWorkOrderRequest,
    signal?: AbortSignal,
  ): Promise<WorkOrderDetail> {
    return this.execute(() =>
      this.workOrders.assignWorkOrder(
        { workOrderId, assignWorkOrderRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  closeWorkOrder(workOrderId: string, signal?: AbortSignal): Promise<WorkOrderDetail> {
    return this.execute(() =>
      this.workOrders.closeWorkOrder({ workOrderId }, signal ? { signal } : undefined),
    );
  }

  cancelWorkOrder(workOrderId: string, signal?: AbortSignal): Promise<WorkOrderDetail> {
    return this.execute(() =>
      this.workOrders.cancelWorkOrder({ workOrderId }, signal ? { signal } : undefined),
    );
  }

  deleteWorkOrder(workOrderId: string, signal?: AbortSignal): Promise<WorkOrderDeleted> {
    return this.execute(() =>
      this.workOrders.deleteWorkOrder({ workOrderId }, signal ? { signal } : undefined),
    );
  }

  listSafetyReports(
    options: ListSafetyReportsOptions = {},
    signal?: AbortSignal,
  ): Promise<SafetyReportListPage> {
    return this.execute(() =>
      this.safetyReports.listSafetyReports(options, signal ? { signal } : undefined),
    );
  }

  getSafetyReport(reportId: string, signal?: AbortSignal): Promise<SafetyReportDetail> {
    return this.execute(() =>
      this.safetyReports.getSafetyReport({ reportId }, signal ? { signal } : undefined),
    );
  }

  createSafetyReport(
    request: CreateSafetyReportRequest,
    signal?: AbortSignal,
  ): Promise<SafetyReportDetail> {
    return this.execute(() =>
      this.safetyReports.createSafetyReport(
        { createSafetyReportRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  assignSafetyReport(
    reportId: string,
    request: AssignSafetyReportRequest,
    signal?: AbortSignal,
  ): Promise<SafetyReportDetail> {
    return this.execute(() =>
      this.safetyReports.assignSafetyReport(
        { reportId, assignSafetyReportRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  transitionSafetyReport(
    reportId: string,
    request: TransitionSafetyReportRequest,
    signal?: AbortSignal,
  ): Promise<SafetyReportDetail> {
    return this.execute(() =>
      this.safetyReports.transitionSafetyReport(
        { reportId, transitionSafetyReportRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  closeSafetyReport(reportId: string, signal?: AbortSignal): Promise<SafetyReportDetail> {
    return this.execute(() =>
      this.safetyReports.closeSafetyReport({ reportId }, signal ? { signal } : undefined),
    );
  }

  uploadSafetyEvidence(
    reportId: string,
    kind: "photo" | "video",
    file: Blob,
    signal?: AbortSignal,
  ): Promise<SafetyReportDetail> {
    return this.execute(() =>
      this.safetyReports.uploadSafetyEvidence(
        { reportId, kind, file },
        signal ? { signal } : undefined,
      ),
    );
  }

  deleteSafetyEvidence(
    reportId: string,
    evidenceId: string,
    signal?: AbortSignal,
  ): Promise<SafetyReportDetail> {
    return this.execute(() =>
      this.safetyReports.deleteSafetyEvidence(
        { reportId, evidenceId },
        signal ? { signal } : undefined,
      ),
    );
  }

  createCorrectiveAction(
    reportId: string,
    request: CreateCorrectiveActionRequest,
    signal?: AbortSignal,
  ): Promise<SafetyReportDetail> {
    return this.execute(() =>
      this.safetyReports.createCorrectiveAction(
        { reportId, createCorrectiveActionRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  updateCorrectiveAction(
    reportId: string,
    actionId: string,
    request: UpdateCorrectiveActionRequest,
    signal?: AbortSignal,
  ): Promise<SafetyReportDetail> {
    return this.execute(() =>
      this.safetyReports.updateCorrectiveAction(
        { reportId, actionId, updateCorrectiveActionRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  cancelCorrectiveAction(
    reportId: string,
    actionId: string,
    request: CancelCorrectiveActionRequest,
    signal?: AbortSignal,
  ): Promise<SafetyReportDetail> {
    return this.execute(() =>
      this.safetyReports.cancelCorrectiveAction(
        { reportId, actionId, cancelCorrectiveActionRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  inviteUser(request: InviteUserRequest, signal?: AbortSignal): Promise<UserDetail> {
    return this.execute(() =>
      this.users.inviteUser({ inviteUserRequest: request }, signal ? { signal } : undefined),
    );
  }

  updateUser(
    userId: string,
    request: UpdateUserRequest,
    signal?: AbortSignal,
  ): Promise<UserDetail> {
    return this.execute(() =>
      this.users.updateUser(
        { userId, updateUserRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  setUserStatus(
    userId: string,
    request: UpdateUserStatusRequest,
    signal?: AbortSignal,
  ): Promise<UserDetail> {
    return this.execute(() =>
      this.users.setUserStatus(
        { userId, updateUserStatusRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  listRoles(signal?: AbortSignal): Promise<RoleList> {
    return this.execute(() => this.roles.listRoles(signal ? { signal } : undefined));
  }

  getRole(roleId: string, signal?: AbortSignal): Promise<RoleDetail> {
    return this.execute(() => this.roles.getRole({ roleId }, signal ? { signal } : undefined));
  }

  createRole(request: CreateRoleRequest, signal?: AbortSignal): Promise<RoleDetail> {
    return this.execute(() =>
      this.roles.createRole({ createRoleRequest: request }, signal ? { signal } : undefined),
    );
  }

  updateRole(
    roleId: string,
    request: UpdateRoleRequest,
    signal?: AbortSignal,
  ): Promise<RoleDetail> {
    return this.execute(() =>
      this.roles.updateRole(
        { roleId, updateRoleRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  deleteRole(roleId: string, signal?: AbortSignal): Promise<RoleDeleted> {
    return this.execute(() => this.roles.deleteRole({ roleId }, signal ? { signal } : undefined));
  }

  listPermissionCatalog(signal?: AbortSignal): Promise<PermissionCatalog> {
    return this.execute(() =>
      this.permissions.listPermissionCatalog(signal ? { signal } : undefined),
    );
  }

  getCompany(signal?: AbortSignal): Promise<CompanyProfile> {
    return this.execute(() => this.company.getCompany(signal ? { signal } : undefined));
  }

  updateCompany(request: UpdateCompanyRequest, signal?: AbortSignal): Promise<CompanyProfile> {
    return this.execute(() =>
      this.company.updateCompany(
        { updateCompanyRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  uploadCompanyLogo(file: Blob, signal?: AbortSignal): Promise<CompanyProfile> {
    return this.execute(() =>
      this.company.uploadCompanyLogo({ file }, signal ? { signal } : undefined),
    );
  }

  removeCompanyLogo(signal?: AbortSignal): Promise<CompanyProfile> {
    return this.execute(() => this.company.removeCompanyLogo(signal ? { signal } : undefined));
  }

  listAuditLogs(options: ListAuditLogsOptions = {}, signal?: AbortSignal): Promise<AuditLogPage> {
    return this.execute(() =>
      this.audit.listAuditLogs(
        {
          fromDate: toDate(options.fromDate),
          toDate: toDate(options.toDate),
          actorUid: options.actorUid,
          action: options.action,
          targetType: options.targetType,
          q: options.q,
          cursor: options.cursor,
          limit: options.limit,
        },
        signal ? { signal } : undefined,
      ),
    );
  }

  getAuditLogFacets(
    options: Pick<AuditLogFilterOptions, "fromDate" | "toDate"> = {},
    signal?: AbortSignal,
  ): Promise<AuditLogFacets> {
    return this.execute(() =>
      this.audit.getAuditLogFacets(
        { fromDate: toDate(options.fromDate), toDate: toDate(options.toDate) },
        signal ? { signal } : undefined,
      ),
    );
  }

  exportAuditLogs(options: AuditLogFilterOptions = {}, signal?: AbortSignal): Promise<string> {
    return this.execute(() =>
      this.audit.exportAuditLogs(
        {
          fromDate: toDate(options.fromDate),
          toDate: toDate(options.toDate),
          actorUid: options.actorUid,
          action: options.action,
          targetType: options.targetType,
          q: options.q,
        },
        signal ? { signal } : undefined,
      ),
    );
  }

  listPlatformCompanies(
    options: { cursor?: string; limit?: number } = {},
    signal?: AbortSignal,
  ): Promise<PlatformCompanyPage> {
    return this.execute(() =>
      this.platform.listPlatformCompanies(
        { cursor: options.cursor, limit: options.limit },
        signal ? { signal } : undefined,
      ),
    );
  }

  getPlatformCompany(companyId: string, signal?: AbortSignal): Promise<PlatformCompanyDetail> {
    return this.execute(() =>
      this.platform.getPlatformCompany({ companyId }, signal ? { signal } : undefined),
    );
  }

  updatePlatformCompanyStatus(
    companyId: string,
    request: UpdateCompanyStatusRequest,
    signal?: AbortSignal,
  ): Promise<PlatformCompanyDetail> {
    return this.execute(() =>
      this.platform.updatePlatformCompanyStatus(
        { companyId, updateCompanyStatusRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  updatePlatformCompany(
    companyId: string,
    request: UpdatePlatformCompanyRequest,
    signal?: AbortSignal,
  ): Promise<PlatformCompanyDetail> {
    return this.execute(() =>
      this.platform.updatePlatformCompany(
        { companyId, updatePlatformCompanyRequest: request },
        signal ? { signal } : undefined,
      ),
    );
  }

  getPlatformStats(signal?: AbortSignal): Promise<PlatformStats> {
    return this.execute(() => this.platform.getPlatformStats(signal ? { signal } : undefined));
  }

  private async execute<T>(request: () => Promise<T>): Promise<T> {
    let typed: ApiClientError;
    try {
      return await request();
    } catch (error) {
      typed = await this.toApiError(error);
    }
    if (typed.status === 401 && this.refreshIdToken) {
      // A 401 may just mean the cached token expired: force one refresh and retry
      // once before treating the session as dead.
      const refreshed = await Promise.resolve()
        .then(() => this.refreshIdToken!())
        .then((token) => Boolean(token))
        .catch(() => false);
      if (refreshed) {
        try {
          return await request();
        } catch (retryError) {
          typed = await this.toApiError(retryError);
        }
      }
    }
    // 401s stay quiet here: the onUnauthorized hook owns session-expired messaging.
    if (typed.status !== 401) this.toast?.error(typed.message);
    if (typed.status === 401) await this.onUnauthorized();
    if (typed.requestId && process.env.NODE_ENV === "development") {
      console.error(`FEV API error request_id=${typed.requestId}`, typed);
    }
    throw typed;
  }

  private async toApiError(error: unknown): Promise<ApiClientError> {
    if (error instanceof ResponseError) {
      let payload: unknown;
      try {
        payload = await error.response.clone().json();
      } catch {
        payload = undefined;
      }
      if (isEnvelope(payload)) {
        return new ApiClientError(
          payload.error,
          payload.message,
          error.response.status,
          payload.details,
          payload.request_id,
        );
      }
      return new ApiClientError(
        "http_error",
        `API request failed with HTTP ${error.response.status}`,
        error.response.status,
      );
    }
    if (error instanceof FetchError || error instanceof TypeError) {
      return new ApiClientError("network_error", "Unable to reach the API");
    }
    if (error instanceof DOMException && error.name === "AbortError") {
      return new ApiClientError("request_cancelled", "Request was cancelled");
    }
    return new ApiClientError("client_error", "The API request could not be completed");
  }
}
