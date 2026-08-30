import SwiftUI
import UniformTypeIdentifiers

/// "Kitaplık" (Library) Ekranı
public struct LibraryView: View {
    @ObservedObject private var engine = RSVPEngine.shared
    
    @State private var documents: [DocumentItem] = []
    @State private var searchText: String = ""
    @State private var showWebInput: Bool = false
    @State private var showFilePicker: Bool = false
    @State private var showEmptyClipboardModal: Bool = false
    @State private var showPlayer: Bool = false
    
    private let storageKey = "fastread_library_documents"
    
    public init() {}
    
    public var filteredDocuments: [DocumentItem] {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            return documents
        } else {
            return documents.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    public var body: some View {
        ZStack {
            AppColors.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ÜST BAŞLIK VE EKLE BUTONU (Degrade Zeminli)
                ZStack(alignment: .bottom) {
                    AppColors.headerGradient
                        .frame(height: 140)
                        .ignoresSafeArea(edges: .top)
                    
                    HStack(alignment: .center) {
                        Text("Kitaplık")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Spacer()
                        
                        // '+' EKLEME POP-OVER MENÜSÜ (Ekran 31)
                        Menu {
                            Button(action: {
                                handlePasteboardImport()
                            }) {
                                Label("Yapıştır", systemImage: "doc.on.doc")
                            }
                            
                            Button(action: {
                                showWebInput = true
                            }) {
                                Label("Web bağlantısı", systemImage: "link")
                            }
                            
                            Button(action: {
                                showFilePicker = true
                            }) {
                                Label("PDF", systemImage: "doc.text.image")
                            }
                            
                            Button(action: {
                                showFilePicker = true
                            }) {
                                Label("EPUB", systemImage: "book")
                            }
                            
                            Button(action: {
                                showFilePicker = true
                            }) {
                                Label("Diğer", systemImage: "questionmark.folder")
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(Color(red: 1.0, green: 0.82, blue: 0.85))
                                        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
                }
                
                // ARAMA ÇUBUĞU (Ekran 10)
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColors.textTertiary)
                        .font(.system(size: 16, weight: .medium))
                    
                    TextField("Arayın", text: $searchText)
                        .font(.system(size: 16, weight: .regular))
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(AppColors.textTertiary)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(AppColors.subtleGray)
                )
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 16) {
                        // BİLGİLENDİRME KARTI (Ekran 10)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Oturumlar arasında ilerlemeyi korumak için belgeler ekleyin; böylece döndüğünüzde kaldığınız yerden devam edebilirsiniz.")
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
                        
                        // BOŞ DURUM (EMPTY STATE) VEYA BELGE LİSTESİ
                        if filteredDocuments.isEmpty {
                            // "Belge yok" Kartı (Ekran 10)
                            HStack(alignment: .center, spacing: 16) {
                                Image(systemName: "folder.badge.questionmark")
                                    .font(.system(size: 28, weight: .light))
                                    .foregroundColor(AppColors.textPrimary.opacity(0.75))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Belge yok")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Text("Henüz hiç belge eklememişsiniz gibi görünüyor!")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(AppColors.textSecondary)
                                        .lineLimit(2)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    handlePasteboardImport()
                                }) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(AppColors.textPrimary)
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
                            )
                            .padding(.horizontal, 20)
                        } else {
                            // Eklenen Belgeler Listesi
                            LazyVStack(spacing: 12) {
                                ForEach(filteredDocuments) { doc in
                                    DocumentRowCard(document: doc) {
                                        openDocument(doc)
                                    } onDelete: {
                                        deleteDocument(doc)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 100) // Tab bar boşluğu
                }
            }
            
            // PANO BOŞ MODALI
            if showEmptyClipboardModal {
                CustomModalDialog(
                    title: "İçerik bulunamadı",
                    message: "Panonuzda hiçbir şey bulunamadı. Lütfen bir şey kopyalayıp tekrar deneyin.",
                    buttonTitle: "Kapat"
                ) {
                    showEmptyClipboardModal = false
                }
            }
        }
        .onAppear {
            loadDocuments()
        }
        .sheet(isPresented: $showWebInput) {
            WebLinkInputSheet { doc in
                addDocument(doc)
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
    
    // MARK: - Depolama & Aksiyonlar
    private func loadDocuments() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let list = try? JSONDecoder().decode([DocumentItem].self, from: data) {
            self.documents = list
        }
    }
    
    private func saveDocuments() {
        if let data = try? JSONEncoder().encode(documents) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func addDocument(_ doc: DocumentItem) {
        documents.insert(doc, at: 0)
        saveDocuments()
        openDocument(doc)
    }
    
    private func deleteDocument(_ doc: DocumentItem) {
        documents.removeAll { $0.id == doc.id }
        saveDocuments()
    }
    
    private func openDocument(_ doc: DocumentItem) {
        engine.loadText(doc.content, document: doc, startIndex: doc.currentWordIndex)
        showPlayer = true
    }
    
    private func handlePasteboardImport() {
        if let result = DocumentParser.shared.getPasteboardContent() {
            let title = result.isURL ? "Web Bağlantısı" : "Panodan Not"
            let doc = DocumentItem(title: title, content: result.text, sourceType: result.isURL ? .web : .pasted)
            addDocument(doc)
        } else {
            showEmptyClipboardModal = true
        }
    }
    
    private func handlePickedFile(url: URL) {
        if url.pathExtension.lowercased() == "pdf" {
            if let result = DocumentParser.shared.extractTextFromPDF(at: url) {
                let doc = DocumentItem(title: result.title, content: result.content, sourceType: .pdf)
                addDocument(doc)
            }
        } else {
            if let result = DocumentParser.shared.extractTextFromTextFile(at: url) {
                let doc = DocumentItem(title: result.title, content: result.content, sourceType: .other)
                addDocument(doc)
            }
        }
    }
}

/// Kitaplık Belge Satır Kartı
struct DocumentRowCard: View {
    let document: DocumentItem
    let onOpen: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onOpen) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(document.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(document.sourceType.rawValue)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(AppColors.subtleGray)
                        )
                }
                
                // İlerleme Çubuğu ve Kelime Bilgisi
                HStack(spacing: 8) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(AppColors.subtleGray)
                                .frame(height: 5)
                            
                            Capsule()
                                .fill(AppColors.orpRed)
                                .frame(width: max(6, geo.size.width * CGFloat(document.progressRatio)), height: 5)
                        }
                    }
                    .frame(height: 5)
                    
                    Text("%\(document.progressPercentage)")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                HStack {
                    Text("\(document.totalWords) kelime")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(AppColors.textTertiary)
                    
                    Spacer()
                    
                    Text(document.dateAdded.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(AppColors.textTertiary)
                }
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4)
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .contextMenu {
            Button(role: .destructive, action: onDelete) {
                Label("Sil", systemImage: "trash")
            }
        }
    }
}
