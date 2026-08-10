import 'package:flutter/material.dart';
import '../theme/zen_colors.dart';
import '../theme/zen_spacing.dart';

class ZenCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const ZenCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(ZenSpacing.md),
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: ZenRadii.mdRadius,
        splashColor: ZenColors.zenGold.withOpacity(0.1),
        highlightColor: ZenColors.zenGold.withOpacity(0.05),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor ?? ZenColors.deepSlate,
            borderRadius: ZenRadii.mdRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
