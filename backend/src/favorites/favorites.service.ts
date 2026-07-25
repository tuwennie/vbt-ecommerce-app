import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { AddFavoriteDto } from './dto/add-favorite.dto';

@Injectable()
export class FavoritesService {
  constructor(private prisma: PrismaService) {}

  async findAll(userId: string) {
    const favorites = await this.prisma.favorite.findMany({
      where: { userId },
      include: {
        product: { include: { category: true, images: true } },
      },
      orderBy: { createdAt: 'desc' },
    });

    return favorites.map((fav) => this.toFavoriteResponse(fav));
  }

  async create(userId: string, dto: AddFavoriteDto) {
    const product = await this.prisma.product.findUnique({
      where: { id: dto.productId },
    });

    if (!product) {
      throw new NotFoundException('Ürün bulunamadı.');
    }

    try {
      const favorite = await this.prisma.favorite.create({
        data: { userId, productId: dto.productId },
        include: {
          product: { include: { category: true, images: true } },
        },
      });

      return this.toFavoriteResponse(favorite);
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      ) {
        throw new ConflictException('Bu ürün zaten favorilerde.');
      }
      throw error;
    }
  }

  async remove(userId: string, productId: string) {
    const favorite = await this.prisma.favorite.findUnique({
      where: {
        userId_productId: { userId, productId },
      },
    });

    if (!favorite) {
      throw new NotFoundException('Favori bulunamadı.');
    }

    await this.prisma.favorite.delete({
      where: { id: favorite.id },
    });
  }

  private toFavoriteResponse(favorite: {
    id: string;
    createdAt: Date;
    product: {
      id: string;
      name: string;
      description: string | null;
      price: Prisma.Decimal;
      stock: number;
      isActive: boolean;
      category: { id: string; name: string; slug: string; isActive: boolean };
      images: Array<{
        id: string;
        imageUrl: string;
        isPrimary: boolean;
        sortOrder: number;
      }>;
    };
  }) {
    return {
      id: favorite.id,
      createdAt: favorite.createdAt,
      product: {
        id: favorite.product.id,
        name: favorite.product.name,
        description: favorite.product.description,
        price: Number(favorite.product.price),
        currency: 'TRY',
        stock: favorite.product.stock,
        isActive: favorite.product.isActive,
        category: {
          id: favorite.product.category.id,
          name: favorite.product.category.name,
          slug: favorite.product.category.slug,
          isActive: favorite.product.category.isActive,
        },
        images: favorite.product.images.map((image) => ({
          id: image.id,
          imageUrl: image.imageUrl,
          isPrimary: image.isPrimary,
          sortOrder: image.sortOrder,
        })),
      },
    };
  }
}
