import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/zen_design_tokens.dart';
import '../utils/animations.dart';

class ZenProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Widget? centerChild;
  final Color? activeColor;

  const ZenProgressRing({
    super.key,
    required this.progress,
    this.size = 120.0,
    this.strokeWidth = 10.0,
    this.centerChild,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    final progressColor = activeColor ?? tokens.primary;

    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: progress),
        duration: const Duration(milliseconds: 1200),
        curve: ZenAnimations.easeOutUI,
        builder: (context, value, child) {
          return CustomPaint(
            painter: _RingPainter(
              progress: value,
              strokeWidth: strokeWidth,
              trackColor: tokens.surfaceVariant,
              progressColor: progressColor,
              progressColorEnd: tokens.primaryMuted,
            ),
            child: Center(child: centerChild),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;
  final Color progressColorEnd;

  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
    required this.progressColorEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    // Draw progress with gradient
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [progressColor, progressColorEnd],
        startAngle: -pi / 2,
        endAngle: -pi / 2 + (2 * pi * progress),
        tileMode: TileMode.clamp,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor;
  }
}
