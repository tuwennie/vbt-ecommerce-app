# E-Ticaret Projesi - PM Notları

## Gün 1 - 13.07.2026 / Başlangıç ve Planlama Stand-up'ı

**Katılımcılar:** Tuba (PM/Design), Kübra (Backend), İkram (Frontend/QA), Zeliha (Mobil)

*   **Tuba (PM/Design):** 
    *   *Bugün Yapılanlar:* GitHub reposu ve Projects board'u kuruldu.
        Birinci hafta görevleri (iş paketleri) Issue olarak açıldı ve kişilere atandı.
        Backend scope'u netleştirildi. Hem mobil uygulamanın hem de web admin panelinin tasarımı tamamlandı.
        Tasarım token'ları çıkarılarak İkram'a iletildi ve ekibin Figma Dev Mode üzerinden tüm token'ları doğrudan alabilmesi sağlandı.
    *   *Engel (Blocker):* Yok.
*   **Kübra (Backend):**
    *   *Bugün Yapılanlar:* Proje kapsamı belirlendi ve analiz onaylandı. OpenAPI (Swagger) sözleşmesi hazırlandı.
    *   *Engel (Blocker):* Yok.
*   **İkram (Frontend/QA):**
    *   *Bugün Yapılanlar:* Frontend proje kurulumu yapıldı (Next.js App Router + TypeScript + Tailwind CSS). Tasarım sistemi ve `openapi-typescript` altyapısı kurulup test edildi. Test & CI altyapısı (Postman koleksiyonu, Playwright E2E health-check, CI pipeline) kurularak PR'dan yeşil ışık alındı. Atanan issue'lar PR ile merge edilerek başarıyla kapatıldı (Closed).
    *   *Engel (Blocker):* Yok (Token'lar teslim alındı).
*   **Zeliha (Mobil):**
    *   *Bugün Yapılanlar:* Mobil mimari altyapısı ve klasör kurulumları araştırıldı.
    *   *Engel (Blocker):* Yok.

**PM Günlük Özeti:** Projenin ilk gününde tüm mimari altyapılar ve CI/CD pipeline'ı sorunsuz şekilde kuruldu. Tasarım token'larının teslim edilmesiyle Frontend'in bekleme durumu (blocker) ortadan kalktı ve ilk Issue'lar başarıyla ana branch'e merge edildi. Backend sözleşmesinin (OpenAPI) tamamlanması ve tasarımların hazır olmasıyla takım mükemmel bir senkron yakaladı. Çok verimli bir ilk gün oldu.
