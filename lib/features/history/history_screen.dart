import 'package:flutter/material.dart';
import '../../core/theme/zen_design_tokens.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    
    return Center(
      child: Text(
        'History Screen',
        style: TextStyle(color: tokens.textPrimary),
      ),
    );
  }
}
