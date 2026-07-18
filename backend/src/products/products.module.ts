import { Module } from '@nestjs/common';
import { ProductsController } from './products.controller';
import { ProductsService } from './products.service';
import { PrismaModule } from '../prisma/prisma.module';
import { AdminController } from './admin.controller';

@Module({
  imports: [PrismaModule],
  controllers: [ProductsController, AdminController],
  providers: [ProductsService],
})
export class ProductsModule {}
