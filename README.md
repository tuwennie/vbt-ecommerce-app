# SHOPSWIFT

Modern, ölçeklenebilir ve tam yığın (full-stack) mimariyle geliştirilmiş kapsamlı bir E-Ticaret platformu ve mobil/web yönetim sistemi.

[![VBT E-Commerce App Demo Videosu](https://img.shields.io/badge/YouTube-Demo%20Videosunu%20İzle-red?style=for-the-badge&logo=youtube)](https://www.youtube.com/watch?v=2vR1B23MF7w&t=2s)

## Proje Hakkında
Bu proje; kullanıcıların ürünleri kategorize edip sepetine ekleyebildiği, çok adımlı (multi-step) akışlarla sipariş verebildiği ve admin panelinden yönetim sağlayabildiği uçtan uca bir e-ticaret çözümüdür. Web, Mobil ve Backend katmanları modern teknolojilerle micro-service / modular yapıda tasarlanmıştır.

## Kullanılan Teknolojiler ve Mimari Gerekçeler

Projede kullanılan her teknoloji, endüstri standartlarına uygunluğu, sürdürülebilirliği ve modülerliği göz önünde bulundurularak bilinçli bir şekilde seçilmiştir:

### 1. Backend (NestJS, Prisma, PostgreSQL)
* **NestJS:** Authentication, authorization, validation, testing ve Swagger/OpenAPI dokümantasyonu için hazır, modüler ve kurumsal mimari standartlarını doğrudan desteklediği için tercih edilmiştir.
* **PostgreSQL & Prisma ORM:** İlişkisel veri bütünlüğünü güçlü bir şekilde koruması, karmaşık sorgularda yüksek performans sunması ve güvenilir `transaction` desteği nedeniyle seçilmiştir.

### 2. Frontend (Next.js, Tailwind CSS, openapi-fetch)
* **Next.js (App Router):** Server-side rendering (SSR) kabiliyetleri, SEO uyumluluğu, güçlü routing sistemi ve kurumsal web uygulamaları için en güncel endüstri standardı olması sebebiyle seçilmiştir.
* **openapi-fetch:** Backend tarafından sağlanan OpenAPI sözleşmesiyle yüzde yüz tip güvenliği (type-safety) sağlayarak ağ katmanındaki olası tip uyuşmazlıklarını derleme zamanında engellediği için tercih edilmiştir.
* **Tailwind CSS:** Hızlı, ölçeklenebilir ve tasarım token'larına dayalı tutarlı bir UI sistemi kurmaya izin verdiği için seçilmiştir.

### 3. Mobil (Flutter & Dart)
* **Flutter:** Tek kod tabanından hem iOS hem de Android platformlarına native performansla çıktı verebilmesi ve 2026 mobil standartlarına (Clean Architecture, tipli ağ katmanı) doğrudan uyumlu olduğu için seçilmiştir.
* **Riverpod (AsyncNotifierProvider):** State yönetimini ve dependency injection'ı son derece temiz, öngörülebilir ve tamamen test edilebilir kıldığı için tercih edilmiştir.
* **Freezed & json_serializable:** Backend'in OpenAPI sözleşmesindeki veri tiplerini mobil tarafta birebir modelleyip derleme zamanında tip hatası yakalamamızı sağladığı için seçilmiştir.
* **Dio:** Güçlü `interceptor` desteği sayesinde `X-Client-Type` header'ı, otomatik Bearer token ekleme ve merkezi 401 (Unauthorized) yönetimini kusursuz şekilde yönettiği için seçilmiştir.

### 4. Test & Kalite Güvencesi (QA)
* **Playwright:** Web uygulamasının uçtan uca (E2E) kullanıcı senaryolarını (giriş, sepet, ödeme adımları) farklı tarayıcılarda hızlı, kararlı ve otomatik olarak simüle edebildiği için tercih edilmiştir.
* **Postman:** Backend endpoint'lerinin sözleşme uyumluluğunu, güvenlik guard'larını (400, 401, 403, 404) ve veri akışlarını izole bir şekilde test etmek için standart bir QA aracı olarak seçilmiştir.

## Kurulum ve Çalıştırma
Projeyi kendi bilgisayarınızda çalıştırmak için aşağıdaki adımları izleyin:

1. Bu repoyu klonlayın: `git clone https://github.com/tuwennie/vbt-ecommerce-app.git`
2. Proje dizinine gidin: `cd vbt-ecommerce-app`
3. Gerekli paketleri ilgili klasörlerde (backend/frontend) yükleyin: `npm install` (Mobil taraf için `flutter pub get`)
4. Veritabanı ve çevre değişkenleri (`.env`) ayarlarını `docker.yml` yapılandırmasına uygun şekilde `.env` dosyasına tanımlayın.
5. Veritabanı tablolarını senkronize edin ve demo verilerini yükleyin:
   ```bash
   npx prisma db push
   npx prisma db seed
   ```
6. Projeyi başlatın:
   Backend için: ```npm run start:dev```

   Frontend için: ```npm run dev```

   Flutter için: ```flutter run```

## Ekran Görüntüleri

### Mobil Uygulama

* **Login ve Register Kısmı:** <p align="center">
  <img src="https://github.com/user-attachments/assets/b6b42f72-da86-4a7c-9abd-59e8f7d8a767" width="250" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/9351b56d-f9ef-40df-bc13-c7ac7235289c" width="250" />
</p>


* **Ana Sayfa Kısmı:** <p align="center">
  <img src="https://github.com/user-attachments/assets/68e33fc1-4e97-4716-87cf-f43239e3c300" width="250![Uploading WhatsApp Image 2026-07-30 at 12.25.39 PM (1).jpeg…]()
" />
</p>


* **Profil ve Kategoriler Kısmı:** <p align="center">
  <img src="https://github.com/user-attachments/assets/e1b2e4da-02d2-41fa-a02a-45681bf326d5" width="250" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/28276fc5-d8f4-4f63-aba0-baf37074e429" width="250" />
</p>

* **Sepet Kısmı** <p align="center">
  <img src="https://github.com/user-attachments/assets/95c3049a-9cd6-45f9-a551-2e42e8a3ec7a" width="250" />
</p>

* **Favoriler ve Siparişlerim Kısmı:**  <p align="center">
  <img src="https://github.com/user-attachments/assets/4b82ea53-f502-4df8-a659-b6bf5fc72a26" width="250" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/ae655651-9c68-4e0a-b45b-330a4e91104f" width="250" />
</p>

### Web Paneli
* **Login ve Register Kısmı:** <p align="center">
  <img src="https://github.com/user-attachments/assets/835380ca-6f48-4c74-9d87-d425adca4319" width="800" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/872c4b86-edf8-4525-8f79-936ec393f821" width="800" />
</p>

* **Ana Sayfa Kısmı:** <p align="center">
  <img src="https://github.com/user-attachments/assets/1d6505ef-06d3-4277-8939-a75367940f64"  width="800" />
</p>

* **Profil ve Kategoriler Kısmı:** <p align="center">
  <img src="https://github.com/user-attachments/assets/6ef10829-3f18-40f1-b122-5ab3c7e6b4fe" width="800" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/d32f8ca0-c420-42ab-861d-b9de217d3cfe" width="800" />
</p>
