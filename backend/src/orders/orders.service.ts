import {
  ForbiddenException,
  Injectable,
  NotFoundException,
  UnprocessableEntityException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { Prisma } from '@prisma/client';

@Injectable()
export class OrdersService {
  constructor(private prisma: PrismaService) {}

  async createOrder(
    userId: string,
    dto: CreateOrderDto,
    idempotencyKey: string,
  ) {
    const existingOrder = await this.prisma.order.findUnique({
      where: { idempotencyKey },
      include: { items: true },
    });

    if (existingOrder) {
      return this.toOrderResponse(existingOrder);
    }

    const cart = await this.prisma.cart.findUnique({
      where: { userId },
      include: { items: { include: { product: true } } },
    });

    if (!cart || cart.items.length === 0) {
      throw new UnprocessableEntityException(
        'Sepet boş, sipariş oluşturulamaz.',
      );
    }

    const address = await this.prisma.address.findUnique({
      where: { id: dto.addressId },
    });

    if (!address) {
      throw new NotFoundException('Adres bulunamadı.');
    }

    if (address.userId !== userId) {
      throw new ForbiddenException('Bu adres size ait değil.');
    }

    for (const item of cart.items) {
      if (!item.product.isActive) {
        throw new UnprocessableEntityException(
          `${item.product.name} artık satışta değil.`,
        );
      }

      if (item.quantity > item.product.stock) {
        throw new UnprocessableEntityException(
          `${item.product.name} için yeterli stok yok.`,
        );
      }
    }

    const total = cart.items.reduce(
      (sum, item) => sum + Number(item.product.price) * item.quantity,
      0,
    );

    const order = await this.prisma.$transaction(async (tx) => {
      const newOrder = await tx.order.create({
        data: {
          userId,
          idempotencyKey,
          total,
          currency: 'TRY',
          paymentMethod: dto.paymentMethod as 'CREDIT_CARD',
          status: 'PENDING',
          shippingRecipientName: address.recipientName,
          shippingPhone: address.phone,
          shippingCity: address.city,
          shippingDistrict: address.district,
          shippingAddressLine: address.addressLine,
          shippingPostalCode: address.postalCode,
          items: {
            create: cart.items.map((item) => ({
              productId: item.productId,
              productName: item.product.name,
              unitPrice: item.product.price,
              quantity: item.quantity,
              subtotal: Number(item.product.price) * item.quantity,
            })),
          },
        },
        include: { items: true },
      });

      for (const item of cart.items) {
        await tx.product.update({
          where: { id: item.productId },
          data: { stock: { decrement: item.quantity } },
        });
      }

      await tx.cartItem.deleteMany({
        where: { cartId: cart.id },
      });

      return newOrder;
    });

    return this.toOrderResponse(order);
  }

  async findAll(userId: string, page: number, size: number) {
    const [orders, total] = await Promise.all([
      this.prisma.order.findMany({
        where: { userId },
        include: { items: true },
        orderBy: { createdAt: 'desc' },
        skip: (page - 1) * size,
        take: size,
      }),
      this.prisma.order.count({ where: { userId } }),
    ]);

    return {
      items: orders.map((order) => this.toOrderResponse(order)),
      pagination: {
        page,
        size,
        total,
        totalPages: Math.ceil(total / size),
        hasNext: page * size < total,
        hasPrevious: page > 1,
      },
    };
  }

  async findOne(userId: string, orderId: string) {
    const order = await this.prisma.order.findUnique({
      where: { id: orderId },
      include: { items: true },
    });

    if (!order) {
      throw new NotFoundException('Sipariş bulunamadı.');
    }

    if (order.userId !== userId) {
      throw new ForbiddenException('Bu sipariş size ait değil.');
    }

    return this.toOrderResponse(order);
  }

  private toOrderResponse(order: {
    id: string;
    status: string;
    total: Prisma.Decimal;
    currency: string;
    createdAt: Date;
    shippingRecipientName: string;
    shippingPhone: string;
    shippingCity: string;
    shippingDistrict: string;
    shippingAddressLine: string;
    shippingPostalCode: string;
    items?: Array<{
      productId: string | null;
      productName: string;
      unitPrice: Prisma.Decimal;
      quantity: number;
      subtotal: Prisma.Decimal;
    }>;
  }) {
    return {
      id: order.id,
      status: order.status,
      total: Number(order.total),
      currency: order.currency,
      shippingAddress: {
        recipientName: order.shippingRecipientName,
        phone: order.shippingPhone,
        city: order.shippingCity,
        district: order.shippingDistrict,
        addressLine: order.shippingAddressLine,
        postalCode: order.shippingPostalCode,
      },
      createdAt: order.createdAt,
      items: (order.items ?? []).map((item) => ({
        productId: item.productId,
        productName: item.productName,
        unitPrice: Number(item.unitPrice),
        quantity: item.quantity,
        subtotal: Number(item.subtotal),
      })),
    };
  }
}
