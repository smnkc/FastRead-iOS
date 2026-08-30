# FastRead iOS 🚀

Hızlı okuma (RSVP - Rapid Serial Visual Presentation) tekniği ile metinleri odak harfini (ORP) merkezleyerek kavrayış kaybı olmadan 3 kata kadar daha hızlı okutan modern iOS uygulaması.

---

## 📱 Proje Özellikleri

- **Geliştirici:** Osman Akça
- **Bundle ID:** `com.smnkc.FastRead`
- **Kategori:** Araçlar (Utilities / `public.app-category.utilities`)
- **Mimari:** Native SwiftUI, Swift 5.9+ / 6.0+, iOS 17.0+
- **RSVP Motoru:** Dinamik ORP (Optimal Recognition Point) hesaplama, noktalama ve cümle sonu duraklama gecikmesi, 100-1000 WPM hız ayarı.
- **İçerik Gezgini:** Tüm metni paragraflar halinde görüp aktif kelimeyi kırmızı renkte takip edebilme ve "Buraya atla" ile istenen konuma zıplayabilme.
- **Özel Görünüm & Tema:** 3 Hazır Ön Ayar (*Klasik, Kitap, Gradyan*), 8 renkli ORP paleti, arka plan ve metin kontrast ayarları, *OpenDyslexic* disleksi dostu font desteği.
- **Haptik Geri Bildirim:** Kelime ve cümle sonu için 4 seviyeli CoreHaptics titreşim motoru.
- **Kitaplık & İçe Aktarma:** Pano kopyalama, PDF, EPUB, Web bağlantısı ve metin dosyalarını içe aktarma ve okuma ilerlemesini kaydetme.

---

## 🛠️ Xcode'da Nasıl Çalıştırılır?

1. Xcode'u açın.
2. **File > New > Project** seçin ve **iOS > App** şablonunu seçin.
3. Proje adını `FastRead`, Organization Identifier kısmını `com.smnkc` yapın.
4. Masaüstünüzdeki `FastRead-iOS` klasöründeki tüm dosyaları projeye sürükleyip bırakın (veya Xcode üzerinden bu klasörü açın).
5. Hedef Simülatörü (ör. *iPhone 16 Pro*) veya fiziksel iPhone cihazınızı seçip **Run (⌘ + R)** butonuna basın.

---

## 📂 Dosya Hiyerarşisi

```
FastRead-iOS/
├── FastReadApp.swift                  # Uygulama Başlangıç Noktası
├── Info.plist                         # Bundle Identifier & İzin Tanımları
├── APP_SPEC.md                        # Ekran Tasarım ve Akış Dokümanı
├── README.md                          # Proje Açıklama ve Kurulum Kılavuzu
├── Models/
│   ├── DocumentItem.swift             # Kitaplık Belge Modeli
│   ├── ReaderTheme.swift              # Tema ve Arka Plan Modelleri
│   ├── ORPColor.swift                 # 8 Renkli Odak Harfi Paleti
│   ├── FontPreference.swift           # Tipografi Tercihleri
│   └── ReaderSettings.swift           # WPM, Duraklama ve Haptik Ayarları
├── Engine/
│   ├── RSVPEngine.swift               # RSVP Hızlı Okuma Motoru
│   ├── DocumentParser.swift           # PDF, Web URL ve Metin Ayrıştırıcı
│   └── HapticsManager.swift           # UIImpactFeedbackGenerator Titreşim Motoru
├── Theme/
│   ├── AppColors.swift                # Degrade ve Renk Paleti
│   ├── AppFonts.swift                 # RSVP Tipografi Fonksiyonları
│   └── ThemeManager.swift             # Dinamik Tema Yönetimi
├── Views/
│   ├── Root/
│   │   ├── RootView.swift             # Onboarding / Ana Uygulama Yönlendiricisi
│   │   └── MainTabView.swift          # Özel Floating Tab Bar ile 3 Sekmeli Görünüm
│   ├── Onboarding/
│   │   ├── OnboardingFlowView.swift   # 5 Adımlı İnteraktif Karşılama ve Eğitim
│   │   └── OnboardingCardView.swift   # Beyin, Göz ve Belge İkonlu Özel Kartlar
│   ├── Reader/
│   │   ├── ReaderHomeView.swift       # "Oku" Ana Sayfası (Pano, PDF/EPUB, Bir örnek dene)
│   │   ├── RSVPPlayerView.swift       # Tam Ekran RSVP Oynatıcı
│   │   ├── ContentNavigatorView.swift # İçerik Gezgini ("Buraya atla")
│   │   └── SpeedPickerSheet.swift     # WPM Hız Seçici Modalı
│   ├── Library/
│   │   ├── LibraryView.swift          # "Kitaplık" Ekranı, Arama ve Boş Durum
│   │   └── WebLinkInputSheet.swift    # Web URL Ekleme Modalı
│   ├── Settings/
│   │   ├── SettingsView.swift         # Ayarlar Ana Sayfası (Osman Akça)
│   │   ├── ReaderTimingView.swift     # Hız ve Cümle Sonu Bekleme Ayarları
│   │   ├── ReaderAppearanceView.swift # Canlı Önizleme ve Görünüm Seçenekleri
│   │   └── ReaderHapticsView.swift    # Dokunsal Geri Bildirim Ayarları
│   └── Components/
│       ├── FloatingTabBar.swift       # Yüzen Hap Alt Gezinme Çubuğu
│       ├── RSVPCenteredWordView.swift # Milimetrik ORP Merkezleme Görünümü
│       ├── CustomModalDialog.swift    # Özel Apple Tarzı Modal Diyalogları
│       └── CustomPillButton.swift     # Oval Eylem Butonları
```
