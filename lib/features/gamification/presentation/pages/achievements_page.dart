import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/achievement_model.dart';

/// Achievements gallery page
class AchievementsPage extends ConsumerWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get from provider
    final unlockedAchievements = <AchievementType>[
      AchievementType.firstTransaction,
      AchievementType.firstZakat,
      AchievementType.streak7Days,
    ];

    final allAchievements = AchievementType.values;
    final unlockedCount = unlockedAchievements.length;
    final totalCount = allAchievements.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Progress Card
          _buildProgressCard(unlockedCount, totalCount),
          const SizedBox(height: 24),

          // Achievements Grid
          Text(
            'Koleksi Achievement',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: allAchievements.length,
            itemBuilder: (context, index) {
              final achievement = allAchievements[index];
              final isUnlocked = unlockedAchievements.contains(achievement);
              
              return _buildAchievementCard(
                context,
                achievement,
                isUnlocked,
              );
            },
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int unlocked, int total) {
    final percentage = (unlocked / total * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.islamicGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$unlocked/$total',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: unlocked / total,
              minHeight: 12,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.secondaryGold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '$percentage% Complete',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
    BuildContext context,
    AchievementType achievement,
    bool isUnlocked,
  ) {
    return GestureDetector(
      onTap: () => _showAchievementDetail(context, achievement, isUnlocked),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isUnlocked
              ? AppColors.primaryGreen.withOpacity(0.1)
              : AppColors.grey100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? AppColors.primaryGreen.withOpacity(0.3)
                : AppColors.grey300,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji Badge
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? AppColors.primaryGreen.withOpacity(0.2)
                          : AppColors.grey200,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        achievement.emoji,
                        style: TextStyle(
                          fontSize: 32,
                          color: isUnlocked ? null : Colors.black26,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                achievement.title.split(' ').first,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked
                      ? AppColors.primaryGreen
                      : AppColors.grey500,
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Points
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppColors.secondaryGold.withOpacity(0.2)
                    : AppColors.grey200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '+${achievement.points}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked
                      ? AppColors.secondaryGold
                      : AppColors.grey500,
                ),
              ),
            ),

            // Lock Icon for locked achievements
            if (!isUnlocked)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(
                  Icons.lock_outline,
                  size: 12,
                  color: AppColors.grey400,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAchievementDetail(
    BuildContext context,
    AchievementType achievement,
    bool isUnlocked,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emoji
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppColors.primaryGreen.withOpacity(0.1)
                    : AppColors.grey100,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isUnlocked
                      ? AppColors.primaryGreen
                      : AppColors.grey300,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  achievement.emoji,
                  style: TextStyle(
                    fontSize: 50,
                    color: isUnlocked ? null : Colors.black26,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppColors.success.withOpacity(0.2)
                    : AppColors.warning.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isUnlocked ? 'UNLOCKED ✓' : 'LOCKED 🔒',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? AppColors.success : AppColors.warning,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              achievement.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              achievement.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey600,
              ),
            ),

            const SizedBox(height: 20),

            // Points
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '⭐',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+${achievement.points} Points',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Achievements'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Achievements',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Unlock achievements dengan melakukan berbagai aktivitas finansial!',
              ),
              SizedBox(height: 16),
              Text(
                'Cara Unlock:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Catat transaksi rutin\n'
                '• Maintain streak harian\n'
                '• Capai milestone savings\n'
                '• Bayar zakat konsisten\n'
                '• Diversifikasi investasi',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 16),
              Text(
                'Benefits:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '✨ Collect points untuk level up\n'
                '🏆 Unlock badges eksklusif\n'
                '💪 Build financial habits\n'
                '🎯 Track progress kamu',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Oke!'),
          ),
        ],
      ),
    );
  }
}
