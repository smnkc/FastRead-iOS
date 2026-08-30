import Foundation

/// Kitaplık Belge Modeli
public struct DocumentItem: Identifiable, Codable, Equatable {
    public var id: UUID
    public var title: String
    public var content: String
    public var currentWordIndex: Int
    public var totalWords: Int
    public var dateAdded: Date
    public var lastReadDate: Date?
    public var sourceType: DocumentSourceType
    
    public enum DocumentSourceType: String, Codable {
        case pasted = "Yapıştırılan Metin"
        case web = "Web Bağlantısı"
        case pdf = "PDF Belgesi"
        case epub = "EPUB Kitap"
        case sample = "Örnek Metin"
        case other = "Dosya"
    }
    
    public init(
        id: UUID = UUID(),
        title: String,
        content: String,
        currentWordIndex: Int = 0,
        dateAdded: Date = Date(),
        lastReadDate: Date? = nil,
        sourceType: DocumentSourceType = .pasted
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.currentWordIndex = currentWordIndex
        self.totalWords = content.split(whereSeparator: { $0.isWhitespace || $0.isNewline }).count
        self.dateAdded = dateAdded
        self.lastReadDate = lastReadDate
        self.sourceType = sourceType
    }
    
    public var progressRatio: Double {
        guard totalWords > 0 else { return 0 }
        return min(1.0, Double(currentWordIndex) / Double(totalWords))
    }
    
    public var progressPercentage: Int {
        Int(progressRatio * 100)
    }
    
    public var remainingWords: Int {
        max(0, totalWords - currentWordIndex)
    }
}
