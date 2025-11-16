import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Animated empty state widget with engaging animations
class AnimatedEmptyState extends StatefulWidget {
  final String emoji;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Color? primaryColor;

  const AnimatedEmptyState({
    super.key,
    required this.emoji,
    required this.title,
    required this.message,
    this.actionText,
    this.onActionPressed,
    this.primaryColor,
  });

  @override
  State<AnimatedEmptyState> createState() => _AnimatedEmptyStateState();
}

class _AnimatedEmptyStateState extends State<AnimatedEmptyState>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _scaleController;
  late Animation<double> _floatAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Float animation
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Scale animation for emoji
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.primaryColor ?? AppColors.primaryGreen;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated emoji
            AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnimation.value),
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.emoji,
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Title
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Message
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey600,
                        height: 1.5,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Action button
            if (widget.actionText != null && widget.onActionPressed != null) ...[
              const SizedBox(height: 24),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: ElevatedButton.icon(
                        onPressed: widget.onActionPressed,
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        label: Text(widget.actionText!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Pre-made empty states for common scenarios
class EmptyStates {
  static Widget noTransactions({VoidCallback? onAdd}) {
    return AnimatedEmptyState(
      emoji: '💸',
      title: 'Belum Ada Transaksi',
      message: 'Yuk mulai catat pengeluaran dan pemasukan kamu!\nStep pertama menuju financial freedom 🚀',
      actionText: 'Tambah Transaksi',
      onActionPressed: onAdd,
      primaryColor: AppColors.accentBlue,
    );
  }

  static Widget noInvestments({VoidCallback? onAdd}) {
    return AnimatedEmptyState(
      emoji: '📈',
      title: 'Mulai Investasi Yuk!',
      message: 'Investasi syariah itu mudah kok!\nDiversifikasi portfolio kamu sekarang 💎',
      actionText: 'Tambah Investasi',
      onActionPressed: onAdd,
      primaryColor: AppColors.investment,
    );
  }

  static Widget noZakat() {
    return AnimatedEmptyState(
      emoji: '✨',
      title: 'Belum Ada Zakat',
      message: 'Hitung dan catat zakat kamu untuk mendapat keberkahan.\nRezeki yang berkah dimulai dari sini 🤲',
      primaryColor: AppColors.zakat,
    );
  }

  static Widget noGoals({VoidCallback? onAdd}) {
    return AnimatedEmptyState(
      emoji: '🎯',
      title: 'Set Target Finansial Kamu!',
      message: 'Goals yang jelas = motivasi yang kuat.\nAyo buat target dan wujudkan impian! 💪',
      actionText: 'Buat Target',
      onActionPressed: onAdd,
      primaryColor: AppColors.secondaryGold,
    );
  }

  static Widget noData() {
    return AnimatedEmptyState(
      emoji: '📊',
      title: 'Data Belum Tersedia',
      message: 'Mulai catat transaksi untuk melihat analytics yang keren! 📈',
      primaryColor: AppColors.grey600,
    );
  }

  static Widget error({String? message}) {
    return AnimatedEmptyState(
      emoji: '😅',
      title: 'Oops! Ada Kesalahan',
      message: message ?? 'Coba refresh atau restart app kamu ya!',
      primaryColor: AppColors.error,
    );
  }

  static Widget comingSoon() {
    return AnimatedEmptyState(
      emoji: '🚀',
      title: 'Coming Soon!',
      message: 'Fitur keren ini sedang dikembangkan.\nStay tuned! 🔥',
      primaryColor: AppColors.accentPurple,
    );
  }
}
