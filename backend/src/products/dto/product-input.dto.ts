import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsBoolean,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  Min,
  MaxLength,
  MinLength,
  ValidateNested,
} from 'class-validator';
import { ProductImageInputDto } from './product-image-input.dto';

export class ProductInputDto {
  @IsString()
  @MinLength(2)
  @MaxLength(150)
  name!: string;

  @IsOptional()
  @IsString()
  @MaxLength(2000)
  description?: string;

  @IsNumber()
  @Min(0.01)
  price!: number;

  @IsInt()
  @Min(0)
  stock!: number;

  @IsString()
  categoryId!: string;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean = true;

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(10)
  @ValidateNested({ each: true })
  @Type(() => ProductImageInputDto)
  images?: ProductImageInputDto[];
}
