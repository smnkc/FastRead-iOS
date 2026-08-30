import SwiftUI

/// Hazır Tema Stilleri
public enum ThemePreset: String, CaseIterable, Identifiable, Codable {
    case classic = "Klasik"
    case book = "Kitap"
    case oled = "OLED"
    case gradient = "Gradyan"
    
    public var id: String { rawValue }
    
    public var localizedName: String {
        switch self {
        case .classic: return "preset_classic".localized
        case .book: return "preset_book".localized
        case .oled: return "preset_oled".localized
        case .gradient: return "preset_gradient".localized
        }
    }
}

/// Arka Plan Seçenekleri
public enum ReaderBackground: String, CaseIterable, Identifiable, Codable {
    case highContrast = "Yüksek kontrast"
    case grey = "Gri"
    case warmGrey = "Gri (sıcak)"
    case oledBlack = "OLED Siyah"
    case gradient = "Gradyan"
    
    public var id: String { rawValue }
    
    public var localizedName: String {
        switch self {
        case .highContrast: return "bg_high_contrast".localized
        case .grey: return "bg_grey".localized
        case .warmGrey: return "bg_warm_grey".localized
        case .oledBlack: return "bg_oled_black".localized
        case .gradient: return "bg_gradient".localized
        }
    }
    
    public var color: Color {
        switch self {
        case .highContrast:
            return AppColors.readerWhite
        case .grey:
            return AppColors.readerCoolGray
        case .warmGrey:
            return AppColors.readerWarmGray
        case .oledBlack:
            return Color.black
        case .gradient:
            return Color.clear
        }
    }
    
    public var isDark: Bool {
        self == .oledBlack
    }
}

/// Metin Kontrastı
public enum TextContrast: String, CaseIterable, Identifiable, Codable {
    case prominent = "Belirgin"
    case normal = "Normal"
    case subtle = "Hafif"
    
    public var id: String { rawValue }
    
    public var localizedName: String {
        switch self {
        case .prominent: return "contrast_prominent".localized
        case .normal: return "contrast_normal".localized
        case .subtle: return "contrast_subtle".localized
        }
    }
    
    public var opacity: Double {
        switch self {
        case .prominent: return 1.0
        case .normal: return 0.85
        case .subtle: return 0.60
        }
    }
}

/// Kılavuz Belirginliği
public enum GuideVisibility: String, CaseIterable, Identifiable, Codable {
    case normal = "Normal"
    case subtle = "Hafif"
    case hidden = "Gizli"
    
    public var id: String { rawValue }
    
    public var localizedName: String {
        switch self {
        case .normal: return "guide_normal".localized
        case .subtle: return "guide_subtle".localized
        case .hidden: return "guide_hidden".localized
        }
    }
    
    public var opacity: Double {
        switch self {
        case .normal: return 0.8
        case .subtle: return 0.35
        case .hidden: return 0.0
        }
    }
}

/// Metin Boyutu
public enum TextSizePreference: String, CaseIterable, Identifiable, Codable {
    case small = "Küçük"
    case normal = "Normal"
    case large = "Büyük"
    
    public var id: String { rawValue }
    
    public var localizedName: String {
        switch self {
        case .small: return "size_small".localized
        case .normal: return "size_normal".localized
        case .large: return "size_large".localized
        }
    }
    
    public var fontSize: CGFloat {
        switch self {
        case .small: return 38
        case .normal: return 48
        case .large: return 58
        }
    }
}
