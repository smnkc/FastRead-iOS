import SwiftUI

/// 8 Renkli Odak Harfi (ORP) Paleti
public enum ORPColor: String, CaseIterable, Identifiable, Codable {
    case black = "Siyah"
    case red = "Kırmızı"
    case orange = "Turuncu"
    case yellow = "Sarı"
    case green = "Yeşil"
    case cyan = "Camgöbeği"
    case blue = "Mavi"
    case purple = "Mor"
    
    public var id: String { rawValue }
    
    public var color: Color {
        switch self {
        case .black: return AppColors.orpBlack
        case .red: return AppColors.orpRed
        case .orange: return AppColors.orpOrange
        case .yellow: return AppColors.orpYellow
        case .green: return AppColors.orpGreen
        case .cyan: return AppColors.orpCyan
        case .blue: return AppColors.orpBlue
        case .purple: return AppColors.orpPurple
        }
    }
}
