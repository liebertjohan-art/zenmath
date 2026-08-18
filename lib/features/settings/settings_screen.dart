import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/zen_design_tokens.dart';
import '../../core/theme/zen_spacing.dart';
import '../../core/widgets/zen_card.dart';
import '../../core/widgets/zen_segmented_control.dart';
import '../../providers/theme_provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    final themeMode = ref.watch(themeModeProvider);
    final settings = ref.watch(settingsProvider);
    
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text('Settings', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: tokens.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: ZenSpacing.xl, vertical: ZenSpacing.lg),
        children: [
          _buildSectionTitle(context, tokens, 'APPEARANCE'),
          ZenCard(
            padding: const EdgeInsets.all(ZenSpacing.md),
            child: Column(
              children: [
                _buildListTile(
                  context: context,
                  tokens: tokens,
                  icon: themeMode == ThemeMode.dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (_) => ref.read(themeModeProvider.notifier).toggleTheme(),
                    activeColor: tokens.primary,
                    activeTrackColor: tokens.primary.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: ZenSpacing.xxl),
          
          _buildSectionTitle(context, tokens, 'PRACTICE'),
          ZenCard(
            padding: const EdgeInsets.all(ZenSpacing.md),
            child: Column(
              children: [
                _buildListTile(
                  context: context,
                  tokens: tokens,
                  icon: Icons.speed_rounded,
                  title: 'Default Difficulty',
                  subtitle: 'For quick start sessions',
                  trailing: const SizedBox.shrink(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(ZenSpacing.xs, 0, ZenSpacing.xs, ZenSpacing.md),
                  child: ZenSegmentedControl<String>(
                    groupValue: settings.defaultDifficulty,
                    values: const ['easy', 'medium', 'hard'],
                    labels: const ['Easy', 'Med', 'Hard'],
                    onValueChanged: (v) => ref.read(settingsProvider.notifier).updateDifficulty(v),
                  ),
                ),
                Divider(color: tokens.surfaceVariant, height: 1),
                _buildListTile(
                  context: context,
                  tokens: tokens,
                  icon: Icons.format_list_numbered_rounded,
                  title: 'Questions per Session',
                  trailing: DropdownButton<int>(
                    value: settings.questionCount,
                    underline: const SizedBox.shrink(),
                    dropdownColor: tokens.surface,
                    icon: Icon(Icons.arrow_drop_down_rounded, color: tokens.textSecondary),
                    style: Theme.of(context).textTheme.titleMedium,
                    items: [10, 15, 20].map((v) => DropdownMenuItem(value: v, child: Text('$v'))).toList(),
                    onChanged: (v) {
                      if (v != null) ref.read(settingsProvider.notifier).updateQuestionCount(v);
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: ZenSpacing.xxl),
          
          _buildSectionTitle(context, tokens, 'FEEDBACK'),
          ZenCard(
            padding: const EdgeInsets.all(ZenSpacing.md),
            child: Column(
              children: [
                _buildListTile(
                  context: context,
                  tokens: tokens,
                  icon: Icons.vibration_rounded,
                  title: 'Haptic Feedback',
                  trailing: Switch(
                    value: settings.hapticsEnabled,
                    onChanged: (v) => ref.read(settingsProvider.notifier).toggleHaptics(v),
                    activeColor: tokens.primary,
                    activeTrackColor: tokens.primary.withOpacity(0.2),
                  ),
                ),
                Divider(color: tokens.surfaceVariant, height: 1),
                _buildListTile(
                  context: context,
                  tokens: tokens,
                  icon: Icons.animation_rounded,
                  title: 'Animations',
                  subtitle: 'Turn off for reduced motion',
                  trailing: Switch(
                    value: settings.animationsEnabled,
                    onChanged: (v) => ref.read(settingsProvider.notifier).toggleAnimations(v),
                    activeColor: tokens.primary,
                    activeTrackColor: tokens.primary.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: ZenSpacing.xxl),
          
          _buildSectionTitle(context, tokens, 'ABOUT'),
          ZenCard(
            padding: const EdgeInsets.all(ZenSpacing.md),
            child: Column(
              children: [
                _buildListTile(
                  context: context,
                  tokens: tokens,
                  icon: Icons.info_outline_rounded,
                  title: 'App Version',
                  trailing: Text('1.0.0', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: tokens.textSecondary)),
                ),
                Divider(color: tokens.surfaceVariant, height: 1),
                Padding(
                  padding: const EdgeInsets.all(ZenSpacing.lg),
                  child: Center(
                    child: Text(
                      'Built with ❤️ by Akashiverse',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: tokens.textTertiary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, ZenDesignTokens tokens, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: ZenSpacing.xs, bottom: ZenSpacing.md),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: tokens.textTertiary,
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required ZenDesignTokens tokens,
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ZenSpacing.xs, vertical: ZenSpacing.sm),
      child: Row(
        children: [
          Icon(icon, color: tokens.textSecondary, size: 24),
          const SizedBox(width: ZenSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: tokens.textTertiary,
                    ),
                  ),
                ]
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
