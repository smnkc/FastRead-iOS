import SwiftUI

/// Okuyucu Zamanlaması Ayarları Ekranı
public struct ReaderTimingView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var settings = ReaderSettings.shared
    @AppStorage("hasShownTimingInfoModal") private var hasShownTimingInfoModal: Bool = false
    
    @State private var showInfoModal: Bool = false
    @State private var showSpeedPicker: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            AppColors.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ÜST BAŞLIK VE GERİ BUTONU
                ZStack(alignment: .bottom) {
                    AppColors.headerGradient
                        .frame(height: 120)
                        .ignoresSafeArea(edges: .top)
                    
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.85))
                                )
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                }
                
                // BAŞLIK
                HStack {
                    Text("Okuyucu zamanlaması")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 20)
                
                // ZAMANLAMA AYARLARI KARTI
                VStack(alignment: .leading, spacing: 18) {
                    Text("Zamanlama")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppColors.textSecondary)
                        .textCase(.uppercase)
                    
                    VStack(spacing: 16) {
                        // 1. Hız Ayarı Satırı
                        Button(action: {
                            showSpeedPicker = true
                        }) {
                            HStack {
                                Image(systemName: "speedometer")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("Hız")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                HStack(spacing: 6) {
                                    Text("\(settings.wpm) kelime/dk")
                                        .font(.system(size: 13, weight: .semibold))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(
                                            Capsule()
                                                .fill(AppColors.subtleGray)
                                        )
                                    
                                    Text(settings.speedCategory)
                                        .font(.system(size: 13, weight: .medium))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(
                                            Capsule()
                                                .fill(AppColors.subtleGray)
                                        )
                                    
                                    Image(systemName: "ellipsis")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(AppColors.textTertiary)
                                }
                                .foregroundColor(AppColors.textPrimary)
                            }
                        }
                        
                        Divider()
                            .padding(.leading, 32)
                        
                        // 2. Cümle Sonu Beklemesi Satırı
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "clock")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Text("Cümle sonu beklemesi")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.textPrimary)
                            }
                            
                            Text("Her cümlenin son kelimesinde ne kadar duraklanacağı.")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(AppColors.textSecondary)
                                .padding(.leading, 32)
                            
                            // Segment Seçici
                            HStack(spacing: 6) {
                                ForEach(SentenceEndDelay.allCases) { item in
                                    let isSelected = settings.sentenceDelay == item
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            settings.sentenceDelay = item
                                        }
                                    }) {
                                        Text(item.rawValue)
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
                            .padding(.leading, 32)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            
            // BİLGİLENDİRME MODALI (Ekran 17)
            if showInfoModal {
                CustomModalDialog(
                    title: "Okuyucu zamanlaması",
                    message: "Hızı ve bekleme sürelerini ayarlayarak okuyucu zamanlamasını özelleştirin.",
                    buttonTitle: "Anladım"
                ) {
                    showInfoModal = false
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if !hasShownTimingInfoModal {
                hasShownTimingInfoModal = true
                showInfoModal = true
            }
        }
        .sheet(isPresented: $showSpeedPicker) {
            SpeedPickerSheet()
                .presentationDetents([.medium])
        }
    }
}
