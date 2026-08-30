import SwiftUI
import Combine

/// Dinamik Tema ve Görünüm Yöneticisi
@MainActor
public class ThemeManager: ObservableObject {
    public static let shared = ThemeManager()
    
    @AppStorage("fastread_preset") public var presetRaw: String = ThemePreset.classic.rawValue
    @AppStorage("fastread_background") public var backgroundRaw: String = ReaderBackground.grey.rawValue
    @AppStorage("fastread_contrast") public var contrastRaw: String = TextContrast.normal.rawValue
    @AppStorage("fastread_orp_color") public var orpColorRaw: String = ORPColor.red.rawValue
    @AppStorage("fastread_guide_vis") public var guideVisibilityRaw: String = GuideVisibility.normal.rawValue
    @AppStorage("fastread_text_size") public var textSizeRaw: String = TextSizePreference.normal.rawValue
    @AppStorage("fastread_font_pref") public var fontPrefRaw: String = FontPreference.serif.rawValue
    
    public var preset: ThemePreset {
        get { ThemePreset(rawValue: presetRaw) ?? .classic }
        set {
            presetRaw = newValue.rawValue
            applyPreset(newValue)
        }
    }
    
    public var background: ReaderBackground {
        get { ReaderBackground(rawValue: backgroundRaw) ?? .grey }
        set { backgroundRaw = newValue.rawValue }
    }
    
    public var contrast: TextContrast {
        get { TextContrast(rawValue: contrastRaw) ?? .normal }
        set { contrastRaw = newValue.rawValue }
    }
    
    public var orpColor: ORPColor {
        get { ORPColor(rawValue: orpColorRaw) ?? .red }
        set { orpColorRaw = newValue.rawValue }
    }
    
    public var guideVisibility: GuideVisibility {
        get { GuideVisibility(rawValue: guideVisibilityRaw) ?? .normal }
        set { guideVisibilityRaw = newValue.rawValue }
    }
    
    public var textSize: TextSizePreference {
        get { TextSizePreference(rawValue: textSizeRaw) ?? .normal }
        set { textSizeRaw = newValue.rawValue }
    }
    
    public var fontPreference: FontPreference {
        get { FontPreference(rawValue: fontPrefRaw) ?? .serif }
        set { fontPrefRaw = newValue.rawValue }
    }
    
    public func applyPreset(_ preset: ThemePreset) {
        switch preset {
        case .classic:
            self.background = .grey
            self.contrast = .normal
            self.orpColor = .red
            self.fontPreference = .serif
        case .book:
            self.background = .warmGrey
            self.contrast = .normal
            self.orpColor = .red
            self.fontPreference = .serif
        case .oled:
            self.background = .oledBlack
            self.contrast = .prominent
            self.orpColor = .red
            self.fontPreference = .serif
        case .gradient:
            self.background = .gradient
            self.contrast = .normal
            self.orpColor = .red
            self.fontPreference = .serif
        }
    }
}
