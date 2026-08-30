import SwiftUI

/// Kök Yönlendirici (Splash vs Onboarding vs Ana Uygulama)
public struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var isSplashActive: Bool = true
    
    public init() {}
    
    public var body: some View {
        ZStack {
            if isSplashActive {
                SplashScreenView(isSplashActive: $isSplashActive)
                    .transition(.opacity)
            } else {
                if !hasCompletedOnboarding {
                    OnboardingFlowView()
                        .transition(.opacity)
                } else {
                    MainTabView()
                        .transition(.opacity)
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: isSplashActive)
        .animation(.easeInOut(duration: 0.35), value: hasCompletedOnboarding)
    }
}
