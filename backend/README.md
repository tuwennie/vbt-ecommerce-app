# VBT E-Ticaret — Backend

Staj 2026 kapsamında geliştirilen e-ticaret projesinin backend API'si. [NestJS](https://nestjs.com/) ve [Prisma ORM](https://www.prisma.io/) ile geliştirilmiştir, PostgreSQL veritabanı kullanır.

Sözleşme-öncelikli (contract-first) yaklaşımla geliştirilmiştir — tüm endpoint'ler `docs/openapi.yaml` sözleşmesine birebir uyumludur.

---

## Proje Yapısı

```text
backend/
├── docs/
│   └── openapi.yaml           # API sözleşmesi
├── prisma/
│   ├── migrations/            # Migration geçmişi
│   ├── schema.prisma          # Veritabanı şeması
│   ├── seed.ts                # Seed script'i
│   └── seed-data/             # Referans veri (JSON)
├── src/
│   ├── addresses/             # Teslimat adresleri
│   ├── auth/                  # Kimlik doğrulama, JWT, guard'lar
│   ├── cart/                  # Sepet
│   ├── categories/            # Kategori (herkese açık + admin)
│   ├── common/
│   │   ├── filters/           # Global hata yakalama
│   │   └── interceptors/      # Global response zarfı
│   ├── favorites/             # Favoriler
│   ├── orders/                # Sipariş / checkout
│   ├── products/              # Ürün (herkese açık + admin)
│   ├── users/                 # Profil, şifre/email değiştirme
│   ├── app.module.ts
│   └── main.ts
├── .env
├── .env.example
├── docker-compose.yml         # PostgreSQL konteyneri
└── package.json
```
---

## Teknoloji Yığını

| Katman | Teknoloji |
| :--- | :--- |
| **Framework** | NestJS (Node.js / TypeScript) |
| **Veritabanı** | PostgreSQL 16 (Docker) |
| **ORM** | Prisma 6.19.3 |
| **Kimlik Doğrulama** | JWT (access + refresh token) |
| **Şifre Hash'leme** | bcryptjs |
| **Validasyon** | class-validator / class-transformer |
| **Rate Limiting** | @nestjs/throttler |
| **Konteynerleştirme** | Docker Compose |

---

## Özellikler

### Kimlik Doğrulama (Auth)
- Kayıt, giriş, token yenileme, çıkış
- Access token (15 dk) + refresh token (7 gün), refresh token rotation
- `X-Client-Type` header'ına göre davranış: `WEB` istemcilerde refresh token `httpOnly` cookie'de saklanır (XSS koruması), `MOBILE` istemcilerde JSON gövdesinde döner.
- Register/login/refresh endpoint'lerinde rate limiting (dakikada 5 istek)
- Şifre ve email değiştirme (mevcut şifre doğrulaması ile); şifre değişince tüm oturumlar geçersiz kılınır.

### Kullanıcı ve Adres Yönetimi
- Profil görüntüleme/güncelleme
- Teslimat adresleri: listeleme, ekleme, güncelleme, silme (sahiplik kontrolü ile)

### Ürün ve Kategori Kataloğu
- Sayfalama, arama, çoklu kategori filtresi, fiyat aralığı, sıralama ile ürün listeleme
- Kategori bazlı ürün gruplandırma, otomatik slug üretimi
- Admin: ürün/kategori oluşturma, güncelleme, aktif/pasif yapma (kalıcı silme yok)

### Sepet ve Sipariş
- Sepet fiyatları her zaman güncel ürün fiyatından canlı hesaplanır.
- Stok ve ürün aktiflik kontrolleri (ekleme/güncelleme anında ve checkout anında)
- Checkout adres sahiplik kontrolü, stok yeniden kontrolü, `Idempotency-Key` header ile tekrar isteklerin önlenmesi
- Sipariş oluşturma tek bir veritabanı transaction'ı içinde yapılır (sipariş kaydı + stok azaltma + sepet temizleme atomik olarak birlikte gerçekleşir).
- Ürün ad/fiyat ve teslimat adresi, sipariş anında donmuş (snapshot) olarak saklanır — sonradan ürün/adres değişse bile geçmiş sipariş etkilenmez.
- **Idempotency:** Checkout endpoint'i zorunlu `Idempotency-Key` header'ı bekler, aynı anahtarla gelen tekrar istekler yeni sipariş oluşturmaz, ilk sonucu döner.
- **Transaction Bütünlüğü:** Sipariş oluşturma, stok azaltma ve sepet temizleme işlemleri Prisma `$transaction` ile atomik olarak yürütülür.

### Favoriler
- Ürün favoriye ekleme/çıkarma, favori listesi

---

## Kurulum

### Gereksinimler
- [Node.js](https://nodejs.org/) 18+
- [Docker Desktop](https://www.docker.com/)

### Adımlar

1. Depoyu klonla:
```bash
git clone [https://github.com/tuwennie/vbt-ecommerce-app.git](https://github.com/tuwennie/vbt-ecommerce-app.git)

Proje dizinine geç ve bağımlılıkları kur:
cd vbt-ecommerce-app/backend
npm install

.env dosyasını oluştur (aşağıdaki ortama göre düzenle):
cp .env.example .env

PostgreSQL'i Docker ile ayağa kaldır:
docker compose up -d

Veritabanı şemasını uygula:
npx prisma migrate dev

Örnek verileri yükle:
npx prisma db seed
```
---

## Ortam Değişkenleri
```.env.example``` dosyasını referans alarak kendi ```.env``` dosyanı oluştur:
```
DATABASE_URL="postgresql://vbt_user:vbt_password@localhost:5432/vbt_ecommerce?schema=public"
JWT_ACCESS_SECRET=
JWT_REFRESH_SECRET=
JWT_ACCESS_EXPIRES_IN=900
JWT_REFRESH_EXPIRES_IN=604800
```
```JWT_ACCESS_SECRET``` / ```JWT_REFRESH_SECRET``` — boş bırakılmalı, her geliştirici kendi anahtarını üretmeli:
```
node -e "console.log(require('crypto').randomBy tes(32).toString('hex'))"
```
```JWT_ACCESS_EXPIRES_IN``` / ```JWT_REFRESH_EXPIRES_IN``` — saniye cinsinden token ömrü, genel bilgi olduğu için değeriyle bırakılabilir.
```.env``` dosyası asla Git'e eklenmemelidir (```.gitignore```'da zaten hariç tutulmuştur).

---

## Çalıştırma
```npm run start:dev```
Sunucu varsayılan olarak ```http://localhost:3000/api/v1``` adresinde çalışır.

Yararlı Docker / Prisma komutları:
```
docker compose ps       # PostgreSQL container durumunu kontrol et
npx prisma studio       # Veritabanını görsel arayüzde incele
```

---

## Veritabanı and Seed Verisi
Seed script'i ```(prisma/seed.ts)```, ```prisma/seed-data/``` klasöründeki JSON dosyalarından (kategoriler, ürünler, kullanıcılar) referans veri oluşturur. Script idempotent'tir — kaç kere çalıştırılırsa çalıştırılsın güvenlidir, tekrar tekrar çalıştırıldığında çift kayıt oluşturmaz, mevcut kayıtları günceller.
```
npx prisma db seed
```
Şema değişikliği (migration) sonrası, her geliştirici kendi ortamında şu sırayı izlemelidir:
```
git pull origin main
npx prisma migrate dev
npx prisma generate
npx prisma db seed
```

---

## Test Kullanıcıları

Seed verisiyle birlikte gelen test hesapları (tüm hesaplar aynı şifreyi kullanır):

| Email | Rol | Şifre |
| :--- | :--- | :--- |
| `admin@vbt.com` | ADMIN | `password123!` |
| `test1@vbt.com` | USER | `password123!` |
| `ahmet@example.com` | USER | `password123!` |

---

---

## API Sözleşmesi

Tüm endpoint'ler, `docs/openapi.yaml` dosyasındaki OpenAPI 3.1 sözleşmesine birebir uyumludur. Sözleşmeyi görsel olarak incelemek için içeriğini [Swagger Editor](https://editor.swagger.io/)'a yapıştırabilirsin.

**Genel kurallar:**
- Tüm başarılı yanıtlar `{ success: true, data: ... }` zarfı ile döner.
- Tüm hata yanıtları `{ success: false, message, statusCode, status, errors? }` şeklinde tek bir formatta döner.
- Sayfalı liste endpoint'leri `?page=&size=` parametrelerini destekler.
- Tarih/saat alanları her zaman UTC (`Z` sonekli) formatındadır.
- Parasal alanlar TRY cinsinden, en fazla 2 ondalık basamaklıdır.

---

## Mimari Kararlar

- **Guard Zinciri:** Korumalı endpoint'ler `JwtAuthGuard` (kimlik doğrulama) ve gerektiğinde `RolesGuard` (`@Roles('ADMIN')`) ile korunur.
- **Sahiplik Kontrolü:** Kullanıcıya özel kaynaklarda (adres, sipariş, sepet) her istek, kaynağın gerçekten istek sahibine ait olduğunu doğrular.
- **Fiyat Güvenliği:** Sepet/sipariş fiyatları hiçbir zaman istemciden alınmaz, her zaman backend'de güncel `Product.price` üzerinden hesaplanır.
- **Snapshot Mantığı:** Sipariş oluşturulduğunda ürün adı/fiyatı ve adres bilgisi doğrudan `Order` / `OrderItem` tablolarına kopyalanır, ürün veya adres sonradan değişse bile geçmiş sipariş etkilenmez.

---

## Bilinen Sınırlamalar

Proje kapsamı belgesinde v1 için bilinçli olarak dışarıda bırakılan özellikler:
- Misafir sepeti (sepet için giriş zorunludur)
- Ürün varyantları (beden/renk/kapasite)
- Kupon sistemi, kargo ücreti
- Gerçek ödeme entegrasyonu (yalnızca simülasyon)
- Sipariş iptali
- Ürün yorum/puanlama
- E-posta doğrulama, "şifremi unuttum" (email tabanlı sıfırlama)
