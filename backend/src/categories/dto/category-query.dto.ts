import { Type } from 'class-transformer';
import { IsOptional } from 'class-validator';

export class CategoryQueryDto {
  @IsOptional()
  @Type(() => Boolean)
  includeInactive?: boolean = false;
}
