import UIKit

/// FastRead Dokunsal Geri Bildirim Motoru (Apple Taptic Engine)
@MainActor
public class HapticsManager {
    public static let shared = HapticsManager()
    
    private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let softGenerator = UIImpactFeedbackGenerator(style: .soft)
    private let rigidGenerator = UIImpactFeedbackGenerator(style: .rigid)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    private init() {
        prepare()
    }
    
    public func prepare() {
        lightGenerator.prepare()
        mediumGenerator.prepare()
        heavyGenerator.prepare()
        softGenerator.prepare()
        rigidGenerator.prepare()
        notificationGenerator.prepare()
    }
    
    /// Kelime Başı Titreşimi
    public func trigger(intensity: HapticIntensity) {
        switch intensity {
        case .none:
            break
        case .light:
            softGenerator.impactOccurred(intensity: 0.6)
            softGenerator.prepare()
        case .medium:
            mediumGenerator.impactOccurred(intensity: 0.8)
            mediumGenerator.prepare()
        case .strong:
            rigidGenerator.impactOccurred(intensity: 1.0)
            rigidGenerator.prepare()
        }
    }
    
    /// Cümle Sonu (. ! ?) Titreşimi
    public func triggerSentenceEnd(intensity: HapticIntensity) {
        switch intensity {
        case .none:
            break
        case .light:
            mediumGenerator.impactOccurred(intensity: 0.7)
            mediumGenerator.prepare()
        case .medium:
            heavyGenerator.impactOccurred(intensity: 0.95)
            heavyGenerator.prepare()
        case .strong:
            notificationGenerator.notificationOccurred(.success)
            notificationGenerator.prepare()
        }
    }
}
