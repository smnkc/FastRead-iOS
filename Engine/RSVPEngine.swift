import SwiftUI
import Combine

/// RSVP Kelime Parçası
public struct RSVPWordToken: Identifiable, Equatable {
    public let id: Int
    public let fullText: String
    public let prefix: String
    public let orpChar: String
    public let suffix: String
    public let orpIndex: Int
    public let isSentenceEnd: Bool
    public let isClauseEnd: Bool
    
    public init(id: Int, text: String) {
        self.id = id
        self.fullText = text
        
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            self.prefix = ""
            self.orpChar = ""
            self.suffix = ""
            self.orpIndex = 0
            self.isSentenceEnd = false
            self.isClauseEnd = false
            return
        }
        
        // Cümle ve virgül tespiti
        let lastChar = trimmed.last
        self.isSentenceEnd = lastChar == "." || lastChar == "!" || lastChar == "?" || lastChar == "…" || lastChar == ":"
        self.isClauseEnd = lastChar == "," || lastChar == ";" || lastChar == "-"
        
        // ORP (Optimal Recognition Point / Odak Harfi) Hesaplama:
        // Kelimenin harf uzunluğuna göre odak harfi indeksi
        let length = trimmed.count
        let orpIdx: Int
        switch length {
        case 0...1: orpIdx = 0   // 1 harf: 1. harf
        case 2:     orpIdx = 0   // 2 harf: 1. harf (ör. [a]z)
        case 3...4: orpIdx = 1   // 3-4 harf: 2. harf (ör. d[a]ha)
        case 5...6: orpIdx = 2   // 5-6 harf: 3. harf (ör. bu[n]un, Ek[r]an, iy[i]dir)
        case 7...8: orpIdx = 3   // 7-8 harf: 4. harf (ör. oku[y]ucu, Rea[d]Maxx)
        case 9...10: orpIdx = 4  // 9-10 harf: 5. harf (ör. keli[m]eler)
        case 11...12: orpIdx = 5
        default:    orpIdx = max(2, length / 2) // Uzun kelimelerde tam ortası
        }
        
        let safeIndex = min(orpIdx, max(0, length - 1))
        self.orpIndex = safeIndex
        
        let chars = Array(trimmed)
        if safeIndex < chars.count {
            self.prefix = String(chars[0..<safeIndex])
            self.orpChar = String(chars[safeIndex])
            self.suffix = String(chars[(safeIndex + 1)...])
        } else {
            self.prefix = ""
            self.orpChar = trimmed
            self.suffix = ""
        }
    }
}

/// RSVP Okuma Motoru
@MainActor
public class RSVPEngine: ObservableObject {
    public static let shared = RSVPEngine()
    
    @Published public var rawText: String = ""
    @Published public var tokens: [RSVPWordToken] = []
    @Published public var currentIndex: Int = 0
    @Published public var isPlaying: Bool = false
    @Published public var currentDocument: DocumentItem?
    
    private var timerTask: Task<Void, Never>?
    private var haptics = HapticsManager.shared
    
    public init() {
        loadSampleText()
    }
    
    public var currentToken: RSVPWordToken? {
        guard currentIndex >= 0 && currentIndex < tokens.count else { return nil }
        return tokens[currentIndex]
    }
    
    public var totalWords: Int {
        tokens.count
    }
    
    public var progressRatio: Double {
        guard totalWords > 0 else { return 0 }
        return Double(currentIndex) / Double(totalWords)
    }
    
    public var elapsedSeconds: Int {
        guard let wpm = ReaderSettings.shared.wpm as Int?, wpm > 0 else { return 0 }
        return Int((Double(currentIndex) / Double(wpm)) * 60.0)
    }
    
    public var totalSeconds: Int {
        guard let wpm = ReaderSettings.shared.wpm as Int?, wpm > 0 else { return 0 }
        return Int((Double(totalWords) / Double(wpm)) * 60.0)
    }
    
    public var remainingSeconds: Int {
        max(0, totalSeconds - elapsedSeconds)
    }
    
    public var elapsedTimeFormatted: String {
        formatSeconds(elapsedSeconds)
    }
    
    public var totalTimeFormatted: String {
        formatSeconds(totalSeconds)
    }
    
    private func formatSeconds(_ secs: Int) -> String {
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = secs % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    public func loadText(_ text: String, document: DocumentItem? = nil, startIndex: Int = 0) {
        pause()
        self.rawText = text
        self.currentDocument = document
        
        let words = Self.normalizeAndSplit(text: text)
        self.tokens = words.enumerated().map { RSVPWordToken(id: $0.offset, text: $0.element) }
        self.currentIndex = min(max(0, startIndex), max(0, tokens.count - 1))
    }
    
    /// Noktalama işaretlerinden sonra boşluk bırakılmamış cümleleri akıllıca ayıran metin temizleyici
    public static func normalizeAndSplit(text: String) -> [String] {
        var formatted = text
        
        // 1. Noktalama işaretleri (. ! ? … : ; ,) sonrasında harf geliyorsa araya boşluk ekle (Örn: "geldi.Gitti" -> "geldi. Gitti")
        let punctPattern = #"([.!?…:;,])(?=[A-Za-zçğıöşüÇĞİÖŞÜ])"#
        if let regex = try? NSRegularExpression(pattern: punctPattern, options: []) {
            let range = NSRange(location: 0, length: formatted.utf16.count)
            formatted = regex.stringByReplacingMatches(in: formatted, options: [], range: range, withTemplate: "$1 ")
        }
        
        // 2. Kapanış parantezi veya tırnak sonrasında harf geliyorsa boşluk ekle (Örn: "dedi)Sonra" -> "dedi) Sonra")
        let bracketPattern = #"([\)\]\"”’])(?=[A-Za-zçğıöşüÇĞİÖŞÜ])"#
        if let regex = try? NSRegularExpression(pattern: bracketPattern, options: []) {
            let range = NSRange(location: 0, length: formatted.utf16.count)
            formatted = regex.stringByReplacingMatches(in: formatted, options: [], range: range, withTemplate: "$1 ")
        }
        
        return formatted
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    public func loadSampleText() {
        let sample = """
        Ekran aydınlanır ve senden hiçbir şey istenmez.
        Kurulum yok, bağlılık yok, sadece kelimeler.
        
        Daha hızlı okumak, daha az önemsemek demek değildir.
        Beynine daha çok güvenmek demektir.
        
        Beynin örüntüler konusunda çok iyidir.
        Sandığından daha iyi.
        
        Okumak genellikle çaba ister.
        Bu istemez.
        
        Kelimeler gelir.
        Kelimeler gider.
        Oyalanmazlar.
        """
        loadText(sample)
    }
    
    public func play() {
        guard !isPlaying else { return }
        guard !tokens.isEmpty else { return }
        
        if currentIndex >= tokens.count - 1 {
            currentIndex = 0
        }
        
        isPlaying = true
        startLoop()
    }
    
    public func pause() {
        isPlaying = false
        timerTask?.cancel()
        timerTask = nil
    }
    
    public func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    public func jumpToIndex(_ index: Int) {
        let target = min(max(0, index), max(0, tokens.count - 1))
        self.currentIndex = target
    }
    
    public func stepForward() {
        if currentIndex < tokens.count - 1 {
            jumpToIndex(currentIndex + 1)
        }
    }
    
    public func stepBackward() {
        if currentIndex > 0 {
            jumpToIndex(currentIndex - 1)
        }
    }
    
    private func startLoop() {
        timerTask?.cancel()
        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                guard let self = self, self.isPlaying else { break }
                
                guard self.currentIndex < self.tokens.count else {
                    self.pause()
                    break
                }
                
                let token = self.tokens[self.currentIndex]
                
                // Haptik Tetikleme
                let settings = ReaderSettings.shared
                if token.isSentenceEnd {
                    self.haptics.triggerSentenceEnd(intensity: settings.sentenceHaptic)
                } else {
                    self.haptics.trigger(intensity: settings.wordHaptic)
                }
                
                // Gecikme Hesaplama
                let baseDelayMs = (60.0 / Double(max(50, settings.wpm))) * 1000.0
                var finalDelayMs = baseDelayMs
                
                if token.isSentenceEnd {
                    finalDelayMs *= settings.sentenceDelay.multiplier
                } else if token.isClauseEnd {
                    finalDelayMs *= 1.3
                }
                
                // Uzun kelime ekstra okuma süresi
                if token.fullText.count > 10 {
                    finalDelayMs += 30
                }
                
                let delayNanos = UInt64(finalDelayMs * 1_000_000)
                try? await Task.sleep(nanoseconds: delayNanos)
                
                if Task.isCancelled || !self.isPlaying { break }
                
                if self.currentIndex < self.tokens.count - 1 {
                    self.currentIndex += 1
                } else {
                    self.pause()
                    break
                }
            }
        }
    }
}
