import 'package:flutter/material.dart';
import '../theme/zen_design_tokens.dart';
import '../theme/zen_spacing.dart';

class ZenBottomSheet extends StatelessWidget {
  final Widget child;
  
  const ZenBottomSheet({
    super.key,
    required this.child,
  });

  static Future<T?> show<T>(BuildContext context, {required Widget child}) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      elevation: 0,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => ZenBottomSheet(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(ZenRadii.xxl)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      padding: const EdgeInsets.only(
        top: ZenSpacing.md,
        left: ZenSpacing.xl,
        right: ZenSpacing.xl,
        bottom: ZenSpacing.xxl,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: ZenSpacing.xl),
              decoration: BoxDecoration(
                color: tokens.textTertiary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
