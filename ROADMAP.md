# Starsign — Development Roadmap

A step-by-step plan for building a Co-Star-style natal chart app in pure Swift/SwiftUI.

## Phase 0 — Setup (Day 1)
- Install Xcode from the Mac App Store (free)
- Create a free Apple Developer account (paid $99/yr account only needed to publish)
- Follow `SETUP.md` to create the project and add the starter code in this folder

## Phase 1 — Natal Chart Core (Weeks 1–3) ✅ scaffolded
The heart of the app: birth data in → chart out.

1. **Birth data input**: date, exact time, and place of birth. Place must become latitude/longitude — use Apple's built-in `CLGeocoder` (no API key needed).
2. **Ephemeris (planet positions)**: the starter code includes a self-contained engine (`Ephemeris.swift`) accurate to roughly a degree — fine for sign placements while learning. Before shipping, swap in the [SwissEphemeris Swift package](https://github.com/vsmithers1087/SwissEphemeris) for professional accuracy. ⚠️ Swiss Ephemeris is AGPL-3.0; a commercial app needs a paid license from Astrodienst (~CHF 750 one-time) or you keep your app's source open.
3. **Houses & Ascendant**: starter code uses Whole Sign houses (simplest and increasingly popular). Placidus can come later via Swiss Ephemeris.
4. **Chart wheel UI**: `ChartWheelView.swift` draws the zodiac wheel with SwiftUI `Canvas`.
5. **Placements list**: "Sun in Leo, 3rd house" style rows — this is what most users actually read.

## Phase 2 — Interpretations (Weeks 4–5)
Co-Star's real product is *writing*, not math.
- Build a content database: one text blurb per (planet × sign) and (planet × house) — 12×10 + 12×10 ≈ 240 entries. Store as JSON in the app bundle.
- Aspects (conjunction, opposition, trine, square, sextile): the math is in the starter engine; write blurbs for major planet pairs.
- Tone is your brand. Co-Star = blunt/poetic. Decide yours early.

## Phase 3 — Daily Horoscopes / Transits (Weeks 6–8)
- Compute today's planet positions and compare against the user's natal chart (transits) — same engine, run for "now".
- Rank the tightest transit aspects, map them to your content database → personalized daily reading.
- Local push notification each morning (`UNUserNotificationCenter`), later server push.

## Phase 4 — Compatibility / Synastry (Weeks 9–10)
- Second birth-data entry → compute cross-aspects between two charts.
- Score by aspect type/tightness; show a comparison view.

## Phase 5 — Social + Backend (Weeks 11+)
Everything before this runs 100% on-device. Social needs a backend:
- **Sign in with Apple** (required by App Store if you offer any login)
- CloudKit (free, pure-Apple, easiest) or Firebase/Supabase for friend graphs
- Friend requests, chart comparison, "your friend's day" notifications

## Phase 6 — Polish & Ship
- App icon, onboarding flow, dark-sky aesthetic
- Paywall if desired (StoreKit 2) — e.g. advanced charts behind subscription
- TestFlight beta → App Store review. Note: Apple requires astrology apps to offer more than generic content (Guideline 4.3 spam rules) — personalized charts satisfy this.

## Skills you'll pick up, in order
Swift basics → SwiftUI layout → dates/timezones (the hardest real bug source in astrology apps!) → Canvas drawing → CoreLocation/geocoding → notifications → StoreKit/CloudKit.

## Sources
- [SwissEphemeris Swift Package](https://github.com/vsmithers1087/SwissEphemeris)
- [Swiss Ephemeris official site & licensing](https://www.astro.com/swisseph/swephinfo_e.htm)
