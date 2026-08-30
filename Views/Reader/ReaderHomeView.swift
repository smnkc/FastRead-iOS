import SwiftUI
import UniformTypeIdentifiers

/// "Oku" Sekmesi Ana Ekranı
public struct ReaderHomeView: View {
    @ObservedObject private var engine = RSVPEngine.shared
    @AppStorage("hasShownWelcomeAlert") private var hasShownWelcomeAlert: Bool = false
    
    @State private var showWelcomeModal: Bool = false
    @State private var showEmptyClipboardModal: Bool = false
    @State private var showInvalidLinkModal: Bool = false
    @State private var showFilePicker: Bool = false
    @State private var showPlayer: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            AppColors.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // ÜST MERKEZ: CANLI LOGO RSVP KUTUSU
                RSVPCenteredWordView(customText: "FastRead")
                    .padding(.horizontal, 16)
                
                Spacer()
                
                // ALT İÇE AKTARMA VE OKUMA KARTI
                VStack(spacing: 12) {
                    // 1. Panodan Yapıştır Butonu
                    CustomPillButton(
                        title: "Panodan Oku",
                        icon: "doc.on.clipboard",
                        backgroundColor: AppColors.subtleGray,
                        foregroundColor: AppColors.textPrimary,
                        isFullWidth: true,
                        height: 52
                    ) {
                        handlePasteboardRead()
                    }
                    
                    // 2. EPUB veya PDF Seç Butonu
                    CustomPillButton(
                        title: "EPUB veya PDF",
                        icon: "doc.text",
                        backgroundColor: AppColors.subtleGray,
                        foregroundColor: AppColors.textPrimary,
                        isFullWidth: true,
                        height: 52
                    ) {
                        showFilePicker = true
                    }
                    
                    // "VEYA" Ayracı
                    Text("VEYA")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(AppColors.textTertiary)
                        .padding(.vertical, 4)
                    
                    // 3. Bir Örnek Dene Butonu (Pembe Vurgulu)
                    CustomPillButton(
                        title: "Bir örnek dene",
                        icon: "line.3.horizontal",
                        backgroundColor: AppColors.sampleButton.opacity(0.85),
                        foregroundColor: AppColors.textPrimary,
                        isFullWidth: true,
                        height: 54
                    ) {
                        engine.loadSampleText()
                        showPlayer = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            engine.play()
                        }
                    }
                    
                    // Marka ve Versiyon Alt Bilgisi
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
                    .padding(.top, 6)
                }
                .padding(22)
                .background(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white.opacity(0.95))
                        .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 8)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 90) // Floating Tab Bar için boşluk
            }
            
            // ÖZEL MODALLAR
            if showWelcomeModal {
                CustomModalDialog(
                    title: "FastRead uygulamasına hoş geldiniz!",
                    buttonTitle: "Başla"
                ) {
                    showWelcomeModal = false
                }
            }
            
            if showEmptyClipboardModal {
                CustomModalDialog(
                    title: "İçerik bulunamadı",
                    message: "Panonuzda hiçbir şey bulunamadı. Lütfen bir şey kopyalayıp tekrar deneyin.",
                    buttonTitle: "Kapat"
                ) {
                    showEmptyClipboardModal = false
                }
            }
            
            if showInvalidLinkModal {
                CustomModalDialog(
                    title: "Bağlantı bulunamadı",
                    message: "Geçerli bir web bağlantısı kopyalayıp tekrar deneyin.",
                    buttonTitle: "Kapat"
                ) {
                    showInvalidLinkModal = false
                }
            }
        }
        .onAppear {
            if !hasShownWelcomeAlert {
                hasShownWelcomeAlert = true
                showWelcomeModal = true
            }
        }
        .sheet(isPresented: $showFilePicker) {
            DocumentPickerView { url in
                handlePickedFile(url: url)
            }
        }
        .fullScreenCover(isPresented: $showPlayer) {
            RSVPPlayerView()
        }
    }
    
    private func handlePasteboardRead() {
        if let result = DocumentParser.shared.getPasteboardContent() {
            if result.isURL {
                Task {
                    do {
                        let article = try await DocumentParser.shared.extractTextFromURL(result.text)
                        await MainActor.run {
                            let doc = DocumentItem(title: article.title, content: article.content, sourceType: .web)
                            engine.loadText(article.content, document: doc)
                            showPlayer = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                engine.play()
                            }
                        }
                    } catch {
                        await MainActor.run {
                            showInvalidLinkModal = true
                        }
                    }
                }
            } else {
                let doc = DocumentItem(title: "Panodan Kopyalanan", content: result.text, sourceType: .pasted)
                engine.loadText(result.text, document: doc)
                showPlayer = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    engine.play()
                }
            }
        } else {
            showEmptyClipboardModal = true
        }
    }
    
    private func handlePickedFile(url: URL) {
        if url.pathExtension.lowercased() == "pdf" {
            if let result = DocumentParser.shared.extractTextFromPDF(at: url) {
                let doc = DocumentItem(title: result.title, content: result.content, sourceType: .pdf)
                engine.loadText(result.content, document: doc)
                showPlayer = true
            }
        } else {
            if let result = DocumentParser.shared.extractTextFromTextFile(at: url) {
                let doc = DocumentItem(title: result.title, content: result.content, sourceType: .other)
                engine.loadText(result.content, document: doc)
                showPlayer = true
            }
        }
    }
}

/// Dosya Seçici Köprüsü (UIDocumentPickerViewController)
public struct DocumentPickerView: UIViewControllerRepresentable {
    let onPick: (URL) -> Void
    
    public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let types: [UTType] = [.pdf, .plainText, .text, .epub]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPickerView
        
        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }
        
        public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            parent.onPick(url)
        }
    }
}
