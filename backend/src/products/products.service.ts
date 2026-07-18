import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ProductQueryDto } from './dto/product-query.dto';
import { ProductInputDto } from './dto/product-input.dto';
import { Prisma } from '@prisma/client';

@Injectable()
export class ProductsService {
  constructor(private prisma: PrismaService) {}

  async findAll(query: ProductQueryDto) {
    const page = query.page ?? 1;
    const size = query.size ?? 20;

    const categoryIds = query.categoryId
      ? query.categoryId.split(',').map((id) => id.trim())
      : undefined;

    const where: Prisma.ProductWhereInput = {
      isActive: query.includeInactive ? undefined : true,
      categoryId: categoryIds ? { in: categoryIds } : undefined,
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
      items: items.map((item) => this.withCurrency(item)),
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

  private withCurrency<T extends object>(product: T): T & { currency: string } {
    return { ...product, currency: 'TRY' };
  }

  async findOne(id: string) {
    const product = await this.prisma.product.findUnique({
      where: { id },
      include: { images: true, category: true },
    });

    if (!product) {
      throw new NotFoundException('Ürün bulunamadı.');
    }

    return this.withCurrency(product);
  }

  async create(dto: ProductInputDto) {
    const product = await this.prisma.product.create({
      data: {
        name: dto.name,
        description: dto.description,
        price: dto.price,
        stock: dto.stock,
        categoryId: dto.categoryId,
        isActive: dto.isActive ?? true,
        images: dto.images
          ? {
              create: dto.images.map((img) => ({
                imageUrl: img.imageUrl,
                isPrimary: img.isPrimary ?? false,
                sortOrder: img.sortOrder ?? 0,
              })),
            }
          : undefined,
      },
      include: { images: true, category: true },
    });

    return this.withCurrency(product);
  }

  async update(id: string, dto: ProductInputDto) {
    await this.findOne(id);

    const product = await this.prisma.product.update({
      where: { id },
      data: {
        name: dto.name,
        description: dto.description,
        price: dto.price,
        stock: dto.stock,
        categoryId: dto.categoryId,
        isActive: dto.isActive ?? true,
      },
      include: { images: true, category: true },
    });

    return this.withCurrency(product);
  }
}
