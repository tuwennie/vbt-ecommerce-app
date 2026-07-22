# VBT E-Commerce App

Modern, ölçeklenebilir ve tam yığın (full-stack) mimariyle geliştirilmiş kapsamlı bir E-Ticaret platformu ve mobil/web yönetim sistemi.

## Proje Hakkında
Bu proje; kullanıcıların güvenli kimlik doğrulama ile kayıt olabildiği, ürünleri kategorize edip sepetine ekleyebildiği, çok adımlı (multi-step) akışlarla sipariş verebildiği ve admin panelinden yönetim sağlayabildiği uçtan uca bir e-ticaret çözümüdür. Web, Mobil ve Backend katmanları modern teknolojilerle micro-service / modular yapıda tasarlanmıştır.

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
5. Projeyi başlatın: 
   * Backend için: `npm run start:dev`
   * Frontend için: `npm run dev`

## Ekran Görüntüleri

* **Ana Sayfa Ekranı:** `[görsel_yolu]`
* **Checkout / Sepet Ekranı:** `[görsel_yolu]`
