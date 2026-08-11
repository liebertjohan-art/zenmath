import 'package:flutter/material.dart';
import '../theme/zen_design_tokens.dart';

class ZenScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final bool extendBodyBehindAppBar;

  const ZenScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: appBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
