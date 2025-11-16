# Amwal Islamic - Aplikasi Manajemen Keuangan Islami

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Material Design 3](https://img.shields.io/badge/Material-Design%203-green.svg)
![License](https://img.shields.io/badge/license-MIT-orange.svg)

Aplikasi mobile untuk manajemen keuangan berbasis syariah Islam, dibangun dengan Flutter dan Material Design 3.

## 📱 Fitur Utama

### 1. Kalkulator Zakat 💰
- Zakat Mal (Harta)
- Zakat Penghasilan/Profesi
- Zakat Perdagangan
- Zakat Pertanian
- Zakat Fitrah
- Nisab tracker dengan harga emas real-time

### 2. Manajemen Transaksi 📊
- Pencatatan pemasukan & pengeluaran
- Kategorisasi transaksi (halal/haram/syubhat)
- Budget planning berdasarkan prinsip Islam
- Laporan keuangan bulanan/tahunan
- Visualisasi data dengan charts

### 3. Tracker Sedekah & Infaq 🤲
- Riwayat sedekah
- Target sedekah rutin
- Reminder sedekah (Jumat, bulan tertentu)
- Statistik amalan jariyah

### 4. Investasi Syariah 📈
- Portfolio investasi syariah
- Tracker saham syariah
- Sukuk & reksadana syariah
- ROI calculator halal

### 5. Manajemen Hutang 📝
- Tracker hutang (Qardh Hasan)
- Cicilan tanpa riba
- Reminder pembayaran
- History hutang piutang

### 6. Target Keuangan 🎯
- Tabungan Haji/Umrah
- Tabungan pernikahan
- Dana pendidikan anak
- Dana darurat
- Progress tracker dengan doa

### 7. Edukasi Keuangan Islami 📚
- Artikel fiqh muamalah
- Video pembelajaran
- Quiz interaktif
- Fatwa keuangan

## 🏗️ Struktur Project

```
lib/
├── core/
│   ├── config/
│   │   ├── app_router.dart         # GoRouter configuration
│   │   └── database_service.dart    # Hive database setup
│   ├── constants/
│   │   └── app_constants.dart       # App-wide constants
│   ├── theme/
│   │   ├── app_colors.dart          # Color palette
│   │   └── app_theme.dart           # Material Design 3 theme
│   └── utils/
│       ├── formatters.dart          # Currency, date formatters
│       └── validators.dart          # Input validators
├── features/
│   ├── home/                        # Dashboard & home
│   ├── zakat/                       # Zakat calculator
│   ├── transactions/                # Transaction management
│   ├── investment/                  # Investment tracking
│   ├── debt/                        # Debt management
│   ├── goals/                       # Financial goals
│   ├── education/                   # Islamic finance education
│   └── settings/                    # App settings
├── shared/
│   ├── widgets/                     # Reusable widgets
│   └── services/                    # Shared services
├── app.dart                         # Main app widget
└── main.dart                        # Entry point
```

Setiap feature menggunakan **Clean Architecture**:
```
feature/
├── data/
│   ├── models/                      # Data models
│   ├── repositories/                # Repository implementations
│   └── datasources/                 # Local/Remote data sources
├── domain/
│   ├── entities/                    # Business entities
│   └── usecases/                    # Business logic
└── presentation/
    ├── pages/                       # UI pages
    └── widgets/                     # Feature-specific widgets
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: Riverpod
- **Routing**: GoRouter
- **Local Database**: Hive
- **UI**: Material Design 3
- **Code Generation**: Freezed, JSON Serializable
- **Date/Time**: Hijri Calendar
- **Charts**: FL Chart

## 📦 Dependencies

```yaml
# State Management
flutter_riverpod: ^2.5.1
riverpod_annotation: ^2.3.5

# Local Database
hive: ^2.2.3
hive_flutter: ^1.1.0

# Routing
go_router: ^14.2.0

# UI Components
fl_chart: ^0.68.0
shimmer: ^3.0.0
flutter_slidable: ^3.1.0

# Utilities
intl: ^0.19.0
hijri: ^3.0.0
dartz: ^0.10.1
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode (untuk iOS)
- Android SDK / iOS SDK

### Installation

1. **Clone repository**
```bash
git clone https://github.com/yogieeka/Amwal-mobile.git
cd Amwal-mobile
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run app**
```bash
flutter run
```

### Build untuk Production

**Android:**
```bash
flutter build apk --release
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 🎨 Design System

### Color Palette

- **Primary (Islamic Green)**: `#00695C`
- **Secondary (Gold)**: `#FFB300`
- **Accent Blue**: `#1976D2`
- **Success**: `#388E3C`
- **Warning**: `#F57C00`
- **Error**: `#D32F2F`

### Typography

Menggunakan Material Design 3 typography dengan font system default dan Amiri untuk konten Arab.

## 📱 Screenshots

*Coming soon...*

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test

# Run with coverage
flutter test --coverage
```

## 📝 Roadmap

- [x] Setup project structure
- [x] Material Design 3 theming
- [x] Basic navigation
- [ ] Implement Zakat calculator
- [ ] Add transaction management
- [ ] Implement investment tracking
- [ ] Add debt management
- [ ] Create financial goals feature
- [ ] Add Islamic education content
- [ ] API integration for gold prices
- [ ] Push notifications
- [ ] Cloud backup
- [ ] Multi-language support (Arabic, English)

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) first.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Material Design 3 Guidelines
- Islamic Finance Principles
- Flutter Community
- All contributors

## 📞 Contact

- **Email**: support@amwal-islamic.com
- **Website**: https://amwal-islamic.com
- **GitHub**: https://github.com/yogieeka/Amwal-mobile

---

**Bismillahirrahmanirrahim** - Semoga aplikasi ini bermanfaat untuk ummat Islam dalam mengelola harta sesuai syariat.

