import SwiftUI

/// FastRead Uygulama Renk Paleti ve Gradyanlar
public struct AppColors {
    // MARK: - Arka Plan Degradeleri
    public static let roseGradientStart = Color(red: 1.0, green: 0.88, blue: 0.90) // #FFE0E6
    public static let roseGradientEnd = Color(red: 1.0, green: 0.96, blue: 0.96)   // #FFF5F5
    public static let appBackground = Color(red: 0.96, green: 0.96, blue: 0.97)     // #F5F5F7
    
    // MARK: - Kart ve Panel Renkleri
    public static let cardBackground = Color.white
    public static let cardBorder = Color(red: 0.90, green: 0.90, blue: 0.92)
    public static let subtleGray = Color(red: 0.93, green: 0.93, blue: 0.95)       // #EDEDF2
    public static let pillBackground = Color(red: 0.94, green: 0.94, blue: 0.96)
    public static let buttonPrimary = Color(red: 0.92, green: 0.92, blue: 0.94)
    public static let sampleButton = Color(red: 0.88, green: 0.72, blue: 0.74)      // Soft rose button
    
    // MARK: - Metin Renkleri
    public static let textPrimary = Color(red: 0.12, green: 0.13, blue: 0.14)      // #1F2124
    public static let textSecondary = Color(red: 0.45, green: 0.45, blue: 0.48)    // #73737A
    public static let textTertiary = Color(red: 0.65, green: 0.65, blue: 0.68)     // #A6A6AD
    
    // MARK: - ORP Odak Renkleri (Varsayılan Kırmızı)
    public static let orpRed = Color(red: 0.95, green: 0.22, blue: 0.20)          // #F23833
    public static let orpOrange = Color(red: 1.00, green: 0.58, blue: 0.00)
    public static let orpYellow = Color(red: 1.00, green: 0.80, blue: 0.00)
    public static let orpGreen = Color(red: 0.20, green: 0.78, blue: 0.35)
    public static let orpCyan = Color(red: 0.00, green: 0.78, blue: 0.75)
    public static let orpBlue = Color(red: 0.35, green: 0.34, blue: 0.84)
    public static let orpPurple = Color(red: 0.69, green: 0.32, blue: 0.87)
    public static let orpBlack = Color(red: 0.10, green: 0.10, blue: 0.10)
    
    // MARK: - Tema Arka Planları
    public static let readerWarmGray = Color(red: 0.95, green: 0.93, blue: 0.88)   // Kitap Sepya
    public static let readerCoolGray = Color(red: 0.92, green: 0.93, blue: 0.95)   // Soğuk Gri
    public static let readerWhite = Color.white                                     // Saf Beyaz
    public static let readerDark = Color(red: 0.12, green: 0.12, blue: 0.14)       // Koyu Mod
    
    // MARK: - Gradyan Arka Planı (Okuyucu için)
    public static let readerGradient = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.92, blue: 0.92),
            Color(red: 0.92, green: 0.94, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let headerGradient = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.65, blue: 0.70),
            Color(red: 1.0, green: 0.85, blue: 0.88),
            Color(red: 0.98, green: 0.98, blue: 0.99)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
