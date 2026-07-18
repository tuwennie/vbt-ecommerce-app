import { NestFactory } from '@nestjs/core';
import { BadRequestException, ValidationPipe } from '@nestjs/common';
import cookieParser from 'cookie-parser';
import { AppModule } from './app.module';
import { HttpExceptionFilter } from './common/filters/http-exception.filter';
import { ResponseInterceptor } from './common/interceptors/response.interceptor';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.setGlobalPrefix('api/v1');

  app.enableCors({
    origin: 'http://localhost:3001',
    credentials: true,
  });

  app.use(cookieParser());

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      exceptionFactory: (errors) => {
        const formatted = errors.map((err) => ({
          field: err.property,
          message: Object.values(err.constraints ?? {})[0] ?? 'Geçersiz değer',
        }));

        return new BadRequestException({
          message: 'Doğrulama hatası',
          errors: formatted,
        });
      },
    }),
  );

  app.useGlobalFilters(new HttpExceptionFilter());
  app.useGlobalInterceptors(new ResponseInterceptor());

  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
