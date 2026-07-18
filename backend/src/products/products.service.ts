import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ProductQueryDto } from './dto/product-query.dto';
import { Prisma } from '@prisma/client';

@Injectable()
export class ProductsService {
  constructor(private prisma: PrismaService) {}

  async findAll(query: ProductQueryDto) {
    const page = query.page ?? 1;
    const size = query.size ?? 20;

    const where: Prisma.ProductWhereInput = {
      isActive: query.includeInactive ? undefined : true,
      categoryId: query.categoryId,
      name: query.search
        ? { contains: query.search, mode: 'insensitive' }
        : undefined,
      price: {
        gte: query.minPrice,
        lte: query.maxPrice,
      },
    };

    const orderBy = this.buildOrderBy(query.sort);

    const [items, total] = await Promise.all([
      this.prisma.product.findMany({
        where,
        orderBy,
        skip: (page - 1) * size,
        take: size,
        include: { images: true, category: true },
      }),
      this.prisma.product.count({ where }),
    ]);

    return {
      items,
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

  private buildOrderBy(sort?: string): Prisma.ProductOrderByWithRelationInput {
    if (!sort) return { createdAt: 'desc' };

    const direction = sort.startsWith('-') ? 'desc' : 'asc';
    const field = sort.replace('-', '');

    return { [field]: direction };
  }

  async findOne(id: string) {
    const product = await this.prisma.product.findUnique({
      where: { id },
      include: { images: true, category: true },
    });

    if (!product) {
      throw new NotFoundException('Ürün bulunamadı.');
    }

    return product;
  }
}
