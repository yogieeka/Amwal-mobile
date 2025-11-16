/// Service for calculating various types of zakat
class ZakatCalculatorService {
  ZakatCalculatorService._();

  static final ZakatCalculatorService instance = ZakatCalculatorService._();

  // Constants
  static const double zakatPercentage = 2.5; // 2.5%
  static const double goldNisabGrams = 85; // 85 grams of gold
  static const double silverNisabGrams = 595; // 595 grams of silver
  static const int haulMonths = 12; // 1 year in Hijri calendar

  /// Calculate Zakat Mal (Wealth)
  /// Formula: If wealth >= nisab for 1 year, then zakat = wealth * 2.5%
  ZakatMalResult calculateZakatMal({
    required double cash,
    required double savings,
    required double gold,
    required double silver,
    required double investments,
    required double receivables,
    required double debt,
    required double goldPricePerGram,
  }) {
    // Calculate total wealth
    final totalWealth = cash + savings + gold + silver + investments + receivables - debt;

    // Calculate nisab based on gold price
    final nisab = goldNisabGrams * goldPricePerGram;

    // Check if zakat is wajib
    final isWajib = totalWealth >= nisab;

    // Calculate zakat amount
    final zakatAmount = isWajib ? (totalWealth * zakatPercentage / 100) : 0.0;

    return ZakatMalResult(
      totalWealth: totalWealth,
      nisab: nisab,
      isWajib: isWajib,
      zakatAmount: zakatAmount,
      details: {
        'cash': cash,
        'savings': savings,
        'gold': gold,
        'silver': silver,
        'investments': investments,
        'receivables': receivables,
        'debt': debt,
        'goldPricePerGram': goldPricePerGram,
      },
    );
  }

  /// Calculate Zakat Penghasilan (Income)
  /// Formula: If monthly income >= nisab/12, then zakat = income * 2.5%
  ZakatPenghasilanResult calculateZakatPenghasilan({
    required double monthlyIncome,
    required double monthlyExpenses,
    required double goldPricePerGram,
    bool useNetIncome = false,
  }) {
    // Calculate nisab
    final nisab = goldNisabGrams * goldPricePerGram;
    final nisabPerMonth = nisab / 12;

    // Calculate income to be used
    final incomeForZakat = useNetIncome ? (monthlyIncome - monthlyExpenses) : monthlyIncome;

    // Check if zakat is wajib
    final isWajib = incomeForZakat >= nisabPerMonth;

    // Calculate zakat amount
    final zakatAmount = isWajib ? (incomeForZakat * zakatPercentage / 100) : 0.0;

    return ZakatPenghasilanResult(
      monthlyIncome: incomeForZakat,
      nisabPerMonth: nisabPerMonth,
      isWajib: isWajib,
      zakatAmount: zakatAmount,
      annualZakat: zakatAmount * 12,
      details: {
        'grossIncome': monthlyIncome,
        'monthlyExpenses': monthlyExpenses,
        'useNetIncome': useNetIncome,
        'goldPricePerGram': goldPricePerGram,
      },
    );
  }

  /// Calculate Zakat Perdagangan (Trading/Business)
  /// Formula: (Assets + Cash + Receivables - Debt) * 2.5%
  ZakatPerdaganganResult calculateZakatPerdagangan({
    required double inventory,
    required double cash,
    required double receivables,
    required double debt,
    required double goldPricePerGram,
  }) {
    // Calculate total business wealth
    final totalWealth = inventory + cash + receivables - debt;

    // Calculate nisab
    final nisab = goldNisabGrams * goldPricePerGram;

    // Check if zakat is wajib
    final isWajib = totalWealth >= nisab;

    // Calculate zakat amount
    final zakatAmount = isWajib ? (totalWealth * zakatPercentage / 100) : 0.0;

    return ZakatPerdaganganResult(
      totalWealth: totalWealth,
      nisab: nisab,
      isWajib: isWajib,
      zakatAmount: zakatAmount,
      details: {
        'inventory': inventory,
        'cash': cash,
        'receivables': receivables,
        'debt': debt,
        'goldPricePerGram': goldPricePerGram,
      },
    );
  }

  /// Calculate Zakat Pertanian (Agriculture)
  /// Formula:
  /// - 10% if rain-watered
  /// - 5% if artificially irrigated
  ZakatPertanianResult calculateZakatPertanian({
    required double harvestValue,
    required bool isRainWatered,
    required double nisabInKg,
  }) {
    // Nisab for agriculture is typically 653 kg (5 wasq)
    final defaultNisab = nisabInKg > 0 ? nisabInKg : 653;

    // Check if zakat is wajib
    final isWajib = harvestValue >= defaultNisab;

    // Calculate percentage based on irrigation type
    final percentage = isRainWatered ? 10.0 : 5.0;

    // Calculate zakat amount
    final zakatAmount = isWajib ? (harvestValue * percentage / 100) : 0.0;

    return ZakatPertanianResult(
      harvestValue: harvestValue,
      nisab: defaultNisab,
      isWajib: isWajib,
      zakatAmount: zakatAmount,
      percentage: percentage,
      details: {
        'isRainWatered': isRainWatered,
        'nisabInKg': defaultNisab,
      },
    );
  }

  /// Calculate Zakat Fitrah
  /// Formula: Fixed amount per person (typically 2.5-3 kg of staple food or its monetary value)
  ZakatFitrahResult calculateZakatFitrah({
    required int numberOfPeople,
    required double pricePerKg,
    double kgPerPerson = 2.5,
  }) {
    // Calculate total amount
    final totalKg = numberOfPeople * kgPerPerson;
    final totalAmount = totalKg * pricePerKg;

    return ZakatFitrahResult(
      numberOfPeople: numberOfPeople,
      kgPerPerson: kgPerPerson,
      pricePerKg: pricePerKg,
      totalKg: totalKg,
      totalAmount: totalAmount,
      details: {
        'numberOfPeople': numberOfPeople,
        'kgPerPerson': kgPerPerson,
        'pricePerKg': pricePerKg,
      },
    );
  }

  /// Get current gold price (mock - should be replaced with API call)
  Future<double> getCurrentGoldPrice() async {
    // TODO: Replace with actual API call
    // For now, return approximate price (Rp 1,000,000 per gram)
    return 1000000.0;
  }

  /// Get current rice price for Zakat Fitrah (mock - should be replaced with API call)
  Future<double> getCurrentRicePrice() async {
    // TODO: Replace with actual API call
    // For now, return approximate price (Rp 15,000 per kg)
    return 15000.0;
  }
}

// Result classes
class ZakatMalResult {
  final double totalWealth;
  final double nisab;
  final bool isWajib;
  final double zakatAmount;
  final Map<String, dynamic> details;

  ZakatMalResult({
    required this.totalWealth,
    required this.nisab,
    required this.isWajib,
    required this.zakatAmount,
    required this.details,
  });
}

class ZakatPenghasilanResult {
  final double monthlyIncome;
  final double nisabPerMonth;
  final bool isWajib;
  final double zakatAmount;
  final double annualZakat;
  final Map<String, dynamic> details;

  ZakatPenghasilanResult({
    required this.monthlyIncome,
    required this.nisabPerMonth,
    required this.isWajib,
    required this.zakatAmount,
    required this.annualZakat,
    required this.details,
  });
}

class ZakatPerdaganganResult {
  final double totalWealth;
  final double nisab;
  final bool isWajib;
  final double zakatAmount;
  final Map<String, dynamic> details;

  ZakatPerdaganganResult({
    required this.totalWealth,
    required this.nisab,
    required this.isWajib,
    required this.zakatAmount,
    required this.details,
  });
}

class ZakatPertanianResult {
  final double harvestValue;
  final double nisab;
  final bool isWajib;
  final double zakatAmount;
  final double percentage;
  final Map<String, dynamic> details;

  ZakatPertanianResult({
    required this.harvestValue,
    required this.nisab,
    required this.isWajib,
    required this.zakatAmount,
    required this.percentage,
    required this.details,
  });
}

class ZakatFitrahResult {
  final int numberOfPeople;
  final double kgPerPerson;
  final double pricePerKg;
  final double totalKg;
  final double totalAmount;
  final Map<String, dynamic> details;

  ZakatFitrahResult({
    required this.numberOfPeople,
    required this.kgPerPerson,
    required this.pricePerKg,
    required this.totalKg,
    required this.totalAmount,
    required this.details,
  });
}
