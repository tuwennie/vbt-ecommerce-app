import { Body, Controller, Get, Patch, Req, UseGuards } from '@nestjs/common';
import type { Request } from 'express';
import { UsersService } from './users.service';
import { UpdateUserDto } from './dto/update-user.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { ChangePasswordDto } from './dto/change-password.dto';
import { ChangeEmailDto } from './dto/change-email.dto';
import { HttpCode, HttpStatus } from '@nestjs/common';

@Controller('users')
@UseGuards(JwtAuthGuard)
export class UsersController {
  constructor(private usersService: UsersService) {}

  @Get('me')
  findMe(@Req() req: Request & { user: { userId: string } }) {
    return this.usersService.findMe(req.user.userId);
  }

  @Patch('me')
  updateMe(
    @Req() req: Request & { user: { userId: string } },
    @Body() dto: UpdateUserDto,
  ) {
    return this.usersService.updateMe(req.user.userId, dto);
  }

  @Patch('me/password')
  @HttpCode(HttpStatus.NO_CONTENT)
  changePassword(
    @Req() req: Request & { user: { userId: string } },
    @Body() dto: ChangePasswordDto,
  ) {
    return this.usersService.changePassword(req.user.userId, dto);
  }

  @Patch('me/email')
  changeEmail(
    @Req() req: Request & { user: { userId: string } },
    @Body() dto: ChangeEmailDto,
  ) {
    return this.usersService.changeEmail(req.user.userId, dto);
  }
}
