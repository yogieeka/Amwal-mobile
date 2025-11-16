import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Confetti/celebration animation widget
class CelebrationWidget extends StatefulWidget {
  final Widget child;
  final bool celebrate;
  final VoidCallback? onComplete;

  const CelebrationWidget({
    super.key,
    required this.child,
    this.celebrate = false,
    this.onComplete,
  });

  @override
  State<CelebrationWidget> createState() => _CelebrationWidgetState();
}

class _CelebrationWidgetState extends State<CelebrationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    if (widget.celebrate) {
      _startCelebration();
    }
  }

  @override
  void didUpdateWidget(CelebrationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.celebrate && !oldWidget.celebrate) {
      _startCelebration();
    }
  }

  void _startCelebration() {
    _particles.clear();
    for (int i = 0; i < 50; i++) {
      _particles.add(ConfettiParticle(
        x: _random.nextDouble(),
        y: 0.0,
        color: _randomColor(),
        size: _random.nextDouble() * 8 + 4,
        velocity: _random.nextDouble() * 2 + 1,
        rotation: _random.nextDouble() * 2 * pi,
      ));
    }

    _controller.forward(from: 0).then((_) {
      widget.onComplete?.call();
    });
  }

  Color _randomColor() {
    final colors = [
      AppColors.primaryGreen,
      AppColors.secondaryGold,
      AppColors.accentBlue,
      AppColors.accentPurple,
      AppColors.success,
      AppColors.warning,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.celebrate)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ConfettiPainter(
                      particles: _particles,
                      progress: _controller.value,
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class ConfettiParticle {
  final double x;
  final double y;
  final Color color;
  final double size;
  final double velocity;
  final double rotation;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.velocity,
    required this.rotation,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(1 - progress)
        ..style = PaintingStyle.fill;

      final x = particle.x * size.width;
      final y = particle.y * size.height + (progress * size.height * particle.velocity);
      final rotation = particle.rotation + (progress * 4 * pi);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Achievement unlock dialog with celebration
class AchievementUnlockedDialog extends StatefulWidget {
  final String emoji;
  final String title;
  final String description;
  final int points;

  const AchievementUnlockedDialog({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    required this.points,
  });

  @override
  State<AchievementUnlockedDialog> createState() =>
      _AchievementUnlockedDialogState();
}

class _AchievementUnlockedDialogState extends State<AchievementUnlockedDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    Future.delayed(const Duration(milliseconds: 100), () {
      _scaleController.forward();
      _slideController.forward();
      setState(() {
        _showConfetti = true;
      });
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CelebrationWidget(
      celebrate: _showConfetti,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryGreen,
                    AppColors.primaryGreen.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Badge/Emoji
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.emoji,
                        style: const TextStyle(fontSize: 50),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'ACHIEVEMENT UNLOCKED!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Points badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryGold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '⭐',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+${widget.points} Points',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Close button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Awesome! 🎉',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Simple success animation for micro-interactions
class SuccessCheckmark extends StatefulWidget {
  final double size;
  final Color color;

  const SuccessCheckmark({
    super.key,
    this.size = 60,
    this.color = AppColors.success,
  });

  @override
  State<SuccessCheckmark> createState() => _SuccessCheckmarkState();
}

class _SuccessCheckmarkState extends State<SuccessCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: widget.size * 0.6,
        ),
      ),
    );
  }
}
