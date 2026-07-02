import SwiftUI

@main
struct StarsignApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                BirthDataFormView()
            }
            .preferredColorScheme(.dark)
        }
    }
}
