import { Body, Controller, Get, Patch, Req, UseGuards } from '@nestjs/common';
import type { Request } from 'express';
import { UsersService } from './users.service';
import { UpdateUserDto } from './dto/update-user.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

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
}
