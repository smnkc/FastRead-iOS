import Foundation

/// FastRead Çoklu Dil ve Yerelleştirme Yöneticisi (i18n)
public struct L10n {
    public static func tr(_ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        if args.isEmpty {
            return format
        } else {
            return String(format: format, arguments: args)
        }
    }
    
    public static var isTurkish: Bool {
        let lang = Locale.current.language.languageCode?.identifier ?? "en"
        return lang.lowercased().hasPrefix("tr")
    }
    
    public static var sampleText: String {
        if isTurkish {
            return """
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
        } else {
            return """
            The screen lights up and nothing is asked of you.
            No setup, no commitment, just words.
            
            Reading faster does not mean caring less.
            It means trusting your brain more.
            
            Your brain is remarkably good with patterns.
            Better than you think.
            
            Reading usually takes effort.
            This doesn't.
            
            Words come.
            Words go.
            They don't linger.
            """
        }
    }
}

public extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    func localized(with args: CVarArg...) -> String {
        let format = NSLocalizedString(self, comment: "")
        return String(format: format, arguments: args)
    }
}
