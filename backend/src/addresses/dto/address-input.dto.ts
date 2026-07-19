import {
  IsOptional,
  IsString,
  Matches,
  MaxLength,
  MinLength,
} from 'class-validator';

export class AddressInputDto {
  @IsOptional()
  @IsString()
  @MaxLength(30)
  title?: string;

  @IsString()
  @MinLength(2)
  @MaxLength(100)
  recipientName!: string;

  @IsString()
  @Matches(/^\+?[0-9]{10,15}$/, {
    message: 'phone geçerli bir telefon numarası formatında olmalıdır.',
  })
  phone!: string;

  @IsString()
  @MinLength(2)
  @MaxLength(60)
  city!: string;

  @IsString()
  @MinLength(2)
  @MaxLength(60)
  district!: string;

  @IsString()
  @MinLength(10)
  @MaxLength(250)
  addressLine!: string;

  @IsString()
  @Matches(/^[0-9]{5}$/, {
    message: 'postalCode 5 haneli bir rakam olmalıdır.',
  })
  postalCode!: string;
}
