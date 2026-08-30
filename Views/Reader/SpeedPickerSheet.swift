import SwiftUI

/// Okuma Hızı Seçici Modalı (WPM Picker Sheet)
public struct SpeedPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var settings = ReaderSettings.shared
    
    @State private var selectedWPM: Int
    
    private let speeds: [Int] = Array(stride(from: 100, through: 1000, by: 10))
    
    public init() {
        _selectedWPM = State(initialValue: ReaderSettings.shared.wpm)
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            // Üst Başlık Barı
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(AppColors.subtleGray)
                        )
                }
                
                Spacer()
                
                Text("Okuma hızı")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Color.clear
                    .frame(width: 44, height: 44)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Spacer()
            
            // Hız Seçim Çarkı / Listesi
            Picker("Okuma Hızı", selection: $selectedWPM) {
                ForEach(speeds, id: \.self) { wpm in
                    Text("\(wpm) kelime/dk")
                        .font(.system(size: 20, weight: selectedWPM == wpm ? .semibold : .regular))
                        .foregroundColor(selectedWPM == wpm ? AppColors.textPrimary : AppColors.textTertiary)
                        .tag(wpm)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 200)
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Kaydet Butonu
            CustomPillButton(
                title: "Kaydet",
                backgroundColor: AppColors.buttonPrimary,
                foregroundColor: AppColors.textPrimary,
                isFullWidth: true,
                height: 52
            ) {
                settings.wpm = selectedWPM
                dismiss()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color.white)
                .ignoresSafeArea()
        )
    }
}
