import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import type { Request } from 'express';
import { FavoritesService } from './favorites.service';
import { AddFavoriteDto } from './dto/add-favorite.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

type AuthenticatedRequest = Request & { user: { userId: string } };

@Controller('favorites')
@UseGuards(JwtAuthGuard)
export class FavoritesController {
  constructor(private favoritesService: FavoritesService) {}

  @Get()
  findAll(@Req() req: AuthenticatedRequest) {
    return this.favoritesService.findAll(req.user.userId);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  create(@Req() req: AuthenticatedRequest, @Body() dto: AddFavoriteDto) {
    return this.favoritesService.create(req.user.userId, dto);
  }

  @Delete(':productId')
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(
    @Req() req: AuthenticatedRequest,
    @Param('productId') productId: string,
  ) {
    return this.favoritesService.remove(req.user.userId, productId);
  }
}
