import 'package:flutter/material.dart';
import '../../core/theme/zen_design_tokens.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    
    return Center(
      child: Text(
        'Stats Screen',
        style: TextStyle(color: tokens.textPrimary),
      ),
    );
  }
}
