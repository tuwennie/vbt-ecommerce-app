# E-Ticaret Projesi - PM Notları
**Katılımcılar:** Tuba (PM/Design), Kübra (Backend), İkram (Frontend/QA), Zeliha (Mobil)

## Gün 1 - 13.07.2026 / Başlangıç ve Planlama Stand-up'ı

*   **Tuba (PM/Design):** 
    *   *Bugün Yapılanlar:* GitHub reposu ve Projects board'u kuruldu.
        Birinci hafta görevleri (iş paketleri) Issue olarak açıldı ve kişilere atandı.
        Backend scope'u netleştirildi. Hem mobil uygulamanın hem de web admin panelinin tasarımı tamamlandı.
        Tasarım token'ları çıkarılarak İkram'a iletildi ve ekibin Figma Dev Mode üzerinden tüm token'ları doğrudan alabilmesi sağlandı.
    *   *Engel (Blocker):* Yok.
*   **Kübra (Backend):**
    *   *Bugün Yapılanlar:*   * Proje kapsamı belirlendi ve analiz onaylandı. OpenAPI (Swagger) sözleşmesi hazırlandı.
    *   *Engel (Blocker):* Yok.
*   **İkram (Frontend/QA):**
    *   *Bugün Yapılanlar:* Frontend proje kurulumu yapıldı (Next.js App Router + TypeScript + Tailwind CSS). Tasarım sistemi ve `openapi-typescript` altyapısı kurulup test edildi. Test & CI altyapısı (Postman koleksiyonu, Playwright E2E health-check, CI pipeline) kurularak PR'dan yeşil ışık alındı. Atanan issue'lar PR ile merge edilerek başarıyla kapatıldı (Closed).
    *   *Engel (Blocker):* Yok (Token'lar teslim alındı).
*   **Zeliha (Mobil):**
    *   *Bugün Yapılanlar:* Mobil mimari altyapısı ve klasör kurulumları araştırıldı.
    *   *Engel (Blocker):* Yok.

**PM Günlük Özeti:** Projenin ilk gününde tüm mimari altyapılar ve CI/CD pipeline'ı sorunsuz şekilde kuruldu. Tasarım token'larının teslim edilmesiyle Frontend'in bekleme durumu (blocker) ortadan kalktı ve ilk Issue'lar başarıyla ana branch'e merge edildi. Backend sözleşmesinin (OpenAPI) tamamlanması ve tasarımların hazır olmasıyla takım mükemmel bir senkron yakaladı. Çok verimli bir ilk gün oldu.

## Gün 2 - 14 Temmuz 2026

*   **Tuba (PM/Design)**
    *   *Bugün Yapılanlar:* Web kullanıcı (B2C) paneli tasarımları Figma üzerinde tamamlandı. Kübra ile API sözleşmesindeki kritik eksiklikler giderilerek son halinin yayınlanması (PR #19) süreci yönetildi. Projenin genel gidişatı takip edildi ve İkram için QA Task 2 planlanarak ataması yapıldı.
    *   *Engel:* Yok.

*   **Kübra (Backend)**
    *   *Bugün Yapılanlar:* OpenAPI 3.1 sözleşmesinin son hali hazırlandı, gözden geçirildi ve GitHub'da paylaşıldı (PR #19 onaylandı). Backend altyapısı için gerekli olan PostgreSQL kurulumu Docker üzerinden başarıyla tamamlandı.
    *   *Engel:* Yok.

*   **İkram (Frontend/QA)**
    *   *Bugün Yapılanlar:* Admin paneli giriş (Login) ekranı responsive olarak kodlandı, Dashboard iskeleti ve Nav-Bar tasarımı tamamlandı. Login ve Admin Dashboard sayfaları için Playwright testleri yazıldı. Postman koleksiyonu, güncel API sözleşmesine göre güncellendi.
    *   *Engel:* Yok.

*   **Zeliha (Mobil)**
    *   *Bugün Yapılanlar:* Kişisel işleri nedeniyle bugün geliştirme faaliyetlerine katılamadı ancak daha önceki günlerdeki tasklarının takibi ve bir sonraki aşamaya hazırlık süreci devam etmektedir.
    *   *Engel:* Yok.

**PM Günlük Özeti:** Bugün, projenin teknik temelini oluşturan API sözleşmesini (OpenAPI) başarıyla yayına alarak çok kritik bir aşamayı geçtik. Backend tarafında veri tabanı kurulumu tamamlanırken, frontend tarafında hem Admin panelinin iskeleti kuruldu hem de test altyapısı (Playwright & Postman) güncellendi. Ekip, belirlenen takvime uygun şekilde ilerliyor; teknik engeller temizlendi ve geliştirme süreçleri standartlara oturtuldu. Yarın odak noktamız, B2C tarafındaki kullanıcı ekranlarının (FE-2) tamamlanması ve backend tarafında veri tabanı modellemesinin (Prisma) başlatılması olacaktır.

## Gün 3 - 16 Temmuz 2026

*   **Tuba (PM/Design)**
    *   *Bugün Yapılanlar:* Backend şemasına tam uyumlu "Golden Dataset" hazırlandı; veriler categories, products ve users olarak üç ayrı modüler JSON dosyasına ayrıldı. Seed işlemleri için Kübra ile koordineli şekilde süreç başlatıldı. API sözleşme denetimi ve dokümantasyon takibi sürece yayılmış bir görev olarak aktif tutuluyor. Ekibin iş akışını hızlandırmak adına teknik ve yönetimsel tasklar (MOB-3,4,5 ve BE-6 gibi) oluşturularak ekip üyelerine atandı.
    *   *Engel:* Yok.

*   **Kübra (Backend)**
    *   *Bugün Yapılanlar:* NestJS mimarisi ve Docker-PostgreSQL altyapısı ayağa kaldırıldı. Prisma ORM entegrasyonu tamamlandı. openapi.yaml dokümantasyonuyla tam uyumlu 11 veritabanı modeli oluşturularak migration süreçleri uygulandı.
    *   *Engel:* Yok.

*   **İkram (Frontend/QA)**
    *   *Bugün Yapılanlar:* Login, Register ve Ana Sayfa (Hero Banner + Ürünler) arayüzleri responsive olarak kodlandı. Arama/Filtreleme mekanizması (kategori, sıralama, sayfalama) TanStack Query ile mock veri üzerinden entegre edildi. Ürün listeleme, query parametreleri, responsive yükleme durumları ve hata yönetimi senaryoları doğrulandı.
    *   *Engel:* Yok.

*   **Zeliha (Mobil)**
    *   *Bugün Yapılanlar:* Proje mimarisi "Feature-First" standardıyla (presentation, domain, data) kuruldu. AppColors token'ları tanımlandı. CustomButton, CustomTextField ve ProductCard komponentleri geliştirildi. Main UI kataloğu üzerinden interaktif render testleri sorunsuz şekilde doğrulandı.
    *   *Engel:* Yok.

**PM Günlük Özeti:** Projemizin tüm katmanlarında (Mobil, Frontend, Backend) altyapı kurulumları ve temel entegrasyonlar başarıyla tamamlandı. Gerçek veri entegrasyonuna geçiş için gereken veri seti hazırlıkları ve ekip görev dağılımları tamamlandı.
