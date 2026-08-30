import SwiftUI

/// Okuyucu Görünümü Özelleştirme Ekranı
public struct ReaderAppearanceView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var theme = ThemeManager.shared
    @AppStorage("hasShownAppearanceInfoModal") private var hasShownAppearanceInfoModal: Bool = false
    
    @State private var showInfoModal: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            AppColors.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ÜST BAŞLIK VE GERİ BUTONU
                ZStack(alignment: .bottom) {
                    AppColors.headerGradient
                        .frame(height: 100)
                        .ignoresSafeArea(edges: .top)
                    
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.85))
                                )
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                }
                
                // BAŞLIK
                HStack {
                    Text("appr_title".localized)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 4)
                .padding(.bottom, 10)
                
                // 1. SABİT (PINNED) CANLI ÖNİZLEME KARTI - KAYDIRIRKEN DE ÜSTTE KALIR
                VStack(alignment: .leading, spacing: 6) {
                    Text("appr_preview".localized)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.leading, 8)
                    
                    RSVPCenteredWordView(customText: "FastRead", previewTheme: theme.background)
                        .frame(height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.black.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 14, x: 0, y: 6)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
                
                // 2. KAYDIRILABİLİR AYARLAR BÖLÜMÜ
                ScrollView {
                    VStack(spacing: 16) {
                        // ÖN AYARLAR (Presets)
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundColor(AppColors.textPrimary)
                                Text("appr_presets_title".localized)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.textPrimary)
                            }
                            
                            Text("appr_presets_desc".localized)
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(AppColors.textSecondary)
                                .lineSpacing(3)
                            
                            HStack(spacing: 6) {
                                ForEach(ThemePreset.allCases) { item in
                                    let isSelected = theme.preset == item
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            theme.preset = item
                                        }
                                    }) {
                                        Text(item.localizedName)
                                            .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                                            .foregroundColor(AppColors.textPrimary)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 38)
                                            .background(
                                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                    .fill(isSelected ? Color.white : Color.clear)
                                                    .shadow(color: isSelected ? Color.black.opacity(0.06) : Color.clear, radius: 4, y: 2)
                                            )
                                    }
                                }
                            }
                            .padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(AppColors.subtleGray)
                            )
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
                        )
                        .padding(.horizontal, 20)
                        
                        // DETAYLI GÖRÜNÜM AYARLARI KARTI
                        VStack(alignment: .leading, spacing: 18) {
                            Text("appr_section_appearance".localized)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(AppColors.textSecondary)
                                .textCase(.uppercase)
                            
                            // A) Arka Plan Dropdown (Ekran 23)
                            HStack {
                                Image(systemName: "circle.lefthalf.filled")
                                    .foregroundColor(AppColors.textPrimary)
                                Text("appr_bg_title".localized)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                Menu {
                                    ForEach(ReaderBackground.allCases) { bg in
                                        Button(action: {
                                            withAnimation {
                                                theme.background = bg
                                            }
                                        }) {
                                            HStack {
                                                Text(bg.localizedName)
                                                if theme.background == bg {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 6) {
                                        Text(theme.background.localizedName)
                                            .font(.system(size: 15, weight: .medium))
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.system(size: 12, weight: .medium))
                                    }
                                    .foregroundColor(AppColors.textPrimary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(AppColors.subtleGray)
                                    )
                                }
                            }
                            
                            Divider()
                            
                            // B) Metin Rengi / Kontrast
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("A")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(AppColors.textPrimary)
                                    Text("appr_text_color_title".localized)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(AppColors.textPrimary)
                                }
                                
                                HStack(spacing: 6) {
                                    ForEach(TextContrast.allCases) { item in
                                        let isSelected = theme.contrast == item
                                        Button(action: {
                                            withAnimation {
                                                theme.contrast = item
                                            }
                                        }) {
                                            Text(item.localizedName)
                                                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                                                .foregroundColor(AppColors.textPrimary)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 36)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                        .fill(isSelected ? Color.white : Color.clear)
                                                        .shadow(color: isSelected ? Color.black.opacity(0.06) : Color.clear, radius: 4, y: 2)
                                                )
                                        }
                                    }
                                }
                                .padding(4)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(AppColors.subtleGray)
                                )
                            }
                            
                            Divider()
                            
                            // C) Odak Harfi Rengi (8-Renk Paleti - Ekran 24)
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Aa")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(AppColors.textPrimary)
                                    Text("appr_orp_color_title".localized)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(AppColors.textPrimary)
                                }
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7), spacing: 10) {
                                    ForEach(ORPColor.allCases) { colorItem in
                                        let isSelected = theme.orpColor == colorItem
                                        
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                theme.orpColor = colorItem
                                            }
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill(colorItem.color)
                                                    .frame(width: 34, height: 34)
                                                
                                                if isSelected {
                                                    Circle()
                                                        .stroke(AppColors.textPrimary, lineWidth: 2.5)
                                                        .frame(width: 42, height: 42)
                                                }
                                            }
                                            .frame(height: 44)
                                        }
                                    }
                                }
                            }
                            
                            Divider()
                            
                            // D) Kılavuz Belirginliği
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "line.3.horizontal")
                                        .foregroundColor(AppColors.textPrimary)
                                    Text("appr_guide_vis_title".localized)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(AppColors.textPrimary)
                                }
                                
                                HStack(spacing: 6) {
                                    ForEach(GuideVisibility.allCases) { item in
                                        let isSelected = theme.guideVisibility == item
                                        Button(action: {
                                            withAnimation {
                                                theme.guideVisibility = item
                                            }
                                        }) {
                                            Text(item.localizedName)
                                                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                                                .foregroundColor(AppColors.textPrimary)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 36)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                        .fill(isSelected ? Color.white : Color.clear)
                                                        .shadow(color: isSelected ? Color.black.opacity(0.06) : Color.clear, radius: 4, y: 2)
                                                )
                                        }
                                    }
                                }
                                .padding(4)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(AppColors.subtleGray)
                                )
                            }
                            
                            Divider()
                            
                            // E) Metin Boyutu
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("aA")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(AppColors.textPrimary)
                                    Text("appr_text_size_title".localized)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(AppColors.textPrimary)
                                }
                                
                                HStack(spacing: 6) {
                                    ForEach(TextSizePreference.allCases) { item in
                                        let isSelected = theme.textSize == item
                                        Button(action: {
                                            withAnimation {
                                                theme.textSize = item
                                            }
                                        }) {
                                            Text(item.localizedName)
                                                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                                                .foregroundColor(AppColors.textPrimary)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 36)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                        .fill(isSelected ? Color.white : Color.clear)
                                                        .shadow(color: isSelected ? Color.black.opacity(0.06) : Color.clear, radius: 4, y: 2)
                                                )
                                        }
                                    }
                                }
                                .padding(4)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(AppColors.subtleGray)
                                )
                            }
                            
                            Divider()
                            
                            // F) Yazı Tipi Dropdown (Ekran 25)
                            HStack {
                                Image(systemName: "pencil.line")
                                    .foregroundColor(AppColors.textPrimary)
                                Text("appr_font_title".localized)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                Menu {
                                    ForEach(FontPreference.allCases) { font in
                                        Button(action: {
                                            withAnimation {
                                                theme.fontPreference = font
                                            }
                                        }) {
                                            HStack {
                                                Text(font.displayName)
                                                if theme.fontPreference == font {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 6) {
                                        Text(theme.fontPreference.displayName)
                                            .font(.system(size: 15, weight: .medium))
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.system(size: 12, weight: .medium))
                                    }
                                    .foregroundColor(AppColors.textPrimary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(AppColors.subtleGray)
                                    )
                                }
                            }
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
                        )
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
