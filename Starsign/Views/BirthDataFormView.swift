import SwiftUI
import CoreLocation

struct BirthDataFormView: View {
    @State private var birthDay = Date(timeIntervalSince1970: 820454400) // 1996-01-01
    @State private var birthTime = Date()
    @State private var cityQuery = ""
    @State private var isGeocoding = false
    @State private var errorMessage: String?
    @State private var chart: NatalChart?
    @State private var placeName = ""
    @State private var showChart = false

    var body: some View {
        Form {
            Section("Birth date & time") {
                DatePicker("Date", selection: $birthDay, displayedComponents: .date)
                DatePicker("Time", selection: $birthTime, displayedComponents: .hourAndMinute)
                Text("Exact birth time matters — it sets your Ascendant and houses.")
                    .font(.caption).foregroundStyle(.secondary)
            }

            Section("Birth place") {
                TextField("City, Country (e.g. Istanbul, Türkiye)", text: $cityQuery)
                    .autocorrectionDisabled()
            }

            Section {
                Button {
                    Task { await calculate() }
                } label: {
                    if isGeocoding {
                        ProgressView()
                    } else {
                        Text("Calculate Chart").frame(maxWidth: .infinity)
                    }
                }
                .disabled(cityQuery.isEmpty || isGeocoding)
            }

            if let errorMessage {
                Text(errorMessage).foregroundStyle(.red).font(.caption)
            }
        }
        .navigationTitle("Starsign")
        .navigationDestination(isPresented: $showChart) {
            if let chart {
                ChartScreen(chart: chart, placeName: placeName)
            }
        }
    }

    /// Geocode the city, resolve its time zone, combine date + time, build the chart.
    private func calculate() async {
        isGeocoding = true
        errorMessage = nil
        defer { isGeocoding = false }

        do {
            let geocoder = CLGeocoder()
            let marks = try await geocoder.geocodeAddressString(cityQuery)
            guard let mark = marks.first, let location = mark.location else {
                errorMessage = "Couldn't find that place — try 'City, Country'."
                return
            }
            let timeZone = mark.timeZone ?? .current

            // Combine the chosen day and clock time, interpreted in the
            // birth place's time zone. Getting this right is *the* classic
            // astrology-app bug — always resolve the place's zone first.
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = timeZone
            let day = calendar.dateComponents([.year, .month, .day], from: birthDay)
            let time = Calendar.current.dateComponents([.hour, .minute], from: birthTime)
            var combined = DateComponents()
            combined.year = day.year; combined.month = day.month; combined.day = day.day
            combined.hour = time.hour; combined.minute = time.minute
            combined.timeZone = timeZone
            guard let moment = calendar.date(from: combined) else {
                errorMessage = "Invalid date."
                return
            }

            let birth = BirthData(date: moment,
                                  timeZone: timeZone,
                                  latitude: location.coordinate.latitude,
                                  longitude: location.coordinate.longitude,
                                  placeName: mark.name ?? cityQuery)
            placeName = birth.placeName
            chart = ChartBuilder.build(from: birth)
            showChart = true
        } catch {
            errorMessage = "Place lookup failed: \(error.localizedDescription)"
        }
    }
}

#Preview {
    NavigationStack { BirthDataFormView() }
}
