# Teknik Borç ve Risk Envanteri Raporu

Bu envanter, projenin hızlı geliştirme ve sprint süreçlerinde arka planda bırakılmış olabilecek geçici kod yapılarını, olası iyileştirmeleri ve riskleri yönetmek amacıyla oluşturulmuştur.

## 1. Kod İçi Geçici Yapılar (TODO ve Hard-Coded Alanlar)
* **Durum:** Geliştirme süreci boyunca bırakılan `TODO` etiketleri ve DTO/Component bazlı yapılandırmalar incelendi.
* **Aksiyon:** Tespit edilen geçici string değerler ve form validasyon alanları projenin son sürümüne (production) geçmeden önce temizlendi veya optimize edildi.

## 2. Mimari ve Veritabanı Riskleri (N+1 ve Performans)
* **Prisma & Veritabanı:** İlişkisel sorgularda (`include` ve `relation` yapıları) N+1 sorgu problemi yaratabilecek alanlar optimize edildi. `seed` script'leri `upsert` mantığıyla güvenli hale getirildi.
* **API Güvenliği:** Auth modülünde token yönetimi `cookie + middleware` yapısıyla koruma altına alındığı için istemci tarafındaki güvenlik riskleri minimize edildi.

## 3. Önümüzdeki Sprint (Sprint 2) İyileştirme Önerileri (Backlog)
* **Kritik:** Sepet ve ödeme adımlarında hata (error boundary) durumlarının kullanıcıya daha şık toast bildirimleriyle gösterilmesi.
* **Orta:** Mobil ve Web arayüzlerinde olası ağ gecikmelerine (latency) karşı skeleton ekranların yaygınlaştırılması.
