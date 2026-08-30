import SwiftUI

/// PreferenceKey to measure the exact width of the ORP character
struct ORPWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 20
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

/// RSVP Odak Kılavuz Çizgileri ve Milimetrik Merkezlenmiş Kelime Görünümü
public struct RSVPCenteredWordView: View {
    let token: RSVPWordToken?
    var customText: String? = nil
    var previewTheme: ReaderBackground? = nil
    
    @ObservedObject private var theme = ThemeManager.shared
    @State private var orpCharWidth: CGFloat = 22
    
    public init(token: RSVPWordToken? = nil, customText: String? = nil, previewTheme: ReaderBackground? = nil) {
        self.token = token
        self.customText = customText
        self.previewTheme = previewTheme
    }
    
    public var body: some View {
        let currentBg = previewTheme ?? theme.background
        let isDark = currentBg.isDark
        
        let textColor = isDark ? Color.white.opacity(theme.contrast.opacity) : AppColors.textPrimary.opacity(theme.contrast.opacity)
        let guideLineColor = isDark ? Color.white.opacity(0.20) : Color.black.opacity(0.18)
        let guideTickColor = isDark ? Color.white.opacity(0.70) : Color.black.opacity(0.50)
        
        let displayToken: RSVPWordToken = {
            if let customText = customText {
                return RSVPWordToken(id: 0, text: customText)
            } else if let token = token {
                return token
            } else {
                return RSVPWordToken(id: 0, text: "FastRead")
            }
        }()
        
        ZStack {
            // Arka Plan
            if currentBg == .gradient {
                AppColors.readerGradient
            } else {
                currentBg.color
            }
            
            GeometryReader { geo in
                let focalX = geo.size.width * 0.50 // Ekranın tam yatay orta çizgisi (%50)
                let centerY = geo.size.height * 0.50 // Dikey orta nokta
                let rsvpFont = AppFonts.rsvpFont(family: theme.fontPreference, size: theme.textSize.fontSize)
                let halfORP = max(4, orpCharWidth / 2)
                let prefixWidth = max(0, focalX - halfORP)
                let suffixWidth = max(0, geo.size.width - (focalX + halfORP))
                
                ZStack(alignment: .topLeading) {
                    // 1. KILAVUZ ÇİZGİLERİ VE ÇENTİKLER (Tam focalX Noktasında)
                    VStack(spacing: 0) {
                        // Üst Kılavuz Çizgisi (Çizgi üstte, çentik aşağı doğru kelimeye iner)
                        ZStack(alignment: .top) {
                            Rectangle()
                                .fill(guideLineColor)
                                .frame(height: 1)
                            
                            Rectangle()
                                .fill(guideTickColor)
                                .frame(width: 1.5, height: 16)
                                .position(x: focalX, y: 8)
                        }
                        .frame(height: 16)
                        
                        Spacer(minLength: 0)
                        
                        // Alt Kılavuz Çizgisi (Çizgi altta, çentik yukarı doğru kelimeye çıkar)
                        ZStack(alignment: .bottom) {
                            Rectangle()
                                .fill(guideLineColor)
                                .frame(height: 1)
                            
                            Rectangle()
                                .fill(guideTickColor)
                                .frame(width: 1.5, height: 16)
                                .position(x: focalX, y: 8)
                        }
                        .frame(height: 16)
                    }
                    .opacity(theme.guideVisibility.opacity)
                    
                    // 2. ORP ODAK HARFİ (Merkezi TAM focalX çizgisine kilitlenir)
                    Text(displayToken.orpChar)
                        .font(rsvpFont)
                        .foregroundColor(theme.orpColor.color)
                        .lineLimit(1)
                        .fixedSize()
                        .background(
                            GeometryReader { orpGeo in
                                Color.clear.preference(key: ORPWidthKey.self, value: orpGeo.size.width)
                            }
                        )
                        .position(x: focalX, y: centerY)
                    
                    // 3. ÖN EK (Sağ kenarı ORP harfinin soluna tam değerle oturur)
                    if !displayToken.prefix.isEmpty {
                        Text(displayToken.prefix)
                            .font(rsvpFont)
                            .foregroundColor(textColor)
                            .lineLimit(1)
                            .fixedSize()
                            .frame(width: prefixWidth, alignment: .trailing)
                            .position(x: prefixWidth / 2, y: centerY)
                    }
                    
                    // 4. SON EK (Sol kenarı ORP harfinin sağına tam değerle oturur)
                    if !displayToken.suffix.isEmpty {
                        Text(displayToken.suffix)
                            .font(rsvpFont)
                            .foregroundColor(textColor)
                            .lineLimit(1)
                            .fixedSize()
                            .frame(width: suffixWidth, alignment: .leading)
                            .position(x: (focalX + halfORP) + (suffixWidth / 2), y: centerY)
                    }
                }
                .onPreferenceChange(ORPWidthKey.self) { measuredWidth in
                    if measuredWidth > 0 && abs(measuredWidth - self.orpCharWidth) > 0.5 {
                        self.orpCharWidth = measuredWidth
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140)
    }
}
