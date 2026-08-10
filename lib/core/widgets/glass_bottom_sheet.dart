import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/zen_colors.dart';
import '../theme/zen_spacing.dart';

class GlassBottomSheet extends StatelessWidget {
  final Widget child;
  
  const GlassBottomSheet({
    super.key,
    required this.child,
  });

  static Future<T?> show<T>(BuildContext context, {required Widget child}) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => GlassBottomSheet(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: ZenColors.deepSlate.withOpacity(0.8),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(ZenRadii.lg)),
          border: Border(
            top: BorderSide(
              color: ZenColors.textPrimary.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.only(
          top: ZenSpacing.md,
          left: ZenSpacing.md,
          right: ZenSpacing.md,
          bottom: ZenSpacing.xl,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: ZenSpacing.lg),
                decoration: BoxDecoration(
                  color: ZenColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
