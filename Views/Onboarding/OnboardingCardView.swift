import SwiftUI

/// Onboarding Bilgilendirme Kartı Bileşeni
public struct OnboardingCardView: View {
    let title: String
    let icon: String
    let description: String
    
    public init(title: String, icon: String, description: String) {
        self.title = title
        self.icon = icon
        self.description = description
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Başlık ve İkon
            HStack(alignment: .top) {
                Text(title)
                    .font(AppFonts.monoTitle(size: 21))
                    .foregroundColor(AppColors.textPrimary)
                    .lineSpacing(4)
                
                Spacer()
                
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(AppColors.textPrimary.opacity(0.75))
            }
            
            // Ayırıcı İnce Çizgi
            Rectangle()
                .fill(AppColors.cardBorder.opacity(0.7))
                .frame(height: 1)
            
            // Açıklama Metni
            Text(description)
                .font(AppFonts.monoBody(size: 15))
                .foregroundColor(AppColors.textSecondary)
                .lineSpacing(6)
        }
        .padding(26)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color.white.opacity(0.92))
                .shadow(color: Color.black.opacity(0.06), radius: 24, x: 0, y: 10)
        )
        .padding(.horizontal, 24)
    }
}
