import {
  IsBoolean,
  IsOptional,
  IsString,
  Matches,
  MaxLength,
  MinLength,
} from 'class-validator';

export class CategoryInputDto {
  @IsString()
  @MinLength(2)
  @MaxLength(100)
  name!: string;

  @IsOptional()
  @IsString()
  @Matches(/^[a-z0-9]+(-[a-z0-9]+)*$/, {
    message:
      'slug küçük harf, rakam ve tire içermelidir (örn. elektronik-ev-aletleri).',
  })
  @MaxLength(120)
  slug?: string;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean = true;
}
