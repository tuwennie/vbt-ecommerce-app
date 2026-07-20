# Proje Otomasyon Araçları ve AI Skills Raporu

Bu doküman, proje geliştirme sürecinde tekrarlayan iş akışlarını otomatikleştirerek zaman kazanmak ve standart kurumsal çıktılar üretmek amacıyla geliştirilen özel AI yeteneklerini (`Skills / Commands`) listeler.

---

## 1. Stand-up Raporu Üretici (`/stand-up`)

* **Amacımız:** Proje ekibinin (Tuba, Kübra, İkram, Zeliha) günlük olarak yaptığı işleri, karşılaştığı blokörleri ve PM günlük özetini tek bir komutla standart formata getirmek.
* **Neden İhtiyaç Duyduk?** Her gün farklı kişilerden gelen dağınık ilerleme notlarını aynı kurumsal şablonda toplamak ve raporlama yükünü azaltmak için.
* **Nasıl Çağrılır?** 
  `/stand-up [Tuba'nın notları] [Kübra'nın notları] [İkram'ın notları] [Zeliha'nın notları]`
* **Konumu:** Proje deposunda `.claude/skills/stand-up/SKILL.md` altında tanımlanmıştır.

### Örnek Çıktı:
```markdown
### Gün X - 20.07.2026
* **Tuba (PM/Design):**
  * *Bugün Yapılanlar:* Görev takipleri ve entegrasyon koordinasyonu yönetildi.
  * *Engel (Blocker):* Yok.
* **Kübra (Backend):**
  * *Bugün Yapılanlar:* BE-4 ve BE-5 servisleri güncellendi.
  * *Engel (Blocker):* Yok.
* **İkram (Frontend/QA):**
  * *Bugün Yapılanlar:* FE-9 ve Playwright testleri koşturuldu.
  * *Engel (Blocker):* Yok.
* **Zeliha (Mobil):**
  * *Bugün Yapılanlar:* MOB-6 entegrasyonları tamamlandı.
  * *Engel (Blocker):* Yok.

**PM Günlük Özeti:** Projede entegrasyon süreci kararlılıkla devam etmektedir.
