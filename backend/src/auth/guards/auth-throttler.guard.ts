import {
  Injectable,
  ExecutionContext,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { ThrottlerGuard, ThrottlerLimitDetail } from '@nestjs/throttler';

@Injectable()
export class AuthThrottlerGuard extends ThrottlerGuard {
  protected async throwThrottlingException(
    context: ExecutionContext,
    throttlerLimitDetail: ThrottlerLimitDetail,
  ): Promise<void> {
    const response = context.switchToHttp().getResponse();
    const retryAfterSeconds = Math.ceil(
      throttlerLimitDetail.timeToBlockExpire / 1000,
    );

    response.setHeader('Retry-After', retryAfterSeconds);

    throw new HttpException(
      {
        message: 'İstek sınırı aşıldı, lütfen daha sonra tekrar deneyin.',
      },
      HttpStatus.TOO_MANY_REQUESTS,
    );
  }
}
