import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/zen_design_tokens.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    final themeMode = ref.watch(themeModeProvider);
    
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: tokens.textPrimary)),
        leading: BackButton(color: tokens.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ListTile(
            title: Text('Dark Mode', style: TextStyle(color: tokens.textPrimary)),
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (_) => ref.read(themeModeProvider.notifier).toggleTheme(),
              activeColor: tokens.primary,
            ),
          )
        ],
      ),
    );
  }
}
