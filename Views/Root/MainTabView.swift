import SwiftUI

/// 3 Sekmeli Ana Görünüm ve Özel Yüzen Tab Bar Yöneticisi
public struct MainTabView: View {
    @State private var selectedTab: AppTab = .reader
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            // AKTİF SEKME İÇERİĞİ
            Group {
                switch selectedTab {
                case .library:
                    LibraryView()
                case .reader:
                    ReaderHomeView()
                case .settings:
                    NavigationView {
                        SettingsView()
                    }
                    .navigationViewStyle(.stack)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // ÖZEL FLOATING TAB BAR
            FloatingTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
