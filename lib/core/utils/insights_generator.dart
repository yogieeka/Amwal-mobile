import 'dart:math';

/// Generate smart financial insights based on user data
class InsightsGenerator {
  static final InsightsGenerator instance = InsightsGenerator._();
  InsightsGenerator._();

  /// Generate insights for analytics page
  List<FinancialInsight> generateInsights({
    required double totalIncome,
    required double totalExpense,
    required double totalZakat,
    required double balance,
    required Map<String, double> categorySpending,
    required DateTime currentMonth,
  }) {
    final insights = <FinancialInsight>[];

    // Balance analysis
    if (balance > 0) {
      final savingsRate = (balance / totalIncome * 100);
      if (savingsRate >= 20) {
        insights.add(FinancialInsight(
          type: InsightType.positive,
          title: 'Saving Goal ON POINT! 🎯',
          message: 'Kamu berhasil nabung ${savingsRate.toStringAsFixed(1)}% dari penghasilan! Keep it up, bestie!',
          emoji: '💪',
        ));
      } else if (savingsRate >= 10) {
        insights.add(FinancialInsight(
          type: InsightType.neutral,
          title: 'Not Bad! 👌',
          message: 'Saving rate ${savingsRate.toStringAsFixed(1)}%. Try to reach 20% biar makin solid!',
          emoji: '📈',
        ));
      } else {
        insights.add(FinancialInsight(
          type: InsightType.warning,
          title: 'Time to Save More! 💰',
          message: 'Coba naikin saving rate kamu. Target minimal 10-20% dari income ya!',
          emoji: '🎯',
        ));
      }
    } else if (balance < 0) {
      insights.add(FinancialInsight(
        type: InsightType.critical,
        title: 'Uh Oh! Defisit Alert ⚠️',
        message: 'Spending kamu melebihi income. Yuk review lagi pengeluaran bulan ini!',
        emoji: '😰',
      ));
    }

    // Category spending analysis
    if (categorySpending.isNotEmpty) {
      final topCategory = categorySpending.entries.reduce((a, b) => a.value > b.value ? a : b);
      final percentage = (topCategory.value / totalExpense * 100);
      
      if (percentage > 40) {
        insights.add(FinancialInsight(
          type: InsightType.warning,
          title: '${topCategory.key} Spending Tinggi!',
          message: '${percentage.toStringAsFixed(0)}% budget kamu habis untuk ${topCategory.key}. Coba diatur lagi ya!',
          emoji: '🤔',
        ));
      } else if (percentage > 25) {
        insights.add(FinancialInsight(
          type: InsightType.neutral,
          title: 'Watch Out! 👀',
          message: '${topCategory.key} menghabiskan ${percentage.toStringAsFixed(0)}% budget. Monitor terus spending-nya!',
          emoji: '📊',
        ));
      }
    }

    // Zakat insights
    if (totalIncome > 0) {
      final zakatPercentage = (totalZakat / totalIncome * 100);
      if (zakatPercentage >= 2.5) {
        insights.add(FinancialInsight(
          type: InsightType.positive,
          title: 'Masya Allah! Barakallah ✨',
          message: 'Zakat & sedekah kamu ${zakatPercentage.toStringAsFixed(1)}% dari income. Rezeki pasti berkah!',
          emoji: '🤲',
        ));
      } else if (zakatPercentage > 0) {
        insights.add(FinancialInsight(
          type: InsightType.neutral,
          title: 'Good Start! 🌟',
          message: 'Tingkatkan zakat & sedekah untuk keberkahan lebih!',
          emoji: '✨',
        ));
      }
    }

    // Spending trend
    if (totalIncome > 0) {
      final spendingRatio = totalExpense / totalIncome;
      if (spendingRatio <= 0.7) {
        insights.add(FinancialInsight(
          type: InsightType.positive,
          title: 'Budgeting Expert! 🎓',
          message: 'Spending control kamu keren banget! Below 70% dari income.',
          emoji: '🏆',
        ));
      }
    }

    // Random motivational insights
    final random = Random();
    if (random.nextDouble() > 0.7) {
      insights.add(_getMotivationalInsight());
    }

    return insights;
  }

  FinancialInsight _getMotivationalInsight() {
    final motivations = [
      FinancialInsight(
        type: InsightType.tip,
        title: 'Pro Tip! 💡',
        message: 'Track spending kamu setiap hari biar lebih aware sama cash flow!',
        emoji: '📝',
      ),
      FinancialInsight(
        type: InsightType.tip,
        title: 'Did You Know? 🤓',
        message: 'Nabung 20% dari gaji itu bukan goals, tapi NEED. Start now!',
        emoji: '💰',
      ),
      FinancialInsight(
        type: InsightType.tip,
        title: 'Financial Wisdom ✨',
        message: 'Investasi terbaik adalah investasi pada diri sendiri. Upgrade skill terus!',
        emoji: '📚',
      ),
      FinancialInsight(
        type: InsightType.tip,
        title: 'Smart Move! 🧠',
        message: 'Diversifikasi portfolio kamu. Don\'t put all eggs in one basket!',
        emoji: '🥚',
      ),
    ];

    return motivations[Random().nextInt(motivations.length)];
  }

  /// Generate comparison text with previous period
  String generateComparison({
    required double current,
    required double previous,
    required String metric,
  }) {
    if (previous == 0) return 'Data bulan lalu tidak tersedia';

    final diff = current - previous;
    final percentage = (diff / previous * 100).abs();

    if (diff > 0) {
      return '↗️ Naik ${percentage.toStringAsFixed(1)}% dari bulan lalu';
    } else if (diff < 0) {
      return '↘️ Turun ${percentage.toStringAsFixed(1)}% dari bulan lalu';
    } else {
      return '➡️ Sama dengan bulan lalu';
    }
  }

  /// Get spending emoji based on amount
  String getSpendingEmoji(double amount) {
    if (amount > 10000000) return '🔥';
    if (amount > 5000000) return '💸';
    if (amount > 1000000) return '💰';
    return '💵';
  }

  /// Get level up message
  String getLevelUpMessage(int newLevel) {
    final messages = {
      2: 'Level 2! Kamu mulai serius nih 🎯',
      3: 'Level 3! Progress is progress 📈',
      4: 'Level 4! Ahli mode: ON 🎓',
      5: 'Level 5! MASTER achieved! 🏆',
      6: 'Level 6! Grandmaster status 👑',
      7: 'Level 7! LEGENDARY! 🌟',
      8: 'Level 8! MYTHIC tier! ⚡',
      9: 'Level 9! IMMORTAL status! 💎',
      10: 'Level 10! DIVINE! You\'re unstoppable! 🔥',
    };

    return messages[newLevel] ?? 'Level Up! 🎊';
  }
}

enum InsightType {
  positive,
  negative,
  warning,
  critical,
  neutral,
  tip,
}

class FinancialInsight {
  final InsightType type;
  final String title;
  final String message;
  final String emoji;

  FinancialInsight({
    required this.type,
    required this.title,
    required this.message,
    required this.emoji,
  });

  Color get color {
    switch (type) {
      case InsightType.positive:
        return const Color(0xFF10B981); // Green
      case InsightType.negative:
      case InsightType.critical:
        return const Color(0xFFEF4444); // Red
      case InsightType.warning:
        return const Color(0xFFF59E0B); // Orange
      case InsightType.neutral:
        return const Color(0xFF3B82F6); // Blue
      case InsightType.tip:
        return const Color(0xFF8B5CF6); // Purple
    }
  }

  IconData get icon {
    switch (type) {
      case InsightType.positive:
        return Icons.trending_up;
      case InsightType.negative:
      case InsightType.critical:
        return Icons.trending_down;
      case InsightType.warning:
        return Icons.warning_amber_rounded;
      case InsightType.neutral:
        return Icons.info_outline;
      case InsightType.tip:
        return Icons.lightbulb_outline;
    }
  }
}
