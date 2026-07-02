import SwiftUI

/// Results screen: chart wheel + placements + aspects.
struct ChartScreen: View {
    let chart: NatalChart
    let placeName: String

    var body: some View {
        List {
            Section {
                ChartWheelView(chart: chart)
                    .frame(height: 340)
                    .listRowBackground(Color.clear)
            }

            Section("Big Three") {
                bigThreeRow("Sun", chart.placement(of: .sun)?.sign)
                bigThreeRow("Moon", chart.placement(of: .moon)?.sign)
                bigThreeRow("Rising", chart.ascendantSign)
            }

            Section("Placements") {
                ForEach(chart.placements) { p in
                    HStack {
                        Text("\(p.body.symbol) \(p.body.name)")
                            .frame(width: 110, alignment: .leading)
                        Text("\(p.sign.symbol) \(p.sign.name)")
                        Spacer()
                        Text("\(p.degreeInSign) · H\(p.house)")
                            .font(.caption.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section("Major aspects") {
                ForEach(chart.aspects.prefix(10)) { a in
                    HStack {
                        Text("\(a.a.name) \(a.kind.symbol) \(a.b.name)")
                        Spacer()
                        Text(String(format: "orb %.1f°", a.orb))
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle(placeName)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func bigThreeRow(_ label: String, _ sign: ZodiacSign?) -> some View {
        HStack {
            Text(label).bold()
            Spacer()
            Text(sign.map { "\($0.symbol) \($0.name)" } ?? "—")
        }
    }
}
