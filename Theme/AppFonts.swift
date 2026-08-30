import SwiftUI

/// FastRead Tipografi Tanımlamaları
public struct AppFonts {
    // MARK: - Özel Monospace ve Karakteristik Fontlar
    public static func monoTitle(size: CGFloat = 22) -> Font {
        .system(size: size, weight: .semibold, design: .monospaced)
    }
    
    public static func monoBody(size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .monospaced)
    }
    
    public static func rsvpFont(family: FontPreference, size: CGFloat = 48) -> Font {
        switch family {
        case .normal:
            return .system(size: size, weight: .medium, design: .default)
        case .serif:
            return .system(size: size, weight: .regular, design: .serif)
        case .condensedSerif:
            return .system(size: size, weight: .light, design: .serif)
        case .openDyslexic:
            // Custom dyslexic design fallback with rounded/monospaced heavy baseline
            return .system(size: size, weight: .bold, design: .rounded)
        }
    }
}
