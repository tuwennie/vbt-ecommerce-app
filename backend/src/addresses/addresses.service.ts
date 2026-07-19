import {
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AddressInputDto } from './dto/address-input.dto';

@Injectable()
export class AddressesService {
  constructor(private prisma: PrismaService) {}

  async findAll(userId: string) {
    const addresses = await this.prisma.address.findMany({
      where: { userId },
    });

    return addresses.map((address) => this.toAddressResponse(address));
  }

  async create(userId: string, dto: AddressInputDto) {
    const address = await this.prisma.address.create({
      data: {
        userId,
        title: dto.title,
        recipientName: dto.recipientName,
        phone: dto.phone,
        city: dto.city,
        district: dto.district,
        addressLine: dto.addressLine,
        postalCode: dto.postalCode,
      },
    });

    return this.toAddressResponse(address);
  }

  async update(userId: string, addressId: string, dto: AddressInputDto) {
    const existing = await this.findOwned(userId, addressId);

    const address = await this.prisma.address.update({
      where: { id: existing.id },
      data: {
        title: dto.title,
        recipientName: dto.recipientName,
        phone: dto.phone,
        city: dto.city,
        district: dto.district,
        addressLine: dto.addressLine,
        postalCode: dto.postalCode,
      },
    });

    return this.toAddressResponse(address);
  }

  async remove(userId: string, addressId: string) {
    const existing = await this.findOwned(userId, addressId);

    await this.prisma.address.delete({
      where: { id: existing.id },
    });
  }

  private async findOwned(userId: string, addressId: string) {
    const address = await this.prisma.address.findUnique({
      where: { id: addressId },
    });

    if (!address) {
      throw new NotFoundException('Adres bulunamadı.');
    }

    if (address.userId !== userId) {
      throw new ForbiddenException('Bu adres size ait değil.');
    }

    return address;
  }

  private toAddressResponse(address: {
    id: string;
    title: string | null;
    recipientName: string;
    phone: string;
    city: string;
    district: string;
    addressLine: string;
    postalCode: string;
  }) {
    return {
      id: address.id,
      title: address.title,
      recipientName: address.recipientName,
      phone: address.phone,
      city: address.city,
      district: address.district,
      addressLine: address.addressLine,
      postalCode: address.postalCode,
    };
  }
}
