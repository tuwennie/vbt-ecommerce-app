# VBT E-Ticaret Projesi

Next.js 16 (TypeScript, Tailwind CSS v4) + NestJS + PostgreSQL/Prisma ile geliştirilmiş, tam entegre bir e-ticaret uygulaması. Admin Paneli (yönetim) ve B2C (müşteri) arayüzlerini tek bir monorepo içinde barındırır.

## Proje Yapısı
```
vbt-ecommerce-app/
├── frontend/          Next.js 16 + TypeScript + Tailwind v4 (Admin Panel + B2C)
├── backend/            NestJS + Prisma + PostgreSQL (API)
└── qa-tests/
    ├── playwright/     Uçtan uca (E2E) otomasyon testleri
    └── postman/        API test koleksiyonu
```

## Gereksinimler
- Node.js 20+
- npm
- PostgreSQL (yerel kurulum ya da Docker)
- (İsteğe bağlı) Docker Desktop — backend'in `docker-compose.yml`'ı ile PostgreSQL'i konteynerde çalıştırmak için

## Kurulum — Adım Adım

### 1) Depoyu klonla
```bash
git clone https://github.com/tuwennie/vbt-ecommerce-app.git
cd vbt-ecommerce-app
```

### 2) Backend'i kur
```bash
cd backend
npm install
```

`.env.example` dosyasını `.env` olarak kopyala, içindeki `DATABASE_URL`'i kendi PostgreSQL bilgilerinle doldur:
```env
DATABASE_URL="postgresql://KULLANICI:SIFRE@localhost:5432/vbt_ecommerce?schema=public"
JWT_ACCESS_SECRET=<rastgele-uzun-bir-metin>
JWT_REFRESH_SECRET=<rastgele-uzun-bir-metin>
JWT_ACCESS_EXPIRES_IN=900
JWT_REFRESH_EXPIRES_IN=604800
```

> **Docker ile PostgreSQL** kullanmak istersen: `docker compose up -d` çalıştır, `DATABASE_URL`'i `docker-compose.yml`'daki bağlantı bilgilerine göre doldur.

Veritabanı şemasını oluştur ve örnek verileri yükle:
```bash
npx prisma generate
npx prisma migrate dev
npx prisma db seed
```

Backend'i başlat:
```bash
npm run start:dev
```
Backend **http://localhost:3000/api/v1** adresinde çalışır. Swagger dokümantasyonuna (varsa) `http://localhost:3000/api/docs` üzerinden erişilebilir.

### 3) Frontend'i kur
Yeni bir terminalde:
```bash
cd frontend
npm install
```

`.env.example`'ı `.env` olarak kopyala:
```env
NEXT_PUBLIC_API_BASE_URL=http://localhost:3000/api/v1
```

Frontend'i başlat:
```bash
npm run dev
```
Frontend **http://localhost:3001** adresinde çalışır (backend'in 3000 portuyla çakışmaması için `-p 3001` ile ayarlanmıştır).

### 4) Giriş yapmak için (seed kullanıcıları)
Seed script'i örnek kullanıcılar oluşturur. Tüm seed kullanıcılarının şifresi:
```
password123!
```
Hangi e-postanın `ADMIN` rolünde olduğunu görmek için `backend/prisma/seed-data/users.json` dosyasına bakabilirsin.

## Ortam Değişkenleri

| Dosya | Değişken | Açıklama |
|---|---|---|
| `backend/.env` | `DATABASE_URL` | PostgreSQL bağlantı string'i |
| `backend/.env` | `JWT_ACCESS_SECRET` / `JWT_REFRESH_SECRET` | Token imzalama anahtarları (rastgele, gizli tutulmalı) |
| `frontend/.env` | `NEXT_PUBLIC_API_BASE_URL` | Frontend'in istek attığı backend adresi |

## Kullanılabilir Komutlar

### Backend (`backend/` içinde)
```bash
npm run start:dev        # Geliştirme sunucusu (watch modu)
npx prisma studio         # Veritabanını görsel arayüzde inceleme
npx prisma migrate dev    # Yeni migration oluşturma/uygulama
npx prisma db seed        # Örnek verileri tekrar yükleme
```

### Frontend (`frontend/` içinde)
```bash
npm run dev                  # Geliştirme sunucusu (localhost:3001)
npm run build                # Production build
npm run generate:api-types   # Backend sözleşmesinden TypeScript tiplerini yeniden üretme
```

### QA / Testler (`qa-tests/playwright/` içinde)
```bash
npm install
npm run test:e2e             # Tüm Playwright testlerini çalıştırır
npx playwright test <dosya>  # Tek bir test dosyasını çalıştırır
```

## Test

Proje, 60'ın üzerinde otomatik Playwright testiyle korunuyor: yetkilendirme, sepet/stok, checkout, adres yönetimi, sipariş akışı, responsive/mobil davranış ve edge-case senaryoları dahil. Test raporları için:
- `QA-AUTH-TEST-REPORT.md` — Auth modülü güvenlik/edge-case testleri
- `CART-STOCK-QA-REPORT.md` — Sepet, stok ve uçtan uca akış testleri

Testleri çalıştırmadan önce hem backend hem frontend'in ayakta olduğundan emin ol.

## Mimari Notlar

- **Tip güvenliği:** Backend sözleşmesi (`backend/docs/openapi.yaml`), `openapi-typescript` ile otomatik olarak frontend TypeScript tiplerine dönüştürülür (`npm run generate:api-types`). Sözleşme her değiştiğinde bu komut tekrar çalıştırılmalı.
- **Kimlik doğrulama:** Admin ve B2C tarafı **ayrı cookie'ler** (`admin_access_token` / `access_token`) kullanır — biri diğerini "giriş yapılmış" gibi göstermez.
- **API istemcisi:** `openapi-fetch` tabanlı merkezi bir istemci (`src/lib/api-client.ts`), her isteğe otomatik `Authorization` header'ı ekler ve `401` cevaplarında oturumu otomatik temizleyip login'e yönlendirir.
- **Bildirimler:** Tüm API işlemlerinin başarı/hata durumları, `sonner` tabanlı merkezi bir toast sistemiyle (hook seviyesinde) kullanıcıya gösterilir.
- **Hata yönetimi:** `error.tsx` / `global-error.tsx` sayesinde uygulama hiçbir senaryoda beyaz ekrana düşmez.

## Bilinen Sınırlamalar

- **Şifre değiştirme:** Backend'de bu işlem için henüz bir uç (endpoint) bulunmuyor — arayüzde bilerek devre dışı bırakılmış bir form olarak duruyor.
- **Sepet kalemi stok kontrolü:** Sepetteki bir kalemin miktarını artırırken, güncel stok sınırı frontend'de değil backend'de kontrol edilir (hata durumunda toast ile bildirilir).


