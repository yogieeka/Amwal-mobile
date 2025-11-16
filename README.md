# Amwal Islamic - Aplikasi Manajemen Keuangan Islami 🕌💰

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Material Design 3](https://img.shields.io/badge/Material-Design%203-green.svg)
![License](https://img.shields.io/badge/license-MIT-orange.svg)

Aplikasi mobile untuk manajemen keuangan berbasis syariah Islam dengan pendekatan modern dan Gen Z-friendly. Dibangun dengan Flutter dan Material Design 3.

## ✨ Kenapa Amwal Islamic?

- **100% Syariah Compliant** - Semua fitur sesuai prinsip keuangan Islam
- **Gen Z Friendly** - UI modern dengan gamification dan micro-interactions
- **Offline First** - Semua data tersimpan lokal, no internet required
- **Privacy First** - Data keuangan kamu aman dan private
- **Free & Open Source** - Gratis selamanya tanpa ads

## 📱 Fitur Utama

### 1. Kalkulator Zakat Komprehensif 💰
- **Zakat Mal (Harta)** - Kalkulator untuk harta yang sudah mencapai nisab
- **Zakat Penghasilan/Profesi** - Hitung zakat dari gaji bulanan (2.5%)
- **Zakat Fitrah** - Kalkulator zakat fitrah dengan harga beras real-time
- **Nisab Tracker** - Monitor apakah hartamu sudah wajib zakat
- **Haul Counter** - Tracking 12 bulan kepemilikan harta

### 2. Manajemen Transaksi 📊
- **CRUD Lengkap** - Create, Read, Update, Delete transaksi
- **Kategorisasi Cerdas** - Income, Expense, Zakat, Sedekah, Infaq
- **Filter & Search** - Cari transaksi by kategori, tanggal, amount
- **Swipe Actions** - Edit/delete dengan gesture swipe
- **Auto-calculation** - Saldo otomatis terhitung

### 3. Analytics & Visualisasi 📈
- **Bar Charts** - Perbandingan income vs expense
- **Pie Charts** - Breakdown spending by kategori
- **Smart Insights** - AI-powered financial insights:
  - Savings rate analysis
  - Top spending category alerts
  - Zakat reminder
  - Budget warnings
  - Positive reinforcement

### 4. Investasi Syariah Tracker 💎
- **Portfolio Management** - Track semua investasi syariah
- **7 Jenis Investasi**:
  - Sukuk (Obligasi Syariah)
  - Saham Syariah
  - Reksadana Syariah
  - Emas
  - Properti
  - Deposito Syariah
  - Bisnis
- **ROI Calculator** - Hitung return on investment
- **Performance Tracking** - Monitor gain/loss portfolio

### 5. Gamification System 🎮
- **15 Achievements** dengan emoji badges:
  - First Step (transaksi pertama)
  - Zakat Warrior (10x, 50x zakat)
  - Savings Master (10M, 50M, 100M)
  - Streak Champion (7, 30, 100 hari)
  - Dan banyak lagi!
- **10-Level Progression**:
  - Pemula 🌱 → Learner 📚 → Saver 💰 → Investor 📈 → ... → Divine 🔥
- **Streak System** - Daily check-in rewards
- **Points & XP** - Earn points dari setiap aktivitas
- **Celebration Animations** - Confetti saat unlock achievement

### 6. Discover - Content Feed 🔍
- **RSS News Feed** - Berita keuangan syariah real-time dari:
  - Republika Ekonomi Syariah
  - Kontan Syariah
- **Curated Tips** - 5 tips finansial pilihan:
  - Cara Memulai Investasi Syariah
  - Mengelola Keuangan ala Rasulullah
  - Tips Nabung untuk Gen Z
  - Zakat 101
  - Hindari 5 Kesalahan Finansial
- **Tab-based UI** - "Tips & Edukasi" | "Berita"
- **Pull-to-refresh** - Update konten terbaru
- **External Browser** - Baca artikel lengkap di browser

### 7. Onboarding Experience 🎯
- **4 Interactive Screens** dengan gradient animations:
  - Kelola Keuangan Secara Islami
  - Track Zakat & Sedekah
  - Investasi Halal
  - Capai Target Keuangan
- **Skip Button** - Langsung ke app
- **Progress Indicators** - Visual progress dots
- **Smooth Transitions** - Page animations

### 8. Theme Customization 🎨
- **Light Mode** - Clean & modern
- **Dark Mode** - OLED-friendly dark theme
- **Toggle di Settings** - Ganti theme kapan aja
- **Persistent** - Theme preference tersimpan

### 9. Empty States & Animations ✨
- **7 Animated Empty States**:
  - No Transactions
  - No Investments
  - No Debts
  - No Goals
  - No Analytics Data
  - No Search Results
  - No Achievements Unlocked
- **Floating Emoji Animations** - Engaging & playful
- **Motivational Copy** - Gen Z language

### 10. Manajemen Hutang & Target 📝
- **Debt Tracker** - Monitor hutang piutang
- **Goals Planner** - Set financial goals
- **Progress Tracker** - Visual progress dengan percentage

## 🏗️ Struktur Project

```
lib/
├── core/
│   ├── config/
│   │   ├── app_router.dart              # GoRouter configuration
│   │   ├── database_service.dart        # Hive database setup
│   │   ├── theme_provider.dart          # Theme state management
│   │   └── onboarding_provider.dart     # Onboarding state
│   ├── constants/
│   │   └── app_constants.dart           # App-wide constants
│   ├── theme/
│   │   ├── app_colors.dart              # Color palette & gradients
│   │   └── app_theme.dart               # Material Design 3 theme
│   └── utils/
│       ├── formatters.dart              # Currency, date formatters
│       ├── validators.dart              # Input validators
│       └── insights_generator.dart      # Smart financial insights
├── features/
│   ├── home/                            # Dashboard & home
│   ├── onboarding/                      # Onboarding flow
│   ├── zakat/                           # Zakat calculator
│   ├── transactions/                    # Transaction management
│   │   ├── data/models/
│   │   ├── domain/repositories/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── transactions_page.dart
│   │       │   ├── add_transaction_page.dart
│   │       │   └── analytics_page.dart
│   │       └── providers/
│   ├── investment/                      # Investment tracking
│   ├── debt/                            # Debt management
│   ├── goals/                           # Financial goals
│   ├── discover/                        # RSS news feed
│   │   ├── data/models/
│   │   │   └── article_model.dart
│   │   ├── domain/services/
│   │   │   └── rss_service.dart
│   │   └── presentation/pages/
│   │       └── discover_page.dart
│   ├── gamification/                    # Achievements & levels
│   │   ├── data/models/
│   │   │   └── achievement_model.dart
│   │   ├── domain/services/
│   │   │   └── achievement_service.dart
│   │   └── presentation/pages/
│   │       └── achievements_page.dart
│   ├── education/                       # Islamic finance education
│   └── settings/                        # App settings
├── shared/
│   ├── widgets/
│   │   ├── empty_states/
│   │   │   └── animated_empty_state.dart
│   │   ├── celebration_widget.dart
│   │   ├── level_progress_widget.dart
│   │   ├── streak_counter_widget.dart
│   │   ├── income_expense_bar_chart.dart
│   │   └── expense_pie_chart.dart
│   └── services/
├── app.dart                             # Main app widget
└── main.dart                            # Entry point
```

Setiap feature menggunakan **Clean Architecture**:
```
feature/
├── data/
│   ├── models/                          # Data models (Freezed)
│   ├── repositories/                    # Repository implementations
│   └── datasources/                     # Local/Remote data sources
├── domain/
│   ├── entities/                        # Business entities
│   ├── repositories/                    # Repository interfaces
│   └── services/                        # Business logic
└── presentation/
    ├── pages/                           # UI pages
    ├── widgets/                         # Feature-specific widgets
    └── providers/                       # Riverpod state management
```

## 🛠️ Tech Stack

### Core
- **Framework**: Flutter 3.0+
- **Language**: Dart 3.0+
- **Architecture**: Clean Architecture + Feature-first
- **State Management**: Riverpod 2.5+
- **Routing**: GoRouter 14.2+

### Data & Storage
- **Local Database**: Hive 2.2+ (NoSQL, fast)
- **Shared Preferences**: Persistent settings
- **Code Generation**: Freezed, JSON Serializable

### UI & UX
- **Design System**: Material Design 3
- **Charts**: FL Chart 0.68+
- **Animations**: Custom animations dengan AnimationController
- **Icons**: Material Symbols Icons
- **Slidable**: flutter_slidable for swipe actions

### Utilities
- **Date/Time**: Hijri Calendar, Timezone
- **Formatting**: intl, currency_formatter
- **HTTP**: dio, http
- **RSS Parsing**: webfeed 0.7+
- **URL Launcher**: url_launcher 6.2+
- **Functional**: dartz (Either, Option)

## 📦 Dependencies

```yaml
dependencies:
  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Local Database
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Routing
  go_router: ^14.2.0

  # API & Network
  dio: ^5.4.3+1
  http: ^1.2.1
  webfeed: ^0.7.0
  url_launcher: ^6.2.5

  # UI Components
  fl_chart: ^0.68.0
  shimmer: ^3.0.0
  flutter_slidable: ^3.1.0

  # Utilities
  intl: ^0.19.0
  shared_preferences: ^2.2.3
  path_provider: ^2.1.3
  uuid: ^4.4.0
  hijri: ^3.0.0
  timezone: ^0.9.3
  dartz: ^0.10.1
  currency_formatter: ^2.2.1

  # Code Generation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0

dev_dependencies:
  # Code Generation
  build_runner: ^2.4.9
  hive_generator: ^2.0.1
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  riverpod_generator: ^2.4.0

  # Testing
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0) - [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode (untuk iOS)
- VS Code / Android Studio (recommended IDE)

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

3. **Generate code (untuk Freezed & Hive)**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run app**
```bash
flutter run
```

### Development Mode

```bash
# Run with hot reload
flutter run

# Run on specific device
flutter run -d <device-id>

# Run with flavor (production)
flutter run --flavor production
```

### Build untuk Production

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle (untuk Play Store):**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 🎨 Design System

### Color Palette

**Primary Colors:**
- Islamic Green: `#00695C` - Primary brand color
- Secondary Gold: `#FFB300` - Accent & highlights

**Functional Colors:**
- Income: `#4CAF50` (Green)
- Expense: `#F44336` (Red)
- Zakat: `#9C27B0` (Purple)
- Investment: `#FF9800` (Orange)
- Success: `#388E3C`
- Warning: `#F57C00`
- Error: `#D32F2F`

**Gradients:**
- Islamic Gradient: Green to Teal
- Gold Gradient: Amber to Orange
- Purple Gradient: Deep Purple to Purple

### Typography

- **Display**: Material Design 3 Display styles
- **Headline**: Bold, for section headers
- **Body**: Regular, for content
- **Label**: Small, for captions
- **Arabic Font**: Amiri (for dua & Arabic text)

### Components

- **Cards**: Rounded corners (12-16px), subtle shadows
- **Buttons**: Material Design 3 filled/outlined/text
- **Bottom Nav**: 4 items dengan icons & labels
- **App Bar**: Floating with elevation
- **Modal Sheets**: Rounded top corners (24px)

## 📱 Screenshots

### Home Dashboard
- Greeting card dengan gradient Islamic
- Quick stats (Income, Expense, Zakat, Saldo)
- 4x4 Grid quick actions
- Recent transactions list

### Zakat Calculator
- 3 kalkulator: Mal, Penghasilan, Fitrah
- Real-time nisab calculation
- Hijri calendar integration

### Discover Feed
- Tab-based content (Tips | Berita)
- RSS news dengan images
- Curated tips dengan emoji

### Gamification
- Achievement gallery (3 columns grid)
- Level progress circular badge
- Streak counter dengan fire emoji

*Screenshots coming soon...*

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test

# Analyze code
flutter analyze
```

## 📝 Roadmap

### ✅ Completed Features
- [x] Setup project structure dengan Clean Architecture
- [x] Material Design 3 theming (light + dark mode)
- [x] GoRouter navigation
- [x] Hive local database
- [x] Onboarding flow (4 screens)
- [x] Zakat calculator (Mal, Penghasilan, Fitrah)
- [x] Transaction management (CRUD complete)
- [x] Analytics dengan charts (Bar + Pie)
- [x] Smart financial insights
- [x] Investment tracking (7 types)
- [x] Gamification (15 achievements, 10 levels, streaks)
- [x] Discover feed (RSS + curated tips)
- [x] Empty states dengan animations
- [x] Theme switcher (Light/Dark)

### 🚧 In Progress
- [ ] Debt management (UI ready, logic pending)
- [ ] Financial goals (UI ready, logic pending)
- [ ] Education content (placeholder)

### 🔮 Future Plans
- [ ] API integration untuk gold prices real-time
- [ ] Cloud backup (Firebase/Supabase)
- [ ] Push notifications (Zakat reminder, Sedekah)
- [ ] Multi-language (Arabic, English)
- [ ] Export data (PDF, Excel)
- [ ] Social features (Share achievements)
- [ ] Qibla finder integration
- [ ] Prayer times integration
- [ ] Halal investment screener API
- [ ] Cryptocurrency halal checker

## 🤝 Contributing

Contributions are welcome! Jazakallahu khairan for your interest.

### How to Contribute

1. Fork the project
2. Create your feature branch
```bash
git checkout -b feature/AmazingFeature
```
3. Commit your changes
```bash
git commit -m 'Add some AmazingFeature'
```
4. Push to the branch
```bash
git push origin feature/AmazingFeature
```
5. Open a Pull Request

### Coding Standards

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use Clean Architecture pattern
- Write meaningful commit messages
- Add tests for new features
- Update documentation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Allah SWT** - Alhamdulillah untuk semua nikmat
- **Material Design 3** - Google's design system
- **Islamic Finance Scholars** - Untuk ilmu fiqh muamalah
- **Flutter Community** - Amazing framework & support
- **All Contributors** - Jazakallahu khairan

## 📞 Contact & Support

- **Email**: support@amwal-islamic.com
- **Website**: https://amwal-islamic.com
- **GitHub**: https://github.com/yogieeka/Amwal-mobile
- **Issues**: [Report Bug](https://github.com/yogieeka/Amwal-mobile/issues)

## 💡 Inspirasi & Prinsip

### Prinsip Keuangan Islam
1. **Tidak ada Riba** - Zero interest, semua halal
2. **Tidak ada Gharar** - Transparansi penuh
3. **Tidak ada Maysir** - No gambling/speculation
4. **Halal & Thayyib** - Pure & good investments
5. **Zakat & Sedekah** - Purify wealth, help others

### Target Pengguna
- **Gen Z Muslims** (17-25 tahun) yang:
  - Tech-savvy & mobile-first
  - Peduli dengan keuangan halal
  - Suka gamification & visual
  - Butuh edukasi finansial
  - Ingin manage keuangan dengan modern way

### Design Philosophy
- **Simplicity** - Easy to use, no learning curve
- **Delight** - Fun animations & micro-interactions
- **Trust** - Transparent calculations, no hidden fees
- **Privacy** - Your data stays on your device
- **Islamic** - Every feature aligned dengan syariah

---

<div align="center">

**بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ**

*Bismillahirrahmanirrahim*

Semoga aplikasi ini bermanfaat untuk ummat Islam dalam mengelola harta sesuai syariat.

**Barakallahu fiikum** 🤲

Made with ❤️ for Muslim Ummah

</div>
