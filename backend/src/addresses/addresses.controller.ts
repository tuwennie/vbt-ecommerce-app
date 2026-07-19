import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Put,
  Req,
  UseGuards,
} from '@nestjs/common';
import type { Request } from 'express';
import { AddressesService } from './addresses.service';
import { AddressInputDto } from './dto/address-input.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

type AuthenticatedRequest = Request & { user: { userId: string } };

@Controller('addresses')
@UseGuards(JwtAuthGuard)
export class AddressesController {
  constructor(private addressesService: AddressesService) {}

  @Get()
  findAll(@Req() req: AuthenticatedRequest) {
    return this.addressesService.findAll(req.user.userId);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  create(@Req() req: AuthenticatedRequest, @Body() dto: AddressInputDto) {
    return this.addressesService.create(req.user.userId, dto);
  }

  @Put(':id')
  update(
    @Req() req: AuthenticatedRequest,
    @Param('id') id: string,
    @Body() dto: AddressInputDto,
  ) {
    return this.addressesService.update(req.user.userId, id, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(@Req() req: AuthenticatedRequest, @Param('id') id: string) {
    return this.addressesService.remove(req.user.userId, id);
  }
}
