/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Amwal Islamic';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Islamic Wealth Management Application';

  // Database
  static const String hiveBoxName = 'amwal_box';
  static const String transactionsBox = 'transactions';
  static const String zakatBox = 'zakat';
  static const String investmentBox = 'investment';
  static const String debtBox = 'debt';
  static const String goalsBox = 'goals';
  static const String settingsBox = 'settings';

  // Zakat Constants
  static const double nisabPercentage = 2.5; // 2.5% of wealth
  static const int nisabMonths = 12; // 1 year in Islamic calendar
  static const double goldNisab = 85; // 85 grams of gold
  static const double silverNisab = 595; // 595 grams of silver

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String monthYearFormat = 'MMMM yyyy';
  static const String hijriDateFormat = 'dd MMMM yyyy';

  // Currency
  static const String defaultCurrency = 'IDR';
  static const String currencySymbol = 'Rp';

  // API Endpoints (for future use)
  static const String baseUrl = 'https://api.amwal-islamic.com';
  static const String goldPriceApi = 'https://api.gold-price.com/v1';

  // Shared Preferences Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyUserName = 'user_name';
  static const String keyDefaultCurrency = 'default_currency';
  static const String keyZakatReminder = 'zakat_reminder';
  static const String keySedekahReminder = 'sedekah_reminder';

  // Routes
  static const String routeHome = '/';
  static const String routeZakat = '/zakat';
  static const String routeTransactions = '/transactions';
  static const String routeInvestment = '/investment';
  static const String routeDebt = '/debt';
  static const String routeGoals = '/goals';
  static const String routeEducation = '/education';
  static const String routeSettings = '/settings';

  // Transaction Categories - Income
  static const List<String> incomeCategories = [
    'Gaji',
    'Bonus',
    'Investasi',
    'Bisnis',
    'Hadiah',
    'Lainnya',
  ];

  // Transaction Categories - Expense
  static const List<String> expenseCategories = [
    'Makanan & Minuman',
    'Transportasi',
    'Kesehatan',
    'Pendidikan',
    'Utilitas',
    'Hiburan',
    'Sedekah',
    'Zakat',
    'Infaq',
    'Cicilan',
    'Lainnya',
  ];

  // Investment Types
  static const List<String> investmentTypes = [
    'Saham Syariah',
    'Reksadana Syariah',
    'Sukuk',
    'Emas',
    'Properti',
    'Deposito Syariah',
    'Bisnis',
  ];

  // Goal Categories
  static const List<String> goalCategories = [
    'Haji & Umrah',
    'Pernikahan',
    'Pendidikan',
    'Rumah',
    'Kendaraan',
    'Dana Darurat',
    'Pensiun',
    'Lainnya',
  ];

  // Islamic Months
  static const List<String> islamicMonths = [
    'Muharram',
    'Safar',
    'Rabiul Awal',
    'Rabiul Akhir',
    'Jumadil Awal',
    'Jumadil Akhir',
    'Rajab',
    'Syaban',
    'Ramadan',
    'Syawal',
    'Dzulqaidah',
    'Dzulhijjah',
  ];

  // Islamic Duas for Financial Matters
  static const String duaBeforeTransaction =
      'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ\n\nBismillahi wa \'ala barakatillah\n(Dengan nama Allah dan atas berkah Allah)';

  static const String duaAfterTransaction =
      'الْحَمْدُ لِلَّهِ الَّذِي بِنِعْمَتِهِ تَتِمُّ الصَّالِحَاتُ\n\nAlhamdulillahil ladzi bi ni\'matihi tatimmus sholihaat\n(Segala puji bagi Allah yang dengan nikmat-Nya segala kebaikan menjadi sempurna)';

  static const String duaForWealth =
      'اللَّهُمَّ بَارِكْ لِي فِيمَا رَزَقْتَنِي وَقِنِي عَذَابَ النَّارِ\n\nAllahumma baarik lii fiimaa razaqtanii wa qinii \'adzaaban naar\n(Ya Allah, berkahilah rezeki yang Engkau berikan kepadaku dan lindungilah aku dari siksa neraka)';
}
