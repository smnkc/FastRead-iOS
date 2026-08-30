import UIKit

/// FastRead Dokunsal Geri Bildirim Motoru
@MainActor
public class HapticsManager {
    public static let shared = HapticsManager()
    
    private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let softGenerator = UIImpactFeedbackGenerator(style: .soft)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    private init() {
        prepare()
    }
    
    public func prepare() {
        lightGenerator.prepare()
        mediumGenerator.prepare()
        heavyGenerator.prepare()
        softGenerator.prepare()
    }
    
    public func trigger(intensity: HapticIntensity) {
        switch intensity {
        case .none:
            break
        case .light:
            softGenerator.impactOccurred(intensity: 0.5)
        case .medium:
            mediumGenerator.impactOccurred(intensity: 0.75)
        case .strong:
            heavyGenerator.impactOccurred(intensity: 1.0)
        }
    }
    
    public func triggerSentenceEnd(intensity: HapticIntensity) {
        switch intensity {
        case .none:
            break
        case .light:
            mediumGenerator.impactOccurred(intensity: 0.6)
        case .medium:
            heavyGenerator.impactOccurred(intensity: 0.85)
        case .strong:
            notificationGenerator.notificationOccurred(.success)
        }
    }
}
