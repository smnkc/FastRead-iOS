import SwiftUI

/// 3 Ana Sekmeyi İçeren Özel Yüzen Hap Alt Gezinme Çubuğu (Floating Tab Bar)
public enum AppTab: Int, CaseIterable {
    case library = 0
    case reader = 1
    case settings = 2
    
    public var title: String {
        switch self {
        case .library: return "tab_library".localized
        case .reader: return "tab_read".localized
        case .settings: return "tab_settings".localized
        }
    }
    
    public var icon: String {
        switch self {
        case .library: return "tray.full"
        case .reader: return "bolt.fill"
        case .settings: return "gearshape"
        }
    }
}

public struct FloatingTabBar: View {
    @Binding var selectedTab: AppTab
    
    public init(selectedTab: Binding<AppTab>) {
        self._selectedTab = selectedTab
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                let isSelected = selectedTab == tab
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: isSelected ? .bold : .regular))
                        
                        Text(tab.title)
                            .font(.system(size: 11, weight: isSelected ? .semibold : .medium))
                    }
                    .foregroundColor(isSelected ? AppColors.textPrimary : AppColors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(isSelected ? AppColors.subtleGray : Color.clear)
                    )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.white.opacity(0.95))
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 8)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
}
