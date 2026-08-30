import SwiftUI

/// Tam Ekran RSVP Oynatıcı (Player View) & Gece / Odak Modu
public struct RSVPPlayerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var engine = RSVPEngine.shared
    @ObservedObject private var theme = ThemeManager.shared
    @ObservedObject private var settings = ReaderSettings.shared
    
    @State private var showNavigator: Bool = false
    @State private var showSpeedPicker: Bool = false
    @State private var showSettingsSheet: Bool = false
    @State private var isZenMode: Bool = false // Ekrandakileri Gizle / Gece Odak Modu
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // 1. ARKA PLAN
            if theme.background == .gradient {
                AppColors.readerGradient
                    .ignoresSafeArea()
            } else {
                theme.background.color
                    .ignoresSafeArea()
            }
            
            // 2. TÜM EKRANA DOKUNARAK OYNAT / DURDUR
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    engine.togglePlayPause()
                }
            
            // 3. MERKEZ RSVP ODAK ALANI (SABİT - ASLA KAYMAZ)
            RSVPCenteredWordView(token: engine.currentToken)
                .contentShape(Rectangle())
                .onTapGesture {
                    engine.togglePlayPause()
                }
            
            // 4. KONTROL VE BİLGİ KATMANI (Üst ve Alt Arayüz Elemanları)
            VStack(spacing: 0) {
                // ÜST BAR (Sol X, Orta Gizle/Odak, Sağ ...)
                HStack {
                    Button(action: {
                        engine.pause()
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.9))
                                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
                            )
                    }
                    
                    Spacer()
                    
                    // EK MEKAN: EKRENDEKİLERİ GİZLE (ODAK / GECE MODU)
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isZenMode = true
                        }
                    }) {
                        Image(systemName: "eye.slash")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.9))
                                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
                            )
                    }
                    
                    // Üç Nokta Seçenekler Menüsü
                    Menu {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                isZenMode = true
                            }
                        }) {
                            Label("menu_zen_mode".localized, systemImage: "eye.slash")
                        }
                        
                        Divider()
                        
                        Button(action: {
                            showSpeedPicker = true
                        }) {
                            Label("menu_speed".localized, systemImage: "speedometer")
                        }
                        
                        Button(action: {
                            showSettingsSheet = true
                        }) {
                            Label("menu_settings".localized, systemImage: "gearshape")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.9))
                                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                
                // DURUM BİLGİLENDİRME KARTI (Tooltip)
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(engine.isPlaying ? "tap_to_pause".localized : "tap_to_play".localized)
                                .font(AppFonts.monoTitle(size: 16))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text(engine.isPlaying ? "tap_to_pause_desc".localized : "tap_to_play_desc".localized)
                                .font(AppFonts.monoBody(size: 13))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "hand.tap")
                            .font(.system(size: 24, weight: .light))
                            .foregroundColor(AppColors.textPrimary.opacity(0.7))
                    }
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.92))
                        .shadow(color: Color.black.opacity(0.05), radius: 16, x: 0, y: 6)
                )
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
                // ALT KONTROL PANELİ
                VStack(spacing: 16) {
                    // Süre ve Slider
                    HStack {
                        Text(engine.elapsedTimeFormatted)
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Slider(
                            value: Binding(
                                get: { Double(engine.currentIndex) },
                                set: { engine.jumpToIndex(Int($0)) }
                            ),
                            in: 0...Double(max(1, engine.totalWords - 1))
                        )
                        .tint(AppColors.textSecondary.opacity(0.4))
                        
                        Text(engine.totalTimeFormatted)
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(.horizontal, 4)
                    
                    // Alt Butonlar (Gezgin & Oynat/Duraklat)
                    HStack(spacing: 12) {
                        // Gezgin Butonu
                        CustomPillButton(
                            title: "btn_navigator".localized,
                            icon: "text.justify",
                            backgroundColor: AppColors.subtleGray,
                            foregroundColor: AppColors.textPrimary,
                            isFullWidth: true,
                            height: 50
                        ) {
                            engine.pause()
                            showNavigator = true
                        }
                        
                        // Oynat / Duraklat Butonu
                        CustomPillButton(
                            title: engine.isPlaying ? "btn_pause".localized : "btn_play".localized,
                            icon: engine.isPlaying ? "pause.fill" : "play.fill",
                            backgroundColor: AppColors.subtleGray,
                            foregroundColor: AppColors.textPrimary,
                            isFullWidth: true,
                            height: 50
                        ) {
                            engine.togglePlayPause()
                        }
                    }
                    
                    // Versiyon ve Marka Alt Bilgisi
                    HStack {
                        Text("FastRead")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(AppColors.textTertiary)
                        
                        Spacer()
                        
                        Text("v1.0.0")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(AppColors.textTertiary)
                    }
                    .padding(.horizontal, 4)
                }
                .padding(22)
                .background(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white.opacity(0.95))
                        .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 8)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
            .opacity(isZenMode ? 0 : 1)
            .allowsHitTesting(!isZenMode)
            .animation(.easeInOut(duration: 0.25), value: isZenMode)
            
            // 5. ODAK MODUNDA KÜÇÜK GERİ GETİRME BUTONU (Sağ Üstte yarı saydam)
            if isZenMode {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                isZenMode = false
                            }
                        }) {
                            Image(systemName: "eye")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(AppColors.textPrimary.opacity(0.6))
                                .frame(width: 38, height: 38)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.75))
                                        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                                )
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 16)
                    }
                    Spacer()
                }
                .transition(.opacity)
            }
        }
        .sheet(isPresented: $showNavigator) {
            ContentNavigatorView()
        }
        .sheet(isPresented: $showSpeedPicker) {
            SpeedPickerSheet()
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showSettingsSheet) {
            NavigationView {
                SettingsView(isModal: true)
            }
        }
    }
}
