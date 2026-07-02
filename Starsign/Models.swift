import Foundation

// MARK: - Zodiac

enum ZodiacSign: Int, CaseIterable, Identifiable, Codable {
    case aries, taurus, gemini, cancer, leo, virgo
    case libra, scorpio, sagittarius, capricorn, aquarius, pisces

    var id: Int { rawValue }

    var name: String {
        ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo",
         "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"][rawValue]
    }

    var symbol: String {
        ["♈︎", "♉︎", "♊︎", "♋︎", "♌︎", "♍︎", "♎︎", "♏︎", "♐︎", "♑︎", "♒︎", "♓︎"][rawValue]
    }

    var element: String {
        ["Fire", "Earth", "Air", "Water"][rawValue % 4]
    }

    /// The sign containing an ecliptic longitude (0°–360°).
    static func containing(longitude: Double) -> ZodiacSign {
        let normalized = longitude.normalizedDegrees
        return ZodiacSign(rawValue: Int(normalized / 30) % 12)!
    }
}

// MARK: - Celestial bodies

enum CelestialBody: Int, CaseIterable, Identifiable, Codable {
    case sun, moon, mercury, venus, mars, jupiter, saturn, uranus, neptune, pluto

    var id: Int { rawValue }

    var name: String {
        ["Sun", "Moon", "Mercury", "Venus", "Mars",
         "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto"][rawValue]
    }

    var symbol: String {
        ["☉", "☽", "☿", "♀", "♂", "♃", "♄", "♅", "♆", "♇"][rawValue]
    }
}

// MARK: - Chart data

/// One placement: e.g. "Sun at 12°34′ Leo, 3rd house".
struct Placement: Identifiable {
    let body: CelestialBody
    /// Ecliptic longitude 0°–360°
    let longitude: Double
    let house: Int

    var id: Int { body.id }
    var sign: ZodiacSign { .containing(longitude: longitude) }

    /// Degrees within the sign, e.g. 12°34′
    var degreeInSign: String {
        let inSign = longitude.normalizedDegrees.truncatingRemainder(dividingBy: 30)
        let degrees = Int(inSign)
        let minutes = Int((inSign - Double(degrees)) * 60)
        return "\(degrees)°\(String(format: "%02d", minutes))′"
    }
}

enum AspectKind: String, CaseIterable {
    case conjunction, sextile, square, trine, opposition

    var angle: Double {
        switch self {
        case .conjunction: return 0
        case .sextile: return 60
        case .square: return 90
        case .trine: return 120
        case .opposition: return 180
        }
    }

    /// Allowed deviation from the exact angle.
    var orb: Double {
        switch self {
        case .conjunction, .opposition: return 8
        case .trine, .square: return 7
        case .sextile: return 4
        }
    }

    var symbol: String {
        switch self {
        case .conjunction: return "☌"
        case .sextile: return "⚹"
        case .square: return "□"
        case .trine: return "△"
        case .opposition: return "☍"
        }
    }
}

struct Aspect: Identifiable {
    let a: CelestialBody
    let b: CelestialBody
    let kind: AspectKind
    /// How far from exact, in degrees. Smaller = stronger.
    let orb: Double

    var id: String { "\(a.rawValue)-\(b.rawValue)-\(kind.rawValue)" }
}

struct NatalChart {
    let placements: [Placement]
    let ascendant: Double        // ecliptic longitude of the Ascendant
    let aspects: [Aspect]

    var ascendantSign: ZodiacSign { .containing(longitude: ascendant) }

    func placement(of body: CelestialBody) -> Placement? {
        placements.first { $0.body == body }
    }
}

// MARK: - Birth data

struct BirthData {
    var date: Date            // exact birth moment (absolute point in time)
    var timeZone: TimeZone    // time zone of the birth place
    var latitude: Double
    var longitude: Double
    var placeName: String
}

// MARK: - Helpers

extension Double {
    /// Normalize an angle into 0°..<360°.
    var normalizedDegrees: Double {
        let r = truncatingRemainder(dividingBy: 360)
        return r < 0 ? r + 360 : r
    }

    var degreesToRadians: Double { self * .pi / 180 }
    var radiansToDegrees: Double { self * 180 / .pi }
}
