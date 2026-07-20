# Teknik Borç ve Risk Envanteri Raporu (Technical Debt & Risk Inventory)

Bu envanter, projenin 2 haftalık hızlı geliştirme ve sprint süreçlerinde arka planda bırakılmış olabilecek geçici kod yapılarını, olası iyileştirmeleri ve teknik riskleri proaktif bir şekilde yönetmek amacıyla oluşturulmuştur.

---

## 1. Kod İçi Geçici Yapılar (TODO ve Hard-Coded Alanlar)
* **API Endpoints & URL Yapılandırması:** 
  * *Durum:* Geliştirme aşamasında lokal testler için kullanılan baz URL'ler (`localhost`) tespit edilmiştir.
  * *İyileştirme:* Proje canlı ortama (production) taşınırken bu değerlerin `environment variables` (.env) üzerinden dinamik olarak çekilmesi sağlanacaktır.
* **Mock Veri Kalıntıları:** 
  * *Durum:* İkram ve Zeliha'nın ilk aşamada UI geliştirmelerini hızlandırmak için kullandığı geçici mock veriler, Kübra'nın veritabanına ent ettiği **Golden Dataset (Seed)** sonrasında gerçek API endpoint'leriyle değiştirilmiştir. Kod tabanında kalan eski mock blokları temizlenmiştir.

## 2. Mimari ve Veritabanı Riskleri (N+1 ve Performans)
* **Prisma & Veritabanı Sorguları (Kübra - Backend):**
  * *Durum:* İlişkisel veri tabanı yapısında (`Categories`, `Products`, `Orders`, `Users`), Prisma `include` ve `relation` sorgularında olası N+1 performans darboğazları incelenmiştir.
  * *Çözüm:* Sorgular optimize edilmiş, `upsert` mantığıyla idiyotik seed script'leri yazılarak veri çakışmaları engellenmiştir.
* **Güvenlik ve Oturum Yönetimi (İkram & Zeliha - Frontend/Mobile):**
  * *Durum:* JWT tabanlı kimlik doğrulama süreçlerinde token saklama güvenliği ön planda tutulmuştur.
  * *Çözüm:* Web tarafında `localStorage` yerine XSS saldırılarına karşı güvenli olan **`cookie + Next.js middleware`** yapısı tercih edilmiş, mobil tarafta ise state izolasyonu `AsyncNotifierProvider` ile güven altına alınmıştır.

## 3. Önümüzdeki Sprint (Sprint 2 / Teslim Sonrası) İyileştirme Önerileri (Backlog)
* **Kritik Seviye:** 
  * Sepet ve ödeme (Checkout) adımlarında olası ağ kopmalarına karşı Global Error Boundary ve kullanıcıya anlık geri bildirim sağlayacak Toast Notification sisteminin yaygınlaştırılması.
* **Orta Seviye:** 
  * Mobil ve web arayüzlerinde veri yüklenme sürelerini optimize etmek adına skeleton ekran geçişlerinin artırılması.
* **Düşük Seviye:** 
  * Playwright E2E test senaryolarının kapsamının ek edge-case'lerle (uç durum senaryolarıyla) genişletilmesi.
