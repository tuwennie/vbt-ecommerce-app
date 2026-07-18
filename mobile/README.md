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
