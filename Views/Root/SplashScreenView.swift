import SwiftUI

/// FastRead Açılış Splash Ekranı
public struct SplashScreenView: View {
    @State private var isAnimating: Bool = false
    @State private var textOpacity: Double = 0.0
    @State private var iconScale: CGFloat = 0.85
    @Binding var isSplashActive: Bool
    
    public init(isSplashActive: Binding<Bool>) {
        self._isSplashActive = isSplashActive
    }
    
    public var body: some View {
        ZStack {
            // Pastel Pembe/Somon Degradeli Arka Plan
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
            
            VStack(spacing: 24) {
                Spacer()
                
                // İKON ALANI (Animasyonlu Uygulama Logosu)
                ZStack {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .shadow(color: Color.black.opacity(0.12), radius: 24, x: 0, y: 12)
                    
                    // İkon Görseli / Vektörel Tasarım
                    if let uiImage = UIImage(contentsOfFile: iconPath()) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                    } else {
                        // Vektörel Fallback Logo
                        Image(systemName: "book.pages.fill")
                            .font(.system(size: 52, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [AppColors.orpRed, Color.orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
                .scaleEffect(iconScale)
                
                // MARKA ADI VE SLOGAN
                VStack(spacing: 8) {
                    HStack(spacing: 0) {
                        Text("Fast")
                            .font(.system(size: 34, weight: .bold, design: .serif))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("R")
                            .font(.system(size: 34, weight: .bold, design: .serif))
                            .foregroundColor(AppColors.orpRed)
                        
                        Text("ead")
                            .font(.system(size: 34, weight: .bold, design: .serif))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    Text("Bilimsel Hızlı Okuma")
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundColor(AppColors.textSecondary)
                        .tracking(1.5)
                }
                .opacity(textOpacity)
                
                Spacer()
                
                // Alt Bilgi
                Text("Osman Akça")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(AppColors.textTertiary)
                    .opacity(textOpacity)
                    .padding(.bottom, 24)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.65)) {
                iconScale = 1.0
            }
            
            withAnimation(.easeIn(duration: 0.6).delay(0.2)) {
                textOpacity = 1.0
            }
            
            // 2 saniye sonra ana ekrana akıcı geçiş yap
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isSplashActive = false
                }
            }
        }
    }
    
    private func iconPath() -> String {
        return "/Users/smnkc/Desktop/FastRead-iOS/Assets/AppIcon.png"
    }
}
