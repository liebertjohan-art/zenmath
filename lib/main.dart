import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'features/practice/practice_screen.dart';
import 'features/results/results_screen.dart';

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
    GoRoute(
      path: '/practice',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PracticeScreen(
          topic: extra?['topic'] as String? ?? 'Addition',
          difficulty: extra?['difficulty'] as String? ?? 'easy',
          isTimed: extra?['isTimed'] as bool? ?? false,
        );
      },
    ),
    GoRoute(
      path: '/results',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ResultsScreen(
          topic: extra?['topic'] as String? ?? 'Addition',
          difficulty: extra?['difficulty'] as String? ?? 'easy',
          score: extra?['score'] as int? ?? 0,
          totalQuestions: extra?['totalQuestions'] as int? ?? 10,
        );
      },
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
