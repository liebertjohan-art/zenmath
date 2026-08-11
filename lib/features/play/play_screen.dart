import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/zen_design_tokens.dart';
import '../../core/theme/zen_spacing.dart';
import '../../core/widgets/zen_card.dart';
import '../../core/widgets/zen_progress_ring.dart';
import '../../core/widgets/zen_bottom_sheet.dart';
import '../../core/widgets/zen_segmented_control.dart';
import '../../core/widgets/zen_button.dart';
import '../../providers/streak_provider.dart';
import '../../providers/progress_provider.dart';

class PlayScreen extends ConsumerWidget {
  const PlayScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    final streakAsync = ref.watch(streakProvider);
    final xpAsync = ref.watch(xpProvider);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: ZenSpacing.xl, vertical: ZenSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: tokens.textSecondary,
                  ),
            ),
            const SizedBox(height: ZenSpacing.xl),
            
            // Stats Row
            Row(
              children: [
                // Streak Card
                Expanded(
                  child: ZenCard(
                    padding: const EdgeInsets.all(ZenSpacing.md),
                    child: Column(
                      children: [
                        streakAsync.when(
                          data: (streak) => ZenProgressRing(
                            progress: streak > 0 ? 1.0 : 0.0,
                            size: 80,
                            strokeWidth: 8,
                            centerChild: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$streak',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const Text('🔥', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                          loading: () => const SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(),
                          ),
                          error: (_, __) => const SizedBox(width: 80, height: 80),
                        ),
                        const SizedBox(height: ZenSpacing.sm),
                        Text(
                          'Day Streak',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: ZenSpacing.md),
                // XP Card
                Expanded(
                  child: ZenCard(
                    padding: const EdgeInsets.all(ZenSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Level',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            Icon(Icons.military_tech_rounded, color: tokens.primary, size: 20),
                          ],
                        ),
                        const SizedBox(height: ZenSpacing.xs),
                        xpAsync.when(
                          data: (xpData) => Text(
                            '${xpData['level']}',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          loading: () => const SizedBox(height: 40),
                          error: (_, __) => const SizedBox(height: 40),
                        ),
                        const SizedBox(height: ZenSpacing.sm),
                        xpAsync.when(
                          data: (xpData) {
                            final current = xpData['currentLevelXp'] as int;
                            final next = xpData['nextLevelXp'] as int;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: ZenRadii.fullRadius,
                                  child: LinearProgressIndicator(
                                    value: current / next,
                                    backgroundColor: tokens.surfaceVariant,
                                    color: tokens.primary,
                                    minHeight: 6,
                                  ),
                                ),
                                const SizedBox(height: ZenSpacing.xxs),
                                Text(
                                  '$current / $next XP',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            );
                          },
                          loading: () => const SizedBox(),
                          error: (_, __) => const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: ZenSpacing.xxl),
            
            // Featured Action
            ZenCard(
              backgroundColor: tokens.surfaceBright,
              onTap: () {
                context.push('/practice', extra: {'isTimed': true});
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: tokens.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.timer_rounded, color: tokens.primary),
                  ),
                  const SizedBox(width: ZenSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Timed Challenge',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '60 seconds. Mixed topics. Go.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: tokens.textSecondary),
                ],
              ),
            ),
            
            const SizedBox(height: ZenSpacing.xxl),
            
            Text(
              'Topics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: ZenSpacing.md),
            
            // Topic Grid
            _TopicGrid(),
          ],
        ),
      ),
    );
  }
}

class _TopicGrid extends StatelessWidget {
  final List<Map<String, dynamic>> topics = [
    {'icon': '+', 'name': 'Addition'},
    {'icon': '−', 'name': 'Subtraction'},
    {'icon': '×', 'name': 'Multiplication'},
    {'icon': '÷', 'name': 'Division'},
    {'icon': '%', 'name': 'Percentages'},
    {'icon': '⅟', 'name': 'Fractions'},
    {'icon': '.', 'name': 'Decimals'},
    {'icon': 'x', 'name': 'Algebra'},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: topics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: ZenSpacing.md,
        mainAxisSpacing: ZenSpacing.md,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        return _TopicCard(
          icon: topics[index]['icon']!,
          name: topics[index]['name']!,
          index: index,
        );
      },
    );
  }
}

class _TopicCard extends StatefulWidget {
  final String icon;
  final String name;
  final int index;

  const _TopicCard({
    required this.icon,
    required this.name,
    required this.index,
  });

  @override
  State<_TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<_TopicCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    // Staggered start
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showDifficultySheet(BuildContext context) {
    String selectedDifficulty = 'easy';
    
    ZenBottomSheet.show(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.name} Practice',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: ZenSpacing.lg),
              Text(
                'Select Difficulty',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: ZenSpacing.sm),
              ZenSegmentedControl<String>(
                groupValue: selectedDifficulty,
                values: const ['easy', 'medium', 'hard'],
                labels: const ['Easy', 'Medium', 'Hard'],
                onValueChanged: (val) {
                  setState(() => selectedDifficulty = val);
                },
              ),
              const SizedBox(height: ZenSpacing.xxl),
              ZenButton(
                label: 'Start Practice',
                onPressed: () {
                  context.pop(); // close sheet
                  context.push('/practice', extra: {
                    'topic': widget.name,
                    'difficulty': selectedDifficulty,
                    'isTimed': false,
                  });
                },
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ZenCard(
          onTap: () => _showDifficultySheet(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.icon,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: tokens.primary,
                      fontSize: 28,
                    ),
              ),
              const SizedBox(height: ZenSpacing.xs),
              Text(
                widget.name,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
