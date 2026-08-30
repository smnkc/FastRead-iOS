import SwiftUI

/// 5 Adımlı İnteraktif Karşılama ve Onboarding Akışı
public struct OnboardingFlowView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var stepIndex: Int = 0
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Arka Plan Seçimi
            if stepIndex < 2 {
                AppColors.appBackground
                    .ignoresSafeArea()
            } else {
                LinearGradient(
                    colors: [
                        AppColors.roseGradientStart,
                        AppColors.roseGradientEnd,
                        Color.white
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
            
            VStack(spacing: 0) {
                // Üst Bar: Sağda "Atla" Butonu
                HStack {
                    Spacer()
                    Button(action: {
                        completeOnboarding()
                    }) {
                        Text("Atla")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                // ORTA ALAN: ADIMLARA GÖRE İÇERİK
                Group {
                    switch stepIndex {
                    case 0:
                        // Ekran 1: RSVP Giriş Demosu ("Ekran")
                        RSVPCenteredWordView(customText: "Ekran")
                            .transition(.opacity)
                        
                    case 1:
                        // Ekran 2: Kısa Kelime Demosu ("az")
                        RSVPCenteredWordView(customText: "az")
                            .transition(.opacity)
                        
                    case 2:
                        // Ekran 3: Zihin & Okuma Hızı
                        OnboardingCardView(
                            title: "Okuma hızınız\nsabit değildir.",
                            icon: "brain.head.profile",
                            description: "Sadece doğru yöntemi bekliyordu."
                        )
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        
                    case 3:
                        // Ekran 4: Bilimsel RSVP Tekniği
                        OnboardingCardView(
                            title: "Bilimle 3 kata kadar\ndaha hızlı okuyun.",
                            icon: "eye",
                            description: "FastRead, Rapid Serial Visual Presentation tekniğini kullanır.\n\nKavrayış kaybı olmadan daha hızlı okumayı sağlayan bilimsel dayanaklı bir teknik."
                        )
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        
                    case 4:
                        // Ekran 5: Belge İçe Aktarma
                        OnboardingCardView(
                            title: "Herhangi bir belgeyi\niçe aktarın.",
                            icon: "doc.text.image",
                            description: "EPUB'lar, PDF'ler, web bağlantıları veya yapıştırılan metin.\n\nSizin için önemli olanları okumanın daha hızlı bir yolu."
                        )
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        
                    default:
                        EmptyView()
                    }
                }
                
                Spacer()
                
                // Sayfalama Noktaları (Slide 1-3 için)
                if stepIndex >= 2 {
                    HStack(spacing: 8) {
                        ForEach(0..<3) { idx in
                            Circle()
                                .fill(stepIndex - 2 == idx ? AppColors.textPrimary : AppColors.textTertiary.opacity(0.4))
                                .frame(width: 7, height: 7)
                        }
                    }
                    .padding(.bottom, 24)
                }
                
                // ALT AKSİYON KARTI
                VStack(spacing: 12) {
                    CustomPillButton(
                        title: buttonTitleForStep(),
                        backgroundColor: AppColors.subtleGray,
                        foregroundColor: AppColors.textPrimary,
                        isFullWidth: true,
                        height: 54
                    ) {
                        nextStep()
                    }
                    
                    // Alt Bilgi
                    HStack {
                        Text("FastRead")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(AppColors.textTertiary)
                        
                        Spacer()
                        
                        Text("v1.0.0")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(AppColors.textTertiary)
                    }
                    .padding(.horizontal, 4)
                    .padding(.top, 4)
                }
                .padding(22)
                .background(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white.opacity(0.95))
                        .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 8)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: stepIndex)
    }
    
    private func buttonTitleForStep() -> String {
        switch stepIndex {
        case 0: return "Haydi başlayalım"
        case 1: return "Devam et"
        case 2: return "Devam et"
        case 3: return "Deneyin"
        case 4: return "Okumaya başla"
        default: return "Devam et"
        }
    }
    
    private func nextStep() {
        if stepIndex < 4 {
            stepIndex += 1
        } else {
            completeOnboarding()
        }
    }
    
    private func completeOnboarding() {
        withAnimation {
            hasCompletedOnboarding = true
        }
    }
}
