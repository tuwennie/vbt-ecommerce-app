import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Headers,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import { isUUID } from 'class-validator';
import type { Request } from 'express';
import { OrdersService } from './orders.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { OrderQueryDto } from './dto/order-query.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

type AuthenticatedRequest = Request & { user: { userId: string } };

@Controller('orders')
@UseGuards(JwtAuthGuard)
export class OrdersController {
  constructor(private ordersService: OrdersService) {}

  @Get()
  findAll(@Req() req: AuthenticatedRequest, @Query() query: OrderQueryDto) {
    return this.ordersService.findAll(
      req.user.userId,
      query.page ?? 1,
      query.size ?? 20,
    );
  }

  @Get(':id')
  findOne(@Req() req: AuthenticatedRequest, @Param('id') id: string) {
    return this.ordersService.findOne(req.user.userId, id);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  createOrder(
    @Req() req: AuthenticatedRequest,
    @Body() dto: CreateOrderDto,
    @Headers('idempotency-key') idempotencyKey: string,
  ) {
    if (!idempotencyKey || !isUUID(idempotencyKey)) {
      throw new BadRequestException(
        "Geçerli bir Idempotency-Key header'ı gereklidir.",
      );
    }
    return this.ordersService.createOrder(req.user.userId, dto, idempotencyKey);
  }
}
