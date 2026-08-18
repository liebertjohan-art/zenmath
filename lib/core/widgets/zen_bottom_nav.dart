import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/zen_design_tokens.dart';
import '../utils/haptics.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: tokens.background,
      extendBody: true,
      body: child,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: tokens.surface.withOpacity(isDark ? 0.85 : 0.90),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: tokens.divider,
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavBarItem(
                        icon: Icons.play_arrow_rounded,
                        label: 'Play',
                        isSelected: _calculateSelectedIndex(context) == 0,
                        onTap: () {
                          ZenHaptics.selection();
                          context.go('/play');
                        },
                        tokens: tokens,
                      ),
                      _NavBarItem(
                        icon: Icons.history_rounded,
                        label: 'History',
                        isSelected: _calculateSelectedIndex(context) == 1,
                        onTap: () {
                          ZenHaptics.selection();
                          context.go('/history');
                        },
                        tokens: tokens,
                      ),
                      _NavBarItem(
                        icon: Icons.bar_chart_rounded,
                        label: 'Stats',
                        isSelected: _calculateSelectedIndex(context) == 2,
                        onTap: () {
                          ZenHaptics.selection();
                          context.go('/stats');
                        },
                        tokens: tokens,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/play')) return 0;
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/stats')) return 2;
    return 0;
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ZenDesignTokens tokens;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? tokens.primary : tokens.textTertiary;
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            scale: isSelected ? 1.08 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          // Active indicator
          AnimatedOpacity(
            opacity: isSelected ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: tokens.primary,
                shape: BoxShape.circle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
