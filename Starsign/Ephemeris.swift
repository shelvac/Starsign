import Foundation

/// Self-contained planetary position engine.
///
/// Accuracy: planets ≲ 1 arcminute–0.5°, Moon ≈ 0.1°, valid roughly 1800–2050.
/// Good enough for sign placements while learning. For production accuracy
/// (and Placidus houses), swap this for the SwissEphemeris Swift package —
/// the rest of the app only talks to `ChartBuilder`, so nothing else changes.
///
/// Math sources: JPL approximate planetary elements; Meeus, "Astronomical
/// Algorithms" (truncated lunar series, sidereal time, obliquity).
enum Ephemeris {

    // MARK: - Julian day

    /// Julian Day for an absolute moment in time. `Date` is already UTC-based.
    static func julianDay(_ date: Date) -> Double {
        2440587.5 + date.timeIntervalSince1970 / 86400.0
    }

    /// Julian centuries since J2000.0.
    static func julianCenturies(_ jd: Double) -> Double {
        (jd - 2451545.0) / 36525.0
    }

    // MARK: - Public API

    /// Geocentric ecliptic longitude (0°–360°) of a body at a moment in time.
    static func longitude(of body: CelestialBody, at date: Date) -> Double {
        let jd = julianDay(date)
        let t = julianCenturies(jd)
        switch body {
        case .sun:  return sunLongitude(t)
        case .moon: return moonLongitude(t)
        default:    return planetLongitude(body, t)
        }
    }

    /// Ecliptic longitude of the Ascendant.
    static func ascendant(at date: Date, latitude: Double, longitude: Double) -> Double {
        let jd = julianDay(date)
        let t = julianCenturies(jd)

        // Greenwich mean sidereal time, in degrees
        let gmst = (280.46061837
                    + 360.98564736629 * (jd - 2451545.0)
                    + 0.000387933 * t * t).normalizedDegrees
        // Local sidereal time = right ascension of the midheaven (RAMC)
        let ramc = (gmst + longitude).normalizedDegrees.degreesToRadians

        let eps = obliquity(t).degreesToRadians
        let phi = latitude.degreesToRadians

        let asc = atan2(cos(ramc), -(sin(ramc) * cos(eps) + tan(phi) * sin(eps)))
        return asc.radiansToDegrees.normalizedDegrees
    }

    // MARK: - Obliquity of the ecliptic

    static func obliquity(_ t: Double) -> Double {
        23.439291111 - 0.0130042 * t
    }

    // MARK: - Sun (via Earth's orbit; Meeus ch. 25, ~0.01°)

    private static func sunLongitude(_ t: Double) -> Double {
        let l0 = 280.46646 + 36000.76983 * t + 0.0003032 * t * t   // mean longitude
        let m = (357.52911 + 35999.05029 * t - 0.0001537 * t * t)  // mean anomaly
            .normalizedDegrees.degreesToRadians
        let c = (1.914602 - 0.004817 * t - 0.000014 * t * t) * sin(m)
            + (0.019993 - 0.000101 * t) * sin(2 * m)
            + 0.000289 * sin(3 * m)                                 // equation of center
        return (l0 + c).normalizedDegrees
    }

    // MARK: - Moon (Meeus ch. 47, truncated; ~0.1°)

    private static func moonLongitude(_ t: Double) -> Double {
        func deg(_ x: Double) -> Double { x.normalizedDegrees.degreesToRadians }

        let lp = 218.3164477 + 481267.88123421 * t   // mean longitude
        let d  = deg(297.8501921 + 445267.1114034 * t)   // mean elongation
        let m  = deg(357.5291092 + 35999.0502909 * t)    // Sun mean anomaly
        let mp = deg(134.9633964 + 477198.8675055 * t)   // Moon mean anomaly
        let f  = deg(93.2720950 + 483202.0175233 * t)    // argument of latitude

        var sum = 6.288774 * sin(mp)
        sum += 1.274027 * sin(2 * d - mp)
        sum += 0.658314 * sin(2 * d)
        sum += 0.213618 * sin(2 * mp)
        sum -= 0.185116 * sin(m)
        sum -= 0.114332 * sin(2 * f)
        sum += 0.058793 * sin(2 * d - 2 * mp)
        sum += 0.057066 * sin(2 * d - m - mp)
        sum += 0.053322 * sin(2 * d + mp)
        sum += 0.045758 * sin(2 * d - m)
        sum -= 0.040923 * sin(m - mp)
        sum -= 0.034720 * sin(d)
        sum -= 0.030383 * sin(m + mp)
        sum += 0.015327 * sin(2 * d - 2 * f)
        sum -= 0.012528 * sin(mp + 2 * f)
        sum += 0.010980 * sin(mp - 2 * f)

        return (lp + sum).normalizedDegrees
    }

    // MARK: - Planets (JPL approximate Keplerian elements, 1800–2050)

    /// a (AU), e, i, L, longPeri (ϖ), longNode (Ω) — value at J2000 + rate per century.
    private struct Elements {
        let a, e, i, l, lp, ln: (Double, Double)

        func at(_ t: Double) -> (a: Double, e: Double, i: Double, l: Double, lp: Double, ln: Double) {
            (a.0 + a.1 * t, e.0 + e.1 * t, i.0 + i.1 * t,
             l.0 + l.1 * t, lp.0 + lp.1 * t, ln.0 + ln.1 * t)
        }
    }

    private static let elementTable: [CelestialBody: Elements] = [
        .mercury: Elements(a: (0.38709927, 0.00000037), e: (0.20563593, 0.00001906),
                           i: (7.00497902, -0.00594749), l: (252.25032350, 149472.67411175),
                           lp: (77.45779628, 0.16047689), ln: (48.33076593, -0.12534081)),
        .venus: Elements(a: (0.72333566, 0.00000390), e: (0.00677672, -0.00004107),
                         i: (3.39467605, -0.00078890), l: (181.97909950, 58517.81538729),
                         lp: (131.60246718, 0.00268329), ln: (76.67984255, -0.27769418)),
        .mars: Elements(a: (1.52371034, 0.00001847), e: (0.09339410, 0.00007882),
                        i: (1.84969142, -0.00813131), l: (-4.55343205, 19140.30268499),
                        lp: (-23.94362959, 0.44441088), ln: (49.55953891, -0.29257343)),
        .jupiter: Elements(a: (5.20288700, -0.00011607), e: (0.04838624, -0.00013253),
                           i: (1.30439695, -0.00183714), l: (34.39644051, 3034.74612775),
                           lp: (14.72847983, 0.21252668), ln: (100.47390909, 0.20469106)),
        .saturn: Elements(a: (9.53667594, -0.00125060), e: (0.05386179, -0.00050991),
                          i: (2.48599187, 0.00193609), l: (49.95424423, 1222.49362201),
                          lp: (92.59887831, -0.41897216), ln: (113.66242448, -0.28867794)),
        .uranus: Elements(a: (19.18916464, -0.00196176), e: (0.04725744, -0.00004397),
                          i: (0.77263783, -0.00242939), l: (313.23810451, 428.48202785),
                          lp: (170.95427630, 0.40805281), ln: (74.01692503, 0.04240589)),
        .neptune: Elements(a: (30.06992276, 0.00026291), e: (0.00859048, 0.00005105),
                           i: (1.77004347, 0.00035372), l: (-55.12002969, 218.45945325),
                           lp: (44.96476227, -0.32241464), ln: (131.78422574, -0.00508664)),
        .pluto: Elements(a: (39.48211675, -0.00031596), e: (0.24882730, 0.00005170),
                         i: (17.14001206, 0.00004818), l: (238.92903833, 145.20780515),
                         lp: (224.06891629, -0.04062942), ln: (110.30393684, -0.01183482)),
        // Earth-Moon barycenter (used to convert heliocentric → geocentric)
        .sun: Elements(a: (1.00000261, 0.00000562), e: (0.01671123, -0.00004392),
                       i: (-0.00001531, -0.01294668), l: (100.46457166, 35999.37244981),
                       lp: (102.93768193, 0.32327364), ln: (0.0, 0.0)),
    ]

    /// Heliocentric ecliptic rectangular coordinates (AU).
    private static func heliocentric(_ body: CelestialBody, _ t: Double) -> (x: Double, y: Double, z: Double) {
        let el = elementTable[body]!.at(t)

        let omega = el.lp - el.ln                         // argument of perihelion
        var m = (el.l - el.lp).normalizedDegrees          // mean anomaly
        if m > 180 { m -= 360 }

        // Solve Kepler's equation (Newton iteration, in degrees)
        let eStar = el.e * 180 / .pi   // eccentricity in degrees, per JPL method
        var eAnom = m + eStar * sin(m.degreesToRadians)
        for _ in 0..<8 {
            let dm = m - (eAnom - eStar * sin(eAnom.degreesToRadians))
            let de = dm / (1 - el.e * cos(eAnom.degreesToRadians))
            eAnom += de
            if abs(de) < 1e-7 { break }
        }
        let eRad = eAnom.degreesToRadians

        // Position in orbital plane
        let xp = el.a * (cos(eRad) - el.e)
        let yp = el.a * (1 - el.e * el.e).squareRoot() * sin(eRad)

        // Rotate into ecliptic frame
        let w = omega.degreesToRadians
        let o = el.ln.degreesToRadians
        let i = el.i.degreesToRadians

        let x = (cos(w) * cos(o) - sin(w) * sin(o) * cos(i)) * xp
              + (-sin(w) * cos(o) - cos(w) * sin(o) * cos(i)) * yp
        let y = (cos(w) * sin(o) + sin(w) * cos(o) * cos(i)) * xp
              + (-sin(w) * sin(o) + cos(w) * cos(o) * cos(i)) * yp
        let z = (sin(w) * sin(i)) * xp + (cos(w) * sin(i)) * yp
        return (x, y, z)
    }

    private static func planetLongitude(_ body: CelestialBody, _ t: Double) -> Double {
        let p = heliocentric(body, t)
        let e = heliocentric(.sun, t)   // Earth-Moon barycenter
        let gx = p.x - e.x
        let gy = p.y - e.y
        return atan2(gy, gx).radiansToDegrees.normalizedDegrees
    }
}
