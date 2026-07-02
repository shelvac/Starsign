# Starsign — Yol Haritası (v2, 2 Temmuz 2026)

Konsey kararı + pazar analiziyle güncellendi. Konumlandırma: **"İsim-yüzlü, hesap verebilir tek geliştirici; verin telefonunda kalır."** Türkçe, editöryel, güvenilir. Fal/tarot/mikro-ödeme alanına girilmez (MASAK gölgesi, toksik pazar).

## ✅ Faz 0–1: Natal Harita Çekirdeği (TAMAM)
Efemeris motoru (Meeus/JPL doğrulamalı), Whole Sign evler, Yükselen, açılar, harita çarkı, doğum formu (CLGeocoder + saat dilimi). Simülatörde çalışıyor, GitHub'da.

## 🔥 Faz 2: Retention Motoru (ŞİMDİ — hedef ~4 hafta)
Killer app bir özellik değil, **her sabah kilit ekranından açtıran alışkanlık.**

1. **Marka geçişi (2-3 gün):** ses tonu, logo, renk paleti. Instagram + TestFlight'a yetecek kadar; büyük tasarım fazı değil.
2. **50-100 Türkçe transit bildirim şablonu (1 hafta):** parametrik (gezegen-açı-ev), LLM'siz. Statik 1728 kombinasyonluk ansiklopedi YAZILMAYACAK (konsey kararı: tek kişi tuzağı).
3. **Transit motoru + günlük yerel bildirim:** mevcut Ephemeris "bugün" için çalıştırılır, natal haritayla en sıkı açılar bulunur, şablona bağlanır.
4. **Instagram kanalı:** "coming soon" DEĞİL — ilk günden değer veren günlük gökyüzü içeriği (şablon metinleri çift kullanım: app + reels). Bio'da TestFlight linki.
5. **TestFlight beta (20-30 kişi) + retention ölçümü:** hedef metrik = haftada 2+ açılış. Sinyal gelmeden başka yatırım yok.

## Faz 2.5: Farklılaştırıcılar (pazar boşluğu doğrulandı)
- **Saatsiz harita:** Co-Star/The Pattern saat zorunlu tutuyor → kapıda çevrilen kullanıcıyı biz alırız. Saat yoksa ev/Yükselen gizlenir, gezegen-burç yerleşimleri gösterilir. İleride "hayat olayları testi" ile saat tahmini (rektifikasyon) premium olur.
- **Düğün tarihi raporu (electional):** Türkçe tüketici uygulamasında YOK; web hesaplayıcıları teknik ve İngilizce. Motor bugünkü haliyle hesaplayabilir (Venüs retrosu, boşlukta Ay, benefik konumlar). Gelir: yüksek değerli TEK SEFERLİK satın alma.
- ⚠️ Çocuk/doğum tarihi zamanlaması: talep var ama tıbbi karar alanına komşu — yalnızca "sembolik rehberlik" çerçevesiyle, sağlık tavsiyesi imasız; App Store review riski nedeniyle sona bırakıldı.

## Faz 3: Sinastri + Gelir
- Türkçe derin sinastri yorumu (İngilizce uygulamaların zayıf bıraktığı alan).
- **Freemium:** günlük bildirim + temel harita ücretsiz (retention motoru); detaylı transit raporları + sinastri abonelikte; düğün raporu tek seferlik.
- StoreKit 2, Sign in with Apple.

## Faz 4: PARK EDİLDİ (retention kanıtlanana kadar dokunma)
- Sosyal özellikler (network effect tek kişiyle kurulamaz; Gen-Z zaten Co-Star'da bağlı).
- Diaspora genişlemesi (konsey 5/5 reddetti: 2.-3. nesil Türkçe okumuyor, kapasite yok).
- RAG/LLM yorum katmanı (önce statik şablonlar RAG'in kaynak metni olur).

## Bilinen Riskler (konseyin yakaladığı kör noktalar)
- **Dağıtım:** sıfır bütçeyle keşfedilebilirlik → Instagram organik kanal + ASO Türkçe anahtar kelime çalışması.
- **Platform:** App Store komisyonu %15-30, KVKK, astroloji kategorisi review hassasiyeti (Guideline 4.3 — kişiselleştirilmiş harita bunu karşılıyor).
- **Lisans:** Ticari yayın öncesi Swiss Ephemeris'e geçilecekse AGPL / ücretli Astrodienst lisansı (~CHF 750) gerekir; mevcut motor kendi kodumuz, lisans sorunu yok.

## Rakip Özeti (Tem 2026)
Faladdin/Binnaz (25M+ indirme, fal, MASAK soruşturması) · Astopia, Ms Astro, Astromatik (ünlü astrolog+AI), Moyra, Stellium (yerli natal, küçük) · Co-Star 30M+, The Pattern (İngilizce, saat zorunlu, TR yerelleşmesi yok). Boşluk: **Türkçe, teknik olmayan dille günlük kişisel gökyüzü + saatsiz harita + electional.**
