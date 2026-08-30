import SwiftUI
import UIKit

/// İçerik Gezgini - Tüm Metni Görme, Kelimelere Dokunma ve İstenen Yere Atlama Modalı
public struct ContentNavigatorView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var engine = RSVPEngine.shared
    
    @State private var selectedIndex: Int
    @State private var selectedWordText: String = ""
    
    public init() {
        let current = RSVPEngine.shared.currentIndex
        _selectedIndex = State(initialValue: current)
    }
    
    private var selectedProgressRatio: Double {
        guard engine.totalWords > 0 else { return 0 }
        return Double(selectedIndex) / Double(engine.totalWords)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // ÜST BAŞLIK BARI
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(AppColors.subtleGray)
                        )
                }
                
                Spacer()
                
                Text("nav_title".localized)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Color.clear
                    .frame(width: 44, height: 44)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 12)
            
            // ÜST KIRMIZI İLERLEME ÇUBUĞU (Seçilen konuma göre anlık güncellenir)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppColors.subtleGray)
                        .frame(height: 4)
                    
                    Capsule()
                        .fill(AppColors.orpRed)
                        .frame(width: max(10, geo.size.width * CGFloat(selectedProgressRatio)), height: 4)
                        .animation(.easeInOut(duration: 0.2), value: selectedProgressRatio)
                }
            }
            .frame(height: 4)
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
            
            // DOKUNULABİLİR İNTERAKTİF METİN ALANI
            InteractiveTextView(
                tokens: engine.tokens,
                selectedIndex: $selectedIndex,
                onWordTapped: { index, text in
                    self.selectedIndex = index
                    self.selectedWordText = text
                    HapticsManager.shared.trigger(intensity: .light)
                }
            )
            .padding(.horizontal, 16)
            
            Spacer()
            
            // ALT "BURAYA ATLA" AKSİYON KARTI
            VStack(spacing: 8) {
                if !selectedWordText.isEmpty {
                    Text(L10n.tr("nav_selected_word", selectedWordText, selectedIndex + 1, engine.totalWords))
                        .font(.system(size: 13, weight: .medium, design: .monospaced))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                CustomPillButton(
                    title: "nav_jump_here".localized,
                    icon: "scope",
                    backgroundColor: AppColors.buttonPrimary,
                    foregroundColor: AppColors.textPrimary,
                    isFullWidth: true,
                    height: 52
                ) {
                    engine.jumpToIndex(selectedIndex)
                    dismiss()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 20)
            .background(
                Color.white
                    .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: -4)
            )
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            if selectedIndex >= 0 && selectedIndex < engine.tokens.count {
                selectedWordText = engine.tokens[selectedIndex].fullText
            }
        }
    }
}

/// Dokunulduğunda Kelimeyi Algılayan Yüksek Performanslı UITextView Köprüsü
struct InteractiveTextView: UIViewRepresentable {
    let tokens: [RSVPWordToken]
    @Binding var selectedIndex: Int
    let onWordTapped: (Int, String) -> Void
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 80, right: 8)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        textView.addGestureRecognizer(tapGesture)
        context.coordinator.textView = textView
        
        updateContent(textView: textView)
        
        // Mevcut okuma pozisyonuna otomatik kaydır
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            context.coordinator.scrollToSelectedWord()
        }
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        context.coordinator.tokens = tokens
        context.coordinator.selectedIndex = selectedIndex
        updateContent(textView: uiView)
    }
    
    private func updateContent(textView: UITextView) {
        let fullAttributedString = NSMutableAttributedString()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.paragraphSpacing = 16
        
        for (index, token) in tokens.enumerated() {
            let isSelected = index == selectedIndex
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: isSelected ? UIFont.systemFont(ofSize: 19, weight: .bold) : UIFont.systemFont(ofSize: 17, weight: .regular),
                .foregroundColor: isSelected ? UIColor(red: 0.95, green: 0.22, blue: 0.20, alpha: 1.0) : UIColor(red: 0.12, green: 0.13, blue: 0.14, alpha: 0.9),
                .paragraphStyle: paragraphStyle,
                .backgroundColor: isSelected ? UIColor(red: 1.0, green: 0.88, blue: 0.90, alpha: 0.6) : UIColor.clear
            ]
            
            let wordAttr = NSAttributedString(string: token.fullText + " ", attributes: attributes)
            fullAttributedString.append(wordAttr)
        }
        
        textView.attributedText = fullAttributedString
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: InteractiveTextView
        weak var textView: UITextView?
        var tokens: [RSVPWordToken] = []
        var selectedIndex: Int = 0
        
        init(_ parent: InteractiveTextView) {
            self.parent = parent
            self.tokens = parent.tokens
            self.selectedIndex = parent.selectedIndex
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let textView = textView else { return }
            let point = gesture.location(in: textView)
            
            // Dokunulan noktanın karakter indeksini bul
            guard let position = textView.closestPosition(to: point) else { return }
            let charIndex = textView.offset(from: textView.beginningOfDocument, to: position)
            
            // Karakter indeksinden kelime indeksini hesapla
            var runningCharCount = 0
            for (tokenIndex, token) in tokens.enumerated() {
                let tokenLength = token.fullText.count + 1 // +1 for space
                if charIndex >= runningCharCount && charIndex < runningCharCount + tokenLength {
                    parent.onWordTapped(tokenIndex, token.fullText)
                    break
                }
                runningCharCount += tokenLength
            }
        }
        
        func scrollToSelectedWord() {
            guard let textView = textView, selectedIndex < tokens.count else { return }
            var runningCharCount = 0
            for i in 0..<selectedIndex {
                runningCharCount += tokens[i].fullText.count + 1
            }
            
            let range = NSRange(location: runningCharCount, length: min(10, (textView.text as NSString).length - runningCharCount))
            if range.location < (textView.text as NSString).length {
                textView.scrollRangeToVisible(range)
            }
        }
    }
}
