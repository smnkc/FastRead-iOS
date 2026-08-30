import SwiftUI

/// Okuyucu Dokunsal Geri Bildirim (Haptics) Ayarları
public struct ReaderHapticsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var settings = ReaderSettings.shared
    
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
                    Text("Okuyucu hissi")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // BİLGİLENDİRME KARTI
                        VStack(alignment: .leading, spacing: 8) {
                            Text("FastRead, okurken dokunsal geri bildirim verilmesini sağlar. Bu, kavrayışı artırmaya ve ilgiyi sürdürmeye yardımcı olur.")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(AppColors.textSecondary)
                                .lineSpacing(4)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
                        )
                        .padding(.horizontal, 20)
                        
                        // HİS AYARLARI KARTI (Ekran 26)
                        VStack(alignment: .leading, spacing: 18) {
                            Text("His")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(AppColors.textSecondary)
                                .textCase(.uppercase)
                            
                            // 1. Kelime Haptiği
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "waveform")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Text("Kelime")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(AppColors.textPrimary)
                                }
                                
                                Text("Her kelimenin başında verilecek dokunsal geri bildirim.")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(AppColors.textSecondary)
                                    .padding(.leading, 28)
                                
                                // Segment Seçici
                                HStack(spacing: 6) {
                                    ForEach(HapticIntensity.allCases) { item in
                                        let isSelected = settings.wordHaptic == item
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                settings.wordHaptic = item
                                                HapticsManager.shared.trigger(intensity: item)
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
                                .padding(.leading, 28)
                            }
                            
                            Divider()
                            
                            // 2. Cümle Sonu Haptiği
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "waveform.path")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Text("Cümle sonu")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(AppColors.textPrimary)
                                }
                                
                                Text("Her cümlenin sonunda verilecek dokunsal geri bildirim.")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(AppColors.textSecondary)
                                    .padding(.leading, 28)
                                
                                // Segment Seçici
                                HStack(spacing: 6) {
                                    ForEach(HapticIntensity.allCases) { item in
                                        let isSelected = settings.sentenceHaptic == item
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                settings.sentenceHaptic = item
                                                HapticsManager.shared.triggerSentenceEnd(intensity: item)
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
                                .padding(.leading, 28)
                            }
                        }
                        .padding(20)
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
