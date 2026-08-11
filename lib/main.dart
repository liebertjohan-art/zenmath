import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/zen_bottom_nav.dart';
import 'features/play/play_screen.dart';
import 'features/history/history_screen.dart';
import 'features/stats/stats_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/practice/practice_screen.dart';
import 'features/results/results_screen.dart';
import 'providers/theme_provider.dart';
import 'core/utils/animations.dart';
import 'features/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: ZenMathApp(),
    ),
  );
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/play',
          pageBuilder: (context, state) => const NoTransitionPage(child: PlayScreen()),
        ),
        GoRoute(
          path: '/history',
          pageBuilder: (context, state) => const NoTransitionPage(child: HistoryScreen()),
        ),
        GoRoute(
          path: '/stats',
          pageBuilder: (context, state) => const NoTransitionPage(child: StatsScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/practice',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final page = PracticeScreen(
          topic: extra?['topic'] as String? ?? 'Addition',
          difficulty: extra?['difficulty'] as String? ?? 'easy',
          isTimed: extra?['isTimed'] as bool? ?? false,
        );
        return CustomTransitionPage(
          key: state.pageKey,
          child: page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                .chain(CurveTween(curve: ZenAnimations.easeOutUI));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
          transitionDuration: ZenAnimations.pageTransition,
        );
      },
    ),
    GoRoute(
      path: '/results',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final page = ResultsScreen(
          topic: extra?['topic'] as String? ?? 'Addition',
          difficulty: extra?['difficulty'] as String? ?? 'easy',
          score: extra?['score'] as int? ?? 0,
          totalQuestions: extra?['totalQuestions'] as int? ?? 10,
        );
        return CustomTransitionPage(
          key: state.pageKey,
          child: page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                .chain(CurveTween(curve: ZenAnimations.easeOutUI));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
          transitionDuration: ZenAnimations.pageTransition,
        );
      },
    ),
  ],
);

class _ZenScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }
}

class ZenMathApp extends ConsumerWidget {
  const ZenMathApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'ZenMath',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _router,
      scrollBehavior: _ZenScrollBehavior(),
      debugShowCheckedModeBanner: false,
    );
  }
}
