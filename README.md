# Starsign

Türkiye'ye özgü, editöryel ve sosyal bir astroloji uygulaması.
SwiftUI ile native iOS olarak geliştiriliyor.

Durum: Geliştirme aşamasında 🌙 — Faz 1 tamam (natal harita çekirdeği)

## Yapı

- `Starsign/` — uygulama kaynak kodu (SwiftUI)
  - `Ephemeris.swift` — gezegen konumu motoru (Meeus/JPL referanslarıyla doğrulandı)
  - `ChartBuilder.swift` — yerleşimler, Whole Sign evler, açılar (aspects), Yükselen
  - `Views/` — doğum bilgisi formu, harita çarkı, sonuç ekranı
- `ROADMAP.md` — geliştirme yol haritası (6 faz)
- `SETUP.md` — Xcode kurulum adımları
