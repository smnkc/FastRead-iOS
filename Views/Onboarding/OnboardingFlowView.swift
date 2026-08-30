import SwiftUI

/// Modern Tanıtım ve Karşılama Ekranı (Welcome Presentation Screen)
public struct OnboardingFlowView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Arka Plan Degradeli Zemin
            LinearGradient(
                colors: [
                    AppColors.roseGradientStart,
                    AppColors.roseGradientEnd,
                    AppColors.appBackground
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {
                        // 1. ÜST İKON VE BAŞLIK
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 88, height: 88)
                                    .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
                                
                                Image(systemName: "book.pages.fill")
                                    .font(.system(size: 40, weight: .semibold))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [AppColors.orpRed, Color.orange],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                            .padding(.top, 24)
                            
                            VStack(spacing: 6) {
                                HStack(spacing: 0) {
                                    Text("Fast")
                                        .foregroundColor(AppColors.textPrimary)
                                    Text("R")
                                        .foregroundColor(AppColors.orpRed)
                                    Text("ead")
                                        .foregroundColor(AppColors.textPrimary)
                                }
                                .font(.system(size: 32, weight: .bold, design: .serif))
                                
                                Text("app_subtitle".localized)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                        
                        // 2. ÖNE ÇIKAN ÖZELLİKLER LİSTESİ
                        VStack(spacing: 14) {
                            FeatureRowCard(
                                icon: "bolt.fill",
                                iconColor: .orange,
                                title: "feat_rsvp_title".localized,
                                description: "feat_rsvp_desc".localized
                            )
                            
                            FeatureRowCard(
                                icon: "scope",
                                iconColor: AppColors.orpRed,
                                title: "feat_orp_title".localized,
                                description: "feat_orp_desc".localized
                            )
                            
                            FeatureRowCard(
                                icon: "doc.text.fill",
                                iconColor: .blue,
                                title: "feat_doc_title".localized,
                                description: "feat_doc_desc".localized
                            )
                            
                            FeatureRowCard(
                                icon: "icloud.fill",
                                iconColor: .teal,
                                title: "feat_cloud_title".localized,
                                description: "feat_cloud_desc".localized
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 20)
                }
                
                // 3. ALT BAŞLAMA AKSİYON KARTI
                VStack(spacing: 12) {
                    CustomPillButton(
                        title: "btn_get_started".localized,
                        icon: "arrow.right",
                        backgroundColor: AppColors.orpRed,
                        foregroundColor: Color.white,
                        isFullWidth: true,
                        height: 54
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            hasCompletedOnboarding = true
                        }
                    }
                    
                    Button(action: {
                        if let appURL = URL(string: "instagram://user?username=smanakca"), UIApplication.shared.canOpenURL(appURL) {
                            UIApplication.shared.open(appURL)
                        } else if let webURL = URL(string: "https://instagram.com/smanakca") {
                            UIApplication.shared.open(webURL)
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text("developed_by".localized)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(AppColors.textTertiary)
                            
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(AppColors.textTertiary)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white.opacity(0.96))
                        .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: -4)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }
}

/// Tanıtım Ekranı Özellik Satır Kartı
struct FeatureRowCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(description)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .lineSpacing(2)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 3)
        )
    }
}
