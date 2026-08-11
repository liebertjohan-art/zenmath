import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/zen_design_tokens.dart';
import '../../core/theme/zen_spacing.dart';
import '../../core/widgets/zen_scaffold.dart';
import '../../core/widgets/zen_progress_ring.dart';
import '../../core/widgets/zen_button.dart';

class ResultsScreen extends StatefulWidget {
  final String topic;
  final String difficulty;
  final int score;
  final int totalQuestions;

  const ResultsScreen({
    super.key,
    required this.topic,
    required this.difficulty,
    required this.score,
    required this.totalQuestions,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  Widget _buildStaggeredItem(int index, Widget child) {
    final start = index * 0.1;
    final end = start + 0.4;
    
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end > 1.0 ? 1.0 : end, curve: Curves.easeOut),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: Interval(start, end > 1.0 ? 1.0 : end, curve: Curves.easeOutCubic),
          ),
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    final accuracy = widget.totalQuestions > 0 ? widget.score / widget.totalQuestions : 0.0;
    
    Color resultColor = accuracy >= 0.8 
        ? tokens.success 
        : (accuracy >= 0.5 ? tokens.primary : tokens.error);

    // Calculate XP earned (matching logic in ProgressService)
    final xpEarned = (widget.score * 10) + ((widget.totalQuestions - widget.score) * 5);

    return ZenScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ZenSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStaggeredItem(
                0,
                Text(
                  'Session Complete',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: tokens.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: ZenSpacing.huge),
              _buildStaggeredItem(
                1,
                Center(
                  child: ZenProgressRing(
                    progress: accuracy,
                    size: 200,
                    strokeWidth: 16,
                    activeColor: resultColor,
                    centerChild: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: accuracy * 100),
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Text(
                          '${value.toInt()}%',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: tokens.textPrimary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: ZenSpacing.xxl),
              _buildStaggeredItem(
                2,
                Text(
                  '${widget.score} / ${widget.totalQuestions} Correct',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: tokens.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: ZenSpacing.lg),
              _buildStaggeredItem(
                3,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.military_tech_rounded, color: tokens.primary, size: 28),
                    const SizedBox(width: ZenSpacing.xs),
                    Text(
                      '+$xpEarned XP',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: tokens.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: ZenSpacing.huge),
              _buildStaggeredItem(
                4,
                ZenButton(
                  label: 'Continue',
                  onPressed: () => context.go('/play'),
                  variant: ZenButtonVariant.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
