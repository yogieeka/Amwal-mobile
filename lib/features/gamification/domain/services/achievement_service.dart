import '../../../transactions/data/repositories/transaction_repository.dart';
import '../../../investment/data/repositories/investment_repository.dart';
import '../../data/models/achievement_model.dart';

/// Service for checking and unlocking achievements
class AchievementService {
  static final AchievementService instance = AchievementService._();
  AchievementService._();

  /// Check which achievements should be unlocked based on current stats
  List<AchievementType> checkAchievements({
    required int totalTransactions,
    required int totalZakat,
    required int totalInvestments,
    required int investmentTypes,
    required double currentBalance,
    required int currentStreak,
    required int consecutivePositiveMonths,
  }) {
    final unlockedAchievements = <AchievementType>[];

    // First transaction
    if (totalTransactions >= 1) {
      unlockedAchievements.add(AchievementType.firstTransaction);
    }

    // First zakat
    if (totalZakat >= 1) {
      unlockedAchievements.add(AchievementType.firstZakat);
    }

    // First investment
    if (totalInvestments >= 1) {
      unlockedAchievements.add(AchievementType.firstInvestment);
    }

    // Streak achievements
    if (currentStreak >= 7) {
      unlockedAchievements.add(AchievementType.streak7Days);
    }
    if (currentStreak >= 30) {
      unlockedAchievements.add(AchievementType.streak30Days);
    }
    if (currentStreak >= 100) {
      unlockedAchievements.add(AchievementType.streak100Days);
    }

    // Savings achievements
    if (currentBalance >= 10000000) {
      unlockedAchievements.add(AchievementType.savings10M);
    }
    if (currentBalance >= 50000000) {
      unlockedAchievements.add(AchievementType.savings50M);
    }
    if (currentBalance >= 100000000) {
      unlockedAchievements.add(AchievementType.savings100M);
    }

    // Zakat frequency
    if (totalZakat >= 10) {
      unlockedAchievements.add(AchievementType.zakat10Times);
    }
    if (totalZakat >= 50) {
      unlockedAchievements.add(AchievementType.zakat50Times);
    }

    // Investment diversity
    if (investmentTypes >= 5) {
      unlockedAchievements.add(AchievementType.investment5Types);
    }

    // Positive balance streak
    if (consecutivePositiveMonths >= 3) {
      unlockedAchievements.add(AchievementType.positiveBalance3Months);
    }

    return unlockedAchievements;
  }

  /// Calculate user level based on total points
  int calculateLevel(int totalPoints) {
    if (totalPoints < 100) return 1;
    if (totalPoints < 300) return 2;
    if (totalPoints < 600) return 3;
    if (totalPoints < 1000) return 4;
    if (totalPoints < 1500) return 5;
    if (totalPoints < 2500) return 6;
    if (totalPoints < 4000) return 7;
    if (totalPoints < 6000) return 8;
    if (totalPoints < 9000) return 9;
    return 10;
  }

  /// Get level name
  String getLevelName(int level) {
    switch (level) {
      case 1:
        return 'Pemula 🌱';
      case 2:
        return 'Pelajar 📚';
      case 3:
        return 'Praktisi 💼';
      case 4:
        return 'Ahli 🎓';
      case 5:
        return 'Master 🏆';
      case 6:
        return 'Grandmaster 👑';
      case 7:
        return 'Legend 🌟';
      case 8:
        return 'Mythic ⚡';
      case 9:
        return 'Immortal 💎';
      case 10:
        return 'Divine 🔥';
      default:
        return 'Pemula 🌱';
    }
  }

  /// Calculate points needed for next level
  int getPointsForNextLevel(int currentLevel) {
    switch (currentLevel) {
      case 1:
        return 100;
      case 2:
        return 300;
      case 3:
        return 600;
      case 4:
        return 1000;
      case 5:
        return 1500;
      case 6:
        return 2500;
      case 7:
        return 4000;
      case 8:
        return 6000;
      case 9:
        return 9000;
      default:
        return 0;
    }
  }

  /// Get motivational message based on achievement
  String getMotivationalMessage(AchievementType type) {
    switch (type) {
      case AchievementType.firstTransaction:
        return 'Great start! Konsistensi adalah kunci 🔑';
      case AchievementType.firstZakat:
        return 'Masya Allah! Keberkahan dimulai dari sini ✨';
      case AchievementType.firstInvestment:
        return 'Smart move! Masa depan cerah menanti 🌟';
      case AchievementType.streak7Days:
        return 'On fire! Keep it up 🔥';
      case AchievementType.streak30Days:
        return 'Luar biasa! Habit sudah terbentuk 💪';
      case AchievementType.streak100Days:
        return 'WOW! You are unstoppable! 🚀';
      case AchievementType.savings10M:
        return 'Nice! Target pertama tercapai 🎯';
      case AchievementType.savings50M:
        return 'Amazing progress! Keep saving 💰';
      case AchievementType.savings100M:
        return 'LEGENDARY! Financial goals unlocked 👑';
      case AchievementType.zakat10Times:
        return 'Barakallah! Rezeki makin berkah 🤲';
      case AchievementType.zakat50Times:
        return 'Subhanallah! Dermawan sejati 🌟';
      case AchievementType.investment5Types:
        return 'Portfolio diversification on point! 📊';
      case AchievementType.positiveBalance3Months:
        return 'Financial stability achieved! 📈';
      case AchievementType.budgetMaster:
        return 'Budget discipline level: Expert! 🎓';
      case AchievementType.monthlyReviewer:
        return 'Data-driven mindset! Love it 🤓';
    }
  }
}
