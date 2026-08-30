import SwiftUI
import UIKit
import PDFKit
import UniformTypeIdentifiers
import Vision
import zlib

/// Belge Ayrıştırma ve İçe Aktarma Motoru (EPUB, PDF, Web, TXT, RTF)
public class DocumentParser {
    public static let shared = DocumentParser()
    
    // MARK: - Genel Belge Ayrıştırıcı
    public func parseDocument(at url: URL) -> (title: String, content: String, sourceType: DocumentItem.DocumentSourceType)? {
        let ext = url.pathExtension.lowercased()
        
        if ext == "epub" {
            if let res = extractTextFromEPUB(at: url) {
                return (res.title, res.content, .epub)
            }
        } else if ext == "pdf" {
            if let res = extractTextFromPDF(at: url) {
                return (res.title, res.content, .pdf)
            }
        } else {
            if let res = extractTextFromTextFile(at: url) {
                return (res.title, res.content, .other)
            }
        }
        return nil
    }
    
    // MARK: - Panodan Metin Alma
    @MainActor
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
        let cleanText = Self.cleanHTML(html: html)
        
        return (title, cleanText)
    }
    
    // MARK: - EPUB E-Kitap Dosyasından Metin Ayıklama
    public func extractTextFromEPUB(at url: URL) -> (title: String, content: String)? {
        let isAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if isAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        return EPUBParser.parse(url: url)
    }
    
    // MARK: - PDF Dosyasından Metin Ayıklama
    public func extractTextFromPDF(at url: URL) -> (title: String, content: String)? {
        let isAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if isAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        guard let pdfDocument = PDFDocument(url: url) else { return nil }
        guard !pdfDocument.isLocked else { return nil }
        
        var fullText = ""
        let pageCount = pdfDocument.pageCount
        
        for i in 0..<pageCount {
            if let page = pdfDocument.page(at: i), let pageContent = page.string {
                fullText += pageContent + "\n\n"
            }
        }
        
        var title = url.deletingPathExtension().lastPathComponent
        if let docTitle = pdfDocument.documentAttributes?[PDFDocumentAttribute.titleAttribute] as? String,
           !docTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            title = docTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let trimmed = fullText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            return (title, trimmed)
        }
        
        // Taranmış / resim tabanlı PDF'ler için Apple Vision OCR desteği
        let ocrText = extractOCRFromPDF(pdfDocument: pdfDocument)
        let ocrTrimmed = ocrText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !ocrTrimmed.isEmpty {
            return (title, ocrTrimmed)
        }
        
        return nil
    }
    
    // MARK: - Düz Metin Dosyası Okuma (TXT, Markdown, RTF, HTML vb.)
    public func extractTextFromTextFile(at url: URL) -> (title: String, content: String)? {
        let isAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if isAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        let title = url.deletingPathExtension().lastPathComponent
        
        // RTF Desteği
        if url.pathExtension.lowercased() == "rtf" {
            if let rtfData = try? Data(contentsOf: url),
               let attrStr = try? NSAttributedString(data: rtfData, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil) {
                let plain = attrStr.string.trimmingCharacters(in: .whitespacesAndNewlines)
                if !plain.isEmpty {
                    return (title, plain)
                }
            }
        }
        
        // HTML / XHTML Desteği
        if url.pathExtension.lowercased() == "html" || url.pathExtension.lowercased() == "htm" {
            if let htmlData = try? Data(contentsOf: url),
               let html = String(data: htmlData, encoding: .utf8) ?? String(data: htmlData, encoding: .isoLatin1) {
                let cleaned = Self.cleanHTML(html: html)
                if !cleaned.isEmpty {
                    return (title, cleaned)
                }
            }
        }
        
        guard let data = try? Data(contentsOf: url) else { return nil }
        
        // Çoklu Kodlama Denemeleri (UTF-8, Windows CP1254 Türkçe, ISO Latin 5, ISO Latin 1, UTF-16)
        let encodings: [String.Encoding] = [
            .utf8,
            String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.windowsLatin5.rawValue))),
            String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.isoLatin5.rawValue))),
            .isoLatin1,
            .utf16,
            .ascii
        ]
        
        for enc in encodings {
            if let content = String(data: data, encoding: enc) {
                let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    return (title, trimmed)
                }
            }
        }
        
        return nil
    }
    
    // MARK: - Apple Vision OCR Motoru (Görsel PDF Sayfalarını Okuma)
    private func extractOCRFromPDF(pdfDocument: PDFDocument) -> String {
        var extracted = ""
        let pageCount = min(pdfDocument.pageCount, 150)
        
        for i in 0..<pageCount {
            guard let page = pdfDocument.page(at: i) else { continue }
            let pageRect = page.bounds(for: .mediaBox)
            guard pageRect.width > 0 && pageRect.height > 0 else { continue }
            
            let renderer = UIGraphicsImageRenderer(size: pageRect.size)
            let img = renderer.image { ctx in
                UIColor.white.set()
                ctx.fill(pageRect)
                ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                page.draw(with: .mediaBox, to: ctx.cgContext)
            }
            
            if let cgImage = img.cgImage {
                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                let request = VNRecognizeTextRequest()
                request.recognitionLevel = .accurate
                request.recognitionLanguages = ["tr-TR", "en-US"]
                request.usesLanguageCorrection = true
                
                try? requestHandler.perform([request])
                
                if let results = request.results {
                    let pageLines = results.compactMap { $0.topCandidates(1).first?.string }
                    if !pageLines.isEmpty {
                        extracted += pageLines.joined(separator: "\n") + "\n\n"
                    }
                }
            }
        }
        return extracted
    }
    
    // MARK: - HTML Temizleyici
    public static func cleanHTML(html: String) -> String {
        var clean = html
        
        // Script ve Style etiketlerini kaldır
        clean = clean.replacingOccurrences(of: "<script[\\s\\S]*?</script>", with: "", options: .regularExpression)
        clean = clean.replacingOccurrences(of: "<style[\\s\\S]*?</style>", with: "", options: .regularExpression)
        clean = clean.replacingOccurrences(of: "<head[\\s\\S]*?</head>", with: "", options: .regularExpression)
        clean = clean.replacingOccurrences(of: "<nav[\\s\\S]*?</nav>", with: "", options: .regularExpression)
        clean = clean.replacingOccurrences(of: "<footer[\\s\\S]*?</footer>", with: "", options: .regularExpression)
        clean = clean.replacingOccurrences(of: "<noscript[\\s\\S]*?</noscript>", with: "", options: .regularExpression)
        
        // Paragraf, başlık ve satır sonlarını koru
        clean = clean.replacingOccurrences(of: "</p>", with: "\n\n", options: .caseInsensitive)
        clean = clean.replacingOccurrences(of: "<br\\s*/?>", with: "\n", options: .regularExpression)
        clean = clean.replacingOccurrences(of: "</div>", with: "\n", options: .caseInsensitive)
        clean = clean.replacingOccurrences(of: "</li>", with: "\n", options: .caseInsensitive)
        clean = clean.replacingOccurrences(of: "</h[1-6]>", with: "\n\n", options: .regularExpression)
        clean = clean.replacingOccurrences(of: "</blockquote>", with: "\n\n", options: .caseInsensitive)
        
        // Kalan HTML etiketlerini sil
        clean = clean.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        
        // HTML Entities çözümü
        clean = decodeHTMLEntities(in: clean)
        
        // Fazla boşlukları temizle
        let lines = clean.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        return lines.joined(separator: "\n\n")
    }
    
    public static func decodeHTMLEntities(in text: String) -> String {
        var str = text
        str = str.replacingOccurrences(of: "&nbsp;", with: " ")
        str = str.replacingOccurrences(of: "&amp;", with: "&")
        str = str.replacingOccurrences(of: "&lt;", with: "<")
        str = str.replacingOccurrences(of: "&gt;", with: ">")
        str = str.replacingOccurrences(of: "&quot;", with: "\"")
        str = str.replacingOccurrences(of: "&#39;", with: "'")
        str = str.replacingOccurrences(of: "&apos;", with: "'")
        str = str.replacingOccurrences(of: "&ldquo;", with: "“")
        str = str.replacingOccurrences(of: "&rdquo;", with: "”")
        str = str.replacingOccurrences(of: "&lsquo;", with: "‘")
        str = str.replacingOccurrences(of: "&rsquo;", with: "’")
        str = str.replacingOccurrences(of: "&mdash;", with: "—")
        str = str.replacingOccurrences(of: "&ndash;", with: "–")
        str = str.replacingOccurrences(of: "&hellip;", with: "…")
        
        // Onaltılık ve ondalık sayısal HTML karakter varlıklarını çöz
        let entityPattern = "&#(x[0-9a-fA-F]+|[0-9]+);"
        if let regex = try? NSRegularExpression(pattern: entityPattern, options: .caseInsensitive) {
            let matches = regex.matches(in: str, range: NSRange(location: 0, length: str.utf16.count)).reversed()
            for match in matches {
                guard let entityRange = Range(match.range, in: str),
                      let numRange = Range(match.range(at: 1), in: str) else { continue }
                let numStr = String(str[numRange])
                let charCode: UInt32?
                if numStr.lowercased().hasPrefix("x") {
                    charCode = UInt32(numStr.dropFirst(), radix: 16)
                } else {
                    charCode = UInt32(numStr, radix: 10)
                }
                if let code = charCode, let scalar = UnicodeScalar(code) {
                    str.replaceSubrange(entityRange, with: String(Character(scalar)))
                }
            }
        }
        return str
    }
    
    private func extractHTMLTitle(html: String) -> String? {
        let pattern = "<title>(.*?)</title>"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
              let match = regex.firstMatch(in: html, range: NSRange(location: 0, length: html.utf16.count)),
              let titleRange = Range(match.range(at: 1), in: html) else {
            return nil
        }
        return Self.decodeHTMLEntities(in: String(html[titleRange])).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Pure Swift ZIP Arşiv Okuyucu Motoru
public final class ZipArchive {
    public private(set) var entries: [String: Data] = [:]
    
    public init?(data: Data) {
        guard parse(data: data) else { return nil }
    }
    
    public convenience init?(url: URL) {
        let isAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if isAccessing { url.stopAccessingSecurityScopedResource() }
        }
        guard let fileData = try? Data(contentsOf: url) else { return nil }
        self.init(data: fileData)
    }
    
    private func parse(data: Data) -> Bool {
        let count = data.count
        guard count >= 22 else { return false }
        
        // End of Central Directory (EOCD) imzası: 0x06054b50 (PK\x05\x06)
        var eocdOffset = -1
        let minOffset = max(0, count - 65557)
        var i = count - 22
        while i >= minOffset {
            if data[i] == 0x50 && data[i+1] == 0x4b && data[i+2] == 0x05 && data[i+3] == 0x06 {
                eocdOffset = i
                break
            }
            i -= 1
        }
        
        guard eocdOffset >= 0 else { return false }
        
        let totalEntries = Int(data.readUInt16(at: eocdOffset + 10))
        let cdOffset = Int(data.readUInt32(at: eocdOffset + 16))
        
        guard cdOffset < count else { return false }
        
        var currentOffset = cdOffset
        for _ in 0..<totalEntries {
            guard currentOffset + 46 <= count else { break }
            
            // Central Directory imzası: 0x02014b50 (PK\x01\x02)
            guard data[currentOffset] == 0x50,
                  data[currentOffset+1] == 0x4b,
                  data[currentOffset+2] == 0x01,
                  data[currentOffset+3] == 0x02 else {
                break
            }
            
            let method = data.readUInt16(at: currentOffset + 10)
            let compressedSize = Int(data.readUInt32(at: currentOffset + 20))
            let uncompressedSize = Int(data.readUInt32(at: currentOffset + 24))
            let fileNameLen = Int(data.readUInt16(at: currentOffset + 28))
            let extraFieldLen = Int(data.readUInt16(at: currentOffset + 30))
            let commentLen = Int(data.readUInt16(at: currentOffset + 32))
            let localHeaderOffset = Int(data.readUInt32(at: currentOffset + 42))
            
            let nameStart = currentOffset + 46
            guard nameStart + fileNameLen <= count else { break }
            
            let nameData = data.subdata(in: nameStart..<(nameStart + fileNameLen))
            let fileName = String(data: nameData, encoding: .utf8) ??
                           String(data: nameData, encoding: .isoLatin1) ?? ""
            
            currentOffset = nameStart + fileNameLen + extraFieldLen + commentLen
            
            // Dizin kayıtlarını atla
            if fileName.hasSuffix("/") || fileName.isEmpty {
                continue
            }
            
            // Yerel dosya başlığından veriyi oku
            guard localHeaderOffset + 30 <= count else { continue }
            guard data[localHeaderOffset] == 0x50,
                  data[localHeaderOffset+1] == 0x4b,
                  data[localHeaderOffset+2] == 0x03,
                  data[localHeaderOffset+3] == 0x04 else {
                continue
            }
            
            let localNameLen = Int(data.readUInt16(at: localHeaderOffset + 26))
            let localExtraLen = Int(data.readUInt16(at: localHeaderOffset + 28))
            let dataStart = localHeaderOffset + 30 + localNameLen + localExtraLen
            let dataEnd = dataStart + compressedSize
            
            guard dataEnd <= count else { continue }
            let rawCompressedData = data.subdata(in: dataStart..<dataEnd)
            
            var entryData: Data?
            if method == 0 {
                // Sıkıştırılmamış ham veri
                entryData = rawCompressedData
            } else if method == 8 {
                // Deflate sıkıştırması çöz
                entryData = decompressDeflate(rawCompressedData, uncompressedSize: uncompressedSize)
            }
            
            if let finalData = entryData {
                let normalizedKey = fileName.replacingOccurrences(of: "\\", with: "/").trimmingCharacters(in: CharacterSet(charactersIn: "/"))
                entries[normalizedKey] = finalData
            }
        }
        
        return !entries.isEmpty
    }
    
    private func decompressDeflate(_ compressedData: Data, uncompressedSize: Int) -> Data? {
        if compressedData.isEmpty { return Data() }
        
        var stream = z_stream()
        // ZIP formatında raw deflate için -MAX_WBITS kullanılır
        var initStatus = inflateInit2_(&stream, -MAX_WBITS, ZLIB_VERSION, Int32(MemoryLayout<z_stream>.size))
        if initStatus != Z_OK {
            // Başlıklı fallback
            initStatus = inflateInit2_(&stream, 32 + MAX_WBITS, ZLIB_VERSION, Int32(MemoryLayout<z_stream>.size))
            guard initStatus == Z_OK else { return nil }
        }
        defer { inflateEnd(&stream) }
        
        let bufferSize = max(uncompressedSize, 8192)
        var destination = Data(count: bufferSize)
        var resultData = Data()
        
        let status: Int32 = compressedData.withUnsafeBytes { srcBuffer in
            destination.withUnsafeMutableBytes { destBuffer in
                guard let srcAddress = srcBuffer.bindMemory(to: Bytef.self).baseAddress,
                      let destAddress = destBuffer.bindMemory(to: Bytef.self).baseAddress else {
                    return Z_STREAM_ERROR
                }
                
                stream.next_in = UnsafeMutablePointer(mutating: srcAddress)
                stream.avail_in = uInt(compressedData.count)
                
                while true {
                    stream.next_out = destAddress
                    stream.avail_out = uInt(bufferSize)
                    
                    let res = inflate(&stream, Z_NO_FLUSH)
                    if res != Z_OK && res != Z_STREAM_END && res != Z_BUF_ERROR {
                        return res
                    }
                    
                    let bytesRead = bufferSize - Int(stream.avail_out)
                    if bytesRead > 0 {
                        resultData.append(destBuffer.baseAddress!.assumingMemoryBound(to: UInt8.self), count: bytesRead)
                    }
                    
                    if res == Z_STREAM_END {
                        return Z_STREAM_END
                    }
                    if stream.avail_in == 0 && stream.avail_out > 0 {
                        return Z_STREAM_END
                    }
                }
            }
        }
        
        return (status == Z_STREAM_END || !resultData.isEmpty) ? resultData : nil
    }
}

fileprivate extension Data {
    func readUInt16(at offset: Int) -> UInt16 {
        guard offset + 2 <= count else { return 0 }
        let b0 = UInt16(self[offset])
        let b1 = UInt16(self[offset + 1])
        return b0 | (b1 << 8)
    }
    
    func readUInt32(at offset: Int) -> UInt32 {
        guard offset + 4 <= count else { return 0 }
        let b0 = UInt32(self[offset])
        let b1 = UInt32(self[offset + 1])
        let b2 = UInt32(self[offset + 2])
        let b3 = UInt32(self[offset + 3])
        return b0 | (b1 << 8) | (b2 << 16) | (b3 << 24)
    }
}

// MARK: - Pure Swift EPUB E-Kitap Ayrıştırıcı Motoru
public final class EPUBParser {
    public static func parse(url: URL) -> (title: String, content: String)? {
        guard let archive = ZipArchive(url: url) else { return nil }
        return parse(archive: archive, defaultTitle: url.deletingPathExtension().lastPathComponent)
    }
    
    public static func parse(data: Data, defaultTitle: String = "EPUB Kitap") -> (title: String, content: String)? {
        guard let archive = ZipArchive(data: data) else { return nil }
        return parse(archive: archive, defaultTitle: defaultTitle)
    }
    
    private static func parse(archive: ZipArchive, defaultTitle: String) -> (title: String, content: String)? {
        // 1. META-INF/container.xml içerisinden rootfile .opf konumunu bul
        var opfPath = ""
        for (key, val) in archive.entries {
            if key.lowercased() == "meta-inf/container.xml" {
                if let xml = String(data: val, encoding: .utf8) ?? String(data: val, encoding: .isoLatin1) {
                    if let path = extractRootFilePath(from: xml) {
                        opfPath = path
                        break
                    }
                }
            }
        }
        
        // Yedek plan: container.xml bulunamazsa arşivdeki ilk .opf dosyasını ara
        if opfPath.isEmpty {
            if let firstOpf = archive.entries.keys.first(where: { $0.lowercased().hasSuffix(".opf") }) {
                opfPath = firstOpf
            }
        }
        
        guard !opfPath.isEmpty else { return nil }
        
        opfPath = opfPath.replacingOccurrences(of: "\\", with: "/").trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        
        // OPF dosyasını bul ve içeriğini oku
        guard let opfEntryKey = archive.entries.keys.first(where: { $0.lowercased() == opfPath.lowercased() }),
              let opfData = archive.entries[opfEntryKey],
              let opfXML = String(data: opfData, encoding: .utf8) ?? String(data: opfData, encoding: .isoLatin1) else {
            return nil
        }
        
        let opfDir: String
        if let lastSlash = opfPath.lastIndex(of: "/") {
            opfDir = String(opfPath[..<lastSlash])
        } else {
            opfDir = ""
        }
        
        // 2. Kitap Başlığını Ayıkla
        var bookTitle = extractTagContent(from: opfXML, tagName: "dc:title") ?? defaultTitle
        bookTitle = DocumentParser.decodeHTMLEntities(in: bookTitle).trimmingCharacters(in: .whitespacesAndNewlines)
        if bookTitle.isEmpty { bookTitle = defaultTitle }
        
        // 3. Manifest Öğelerini Ayıkla (id -> href)
        var manifest: [String: String] = [:]
        let itemPattern = "<item\\s+([^>]+)/?>"
        if let regex = try? NSRegularExpression(pattern: itemPattern, options: .caseInsensitive) {
            let matches = regex.matches(in: opfXML, range: NSRange(location: 0, length: opfXML.utf16.count))
            for match in matches {
                guard let range = Range(match.range(at: 1), in: opfXML) else { continue }
                let attributes = String(opfXML[range])
                
                guard let id = extractAttribute("id", from: attributes),
                      let href = extractAttribute("href", from: attributes) else {
                    continue
                }
                
                let cleanHref = href.removingPercentEncoding ?? href
                manifest[id] = cleanHref
            }
        }
        
        // 4. Spine Okuma Sırasını (Reading Order) Ayıkla
        var spineIds: [String] = []
        let itemrefPattern = "<itemref\\s+[^>]*idref=[\"']([^\"']+)[\"']"
        if let regex = try? NSRegularExpression(pattern: itemrefPattern, options: .caseInsensitive) {
            let matches = regex.matches(in: opfXML, range: NSRange(location: 0, length: opfXML.utf16.count))
            for match in matches {
                guard let range = Range(match.range(at: 1), in: opfXML) else { continue }
                spineIds.append(String(opfXML[range]))
            }
        }
        
        // 5. Bölüm Href'lerini Sırala
        var chapterHrefs: [String] = []
        for spineId in spineIds {
            if let href = manifest[spineId] {
                chapterHrefs.append(href)
            }
        }
        
        if chapterHrefs.isEmpty {
            chapterHrefs = manifest.values.filter { href in
                let lower = href.lowercased()
                return lower.hasSuffix(".xhtml") || lower.hasSuffix(".html") || lower.hasSuffix(".htm") || lower.hasSuffix(".xml")
            }.sorted()
        }
        
        // 6. Bölümleri Sırasıyla Oku, HTML'i Temizle ve Birleştir
        var fullBookText: [String] = []
        
        for relHref in chapterHrefs {
            let fullPath: String
            if opfDir.isEmpty {
                fullPath = relHref
            } else {
                fullPath = resolvePath(dir: opfDir, file: relHref)
            }
            
            let normalizedPath = fullPath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            
            if let entryKey = archive.entries.keys.first(where: { $0.lowercased() == normalizedPath.lowercased() }),
               let chapterData = archive.entries[entryKey] {
                if let chapterHTML = String(data: chapterData, encoding: .utf8) ?? String(data: chapterData, encoding: .isoLatin1) {
                    let cleaned = DocumentParser.cleanHTML(html: chapterHTML)
                    if !cleaned.isEmpty {
                        fullBookText.append(cleaned)
                    }
                }
            }
        }
        
        let combined = fullBookText.joined(separator: "\n\n").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !combined.isEmpty else { return nil }
        
        return (title: bookTitle, content: combined)
    }
    
    private static func extractRootFilePath(from xml: String) -> String? {
        let pattern = "<rootfile\\s+[^>]*full-path=[\"']([^\"']+)[\"']"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
              let match = regex.firstMatch(in: xml, range: NSRange(location: 0, length: xml.utf16.count)),
              let range = Range(match.range(at: 1), in: xml) else {
            return nil
        }
        return String(xml[range])
    }
    
    private static func extractTagContent(from xml: String, tagName: String) -> String? {
        let pattern = "<\(tagName)[^>]*>([\\s\\S]*?)</\(tagName)>"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
              let match = regex.firstMatch(in: xml, range: NSRange(location: 0, length: xml.utf16.count)),
              let range = Range(match.range(at: 1), in: xml) else {
            return nil
        }
        return String(xml[range])
    }
    
    private static func extractAttribute(_ attrName: String, from string: String) -> String? {
        let pattern = "\(attrName)=[\"']([^\"']+)[\"']"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
              let match = regex.firstMatch(in: string, range: NSRange(location: 0, length: string.utf16.count)),
              let range = Range(match.range(at: 1), in: string) else {
            return nil
        }
        return String(string[range])
    }
    
    private static func resolvePath(dir: String, file: String) -> String {
        let combined = (dir as NSString).appendingPathComponent(file)
        return (combined as NSString).standardizingPath
    }
}

