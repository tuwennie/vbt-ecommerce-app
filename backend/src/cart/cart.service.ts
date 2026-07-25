import { PrismaService } from '../prisma/prisma.service';
import { Prisma } from '@prisma/client';
import {
  Injectable,
  NotFoundException,
  UnprocessableEntityException,
} from '@nestjs/common';
import { AddCartItemDto } from './dto/add-cart-item.dto';
import { UpdateCartItemDto } from './dto/update-cart-item.dto';

@Injectable()
export class CartService {
  constructor(private prisma: PrismaService) {}

  async getOrCreateCart(userId: string) {
    let cart = await this.prisma.cart.findUnique({
      where: { userId },
      include: { items: { include: { product: true } } },
    });

    if (!cart) {
      cart = await this.prisma.cart.create({
        data: { userId },
        include: { items: { include: { product: true } } },
      });
    }

    return cart;
  }

  async getCart(userId: string) {
    const cart = await this.getOrCreateCart(userId);
    return this.toCartResponse(cart);
  }

  async addItem(userId: string, dto: AddCartItemDto) {
    const cart = await this.getOrCreateCart(userId);

    const product = await this.prisma.product.findUnique({
      where: { id: dto.productId },
    });

    if (!product) {
      throw new NotFoundException('Ürün bulunamadı.');
    }

    if (!product.isActive) {
      throw new UnprocessableEntityException({
        message: 'Bu ürün şu anda satışa kapalı.',
        status: 'PRODUCT_INACTIVE',
      });
    }

    const existingItem = await this.prisma.cartItem.findUnique({
      where: {
        cartId_productId: {
          cartId: cart.id,
          productId: dto.productId,
        },
      },
    });

    const requestedQuantity = existingItem
      ? existingItem.quantity + dto.quantity
      : dto.quantity;

    if (requestedQuantity > product.stock) {
      throw new UnprocessableEntityException({
        message: 'İstenen miktar mevcut stoku aşıyor.',
        status: 'INSUFFICIENT_STOCK',
      });
    }

    if (existingItem) {
      await this.prisma.cartItem.update({
        where: { id: existingItem.id },
        data: { quantity: requestedQuantity },
      });
    } else {
      await this.prisma.cartItem.create({
        data: {
          cartId: cart.id,
          productId: dto.productId,
          quantity: dto.quantity,
        },
      });
    }

    return this.getCart(userId);
  }

  async updateItem(userId: string, itemId: string, dto: UpdateCartItemDto) {
    const cart = await this.getOrCreateCart(userId);

    const item = await this.prisma.cartItem.findUnique({
      where: { id: itemId },
      include: { product: true },
    });

    if (!item || item.cartId !== cart.id) {
      throw new NotFoundException('Sepet öğesi bulunamadı.');
    }

    if (dto.quantity > item.product.stock) {
      throw new UnprocessableEntityException({
        message: 'İstenen miktar mevcut stoku aşıyor.',
        status: 'INSUFFICIENT_STOCK',
      });
    }

    await this.prisma.cartItem.update({
      where: { id: itemId },
      data: { quantity: dto.quantity },
    });

    return this.getCart(userId);
  }

  async removeItem(userId: string, itemId: string) {
    const cart = await this.getOrCreateCart(userId);

    const item = await this.prisma.cartItem.findUnique({
      where: { id: itemId },
    });

    if (!item || item.cartId !== cart.id) {
      throw new NotFoundException('Sepet öğesi bulunamadı.');
    }

    await this.prisma.cartItem.delete({
      where: { id: itemId },
    });
  }

  private toCartResponse(cart: {
    id: string;
    items: Array<{
      id: string;
      quantity: number;
      product: { id: string; name: string; price: Prisma.Decimal };
    }>;
  }) {
    const items = cart.items.map((item) => {
      const unitPrice = Number(item.product.price);
      const subtotal = unitPrice * item.quantity;

      return {
        id: item.id,
        productId: item.product.id,
        productName: item.product.name,
        unitPrice,
        quantity: item.quantity,
        subtotal,
      };
    });

    const total = items.reduce((sum, item) => sum + item.subtotal, 0);

    return {
      id: cart.id,
      items,
      total,
    };
  }
}
