import {
  Body,
  Controller,
  Headers,
  HttpCode,
  HttpStatus,
  Post,
  Req,
  Res,
  UnauthorizedException,
} from '@nestjs/common';
import type { Request, Response } from 'express';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { RefreshDto } from './dto/refresh.dto';

const REFRESH_COOKIE_NAME = 'refreshToken';
const REFRESH_COOKIE_PATH = '/api/v1/auth';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  async register(
    @Body() dto: RegisterDto,
    @Headers('x-client-type') clientType: string,
    @Res({ passthrough: true }) res: Response,
  ) {
    const result = await this.authService.register(dto);
    return this.formatForClient(result, clientType, res);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(
    @Body() dto: LoginDto,
    @Headers('x-client-type') clientType: string,
    @Res({ passthrough: true }) res: Response,
  ) {
    const result = await this.authService.login(dto);
    return this.formatForClient(result, clientType, res);
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  async refresh(
    @Body() dto: RefreshDto,
    @Headers('x-client-type') clientType: string,
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
  ) {
    const token = this.extractRefreshToken(dto, clientType, req);
    const result = await this.authService.refresh(token);
    return this.formatForClient(result, clientType, res);
  }

  @Post('logout')
  @HttpCode(HttpStatus.NO_CONTENT)
  async logout(
    @Body() dto: RefreshDto,
    @Headers('x-client-type') clientType: string,
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
  ) {
    const token = this.extractRefreshToken(dto, clientType, req);
    await this.authService.logout(token);

    if (clientType === 'WEB') {
      res.clearCookie(REFRESH_COOKIE_NAME, { path: REFRESH_COOKIE_PATH });
    }
  }

  private extractRefreshToken(
    dto: RefreshDto,
    clientType: string,
    req: Request,
  ): string {
    if (clientType === 'WEB') {
      const cookieToken = req.cookies?.[REFRESH_COOKIE_NAME];
      if (!cookieToken) {
        throw new UnauthorizedException('Refresh token cookie bulunamadı.');
      }
      return cookieToken;
    }

    if (!dto.refreshToken) {
      throw new UnauthorizedException('refreshToken zorunludur.');
    }

    return dto.refreshToken;
  }

  private formatForClient(
    result: {
      accessToken: string;
      refreshToken: string;
      expiresIn: number;
      user: unknown;
    },
    clientType: string,
    res: Response,
  ) {
    if (clientType === 'WEB') {
      res.cookie(REFRESH_COOKIE_NAME, result.refreshToken, {
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production',
        sameSite: 'strict',
        path: REFRESH_COOKIE_PATH,
      });

      const { refreshToken, ...rest } = result;
      return rest;
    }

    return result;
  }
}
