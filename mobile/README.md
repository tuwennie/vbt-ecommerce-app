# Mobil (Flutter) — VBT E-Ticaret

**Sorumlu:** Zeliha
**Stack:** Flutter + Riverpod + Dio + freezed/json_serializable + go_router

## Neden bu teknolojiler?
Flutter tek kod tabanından iOS + Android çıktısı verdiği ve staj kapsamındaki
2026 standardı (Clean Architecture, tipli ağ katmanı) ile doğrudan uyumlu
olduğu için seçildi. Riverpod, state ve dependency injection'ı test edilebilir
şekilde ayırır; freezed/json_serializable Backend'in OpenAPI sözleşmesindeki
tipleri bire bir modelleyip derleme zamanında hata yakalamamızı sağlar; Dio,
interceptor desteğiyle `X-Client-Type` header'ı ve JWT ekleme işini merkezi
şekilde yönetmemize izin verir.

## Klasör Mimarisi
```
lib/
├── core/        # theme (design token'ları), network (Dio), error, router
├── data/        # API modelleri (freezed) + repository implementasyonları
├── domain/      # Entity'ler + repository interface'leri (saf Dart)
└── presentation/# screens + ortak widget'lar (AppButton, AppInput, ProductCard)
```

## İlk Kurulum (bu klasör platform dosyalarını içermez)
Bu commit yalnızca `lib/` ve `pubspec.yaml`'ı içerir; `android/`, `ios/` gibi
platform klasörleri henüz üretilmedi. İlk klonlayan kişi şunu çalıştırmalı:

```bash
cd mobile
flutter create --org com.tuwennie.vbt_ecommerce --project-name vbt_ecommerce_mobile .
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1
```

> `flutter create .` mevcut `lib/` ve `pubspec.yaml` dosyalarının üzerine
> yazmaz, yalnızca eksik platform klasörlerini (android/ios) ekler.

## Design Token Kaynağı
Renk/spacing/radius/tipografi değerleri Tuba'nın Figma Dev Mode çıktısından
(`frontend/tokens/design-tokens.json`) birebir `lib/core/theme/` altına
aktarıldı. Token değişirse yalnızca bu klasördeki dosyalar güncellenir.

## API Sözleşmesi Kaynağı
`backend/docs/openapi.yaml` (v1.1.0). Önemli noktalar:
- Auth uçlarında `X-Client-Type: MOBILE` header'ı zorunlu (refreshToken JSON'da döner).
- Başarılı yanıt zarfı: `{ success: true, data: ... }`
- Hata zarfı: `{ success: false, message, statusCode, status }`

## DoD Durumu (bu görev)
- [x] Klasör mimarisi (core/data/domain/presentation) kuruldu
- [x] `ProductModel` için freezed + json_serializable tanımlandı
- [x] `AppButton`, `AppInput`, `ProductCard` Tuba'nın token'larına göre kurgulandı
- [x] `/gallery` route'u (yalnızca debug) üç komponenti bağımsız render ediyor
- [ ] `flutter create .` + `build_runner` yerelde çalıştırılıp doğrulanacak (bu adımı Flutter kurulu bir makinede yapman gerekiyor)

## Sıradaki Adımlar
- Auth akışı (`data/repositories/auth_repository_impl.dart`)
- Ürün listesi ekranı ve `ProductRepository` implementasyonu
- Dark tema (Tuba'nın token'ları netleşince)
