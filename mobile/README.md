# VBT E-Ticaret — Mobil Uygulaması (Flutter)

Flutter (Dart 3.4+, Material 3) + Riverpod + Dio ile geliştirilmiş, NestJS REST API entegrasyonuna sahip yüksek performanslı, tip güvenli ve modern mobil e-ticaret uygulaması (iOS & Android).

## Proje Yapısı

```
mobile/
├── assets/                  # Mock JSON verileri ve görsel varlıklar
├── lib/
│   ├── core/                # Uygulama geneli kullanılan altyapı
│   │   ├── components/      # Ortak UI bileşenleri ve kartlar
│   │   ├── navigation/      # GoRouter deklaratif rotalandırma
│   │   ├── network/         # DioClient, Interceptors ve ApiEndpoints
│   │   ├── storage/         # SecureStorage & SharedPreferences token yönetimi
│   │   ├── theme/           # Renk paleti, tipografi ve tema token'ları
│   │   └── widgets/         # Genel widget'lar ve dialog'lar
│   └── features/            # Feature-First modüler mimari
│       ├── auth/            # Giriş, Kayıt ve Oturum yönetimi
│       ├── cart/            # Sepet işlemleri ve miktar kontrolü
│       ├── categories/      # Kategori listeleme ve filtreleme
│       ├── checkout/        # Çok adımlı ödeme akışı
│       ├── orders/          # Sipariş geçmişi ve detayları
│       ├── products/        # Ürün listeleme, detay ve arama
│       └── profile/         # Kullanıcı profili ve favoriler
└── test/                    # Unit ve Widget testleri
```

## Gereksinimler

- **Flutter SDK:** `^3.22.0` (Dart SDK `>=3.4.0 <4.0.0`)
- **Android Studio / VS Code** (Flutter ve Dart eklentileri kurulu)
- **Xcode** (iOS geliştirmesi / simülatör için — yalnızca macOS kullanıcıları)
- **Android Emulator / iOS Simulator** veya fiziki mobil cihaz
- Backend servisinin çalışır durumda olması (`http://localhost:3000/api/v1`)

## Kurulum — Adım Adım

### 1) Bağımlılıkları Yükle
`mobile` dizininde:
```bash
cd mobile
flutter pub get
```

### 2) Model & Kod Üretimi (Freezed / JsonSerializable)
Backend DTO'ları ve veri modelleri için derleme zamanında tip güvenli modeller üretin:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
> **İpucu:** Geliştirme yaparken modellerin otomatik güncellenmesi için `watch` komutunu kullanabilirsiniz:
> ```bash
> flutter pub run build_runner watch --delete-conflicting-outputs
> ```

### 3) Uygulamayı Başlat

**Varsayılan Ayarlarla Çalıştırma:**
```bash
flutter run
```

**Özel API Adresi ile Çalıştırma (`--dart-define`):**
Fiziki Android cihazlar veya farklı ağ adreslerinde backend'e bağlanmak için `API_BASE_URL` parametresi tanımlayabilirsiniz:
```bash
# Android Emülatör / Fiziki Cihaz İçin (Yerel IP Örneği):
flutter run --dart-define=API_BASE_URL=http://192.168.1.104:3000/api/v1

# iOS Simülatör / Web İçin:
flutter run --dart-define=API_BASE_URL=http://localhost:3000/api/v1
```

## Ortam Değişkenleri ve Ağ Ayarları

Mobil uygulama, dinamik API adresi yapılandırmasını destekler (`lib/core/network/api_endpoints.dart`):

| Değişken / Parametre | Açıklama | Varsayılan Değer |
|---|---|---|
| `--dart-define=API_BASE_URL` | Mobil uygulamanın istek attığı NestJS backend API adresi | Android: `http://192.168.1.104:3000/api/v1`<br>iOS / Web: `http://localhost:3000/api/v1` |

## Kullanılabilir Komutlar

```bash
flutter pub get                                                   # Bağımlılıkları indirir
flutter pub run build_runner build --delete-conflicting-outputs    # Model kodlarını üretir
flutter pub run build_runner watch --delete-conflicting-outputs    # Kod üretimini canlı izler
flutter analyze                                                   # Linter ve statik analizi çalıştırır
flutter test                                                      # Testleri çalıştırır
flutter build apk --release                                       # Android Release APK derler
flutter build appbundle --release                                 # Google Play App Bundle (.aab) üretir
flutter build ios --release                                       # iOS derlemesi hazırlar
```

## Mimari Notlar

- **Feature-First & Clean Architecture:** Kod tabanı modüler bir yapıda tasarlanmıştır. Her özellik (`auth`, `products`, `cart`, `checkout`, `orders`, `profile`) kendi bağımsız veri, sağlayıcı ve ekran katmanlarını içerir.
- **Tip Güvenliği & Immutability:** Backend DTO'ları `freezed` ve `json_serializable` ile modellenmiştir. Değişmez (immutable) veri nesneleri ve `copyWith` yetenekleri sayesinde runtime tip hataları engellenmiştir.
- **Otomatik Token Yönetimi & Interceptor:** `DioClient` HTTP istemcisi:
  - Tüm isteklere otomatik `Authorization: Bearer <access_token>` ve `X-Client-Type: MOBILE` başlığı ekler.
  - `401 Unauthorized` yanıtı alındığında arka planda sessizce `Refresh Token` kullanarak yeni token alır ve başarısız isteği otomatik olarak tekrarlar (`retry`).
- **Güvenli Depolama (Secure Storage):** Hassas kimlik doğrulama verileri `flutter_secure_storage` ve `shared_preferences` fallback desteği ile şifreli kaydedilir.
- **Merkezi Yönlendirme:** Rotalandırma `go_router` ile deklaratif olarak yönetilir ve yetkisiz erişimler otomatik olarak giriş ekranına yönlendirilir.
- **Merkezi Hata Yönetimi:** Ağ hataları ve backend yanıtları `CustomApiException` sınıfı aracılığıyla yakalanır, Türkçe ve kullanıcı dostu hata mesajlarına dönüştürülerek UI katmanına iletilir.

## Bilinen Sınırlamalar

- **Android Localhost Bağlantısı:** Android emülatörlerde `localhost` adresi emülatörün kendisini temsil eder. Bu nedenle bilgisayarınızın ağ üzerindeki yerel IP adresini (`--dart-define=API_BASE_URL=...`) kullanmanız gerekir.
