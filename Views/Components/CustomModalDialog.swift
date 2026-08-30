import SwiftUI

/// Ekran Görüntülerindeki Özel Modal Bildirim Diyaloğu
public struct CustomModalDialog: View {
    let title: String
    var message: String? = nil
    var buttonTitle: String = "Kapat"
    var onAction: () -> Void
    
    public init(
        title: String,
        message: String? = nil,
        buttonTitle: String = "Kapat",
        onAction: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.onAction = onAction
    }
    
    public var body: some View {
        ZStack {
            // Karartma Arka Planı
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    onAction()
                }
            
            // Modal Kartı
            VStack(alignment: .leading, spacing: 14) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                if let message = message, !message.isEmpty {
                    Text(message)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                        .lineSpacing(3)
                }
                
                Spacer().frame(height: 6)
                
                CustomPillButton(
                    title: buttonTitle,
                    backgroundColor: AppColors.subtleGray,
                    foregroundColor: AppColors.textPrimary,
                    isFullWidth: true,
                    height: 48
                ) {
                    onAction()
                }
            }
            .padding(22)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.12), radius: 24, x: 0, y: 12)
            )
            .padding(.horizontal, 32)
            .transition(.scale(scale: 0.9).combined(with: .opacity))
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: true)
    }
}
