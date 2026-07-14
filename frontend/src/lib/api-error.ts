export type ApiErrorStatus =
  | "BAD_REQUEST"
  | "UNAUTHORIZED"
  | "FORBIDDEN"
  | "NOT_FOUND"
  | "CONFLICT"
  | "UNPROCESSABLE_ENTITY"
  | "TOO_MANY_REQUESTS"
  | "INTERNAL_SERVER_ERROR"
  | "SERVICE_UNAVAILABLE";

export interface ApiErrorResponse {
  success: false;
  message: string;
  statusCode: number;
  status: ApiErrorStatus;
}

export interface ApiValidationErrorResponse extends ApiErrorResponse {
  status: "BAD_REQUEST";
  errors: { field: string; message: string }[];
}

export function isApiValidationError(
  error: ApiErrorResponse,
): error is ApiValidationErrorResponse {
  return "errors" in error && Array.isArray((error as ApiValidationErrorResponse).errors);
}

export function getApiErrorMessage(error: ApiErrorResponse): string {
  if (isApiValidationError(error)) {
    return error.errors.map((e) => e.message).join(" ");
  }
  return error.message;
}