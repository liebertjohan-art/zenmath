import 'package:flutter/material.dart';
import '../theme/zen_design_tokens.dart';
import '../theme/zen_spacing.dart';
import '../utils/haptics.dart';
import '../utils/animations.dart';

enum ZenButtonVariant { primary, secondary, ghost }

class ZenButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final ZenButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  const ZenButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ZenButtonVariant.primary,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<ZenButton> createState() => _ZenButtonState();
}

class _ZenButtonState extends State<ZenButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: ZenAnimations.tapFeedback,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: ZenAnimations.easeOutUI),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
      ZenHaptics.light();
      widget.onPressed!();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    final bool isDisabled = widget.onPressed == null || widget.isLoading;

    Color bgColor;
    Color textColor;
    Border? border;

    switch (widget.variant) {
      case ZenButtonVariant.primary:
        bgColor = isDisabled ? tokens.surfaceVariant : tokens.primary;
        textColor = isDisabled ? tokens.textTertiary : tokens.background;
        break;
      case ZenButtonVariant.secondary:
        bgColor = Colors.transparent;
        textColor = isDisabled ? tokens.textTertiary : tokens.primary;
        border = Border.all(
          color: isDisabled ? tokens.surfaceVariant : tokens.primaryMuted,
          width: 1.5,
        );
        break;
      case ZenButtonVariant.ghost:
        bgColor = Colors.transparent;
        textColor = isDisabled ? tokens.textTertiary : tokens.textSecondary;
        break;
    }

    final buttonContent = Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: ZenSpacing.xl),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: ZenRadii.fullRadius,
        border: border,
      ),
      child: Center(
        child: widget.isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: textColor, size: 20),
                    const SizedBox(width: ZenSpacing.xs),
                  ],
                  Text(
                    widget.label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: textColor,
                        ),
                  ),
                ],
              ),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: buttonContent,
      ),
    );
  }
}
