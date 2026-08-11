import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/zen_design_tokens.dart';

class PlayScreen extends ConsumerWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text('ZenMath', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: tokens.textSecondary),
            onPressed: () => context.push('/settings'),
          )
        ],
      ),
      body: Center(
        child: Text(
          'Play Dashboard',
          style: TextStyle(color: tokens.textPrimary),
        ),
      ),
    );
  }
}
