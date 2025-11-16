import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'achievement_model.freezed.dart';
part 'achievement_model.g.dart';

/// Achievement types
@HiveType(typeId: 5)
enum AchievementType {
  @HiveField(0)
  firstTransaction,
  @HiveField(1)
  firstZakat,
  @HiveField(2)
  firstInvestment,
  @HiveField(3)
  streak7Days,
  @HiveField(4)
  streak30Days,
  @HiveField(5)
  streak100Days,
  @HiveField(6)
  savings10M,
  @HiveField(7)
  savings50M,
  @HiveField(8)
  savings100M,
  @HiveField(9)
  zakat10Times,
  @HiveField(10)
  zakat50Times,
  @HiveField(11)
  investment5Types,
  @HiveField(12)
  positiveBalance3Months,
  @HiveField(13)
  budgetMaster,
  @HiveField(14)
  monthlyReviewer,
}

extension AchievementTypeExtension on AchievementType {
  String get title {
    switch (this) {
      case AchievementType.firstTransaction:
        return 'First Step! 🎯';
      case AchievementType.firstZakat:
        return 'Berkah Pertama ✨';
      case AchievementType.firstInvestment:
        return 'Investor Pemula 💼';
      case AchievementType.streak7Days:
        return 'Konsisten 7 Hari 🔥';
      case AchievementType.streak30Days:
        return 'Monthly Warrior ⚡';
      case AchievementType.streak100Days:
        return 'Century Streak 💯';
      case AchievementType.savings10M:
        return 'Nabung 10 Juta 💰';
      case AchievementType.savings50M:
        return 'Half Centi! 🤑';
      case AchievementType.savings100M:
        return 'Centikawan! 👑';
      case AchievementType.zakat10Times:
        return 'Dermawan Sejati 🤲';
      case AchievementType.zakat50Times:
        return 'Zakat Master 🌟';
      case AchievementType.investment5Types:
        return 'Portfolio Diversified 📊';
      case AchievementType.positiveBalance3Months:
        return 'Financial Stable 📈';
      case AchievementType.budgetMaster:
        return 'Budget Master 🎓';
      case AchievementType.monthlyReviewer:
        return 'Analytics Geek 🤓';
    }
  }

  String get description {
    switch (this) {
      case AchievementType.firstTransaction:
        return 'Catat transaksi pertamamu';
      case AchievementType.firstZakat:
        return 'Tunaikan zakat pertama kali';
      case AchievementType.firstInvestment:
        return 'Mulai investasi pertamamu';
      case AchievementType.streak7Days:
        return 'Catat transaksi 7 hari berturut-turut';
      case AchievementType.streak30Days:
        return 'Konsisten 1 bulan penuh!';
      case AchievementType.streak100Days:
        return 'Luar biasa! 100 hari streak!';
      case AchievementType.savings10M:
        return 'Tabunganmu mencapai 10 juta';
      case AchievementType.savings50M:
        return 'Wow! 50 juta tersimpan';
      case AchievementType.savings100M:
        return 'Amazing! 100 juta!';
      case AchievementType.zakat10Times:
        return 'Bayar zakat 10 kali';
      case AchievementType.zakat50Times:
        return 'Bayar zakat 50 kali!';
      case AchievementType.investment5Types:
        return 'Punya 5 jenis investasi berbeda';
      case AchievementType.positiveBalance3Months:
        return 'Surplus 3 bulan berturut-turut';
      case AchievementType.budgetMaster:
        return 'Tidak overspending selama sebulan';
      case AchievementType.monthlyReviewer:
        return 'Buka analytics 10x dalam sebulan';
    }
  }

  String get emoji {
    switch (this) {
      case AchievementType.firstTransaction:
        return '🎯';
      case AchievementType.firstZakat:
        return '✨';
      case AchievementType.firstInvestment:
        return '💼';
      case AchievementType.streak7Days:
        return '🔥';
      case AchievementType.streak30Days:
        return '⚡';
      case AchievementType.streak100Days:
        return '💯';
      case AchievementType.savings10M:
        return '💰';
      case AchievementType.savings50M:
        return '🤑';
      case AchievementType.savings100M:
        return '👑';
      case AchievementType.zakat10Times:
        return '🤲';
      case AchievementType.zakat50Times:
        return '🌟';
      case AchievementType.investment5Types:
        return '📊';
      case AchievementType.positiveBalance3Months:
        return '📈';
      case AchievementType.budgetMaster:
        return '🎓';
      case AchievementType.monthlyReviewer:
        return '🤓';
    }
  }

  int get points {
    switch (this) {
      case AchievementType.firstTransaction:
        return 10;
      case AchievementType.firstZakat:
        return 20;
      case AchievementType.firstInvestment:
        return 30;
      case AchievementType.streak7Days:
        return 50;
      case AchievementType.streak30Days:
        return 100;
      case AchievementType.streak100Days:
        return 500;
      case AchievementType.savings10M:
        return 100;
      case AchievementType.savings50M:
        return 300;
      case AchievementType.savings100M:
        return 1000;
      case AchievementType.zakat10Times:
        return 150;
      case AchievementType.zakat50Times:
        return 500;
      case AchievementType.investment5Types:
        return 200;
      case AchievementType.positiveBalance3Months:
        return 250;
      case AchievementType.budgetMaster:
        return 150;
      case AchievementType.monthlyReviewer:
        return 100;
    }
  }
}

/// Achievement model
@freezed
@HiveType(typeId: 6)
class AchievementModel with _$AchievementModel {
  const factory AchievementModel({
    @HiveField(0) required AchievementType type,
    @HiveField(1) required DateTime unlockedAt,
    @HiveField(2) @Default(false) bool isNew,
  }) = _AchievementModel;

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      _$AchievementModelFromJson(json);
}

/// Streak data
@freezed
@HiveType(typeId: 7)
class StreakData with _$StreakData {
  const factory StreakData({
    @HiveField(0) @Default(0) int currentStreak,
    @HiveField(1) @Default(0) int longestStreak,
    @HiveField(2) DateTime? lastActivityDate,
    @HiveField(3) @Default(0) int totalPoints,
  }) = _StreakData;

  factory StreakData.fromJson(Map<String, dynamic> json) =>
      _$StreakDataFromJson(json);
}
