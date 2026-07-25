import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { Response } from 'express';

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();

    const statusCode =
      exception instanceof HttpException
        ? exception.getStatus()
        : HttpStatus.INTERNAL_SERVER_ERROR;

    const exceptionResponse =
      exception instanceof HttpException ? exception.getResponse() : null;

    const { message, errors, customStatus } =
      this.extractMessage(exceptionResponse);

    response.status(statusCode).json({
      success: false,
      message,
      statusCode,
      status: customStatus ?? this.statusToEnum(statusCode),
      ...(errors ? { errors } : {}),
    });
  }

  private extractMessage(exceptionResponse: unknown): {
    message: string;
    errors?: { field: string; message: string }[];
    customStatus?: string;
  } {
    if (
      typeof exceptionResponse === 'object' &&
      exceptionResponse !== null &&
      'message' in exceptionResponse
    ) {
      const body = exceptionResponse as {
        message: unknown;
        errors?: { field: string; message: string }[];
        status?: string;
      };

      if (body.errors) {
        return { message: String(body.message), errors: body.errors };
      }

      return { message: String(body.message), customStatus: body.status };
    }

    return { message: 'Beklenmeyen bir hata oluştu.' };
  }

  private statusToEnum(statusCode: number): string {
    const map: Record<number, string> = {
      400: 'BAD_REQUEST',
      401: 'UNAUTHORIZED',
      403: 'FORBIDDEN',
      404: 'NOT_FOUND',
      409: 'CONFLICT',
      422: 'UNPROCESSABLE_ENTITY',
      429: 'TOO_MANY_REQUESTS',
      500: 'INTERNAL_SERVER_ERROR',
    };
    return map[statusCode] ?? 'INTERNAL_SERVER_ERROR';
  }
}
