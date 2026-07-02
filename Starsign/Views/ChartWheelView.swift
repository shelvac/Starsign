import SwiftUI

/// The circular natal chart, drawn with SwiftUI Canvas.
/// Convention: the Ascendant sits at 9 o'clock, zodiac runs counter-clockwise.
struct ChartWheelView: View {
    let chart: NatalChart

    var body: some View {
        Canvas { context, size in
            // Do all geometry in Double to avoid CGFloat/Double ambiguity.
            let cx = Double(size.width) / 2
            let cy = Double(size.height) / 2
            let outer = min(Double(size.width), Double(size.height)) / 2 - 8
            let inner = outer * 0.78
            let planetRing = outer * 0.62

            // Rotates an ecliptic longitude so the Ascendant is at 9 o'clock.
            // Screen angles: 0 = right, grows clockwise; zodiac grows CCW.
            func screenAngle(_ eclipticLongitude: Double) -> Double {
                (180 - (eclipticLongitude - chart.ascendant)).degreesToRadians
            }
            func point(angle: Double, radius: Double) -> CGPoint {
                CGPoint(x: cx + cos(angle) * radius,
                        y: cy - sin(angle) * radius) // minus: flip to CCW
            }

            // Rings
            for radius in [outer, inner] {
                let circle = Path(ellipseIn: CGRect(x: cx - radius, y: cy - radius,
                                                    width: radius * 2, height: radius * 2))
                context.stroke(circle, with: .color(.secondary.opacity(0.6)), lineWidth: 1)
            }

            // Sign boundaries + glyphs
            for sign in ZodiacSign.allCases {
                let startLon = Double(sign.rawValue) * 30
                let a = screenAngle(startLon)
                var tick = Path()
                tick.move(to: point(angle: a, radius: inner))
                tick.addLine(to: point(angle: a, radius: outer))
                context.stroke(tick, with: .color(.secondary.opacity(0.6)), lineWidth: 1)

                let mid = screenAngle(startLon + 15)
                let glyphPoint = point(angle: mid, radius: (outer + inner) / 2)
                context.draw(Text(sign.symbol).font(.system(size: 14)),
                             at: glyphPoint)
            }

            // Ascendant marker
            let ascAngle = screenAngle(chart.ascendant)
            var ascLine = Path()
            ascLine.move(to: point(angle: ascAngle, radius: 0))
            ascLine.addLine(to: point(angle: ascAngle, radius: inner))
            context.stroke(ascLine, with: .color(.accentColor), lineWidth: 1.5)
            context.draw(Text("ASC").font(.caption2.bold()).foregroundStyle(.tint),
                         at: point(angle: ascAngle, radius: inner * 0.9))

            // Aspect lines (drawn first ring inward)
            for aspect in chart.aspects.prefix(12) {
                guard let pa = chart.placement(of: aspect.a),
                      let pb = chart.placement(of: aspect.b) else { continue }
                var line = Path()
                line.move(to: point(angle: screenAngle(pa.longitude), radius: planetRing * 0.85))
                line.addLine(to: point(angle: screenAngle(pb.longitude), radius: planetRing * 0.85))
                context.stroke(line, with: .color(.secondary.opacity(0.25)), lineWidth: 0.8)
            }

            // Planet glyphs
            for placement in chart.placements {
                let a = screenAngle(placement.longitude)
                context.draw(Text(placement.body.symbol).font(.system(size: 16)),
                             at: point(angle: a, radius: planetRing))
            }
        }
    }
}
