/// Transaction type enum
enum TransactionType {
  income,
  expense,
  zakat,
  sedekah,
  investment,
}

/// Extension for TransactionType
extension TransactionTypeExtension on TransactionType {
  String get displayName {
    switch (this) {
      case TransactionType.income:
        return 'Pemasukan';
      case TransactionType.expense:
        return 'Pengeluaran';
      case TransactionType.zakat:
        return 'Zakat';
      case TransactionType.sedekah:
        return 'Sedekah';
      case TransactionType.investment:
        return 'Investasi';
    }
  }

  String get iconName {
    switch (this) {
      case TransactionType.income:
        return 'arrow_downward';
      case TransactionType.expense:
        return 'arrow_upward';
      case TransactionType.zakat:
        return 'volunteer_activism';
      case TransactionType.sedekah:
        return 'favorite';
      case TransactionType.investment:
        return 'trending_up';
    }
  }
}
