import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Put,
  Req,
  UseGuards,
  Delete,
} from '@nestjs/common';
import type { Request } from 'express';
import { CartService } from './cart.service';
import { AddCartItemDto } from './dto/add-cart-item.dto';
import { UpdateCartItemDto } from './dto/update-cart-item.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

type AuthenticatedRequest = Request & { user: { userId: string } };

@Controller('cart')
@UseGuards(JwtAuthGuard)
export class CartController {
  constructor(private cartService: CartService) {}

  @Get()
  getCart(@Req() req: AuthenticatedRequest) {
    return this.cartService.getCart(req.user.userId);
  }

  @Post('items')
  @HttpCode(HttpStatus.OK)
  addItem(@Req() req: AuthenticatedRequest, @Body() dto: AddCartItemDto) {
    return this.cartService.addItem(req.user.userId, dto);
  }

  @Put('items/:itemId')
  updateItem(
    @Req() req: AuthenticatedRequest,
    @Param('itemId') itemId: string,
    @Body() dto: UpdateCartItemDto,
  ) {
    return this.cartService.updateItem(req.user.userId, itemId, dto);
  }

  @Delete('items/:itemId')
  @HttpCode(HttpStatus.NO_CONTENT)
  removeItem(
    @Req() req: AuthenticatedRequest,
    @Param('itemId') itemId: string,
  ) {
    return this.cartService.removeItem(req.user.userId, itemId);
  }
}
