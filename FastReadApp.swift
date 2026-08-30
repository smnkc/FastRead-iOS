import SwiftUI

@main
struct FastReadApp: App {
    @StateObject private var engine = RSVPEngine.shared
    @StateObject private var theme = ThemeManager.shared
    @StateObject private var settings = ReaderSettings.shared
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(engine)
                .environmentObject(theme)
                .environmentObject(settings)
                .preferredColorScheme(.light) // Orijinal tasarımdaki açık/pastel tema
        }
    }
}
