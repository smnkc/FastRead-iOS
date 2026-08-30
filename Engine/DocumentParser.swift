import SwiftUI
import PDFKit
import UniformTypeIdentifiers

/// Belge Ayrıştırma ve İçe Aktarma Motoru
@MainActor
public class DocumentParser {
    public static let shared = DocumentParser()
    
    // MARK: - Panodan Metin Alma
    public func getPasteboardContent() -> (text: String, isURL: Bool)? {
        guard let string = UIPasteboard.general.string?.trimmingCharacters(in: .whitespacesAndNewlines), !string.isEmpty else {
            return nil
        }
        
        let isURL = string.lowercased().hasPrefix("http://") || string.lowercased().hasPrefix("https://")
        return (string, isURL)
    }
    
    // MARK: - Web Sayfasından Metin Kazıma (URL Reader)
    public func extractTextFromURL(_ urlString: String) async throws -> (title: String, content: String) {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let html = String(data: data, encoding: .utf8) ?? String(data: data, encoding: .isoLatin1) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        let title = extractHTMLTitle(html: html) ?? url.host ?? "Web Makalesi"
        let cleanText = cleanHTML(html: html)
        
        return (title, cleanText)
    }
    
    // MARK: - PDF Dosyasından Metin Ayıklama
    public func extractTextFromPDF(at url: URL) -> (title: String, content: String)? {
        guard let pdfDocument = PDFDocument(url: url) else { return nil }
        
        var fullText = ""
        let pageCount = pdfDocument.pageCount
        
        for i in 0..<pageCount {
            if let page = pdfDocument.page(at: i), let pageContent = page.string {
                fullText += pageContent + "\n\n"
            }
        }
        
        let title = url.deletingPathExtension().lastPathComponent
        let trimmed = fullText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        
        return (title, trimmed)
    }
    
    // MARK: - Düz Metin Dosyası Okuma (TXT, Markdown vb.)
    public func extractTextFromTextFile(at url: URL) -> (title: String, content: String)? {
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            let title = url.deletingPathExtension().lastPathComponent
            return (title, content)
        } catch {
            return nil
        }
    }
    
    // MARK: - HTML Temizleyici
    private func cleanHTML(html: String) -> String {
        var clean = html
        
        // Script ve Style etiketlerini kaldır
        clean = clean.replacingOccurrences(of: "<script[\\s\\S]*?</script>", with: "", options: .regularExpression)
        clean = clean.replacingOccurrences(of: "<style[\\s\\S]*?</style>", with: "", options: .regularExpression)
        clean = clean.replacingOccurrences(of: "<head[\\s\\S]*?</head>", with: "", options: .regularExpression)
        clean = clean.replacingOccurrences(of: "<nav[\\s\\S]*?</nav>", with: "", options: .regularExpression)
        clean = clean.replacingOccurrences(of: "<footer[\\s\\S]*?</footer>", with: "", options: .regularExpression)
        
        // Paragraf ve satır sonlarını koru
        clean = clean.replacingOccurrences(of: "</p>", with: "\n\n", options: .caseInsensitive)
        clean = clean.replacingOccurrences(of: "<br\\s*/?>", with: "\n", options: .regularExpression)
        clean = clean.replacingOccurrences(of: "</div>", with: "\n", options: .caseInsensitive)
        clean = clean.replacingOccurrences(of: "</li>", with: "\n", options: .caseInsensitive)
        
        // Kalan HTML etiketlerini sil
        clean = clean.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        
        // HTML Entities çözümü
        clean = clean.replacingOccurrences(of: "&nbsp;", with: " ")
        clean = clean.replacingOccurrences(of: "&amp;", with: "&")
        clean = clean.replacingOccurrences(of: "&lt;", with: "<")
        clean = clean.replacingOccurrences(of: "&gt;", with: ">")
        clean = clean.replacingOccurrences(of: "&quot;", with: "\"")
        clean = clean.replacingOccurrences(of: "&#39;", with: "'")
        
        // Fazla boşlukları temizle
        let lines = clean.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        return lines.joined(separator: "\n\n")
    }
    
    private func extractHTMLTitle(html: String) -> String? {
        let pattern = "<title>(.*?)</title>"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
              let match = regex.firstMatch(in: html, range: NSRange(location: 0, length: html.utf16.count)),
              let titleRange = Range(match.range(at: 1), in: html) else {
            return nil
        }
        return String(html[titleRange]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
