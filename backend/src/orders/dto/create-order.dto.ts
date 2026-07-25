import { IsIn, IsString } from 'class-validator';

export class CreateOrderDto {
  @IsString()
  addressId!: string;

  @IsIn(['CREDIT_CARD'])
  paymentMethod!: string;
}
