import SwiftUI

/// Özel Kapsül Buton Stili (Apple Minimal Tasarımı)
public struct CustomPillButton: View {
    let title: String
    var icon: String? = nil
    var backgroundColor: Color = AppColors.buttonPrimary
    var foregroundColor: Color = AppColors.textPrimary
    var isFullWidth: Bool = true
    var height: CGFloat = 52
    let action: () -> Void
    
    public init(
        title: String,
        icon: String? = nil,
        backgroundColor: Color = AppColors.buttonPrimary,
        foregroundColor: Color = AppColors.textPrimary,
        isFullWidth: Bool = true,
        height: CGFloat = 52,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.isFullWidth = isFullWidth
        self.height = height
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: height)
            .padding(.horizontal, isFullWidth ? 0 : 20)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(backgroundColor)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

/// Dokunma Geri Bildirimi Animasyonu
public struct ScaleButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
