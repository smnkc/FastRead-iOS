import SwiftUI

/// Okuyucu Yazı Tipi Tercihleri
public enum FontPreference: String, CaseIterable, Identifiable, Codable {
    case normal = "Normal"
    case serif = "Serif"
    case condensedSerif = "Serif (Daraltılmış)"
    case openDyslexic = "OpenDyslexic"
    
    public var id: String { rawValue }
    
    public var displayName: String { rawValue }
}
