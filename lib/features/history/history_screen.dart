import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/zen_design_tokens.dart';
import '../../core/theme/zen_spacing.dart';
import '../../core/widgets/zen_card.dart';
import '../../providers/progress_provider.dart';
import '../../data/models/session_score.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  Future<void> _onRefresh() async {
    ref.invalidate(sessionsProvider);
    await ref.read(sessionsProvider.future);
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDate = DateTime(date.year, date.month, date.day);
    
    if (sessionDate == today) return 'Today';
    if (sessionDate == today.subtract(const Duration(days: 1))) return 'Yesterday';
    
    if (now.difference(sessionDate).inDays < 7) {
      return DateFormat('EEEE').format(date); // 'Monday', 'Tuesday'
    }
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    final sessionsAsync = ref.watch(sessionsProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text('History', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: sessionsAsync.when(
        data: (sessions) {
          if (sessions.isEmpty) {
            return _buildEmptyState(tokens);
          }
          
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: tokens.primary,
            backgroundColor: tokens.surfaceVariant,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(ZenSpacing.xl, ZenSpacing.lg, ZenSpacing.xl, 100),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                bool showHeader = false;
                if (index == 0) {
                  showHeader = true;
                } else {
                  final prevSession = sessions[index - 1];
                  final currDate = DateTime(session.timestamp.year, session.timestamp.month, session.timestamp.day);
                  final prevDate = DateTime(prevSession.timestamp.year, prevSession.timestamp.month, prevSession.timestamp.day);
                  showHeader = currDate != prevDate;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader) ...[
                      if (index != 0) const SizedBox(height: ZenSpacing.xl),
                      Text(
                        _formatDateHeader(session.timestamp),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                      const SizedBox(height: ZenSpacing.md),
                    ],
                    Padding(
                      padding: const EdgeInsets.only(bottom: ZenSpacing.md),
                      child: _SessionCard(session: session, index: index),
                    ),
                  ],
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildEmptyState(ZenDesignTokens tokens) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 64, color: tokens.textTertiary),
          const SizedBox(height: ZenSpacing.lg),
          Text(
            'No sessions yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: tokens.textSecondary,
            ),
          ),
          const SizedBox(height: ZenSpacing.sm),
          Text(
            'Play a practice session to see it here.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: tokens.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatefulWidget {
  final SessionScore session;
  final int index;

  const _SessionCard({required this.session, required this.index});

  @override
  State<_SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<_SessionCard> with SingleTickerProviderStateMixin {
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

    Future.delayed(Duration(milliseconds: (widget.index % 10) * 50), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getTopicIcon(String topic) {
    switch (topic) {
      case 'Addition': return '+';
      case 'Subtraction': return '−';
      case 'Multiplication': return '×';
      case 'Division': return '÷';
      case 'Percentages': return '%';
      case 'Fractions': return '⅟';
      case 'Decimals': return '.';
      case 'Algebra': return 'x';
      default: return '?';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    final accuracy = widget.session.accuracy;
    
    Color accentColor = accuracy >= 0.8 
        ? tokens.success 
        : (accuracy >= 0.5 ? tokens.primary : tokens.error);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ZenCard(
          padding: const EdgeInsets.all(ZenSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _getTopicIcon(widget.session.topic),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: accentColor,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: ZenSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.session.topic,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: ZenSpacing.xxs),
                    Text(
                      '${widget.session.difficulty.toUpperCase()} • ${DateFormat('h:mm a').format(widget.session.timestamp)}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: tokens.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(accuracy * 100).toInt()}%',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: ZenSpacing.xxs),
                  Text(
                    '${widget.session.score}/${widget.session.totalQuestions}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: tokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
