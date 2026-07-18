import { Body, Controller, Param, Post, Put, UseGuards } from '@nestjs/common';
import { ProductsService } from './products.service';
import { ProductInputDto } from './dto/product-input.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';

@Controller('admin/products')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('ADMIN')
export class AdminController {
  constructor(private productsService: ProductsService) {}

  @Post()
  create(@Body() dto: ProductInputDto) {
    return this.productsService.create(dto);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() dto: ProductInputDto) {
    return this.productsService.update(id, dto);
  }
}
