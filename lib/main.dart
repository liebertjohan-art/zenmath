import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/zen_scaffold.dart';
import 'core/widgets/zen_card.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ZenMathApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);

class ZenMathApp extends StatelessWidget {
  const ZenMathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ZenMath',
      theme: AppTheme.darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ZenScaffold(
      appBar: AppBar(
        title: Text(
          'ZenMath',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0), // ZenSpacing.md
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Focus & Flow',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 32),
              ZenCard(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(Icons.add, size: 32),
                    const SizedBox(width: 16),
                    Text(
                      'Addition',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
