import Foundation

/// Turns birth data into a complete natal chart.
/// This is the only place the rest of the app asks for astrology math,
/// so upgrading to SwissEphemeris later means changing only this file
/// and `Ephemeris.swift`.
enum ChartBuilder {

    static func build(from birth: BirthData) -> NatalChart {
        let asc = Ephemeris.ascendant(at: birth.date,
                                      latitude: birth.latitude,
                                      longitude: birth.longitude)
        let ascSign = ZodiacSign.containing(longitude: asc)

        let placements = CelestialBody.allCases.map { body -> Placement in
            let lon = Ephemeris.longitude(of: body, at: birth.date)
            let sign = ZodiacSign.containing(longitude: lon)
            // Whole Sign houses: the Ascendant's sign is the 1st house.
            let house = ((sign.rawValue - ascSign.rawValue) + 12) % 12 + 1
            return Placement(body: body, longitude: lon, house: house)
        }

        return NatalChart(placements: placements,
                          ascendant: asc,
                          aspects: aspects(in: placements))
    }

    /// All major aspects between placement pairs, tightest first.
    static func aspects(in placements: [Placement]) -> [Aspect] {
        var result: [Aspect] = []
        for i in placements.indices {
            for j in placements.indices where j > i {
                let sep = angularSeparation(placements[i].longitude, placements[j].longitude)
                for kind in AspectKind.allCases {
                    let orb = abs(sep - kind.angle)
                    if orb <= kind.orb {
                        result.append(Aspect(a: placements[i].body,
                                             b: placements[j].body,
                                             kind: kind, orb: orb))
                    }
                }
            }
        }
        return result.sorted { $0.orb < $1.orb }
    }

    /// Smallest angle between two ecliptic longitudes (0°–180°).
    static func angularSeparation(_ a: Double, _ b: Double) -> Double {
        let diff = abs(a - b).truncatingRemainder(dividingBy: 360)
        return diff > 180 ? 360 - diff : diff
    }
}
