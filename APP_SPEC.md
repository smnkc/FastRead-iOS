# FastRead iOS - Uygulama Spesifikasyonu & Ekran Takip Dokümanı

## 📌 Proje Genel Bakış
- **Uygulama İsmi:** FastRead
- **Geliştirici / Yazar:** Osman Akça
- **Bundle Identifier:** `com.smnkc.FastRead`
- **Kategori:** Araçlar (Utilities / `public.app-category.utilities`)
- **Hedef Platform:** iOS 17.0+ (SwiftUI & Swift)
- **Temel Konsept:** RSVP (Rapid Serial Visual Presentation) tekniği ile metinleri tek tek kelimeler halinde, odak noktası (ORP - Optimal Recognition Point) kırmızı ile vurgulanarak ultra hızlı ve kavrama kaybı olmadan okutma.
- **Kaynak Formatlar:** EPUB, PDF, Web Bağlantıları (URL), Kopyala-Yapıştır Metinler.
- **Özel Düzenlemeler:** "Özetle" ve "Geri bildirim" özellikleri kullanıcı isteği doğrultusunda kaldırıldı; 3 sekmeli temiz arayüz (Kitaplık, Oku, Ayarlar) uygulandı.

---

## 🎨 Tasarım Dili & Tasarım Sistemi (Design System)

### 1. Renk Paleti (Color Palette)
- **Arka Plan 1 (Minimal):** Saf Beyaz `#FFFFFF` / Açık Nötr Gri `#F8F9FA`
- **Arka Plan 2 (Gradient Onboarding):** Pembe/Somon Yumuşak Radyal Geçiş (Soft Rose-Peach Gradient: `#FFF0F0` -> `#FFDFDF` / `#FFE6E6`)
- **Odak Noktası Vurgusu (ORP / Accent):** Canlı Kırmızı `#E53935` / `#FF3B30`
- **Ana Metin Rengi:** Koyu Antrasit `#1E2022` / `#2C2C2E`
- **İkincil / Açıklama Metni Rengi:** Nötr Gri `#666668` / `#8E8E93`
- **Kart Arka Planları:** Yumuşak köşeli beyaz kartlar (`#FFFFFF`), hafif gölgeli (Soft Drop Shadow: `color: black.opacity(0.06), radius: 16, y: 8`)
- **Ayrım Çizgileri / Rehber Çizgileri:** Çok açık gri `#E5E5EA`
- **Butonlar:** 
  - Üst "Atla" hap (pill) butonu: Beyaz, yuvarlak köşeli (`Capsule()`), hafif gölge / kenar çizgisi.
  - Alt Aksiyon Butonu: Geniş yuvarlatılmış (Rounded Rectangle / Capsule), nötr açık gri arka plan `#EFEFF0` veya temaya göre koyu/kontrast.

### 2. Tipografi (Typography)
- **RSVP Okuma Ekranı:** Monospace / Fixed-width Sans (ör. SF Mono / San Francisco) - kelime uzunluğu değiştikçe ORP (kırmızı harf) tam hizada sabit kalır.
- **Onboarding Kart Başlıkları:** Karakteristik Modern Monospace / Typewriter (ör. `SF Mono`, `Courier New` veya modern monospaced sistem fontu).
- **Gövde Metinleri & Butonlar:** `SF Pro Text / SF Pro Display` (Apple Sistem Fontu).

---

## 📱 İncelenen Ekranlar (Gelen Ekran Görüntüleri)

### [Ekran 01] Karşılama / Canlı RSVP Giriş Ekranı (Media 1)
- **Görsel:** `media_1788076402940.png`
- **Üst Bar:** Sağ üstte "Atla" hap butonu.
- **Merkez Alan:** RSVP Odaklayıcı (Top & bottom horizontal guide lines, ortada kılavuz çentik). Örnek kelime: `Ek[r]an` ('r' harfi kırmızı).
- **Alt Panel:** Oval köşeli beyaz alt kart:
  - Buton: "Haydi başlayalım"
  - Altbilgi: Sol `FastRead` (ReadMaxx), Sağ `v1.0.0` (v1.21.0)

### [Ekran 02] Canlı RSVP Eğitici / İkinci Adım (Media 2)
- **Görsel:** `media_1788076402941.png`
- **Merkez Alan:** `[a]z` kelimesi odaklama çizgileri içinde.
- **Alt Panel:** "Devam et" butonu.

### [Ekran 03] Onboarding Slide 1 - Zihin / Okuma Hızı (Media 3)
- **Görsel:** `media_1788076402945.png`
- **Arka Plan:** Pembe / somon pastel gradyan.
- **Merkez Kart:**
  - Başlık: `Okuma hızınız sabit değildir.`
  - İkon: Sağ üstte Beyin (Brain) ikonu (`brain.head.profile`).
  - Çizgi ayırıcı.
  - Açıklama: `Sadece doğru yöntemi bekliyordu.`
- **Sayfa Göstergesi:** 4 nokta (1. aktif).
- **Alt Panel:** "Devam et" butonu.

### [Ekran 04] Onboarding Slide 2 - Bilimsel RSVP Tekniği (Media 4)
- **Görsel:** `media_1788076402948.png`
- **Merkez Kart:**
  - Başlık: `Bilimle 3 kata kadar daha hızlı okuyun.`
  - İkon: Sağ üstte Göz (Eye) ikonu (`eye`).
  - Çizgi ayırıcı.
  - Açıklama: `FastRead, Rapid Serial Visual Presentation tekniğini kullanır.\n\nKavrayış kaybı olmadan daha hızlı okumayı sağlayan bilimsel dayanaklı bir teknik.`
- **Sayfa Göstergesi:** 4 nokta (2. aktif).
- **Alt Panel:** "Deneyin" butonu.

### [Ekran 05] Onboarding Slide 3 - Belge / Format İçe Aktarma (Media 5)
- **Görsel:** `media_1788076402952.png`
- **Merkez Kart:**
  - Başlık: `Herhangi bir belgeyi içe aktarın.`
  - İkon: Sağ üstte Belge/Metin ikonu (`doc.text.image` / `doc.text`).
  - Çizgi ayırıcı.
  - Açıklama: `EPUB'lar, PDF'ler, web bağlantıları veya yapıştırılan metin.\n\nSizin için önemli olanları okumanın daha hızlı bir yolu.`
- **Sayfa Göstergesi:** 4 nokta (3. aktif).
- **Alt Panel:** "Okumaya başla" butonu.

### [Ekran 06-08] "Oku" (Read) Ana Ekranı & Pano/Bağlantı Uyarı Modalları
- **Görseller:** `media_1788076504806.png`, `media_1788076504808.png`, `media_1788076504809.png`
- **Üst Alan:** Canlı RSVP göstergesi (`Fast[R]ead` kelimesi 'R' harfi kırmızı odak kılavuzunda).
- **Alt İçe Aktarma Kartı:**
  - Pano / Yapıştır butonu (Kopyalanan metin veya linki otomatik algılar)
  - "EPUB veya PDF" Seçim Butonu (`doc.text` ikonu)
  - "VEYA" ayracı
  - Pembe/Kırmızı yumuşak vurgulu "Bir örnek dene" butonu (`line.3.horizontal` ikonu)
  - Altbilgi: Versiyon ve telif.
- **Özel Modal Diyalogları:**
  - Hoş Geldiniz Modalı: *"FastRead uygulamasına hoş geldiniz!"* -> [Başla]
  - Pano Boş Modalı: *"İçerik bulunamadı - Panonuzda hiçbir şey bulunamadı. Lütfen bir şey kopyalayıp tekrar deneyin."* -> [Kapat]
  - Link Boş Modalı: *"Bağlantı bulunamadı - Geçerli bir web bağlantısı kopyalayıp tekrar deneyin."* -> [Kapat]

### [Ekran 09-10] "Kitaplık" (Library) Ekranı
- **Görsel:** `media_1788076504815.png`
- **Üst Başlık Barı:** Pembe/somon yumuşak degrade arka plan, kalın "Kitaplık" başlığı, sağ üstte pembe yuvarlak `+` (Ekle) butonu.
- **Arama Çubuğu:** `🔍 Arayın` yuvarlak köşeli gri arama kutusu.
- **Bilgi Kartı:** *"Oturumlar arasında ilerlemeyi korumak için belgeler ekleyin; böylece döndüğünüzde kaldığınız yerden devam edebilirsiniz."*
- **Boş Durum (Empty State) Kartı:**
  - Sol ikon: Klasör soru işareti (`folder.badge.questionmark`)
  - Başlık: `Belge yok`
  - Açıklama: `Henüz hiç belge eklememişsiniz gibi görünüyor!`
  - Sağ Aksiyon: `+` Ekle butonu.

### 🧭 Alt Gezinme Çubuğu (Floating Floating Tab Bar)
- Özel kapsül (Floating Pill) tasarım:
  1. **Kitaplık** (`tray.full` / `books.vertical`)
  2. **Oku** (`bolt.fill`) - Seçili sekme belirgin hap arka planlı
  3. **Özetle** (`list.bullet`)
  4. **Ayarlar** (`gearshape`)

### [Ekran 11-12] RSVP Oynatıcı / Okuma Ekranı (Player View)
- **Görseller:** `media_1788076521866.png`, `media_1788076521867.png`
- **Üst Bar:** Sol `✕` Kapat butonu, Sağ `•••` Menü butonu.
- **Etkileşim İpucu Kartı (Tooltip Card):**
  - Oynatırken: *"Dokunarak duraklatın - Okuyucuda herhangi bir yere dokunarak duraklatın."*
  - Duraklatıldığında: *"Dokunarak oynatın - Okuyucuda herhangi bir yere dokunarak oynatın."* (Sağda `hand.tap` ikonu).
- **Merkez RSVP Ekranı:**
  - Üst/alt kılavuz çizgileri ve odak çentiği.
  - Kelime odak noktası (ORP) kırmızı harf ile vurgulanır (Örnek: `Ek[r]an`, `iy[i]dir.`).
  - Ekrana dokunulduğunda Oynat / Duraklat toggle olur.
- **Alt Kontrol Paneli:**
  - Süre ve İlerleme: Geçen süre `00:00:04`, Kalan/Toplam süre `00:00:14`, akıcı kaydırıcı (Slider).
  - Buton 1: `Gezgin` (`text.justify` ikonu) -> İçerik Gezginini açar.
  - Buton 2: `▶ Oynat` / `❚❚ Duraklat` aksiyonu.

### [Ekran 13] İçerik Gezgini (Content Navigator Modal)
- **Görsel:** `media_1788076521868.png`
- **Üst Bar:** Sol `✕` Kapat, Başlık: `İçerik gezgini`.
- **Üst İlerleme Çubuğu:** Kırmızı dolgulu yatay ilerleme göstergesi.
- **Metin Görünümü:** Tüm metin paragraflar halinde listelenir. O anki okunan kelime/cümle **Kırmızı** renkle vurgulanır (`Ekran`).
- **Etkileşim:** Kullanıcı metin içinde istediği paragrafa/kelimeye tıklayabilir.
- **Alt Sabit Aksiyon:** `🎯 Buraya atla` butonu (`scope` ikonu ile) -> Seçilen kelimeden RSVP okumayı başlatır.

### [Ekran 14] Oynatıcı Menüsü (More Options Menu)
- **Görsel:** `media_1788076521869.png`
- **Açılan Seçenekler:**
  - ⏱ `Hız` -> WPM (Kelime/Dakika) hız seçici modalını açar.
  - ⚙ `Ayarlar` -> Okuyucu özelleştirme ayarlarını açar.
  - 📋 `Özet` -> Metnin özetini görüntüler.

### [Ekran 15] Okuma Hızı Seçici Modalı (WPM Picker Sheet)
- **Görsel:** `media_1788076521870.png`
- **Üst Bar:** Sol `✕` Kapat, Başlık: `Okuma hızı`.
- **Hız Çarkı / Listesi:** `340, 350, 360, 370, 380 kelime/dk, 390, 400...` seçimi (Özel gri vurgu pill'i).
- **Alt Buton:** `Kaydet` butonu.

### [Ekran 16-17] Ayarlar Ana Ekranı (Settings View)
- **Görseller:** `media_1788076538112.png`, `media_1788076538119.png`
- **Başlık & Üst Bar:** Pembe degrade zemin, Sol `✕` Kapat, Başlık: `Ayarlar`.
- **Kategoriler & Gruplar:**
  - **Okuyucu Grubu:**
    - ⏱ `Zamanlama` (Hız, bekleme süreleri, duraklama ayarları) -> Badge göstergesi
    - ✨ `Görünüm` (Arka plan renkleri, kontrast, tema önizleme) -> Badge göstergesi
    - 📳 `His` (Haptik geri bildirim, titreşim yoğunluğu) -> Badge göstergesi
  - **İpuçları Grubu:**
    - 📋 `Web özeti` (Arka planda özet çıkarma rehberi)
  - **Geri Bildirim Grubu:**
    - 💬 `Geri bildirim` (Fikir ve hata bildirme)
  - **Paylaş Grubu:**
    - 📤 `Paylaş` (Uygulamayı tavsiye etme)
  - **Hakkında Grubu:**
    - 👤 `Yazar` & Versiyon bilgisi

### [Ekran 18-19] Okuyucu Zamanlaması Ayarları (Reader Timing)
- **Görseller:** `media_1788076538113.png`, `media_1788076538114.png`
- **Açılış Bilgi Modalı:** *"Hızı ve bekleme sürelerini ayarlayarak okuyucu zamanlamasını özelleştirin."* -> [Anladım]
- **Ayarlar:**
  - ⏱ `Hız`: `380 kelime/dk` `Hızlı` pill göstergesi ve düzenleme menüsü.
  - 🕒 `Cümle sonu beklemesi`: Her cümlenin son kelimesinde duraklama süresi -> Segment Seçici: `[ Yok | Kısa | Normal | Uzun ]`

### [Ekran 21-25] Okuyucu Görünümünün Tam Özelleştirme Detayları
- **Görseller:** `media_1788076557062.png`, `media_1788076557067.png`, `media_1788076557068.png`, `media_1788076557069.png`, `media_1788076557071.png`
- **Hazır Ön Ayarlar (Presets):**
  - `Klasik` (Beyaz/Açık Gri sade tema)
  - `Kitap` (Sıcak bej/sepya kağıt hissi `#F4EFE6`)
  - `Gradyan` (Pastel pembe-mavi akıcı renk geçişi)
- **Arka Plan Seçenekleri (Backgrounds):**
  - `Yüksek kontrast` (High Contrast Pure White / Dark)
  - `Gri` (Cool Gray)
  - `Gri (sıcak)` (Warm Sepia/Book)
  - `Gradyan` (Pastel Mesh Gradient)
- **Metin Rengi / Kontrast:**
  - `[ Belirgin | Normal | Hafif ]`
- **Odak Harfi Rengi (ORP Highlight Colors):**
  - 8 Renkli Palet: `Siyah`, `Kırmızı (Varsayılan)`, `Turuncu`, `Sarı`, `Yeşil`, `Camgöbeği/Açık Mavi`, `İndigo/Mavi`, `Mor/Fuşya`.
- **Kılavuz Belirginliği (Guide Lines):**
  - `[ Normal | Hafif | Gizli ]`
- **Metin Boyutu (Text Size):**
  - `[ Küçük | Normal | Büyük ]` (RSVP okuma font ölçeği)
- **Yazı Tipi Ailesi (Typography Families):**
  - `Normal` (SF Pro Sans-serif)
  - `Serif` (New York / Klasik Serif)
  - `Serif (Daraltılmış)` (Condensed Serif)
  - `OpenDyslexic` (Disleksi okuma kolaylığı sağlayan özel ağırlıklı font)

### [Ekran 26] Okuyucu Hissi Ayarları (Reader Haptics)
- **Görsel:** `media_1788076576730.png`
- **Başlık & Üst Bar:** Pembe degrade zemin, `<` Geri butonu, Başlık: `Okuyucu hissi`.
- **Açıklama Kartı:** *"FastRead, okurken dokunsal geri bildirim verilmesini sağlar. Bu, kavrayışı artırmaya ve ilgiyi sürdürmeye yardımcı olur."*
- **Dokunsal Geri Bildirim Seçenekleri:**
  - 📶 `Kelime`: Her kelimenin başında verilecek dokunsal geri bildirim -> `[ Yok | Zayıf | Orta | Güçlü ]`
  - 📶 `Cümle sonu`: Her cümlenin sonunda verilecek dokunsal geri bildirim -> `[ Yok | Zayıf | Orta | Güçlü ]`
- **Geri Bildirim Kartı:** Dokunsal geri bildirim önerileri alanı.

### [Ekran 31] Kitaplık Belge Ekleme Menüsü (Library Import Popover)
- **Görsel:** `media_1788076581680.png`
- **Tetikleyici:** Kitaplık sağ üstündeki pembe `+` butonuna dokunulduğunda açılan menü.
- **İçe Aktarma Seçenekleri:**
  1. 📋 `Yapıştır` (`doc.on.doc`): Panodaki metni doğrudan kütüphaneye yeni belge olarak ekler.
  2. 🔗 `Web bağlantısı` (`link`): Web linkinden makale/metin kazır ve ekler.
  3. 📑 `PDF` (`doc.text.image`): iOS Dosyalar uygulamasından PDF seçer ve metnini ayıklar.
  4. 📖 `EPUB` (`book`): EPUB e-kitap dosyasını içe aktarır.
  5. ❓ `Diğer` (`questionmark.folder` / `doc`): TXT, Markdown vb. diğer metin formatlarını yükler.

---

## 🏁 31 Ekranın Tam Özeti & Ekran Haritası (Screen Map)

| # | Ekran Adı | Görsel / Akış | Temel Bileşenler |
|---|---|---|---|
| 01 | Açılış & Canlı RSVP Demosu | Media 1 | RSVP odak çizgisi, `Ek[r]an` gösterimi, Haydi başlayalım butonu |
| 02 | Hızlı Okuma Pratiği | Media 2 | `[a]z` kelimesi ile ORP mantığı, Devam et butonu |
| 03 | Onboarding 1 (Zihin & Hız) | Media 3 | Pembe gradyan, Beyin ikonu, "Okuma hızınız sabit değildir." kartı |
| 04 | Onboarding 2 (Bilimsel RSVP) | Media 4 | Göz ikonu, "Bilimle 3 kata kadar daha hızlı okuyun." kartı, Deneyin butonu |
| 05 | Onboarding 3 (Belge Formatları) | Media 5 | Belge ikonu, EPUB/PDF/Web/Metin desteği, Okumaya başla butonu |
| 06 | Oku Sekmesi (Pano Uyarısı) | Media 6 | "İçerik bulunamadı" modalı, "Kapat" butonu |
| 07 | Oku Sekmesi (Link Uyarısı) | Media 7 | "Bağlantı bulunamadı" modalı, "Kapat" butonu |
| 08 | Oku Sekmesi (Hoş Geldiniz) | Media 8 | "FastRead'e hoş geldiniz!" modalı, "Başla" butonu |
| 09 | Oku Sekmesi Ana Görünüm | Media 6-8 zemin | Pano oku, EPUB/PDF seç, Bir örnek dene butonu, Versiyon altbilgisi |
| 10 | Kitaplık (Boş Durum) | Media 9 | Pembe degrade başlık, Arama kutusu, Bilgi kartı, `Belge yok` kartı |
| 11 | RSVP Oynatıcı (Duraklatılmış) | Media 10 | Sol `✕`, Sağ `•••`, "Dokunarak oynatın" ipucu, Süre slider, Gezgin, Oynat |
| 12 | RSVP Oynatıcı (Oynatılıyor) | Media 11 | "Dokunarak duraklatın" ipucu, `iy[i]dir.` kelimesi, Duraklat butonu |
| 13 | İçerik Gezgini | Media 12 | Kırmızı ilerleme barı, Tam metin görünümü, Aktif kelime kırmızı, "Buraya atla" |
| 14 | Oynatıcı Menüsü ('...') | Media 13 | ⏱ Hız, ⚙ Ayarlar, 📋 Özet seçenekleri |
| 15 | Okuma Hızı Seçici Modalı | Media 14 | WPM Hız tekerleği (340-420+ wpm), Kaydet butonu |
| 16 | Ayarlar (Alt Bölüm) | Media 15 | İpuçları, Geri bildirim, Paylaş, Yazar ve Versiyon kartları |
| 17 | Okuyucu Zamanlaması Modalı | Media 16 | "Okuyucu zamanlamasını özelleştirin" bilgilendirme diyalogu |
| 18 | Okuyucu Zamanlaması Detay | Media 17 | WPM Hız göstergesi, Cümle sonu beklemesi `[Yok, Kısa, Normal, Uzun]` |
| 19 | Okuyucu Görünümü Modalı | Media 18 | "Okuyucunuzun görsel stilini özelleştirin" bilgilendirme diyalogu |
| 20 | Ayarlar Ana Ekranı (Üst) | Media 19 | Zamanlama, Görünüm, His seçenekleri (Kırmızı rozetler) |
| 21 | Görünüm - Kitap Teması | Media 20 | Canlı Sepya önizleme, `[Klasik, Kitap, Gradyan]`, Sıcak gri zemin |
| 22 | Görünüm - Gradyan Teması | Media 21 | Canlı pastel degrade önizleme, Gradyan arka plan |
| 23 | Görünüm - Arka Plan Menüsü | Media 22 | Yüksek kontrast, Gri, Gri (sıcak), Gradyan açılır menü |
| 24 | Görünüm - ORP Renk Paleti | Media 23 | 8 renk seçici, Kılavuz `[Normal, Hafif, Gizli]`, Metin boyutu `[Küçük, Normal, Büyük]` |
| 25 | Görünüm - Yazı Tipi Menüsü | Media 24 | Normal, Serif, Serif (Daraltılmış), OpenDyslexic yazı tipleri |
| 26 | Okuyucu Hissi (Haptik) | Media 25 | Kelime haptik `[Yok, Zayıf, Orta, Güçlü]`, Cümle sonu haptik `[Yok, Zayıf, Orta, Güçlü]` |
| 27 | Web Özeti Rehberi (Adım 1) | Media 26 | Safari'de web sayfası görüntüleme mockup |
| 28 | Web Özeti Rehberi (Adım 2) | Media 29 | Safari Paylaşım menüsünü açma mockup |
| 29 | Web Özeti Rehberi (Adım 3) | Media 27 | FastRead paylaşım eklentisini seçme mockup |
| 30 | Web Özeti Rehberi (Adım 4) | Media 28 | Kısa özet, Önemli noktalar, İçe aktar aksiyonu |
| 31 | Kitaplık İçe Aktarma Menüsü | Media 31 | Yapıştır, Web bağlantısı, PDF, EPUB, Diğer açılır menüsü |

---

## 🏗️ Tam Native iOS SwiftUI Proje Mimarisi

```
FastRead-iOS/
├── FastReadApp.swift                  # Ana SwiftUI App Giriş Noktası
├── APP_SPEC.md                        # Ekran ve tasarım spesifikasyon dokümanı
├── Models/
│   ├── DocumentItem.swift             # Kitaplık belgeleri, okuma pozisyonu, tarih
│   ├── ReaderTheme.swift              # Tema stilleri (Klasik, Kitap, Gradyan, Yüksek Kontrast)
│   ├── ORPColor.swift                 # 8 renk seçeneği
│   ├── FontPreference.swift           # Normal, Serif, Condensed, OpenDyslexic
│   └── ReaderSettings.swift           # WPM, Duraklama, Dokunsal ayarlar
├── Engine/
│   ├── RSVPEngine.swift               # WPM zamanlayıcı, ORP (Odak harfi) hesaplama, noktalama gecikmesi
│   ├── DocumentParser.swift           # PDF, EPUB, Web Link Scraper ve Düz Metin ayrıştırıcı
│   ├── HapticsManager.swift           # UIImpactFeedbackGenerator mikro ve güçlü titreşim motoru
│   └── SummaryEngine.swift            # Metin özetleme ve anahtar nokta çıkarıcı
├── Theme/
│   ├── AppColors.swift                # Degrade pembeler, kart zeminleri, gri tonları
│   ├── AppFonts.swift                 # Monospace, Serif ve OpenDyslexic tanımlamaları
│   └── ThemeManager.swift             # Canlı tema ve görünüm yöneticisi
├── Views/
│   ├── Root/
│   │   ├── RootView.swift             # Onboarding vs Ana Uygulama yönlendiricisi
│   │   └── MainTabView.swift          # Özel Floating Tab Bar ile 4 ana sekme
│   ├── Onboarding/
│   │   ├── OnboardingFlowView.swift   # Canlı RSVP demosu ve 3 adımlı gradyan kartlar
│   │   └── OnboardingCardView.swift   # Beyin, Göz, Belge ikonlu özel kartlar
│   ├── Reader/
│   │   ├── ReaderHomeView.swift       # Oku sekmesi (Pano, PDF/EPUB, Bir örnek dene)
│   │   ├── RSVPPlayerView.swift       # Tam ekran RSVP oynatıcı (kılavuz çizgileri, slider, dokun-duraklat)
│   │   ├── ContentNavigatorView.swift # İçerik Gezgini (Tüm metin, aktif kelime, "Buraya atla")
│   │   └── SpeedPickerSheet.swift     # WPM hız seçici çark / tekerlek
│   ├── Library/
│   │   ├── LibraryView.swift          # Kitaplık ekranı, arama, boş durum, belge listesi
│   │   ├── AddDocumentMenu.swift      # Yapıştır, Web, PDF, EPUB, Diğer menüsü
│   │   └── WebLinkInputSheet.swift    # Web linki yapıştırma modalı
│   ├── Summary/
│   │   ├── SummaryView.swift          # Özetler listesi ve özet çıkarma
│   │   └── WebSummaryTutorialView.swift # 4 adımlı Safari interaktif iPhone mockup rehberi
│   ├── Settings/
│   │   ├── SettingsView.swift         # Ayarlar ana menüsü
│   │   ├── ReaderTimingView.swift     # Hız & Cümle sonu bekleme ayarları
│   │   ├── ReaderAppearanceView.swift # Canlı önizleme, Arka plan, 8 renkli ORP, Boyut, Yazı tipi
│   │   └── ReaderHapticsView.swift    # Kelime ve cümle sonu haptik yoğunluk ayarları
│   └── Components/
│       ├── FloatingTabBar.swift       # 4 sekmeli modern yüzen hap tab bar
│       ├── RSVPCenteredWordView.swift # ORP harfini milimetrik ortalayan kelime bileşeni
│       ├── CustomModalDialog.swift    # "İçerik bulunamadı", "Hoş geldiniz" vb. özel modallar
│       └── CustomPillButton.swift     # Atla, Devam et, Oynat özel buton stilleri
```
