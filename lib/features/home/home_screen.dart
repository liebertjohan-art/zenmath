import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/widgets/zen_scaffold.dart';
import '../../core/widgets/zen_card.dart';
import '../../core/widgets/glass_bottom_sheet.dart';
import '../../providers/streak_provider.dart';
import '../../providers/progress_provider.dart';
import '../../data/models/daily_progress.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  
  final List<Map<String, String>> _topics = [
    {'title': 'Addition', 'icon': '+'},
    {'title': 'Subtraction', 'icon': '-'},
    {'title': 'Multiplication', 'icon': '×'},
    {'title': 'Division', 'icon': '÷'},
    {'title': 'Percentages', 'icon': '%'},
    {'title': 'Fractions', 'icon': '⅟'},
    {'title': 'Decimals', 'icon': '.'},
    {'title': 'Algebra', 'icon': 'x'},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showDifficultySheet(BuildContext context, String topic) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassBottomSheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Difficulty',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildDifficultyButton(context, 'Easy', topic, 'easy'),
            const SizedBox(height: 16),
            _buildDifficultyButton(context, 'Medium', topic, 'medium'),
            const SizedBox(height: 16),
            _buildDifficultyButton(context, 'Hard', topic, 'hard'),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String label, String topic, String difficulty) {
    return InkWell(
      onTap: () {
        context.pop();
        context.push('/practice', extra: {'topic': topic, 'difficulty': difficulty});
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF242623),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildChart(List<DailyProgress> weeklyData) {
    if (weeklyData.isEmpty) {
      return const Center(child: Text("No progress yet. Start practicing!", style: TextStyle(color: Colors.grey)));
    }

    final spots = <FlSpot>[];
    double maxScore = 1;
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    
    for (int i = 0; i < 7; i++) {
      final date = todayStart.subtract(Duration(days: 6 - i));
      final progress = weeklyData.where((p) => p.date == date).firstOrNull;
      final score = progress?.correctAnswers.toDouble() ?? 0.0;
      if (score > maxScore) maxScore = score;
      spots.add(FlSpot(i.toDouble(), score));
    }

    return SizedBox(
      height: 100, // Reduced from 150 to fit better
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: maxScore * 1.2,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xFF8BA888),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF8BA888).withOpacity(0.2),
              ),
            ),
          ],
          titlesData: const FlTitlesData(show: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final streakAsync = ref.watch(streakProvider);
    final weeklyAsync = ref.watch(weeklyProgressProvider);

    return ZenScaffold(
      appBar: AppBar(
        title: Text(
          'ZenMath',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Focus & Flow',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                value: 1.0,
                                strokeWidth: 8,
                                backgroundColor: const Color(0xFF242623),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8BA888)),
                              ),
                            ),
                            streakAsync.when(
                              data: (streak) => Text(
                                '🔥 $streak',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              loading: () => const CircularProgressIndicator(color: Color(0xFFD4AF37)),
                              error: (e, st) => const Text('Err'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text('Day Streak', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF242623),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('7-Day Growth', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                          const SizedBox(height: 8),
                          weeklyAsync.when(
                            data: (data) => _buildChart(data),
                            loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
                            error: (e, st) => const SizedBox(height: 100, child: Center(child: Text('Err'))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Text(
                'Topics',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _topics.length,
                  itemBuilder: (context, index) {
                    final topic = _topics[index];
                    final start = (index * 0.1).clamp(0.0, 1.0);
                    final end = (start + 0.4).clamp(0.0, 1.0);
                    
                    final fadeAnim = Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(parent: _animController, curve: Interval(start, end, curve: Curves.easeOutCubic))
                    );
                    final slideAnim = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
                      CurvedAnimation(parent: _animController, curve: Interval(start, end, curve: Curves.easeOutCubic))
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: FadeTransition(
                        opacity: fadeAnim,
                        child: SlideTransition(
                          position: slideAnim,
                          child: ZenCard(
                            onTap: () => _showDifficultySheet(context, topic['title']!),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                children: [
                                  Text(topic['icon']!, style: const TextStyle(fontSize: 32, color: Color(0xFFD4AF37))),
                                  const SizedBox(width: 24),
                                  Text(
                                    topic['title']!,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
