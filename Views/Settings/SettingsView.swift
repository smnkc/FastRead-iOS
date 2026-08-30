import SwiftUI

/// Ayarlar Ana Ekranı
public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    var isModal: Bool = false
    
    @State private var showShareSheet: Bool = false
    
    public init(isModal: Bool = false) {
        self.isModal = isModal
    }
    
    public var body: some View {
        ZStack {
            AppColors.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ÜST BAŞLIK VE KAPAT BUTONU (Degrade Zeminli)
                ZStack(alignment: .bottom) {
                    AppColors.headerGradient
                        .frame(height: 120)
                        .ignoresSafeArea(edges: .top)
                    
                    HStack(alignment: .center) {
                        if isModal {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(AppColors.textPrimary)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(Color.white.opacity(0.85))
                                    )
                            }
                        }
                        
                        Text("Ayarlar")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
                }
                
                ScrollView {
                    VStack(spacing: 24) {
                        // 1. OKUYUCU GRUBU (Ekran 20)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Okuyucu")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(AppColors.textSecondary)
                                .textCase(.uppercase)
                                .padding(.leading, 8)
                            
                            VStack(spacing: 0) {
                                // A) Zamanlama
                                NavigationLink(destination: ReaderTimingView()) {
                                    SettingsNavigationRow(
                                        icon: "speedometer",
                                        title: "Zamanlama",
                                        subtitle: "Okuyucunuzun zamanlamasını özelleştirin."
                                    )
                                }
                                
                                Divider().padding(.leading, 56)
                                
                                // B) Görünüm
                                NavigationLink(destination: ReaderAppearanceView()) {
                                    SettingsNavigationRow(
                                        icon: "sparkles",
                                        title: "Görünüm",
                                        subtitle: "Okuyucunuzun görünümünü özelleştirin."
                                    )
                                }
                                
                                Divider().padding(.leading, 56)
                                
                                // C) His (Dokunsal)
                                NavigationLink(destination: ReaderHapticsView()) {
                                    SettingsNavigationRow(
                                        icon: "waveform",
                                        title: "His",
                                        subtitle: "Okuyucunuzun hissini özelleştirin."
                                    )
                                }
                            }
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // 2. PAYLAŞ GRUBU (Ekran 16)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Paylaş")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(AppColors.textSecondary)
                                .textCase(.uppercase)
                                .padding(.leading, 8)
                            
                            Button(action: {
                                showShareSheet = true
                            }) {
                                HStack(spacing: 14) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(AppColors.textPrimary)
                                        .frame(width: 28)
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Paylaş")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(AppColors.textPrimary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("FastRead hoşunuza gidiyor mu? Bir arkadaşınızla paylaşın.")
                                            .font(.system(size: 13, weight: .regular))
                                            .foregroundColor(AppColors.textSecondary)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "ellipsis")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(AppColors.textTertiary)
                                }
                                .padding(18)
                                .background(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
                                )
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                        .padding(.horizontal, 20)
                        
                        // 3. HAKKINDA GRUBU (Ekran 16)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Hakkında")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(AppColors.textSecondary)
                                .textCase(.uppercase)
                                .padding(.leading, 8)
                            
                            VStack(spacing: 0) {
                                HStack(spacing: 14) {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(AppColors.textPrimary)
                                        .frame(width: 28)
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Yazar")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(AppColors.textPrimary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("Osman Akça tarafından ❤️ ile yapıldı.")
                                            .font(.system(size: 13, weight: .regular))
                                            .foregroundColor(AppColors.textSecondary)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(18)
                                
                                Divider().padding(.leading, 56)
                                
                                HStack(spacing: 14) {
                                    Image(systemName: "info.circle")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(AppColors.textPrimary)
                                        .frame(width: 28)
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Sürüm")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(AppColors.textPrimary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("v1.0.0 (Build 1)")
                                            .font(.system(size: 13, weight: .regular))
                                            .foregroundColor(AppColors.textSecondary)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(18)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 130) // Floating tab bar'ın altında kalmaması için geniş alt boşluk
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showShareSheet) {
            ActivityViewController(activityItems: ["FastRead ile bilimsel RSVP tekniğini kullanarak 3 kata kadar daha hızlı okuyun!"])
        }
    }
}

/// Ayarlar Gezinme Satırı
struct SettingsNavigationRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.textTertiary)
        }
        .padding(18)
    }
}

/// Paylaşım Sheet Köprüsü (UIActivityViewController)
struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}
