import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ThrottlerModule } from '@nestjs/throttler';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { ProductsModule } from './products/products.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    ThrottlerModule.forRoot([
      {
        name: 'auth',
        ttl: 60000,
        limit: 5,
      },
    ]),
    PrismaModule,
    AuthModule,
    ProductsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
