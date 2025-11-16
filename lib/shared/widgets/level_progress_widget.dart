import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../features/gamification/domain/services/achievement_service.dart';

/// Level progress widget for displaying user level and XP
class LevelProgressWidget extends StatelessWidget {
  final int totalPoints;
  final VoidCallback? onTap;

  const LevelProgressWidget({
    super.key,
    required this.totalPoints,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentLevel = AchievementService.instance.calculateLevel(totalPoints);
    final currentLevelName = AchievementService.instance.getLevelName(currentLevel);
    final nextLevelPoints = AchievementService.instance.getPointsForNextLevel(currentLevel);
    
    // Calculate points needed for current level
    int currentLevelPoints = 0;
    if (currentLevel > 1) {
      currentLevelPoints = AchievementService.instance.getPointsForNextLevel(currentLevel - 1);
    }
    
    final pointsInCurrentLevel = totalPoints - currentLevelPoints;
    final pointsNeeded = nextLevelPoints - currentLevelPoints;
    final progress = nextLevelPoints > 0 
        ? (pointsInCurrentLevel / pointsNeeded).clamp(0.0, 1.0)
        : 1.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.secondaryGold.withOpacity(0.1),
              AppColors.primaryGreen.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryGreen.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Level Badge
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondaryGold.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentLevel.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'LVL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Progress Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Level Name
                  Text(
                    currentLevelName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // XP Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        nextLevelPoints > 0
                            ? '$pointsInCurrentLevel / $pointsNeeded XP'
                            : 'MAX LEVEL!',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey600,
                        ),
                      ),
                      if (nextLevelPoints > 0)
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: AppColors.grey200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        currentLevel >= 9
                            ? AppColors.secondaryGold
                            : AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Arrow icon
            Icon(
              Icons.chevron_right,
              color: AppColors.grey500,
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact level badge for app bar
class LevelBadge extends StatelessWidget {
  final int level;
  final VoidCallback? onTap;

  const LevelBadge({
    super.key,
    required this.level,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: AppColors.goldGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryGold.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '⭐',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 4),
            Text(
              'Lv.$level',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
