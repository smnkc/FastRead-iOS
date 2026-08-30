import SwiftUI

/// Web Linki İçe Aktarma Modalı
public struct WebLinkInputSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var urlString: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    let onImport: (DocumentItem) -> Void
    
    public init(onImport: @escaping (DocumentItem) -> Void) {
        self.onImport = onImport
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button("web_sheet_cancel".localized) {
                    dismiss()
                }
                .foregroundColor(AppColors.textSecondary)
                
                Spacer()
                
                Text("web_sheet_title".localized)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button("web_sheet_add".localized) {
                    fetchURL()
                }
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(AppColors.orpRed)
                .disabled(urlString.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("web_sheet_desc".localized)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                
                HStack {
                    Image(systemName: "link")
                        .foregroundColor(AppColors.textTertiary)
                    
                    TextField("web_sheet_placeholder".localized, text: $urlString)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    if !urlString.isEmpty {
                        Button(action: { urlString = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(AppColors.textTertiary)
                        }
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(AppColors.subtleGray)
                )
            }
            .padding(.horizontal, 20)
            
            if let error = errorMessage {
                Text(error)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(AppColors.orpRed)
                    .padding(.horizontal, 20)
            }
            
            if isLoading {
                ProgressView("Sayfa içeriği alınıyor...")
                    .padding(.top, 12)
            }
            
            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
    }
    
    private func fetchURL() {
        var cleanURL = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        if !cleanURL.lowercased().hasPrefix("http://") && !cleanURL.lowercased().hasPrefix("https://") {
            cleanURL = "https://" + cleanURL
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let article = try await DocumentParser.shared.extractTextFromURL(cleanURL)
                await MainActor.run {
                    isLoading = false
                    let doc = DocumentItem(title: article.title, content: article.content, sourceType: .web)
                    onImport(doc)
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Web sayfası okunamadı. Lütfen adresi kontrol edin."
                }
            }
        }
    }
}
