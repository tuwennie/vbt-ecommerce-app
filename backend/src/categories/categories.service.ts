import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { CategoryQueryDto } from './dto/category-query.dto';
import { CategoryInputDto } from './dto/category-input.dto';

@Injectable()
export class CategoriesService {
  constructor(private prisma: PrismaService) {}

  async findAll(query: CategoryQueryDto) {
    const categories = await this.prisma.category.findMany({
      where: query.includeInactive ? undefined : { isActive: true },
    });

    return categories.map((category) => this.toCategoryResponse(category));
  }

  async create(dto: CategoryInputDto) {
    const slug = dto.slug ?? this.generateSlug(dto.name);

    try {
      const category = await this.prisma.category.create({
        data: {
          name: dto.name,
          slug,
          isActive: dto.isActive ?? true,
        },
      });

      return this.toCategoryResponse(category);
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      ) {
        throw new ConflictException('Bu slug zaten kullanılıyor.');
      }
      throw error;
    }
  }

  async update(id: string, dto: CategoryInputDto) {
    await this.findOne(id);

    const slug = dto.slug ?? this.generateSlug(dto.name);

    try {
      const category = await this.prisma.category.update({
        where: { id },
        data: {
          name: dto.name,
          slug,
          isActive: dto.isActive ?? true,
        },
      });

      return this.toCategoryResponse(category);
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      ) {
        throw new ConflictException('Bu slug zaten kullanılıyor.');
      }
      throw error;
    }
  }

  private async findOne(id: string) {
    const category = await this.prisma.category.findUnique({
      where: { id },
    });

    if (!category) {
      throw new NotFoundException('Kategori bulunamadı.');
    }

    return category;
  }

  private generateSlug(name: string): string {
    const turkishMap: Record<string, string> = {
      ç: 'c',
      Ç: 'c',
      ğ: 'g',
      Ğ: 'g',
      ı: 'i',
      I: 'i',
      İ: 'i',
      ö: 'o',
      Ö: 'o',
      ş: 's',
      Ş: 's',
      ü: 'u',
      Ü: 'u',
    };

    return name
      .split('')
      .map((char) => turkishMap[char] ?? char)
      .join('')
      .toLowerCase()
      .trim()
      .replace(/[^a-z0-9\s-]/g, '')
      .replace(/\s+/g, '-')
      .replace(/-+/g, '-')
      .replace(/^-|-$/g, '');
  }

  private toCategoryResponse(category: {
    id: string;
    name: string;
    slug: string;
    isActive: boolean;
  }) {
    return {
      id: category.id,
      name: category.name,
      slug: category.slug,
      isActive: category.isActive,
    };
  }
}
