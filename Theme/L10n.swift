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
            Zihnin derinliklerine doğru bir yolculuğa hoş geldiniz.

            Okumak, insanlık tarihinin en büyüleyici zihinsel eylemlerinden biridir. Bir başkasının zihninde doğan bir düşünce, yüzyıllar sonra sizin zihninizde yeniden hayat bulur. Sayfalar, satırlar ve kelimeler; zamana meydan okuyan görünmez köprülerdir.

            Geleneksel okuma alışkanlıklarımızda gözlerimiz satırlar arasında sürekli sıçramalar yapar. Bu istemsiz göz hareketleri hem enerjimizi tüketir hem de dikkatimizi dağıtır. Oysa insan beyni, kelimeleri harf harf değil, anlam örüntüleri halinde bir bütün olarak kavramak üzere tasarlanmıştır.

            FastRead tam bu noktada devreye girer. Kelimeleri doğrudan gözünüzün en rahat odaklandığı merkeze getirerek göz kaslarının yorulmasını önler. Zihniniz, gereksiz fiziksel hareketlerden arınarak sadece fikrin özüne odaklanır.

            Hızlı okumak, metni aceleyle geçmek değildir; aksine dikkatinizi en yüksek seviyeye çıkararak anlama derinliğini artırmaktır. Zamanınızı geri kazandıkça daha çok öğrenir, daha geniş düşünür ve dünyayı daha berrak bir pencereden görmeye başlarsınız.

            Şimdi arkanıza yaslanın, derin bir nefes alın ve kelimelerin zihninizde zahmetsizce akmasına izin verin.
            """
        } else {
            return """
            Welcome to a journey into the depths of focused cognition.

            Reading is one of the most profound inventions of human civilization. A thought born in someone else's mind centuries ago can rekindle within your own mind in an instant. Words and sentences are timeless bridges connecting human intellect across eras.

            In traditional reading, our eyes constantly make saccadic jumps back and forth across lines of text. These involuntary movements consume energy and disrupt the rhythm of comprehension. Yet the human brain was built to process meaningful patterns, not to strain over physical eye mechanics.

            This is where FastRead transforms your experience. By presenting each word directly at your eye's optimal recognition point, it eliminates physical fatigue and cognitive friction. Your mind is freed to absorb pure meaning.

            Speed reading is not about rushing through knowledge; it is about elevating your focus and deepening your understanding. As you master your reading rhythm, you unlock more time to learn, explore, and expand your horizons.

            Now relax, take a deep breath, and let the stream of thoughts flow effortlessly through your mind.
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
