import {
  IsBoolean,
  IsInt,
  IsOptional,
  IsString,
  IsUrl,
  Matches,
} from 'class-validator';

export class ProductImageInputDto {
  @IsUrl()
  @Matches(/^https:\/\//, { message: 'imageUrl https:// ile başlamalıdır.' })
  imageUrl!: string;

  @IsOptional()
  @IsBoolean()
  isPrimary?: boolean = false;

  @IsOptional()
  @IsInt()
  sortOrder?: number = 0;
}
