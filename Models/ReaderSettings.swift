import SwiftUI
import Combine

/// Cümle Sonu Bekleme Süresi
public enum SentenceEndDelay: String, CaseIterable, Identifiable, Codable {
    case none = "Yok"
    case short = "Kısa"
    case normal = "Normal"
    case long = "Uzun"
    
    public var id: String { rawValue }
    
    public var localizedName: String {
        switch self {
        case .none: return "delay_none".localized
        case .short: return "delay_short".localized
        case .normal: return "delay_normal".localized
        case .long: return "delay_long".localized
        }
    }
    
    public var multiplier: Double {
        switch self {
        case .none: return 1.0
        case .short: return 1.5
        case .normal: return 2.0
        case .long: return 2.8
        }
    }
}

/// Dokunsal Titreşim Yoğunluğu
public enum HapticIntensity: String, CaseIterable, Identifiable, Codable {
    case none = "Yok"
    case light = "Zayıf"
    case medium = "Orta"
    case strong = "Güçlü"
    
    public var id: String { rawValue }
    
    public var localizedName: String {
        switch self {
        case .none: return "haptic_none".localized
        case .light: return "haptic_light".localized
        case .medium: return "haptic_medium".localized
        case .strong: return "haptic_strong".localized
        }
    }
}

/// Kullanıcı Okuyucu Ayarları Deposu
@MainActor
public class ReaderSettings: ObservableObject {
    public static let shared = ReaderSettings()
    
    @AppStorage("fastread_wpm") public var wpm: Int = 380
    @AppStorage("fastread_sentence_delay") public var sentenceDelayRaw: String = SentenceEndDelay.short.rawValue
    @AppStorage("fastread_word_haptic") public var wordHapticRaw: String = HapticIntensity.none.rawValue
    @AppStorage("fastread_sentence_haptic") public var sentenceHapticRaw: String = HapticIntensity.medium.rawValue
    
    public var sentenceDelay: SentenceEndDelay {
        get { SentenceEndDelay(rawValue: sentenceDelayRaw) ?? .short }
        set { sentenceDelayRaw = newValue.rawValue }
    }
    
    public var wordHaptic: HapticIntensity {
        get { HapticIntensity(rawValue: wordHapticRaw) ?? .none }
        set { wordHapticRaw = newValue.rawValue }
    }
    
    public var sentenceHaptic: HapticIntensity {
        get { HapticIntensity(rawValue: sentenceHapticRaw) ?? .medium }
        set { sentenceHapticRaw = newValue.rawValue }
    }
    
    public var speedCategory: String {
        if wpm < 250 {
            return "speed_comfortable".localized
        } else if wpm < 400 {
            return "speed_fast".localized
        } else if wpm < 600 {
            return "speed_very_fast".localized
        } else {
            return "speed_turbo".localized
        }
    }
}
