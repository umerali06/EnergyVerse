import {
  AuthApi,
  Configuration,
  FetchError,
  ResponseError,
  SystemApi,
  type CompanyRegistrationRequest,
  type CompanyRegistrationResponse,
  type CurrentUser,
  type HealthResponse,
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

export class FevApiClient {
  private readonly auth: AuthApi;
  private readonly system: SystemApi;
  private readonly onUnauthorized: UnauthorizedHook;
  private readonly toast?: ErrorToast;

  constructor(options: FevApiClientOptions = {}) {
    const getIdToken = options.getIdToken ?? (() => undefined);
    const configuration = new Configuration({
      accessToken: async () => (await getIdToken()) ?? "",
      basePath: (options.baseUrl ?? defaultBaseUrl).replace(/\/$/, ""),
      fetchApi: options.fetchApi,
    });
    this.auth = new AuthApi(configuration);
    this.system = new SystemApi(configuration);
    this.onUnauthorized = options.onUnauthorized ?? (() => undefined);
    this.toast = options.toast;
  }

  getHealth(signal?: AbortSignal): Promise<HealthResponse> {
    return this.execute(() => this.system.getHealth(signal ? { signal } : undefined));
  }

  getCurrentUser(signal?: AbortSignal): Promise<CurrentUser> {
    return this.execute(() => this.auth.getCurrentUser(signal ? { signal } : undefined));
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

  private async execute<T>(request: () => Promise<T>): Promise<T> {
    try {
      return await request();
    } catch (error) {
      const typed = await this.toApiError(error);
      this.toast?.error(typed.message);
      if (typed.status === 401) await this.onUnauthorized();
      if (typed.requestId && process.env.NODE_ENV === "development") {
        console.error(`FEV API error request_id=${typed.requestId}`, typed);
      }
      throw typed;
    }
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
