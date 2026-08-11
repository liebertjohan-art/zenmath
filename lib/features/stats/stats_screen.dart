import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/theme/zen_design_tokens.dart';
import '../../core/theme/zen_spacing.dart';
import '../../core/widgets/zen_card.dart';
import '../../core/widgets/zen_segmented_control.dart';
import '../../providers/progress_provider.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  int _selectedDays = 7; // 7, 30, 0 (All Time)

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    final statsAsync = ref.watch(statsProvider(_selectedDays));

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text('Statistics', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: ZenSpacing.xl, vertical: ZenSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ZenSegmentedControl<int>(
                  groupValue: _selectedDays,
                  values: const [7, 30, 0],
                  labels: const ['7 Days', '30 Days', 'All Time'],
                  onValueChanged: (val) {
                    setState(() => _selectedDays = val);
                  },
                ),
                const SizedBox(height: ZenSpacing.xxl),
                
                statsAsync.when(
                  data: (stats) {
                    if (stats['totalSessions'] == 0) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('No data for this period'),
                        )
                      );
                    }
                    return _buildStatsContent(context, tokens, stats);
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(48.0),
                      child: CircularProgressIndicator(),
                    )
                  ),
                  error: (e, _) => Text('Error: $e'),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsContent(BuildContext context, ZenDesignTokens tokens, Map<String, dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart
        ZenCard(
          padding: const EdgeInsets.all(ZenSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Accuracy Trend', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: ZenSpacing.xl),
              SizedBox(
                height: 200,
                child: _buildChart(tokens, stats['chartData'] as List<Map<String, dynamic>>),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: ZenSpacing.xl),
        
        // 2x2 Grid
        Row(
          children: [
            Expanded(child: _buildStatMiniCard(context, tokens, 'Sessions', '${stats['totalSessions']}')),
            const SizedBox(width: ZenSpacing.md),
            Expanded(child: _buildStatMiniCard(context, tokens, 'Avg Accuracy', '${((stats['avgAccuracy'] as double) * 100).toInt()}%')),
          ],
        ),
        const SizedBox(height: ZenSpacing.md),
        Row(
          children: [
            Expanded(child: _buildStatMiniCard(context, tokens, 'XP Earned', '${stats['totalXp']}')),
            const SizedBox(width: ZenSpacing.md),
            // Placeholder for best streak in period (would need query update)
            Expanded(child: _buildStatMiniCard(context, tokens, 'Topics Played', '${(stats['topicStats'] as List).length}')),
          ],
        ),
        
        const SizedBox(height: ZenSpacing.xxl),
        
        // Topic Breakdown
        Text('By Topic', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: ZenSpacing.md),
        ...(stats['topicStats'] as List<Map<String, dynamic>>).map((ts) {
          final acc = ts['accuracy'] as double;
          return Padding(
            padding: const EdgeInsets.only(bottom: ZenSpacing.md),
            child: ZenCard(
              padding: const EdgeInsets.all(ZenSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(ts['topic'], style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${(acc * 100).toInt()}%', style: Theme.of(context).textTheme.labelSmall),
                            Text('${ts['sessions']} sessions', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: tokens.textTertiary)),
                          ],
                        ),
                        const SizedBox(height: ZenSpacing.xs),
                        ClipRRect(
                          borderRadius: ZenRadii.fullRadius,
                          child: LinearProgressIndicator(
                            value: acc,
                            backgroundColor: tokens.surfaceVariant,
                            color: acc >= 0.8 ? tokens.success : (acc >= 0.5 ? tokens.primary : tokens.error),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildStatMiniCard(BuildContext context, ZenDesignTokens tokens, String label, String value) {
    return ZenCard(
      padding: const EdgeInsets.all(ZenSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: ZenSpacing.xs),
          Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: tokens.primary,
          )),
        ],
      ),
    );
  }

  Widget _buildChart(ZenDesignTokens tokens, List<Map<String, dynamic>> chartData) {
    if (chartData.isEmpty) return const SizedBox();

    List<FlSpot> spots = [];
    double minX = 0;
    double maxX = (chartData.length - 1).toDouble();

    for (int i = 0; i < chartData.length; i++) {
      spots.add(FlSpot(i.toDouble(), chartData[i]['accuracy'] as double));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 1.0,
        minX: minX,
        maxX: maxX,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 0.25,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: tokens.surfaceVariant,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0 || value < 0 || value >= chartData.length) return const SizedBox();
                final date = chartData[value.toInt()]['date'] as DateTime;
                // Only show a few labels if many points
                if (chartData.length > 7 && value.toInt() % (chartData.length ~/ 4) != 0) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('M/d').format(date),
                    style: TextStyle(color: tokens.textTertiary, fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${(value * 100).toInt()}%',
                  style: TextStyle(color: tokens.textTertiary, fontSize: 10),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: tokens.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: tokens.primary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
