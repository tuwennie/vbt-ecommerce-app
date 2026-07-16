import { PrismaClient } from '../generated/prisma/client';
import * as bcrypt from 'bcryptjs';
import * as fs from 'fs';
import * as path from 'path';

const prisma = new PrismaClient();

function readJson<T>(filename: string): T {
  const filePath = path.join(__dirname, 'seed-data', filename);
  const raw = fs.readFileSync(filePath, 'utf-8');
  return JSON.parse(raw) as T;
}

type SeedCategory = {
  id: string;
  name: string;
  slug: string;
  isActive: boolean;
};

type SeedProduct = {
  id: string;
  name: string;
  price: string;
  stock: number;
  categoryId: string;
  imageUrl: string;
};

type SeedAddress = {
  recipientName: string;
  phone: string;
  city: string;
  district: string;
  addressLine: string;
  postalCode: string;
};

type SeedUser = {
  id: string;
  email: string;
  fullName: string;
  role: 'ADMIN' | 'USER';
  address: SeedAddress | null;
};

async function main() {
  console.log('Seed başlıyor...');

  const categories = readJson<SeedCategory[]>('categories.json');
  for (const cat of categories) {
    await prisma.category.upsert({
      where: { id: cat.id },
      update: {
        name: cat.name,
        slug: cat.slug,
        isActive: cat.isActive,
      },
      create: {
        id: cat.id,
        name: cat.name,
        slug: cat.slug,
        isActive: cat.isActive,
      },
    });
  }
  console.log(`${categories.length} kategori eklendi/güncellendi.`);

  const products = readJson<SeedProduct[]>("products.json");
  for (const prod of products) {
    await prisma.product.upsert({
      where: { id: prod.id },
      update: {
        name: prod.name,
        price: prod.price,
        stock: prod.stock,
        categoryId: prod.categoryId,
      },
      create: {
        id: prod.id,
        name: prod.name,
        price: prod.price,
        stock: prod.stock,
        categoryId: prod.categoryId,
        images: {
          create: [
            {
              imageUrl: prod.imageUrl,
              isPrimary: true,
              sortOrder: 0,
            },
          ],
        },
      },
    });
  }
  console.log(`${products.length} ürün eklendi/güncellendi.`);

  const passwordHash = bcrypt.hashSync("password123!", 10);
  const users = readJson<SeedUser[]>("users.json");

  for (const u of users) {
    await prisma.user.upsert({
      where: { id: u.id },
      update: {
        email: u.email,
        fullName: u.fullName,
        role: u.role,
      },
      create: {
        id: u.id,
        email: u.email,
        fullName: u.fullName,
        role: u.role,
        passwordHash: passwordHash,
        cart: {
          create: {},
        },
        addresses: u.address
          ? {
              create: [
                {
                  recipientName: u.address.recipientName,
                  phone: u.address.phone,
                  city: u.address.city,
                  district: u.address.district,
                  addressLine: u.address.addressLine,
                  postalCode: u.address.postalCode,
                },
              ],
            }
          : undefined,
      },
    });
  }
  console.log(`${users.length} kullanıcı eklendi/güncellendi.`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
