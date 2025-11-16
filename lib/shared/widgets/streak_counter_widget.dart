import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Streak counter widget with fire animation
class StreakCounterWidget extends StatefulWidget {
  final int currentStreak;
  final int longestStreak;
  final VoidCallback? onTap;

  const StreakCounterWidget({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    this.onTap,
  });

  @override
  State<StreakCounterWidget> createState() => _StreakCounterWidgetState();
}

class _StreakCounterWidgetState extends State<StreakCounterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasStreak = widget.currentStreak > 0;
    
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: hasStreak
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFF6B6B).withOpacity(0.1),
                    const Color(0xFFFFE66D).withOpacity(0.1),
                  ],
                )
              : LinearGradient(
                  colors: [AppColors.grey100, AppColors.grey100],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasStreak
                ? const Color(0xFFFF6B6B).withOpacity(0.3)
                : AppColors.grey300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Fire Icon (animated if has streak)
            if (hasStreak)
              ScaleTransition(
                scale: _scaleAnimation,
                child: const Text(
                  '🔥',
                  style: TextStyle(fontSize: 40),
                ),
              )
            else
              Text(
                '🎯',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black.withOpacity(0.3),
                ),
              ),

            const SizedBox(width: 16),

            // Streak Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Streak
                  Row(
                    children: [
                      Text(
                        hasStreak ? 'Streak Aktif!' : 'Mulai Streak!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: hasStreak
                              ? const Color(0xFFFF6B6B)
                              : AppColors.grey600,
                        ),
                      ),
                      if (hasStreak) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${widget.currentStreak} hari',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6B6B),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Longest Streak
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        size: 14,
                        color: AppColors.grey500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Terbaik: ${widget.longestStreak} hari',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Motivational Text
                  Text(
                    _getMotivationalText(widget.currentStreak),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.grey500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right,
              color: AppColors.grey500,
            ),
          ],
        ),
      ),
    );
  }

  String _getMotivationalText(int streak) {
    if (streak == 0) {
      return 'Catat transaksi hari ini untuk mulai streak! 🎯';
    } else if (streak < 7) {
      return 'Keep going! ${7 - streak} hari lagi unlock achievement! 🔥';
    } else if (streak < 30) {
      return 'Amazing! ${30 - streak} hari lagi jadi Monthly Warrior! ⚡';
    } else if (streak < 100) {
      return 'On fire! Target 100 days tinggal ${100 - streak} hari! 💯';
    } else {
      return 'LEGENDARY! You\'re unstoppable! 🚀';
    }
  }
}

/// Compact streak badge for headers
class StreakBadge extends StatelessWidget {
  final int streak;

  const StreakBadge({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    if (streak == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B6B).withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🔥',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Text(
            '$streak days',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
