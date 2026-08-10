import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/zen_scaffold.dart';
import '../../core/widgets/zen_card.dart';
import '../../core/widgets/glass_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 48),
              // Mockup Progress Ring
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: 0.6,
                        strokeWidth: 8,
                        backgroundColor: const Color(0xFF242623),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8BA888)),
                      ),
                    ),
                    Text(
                      '🔥 3',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Topics',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ZenCard(
                      onTap: () => _showDifficultySheet(context, 'Addition'),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          children: [
                            const Text('+', style: TextStyle(fontSize: 32, color: Color(0xFFD4AF37))),
                            const SizedBox(width: 24),
                            Text(
                              'Addition',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ZenCard(
                      onTap: () => _showDifficultySheet(context, 'Subtraction'),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          children: [
                            const Text('-', style: TextStyle(fontSize: 32, color: Color(0xFFD4AF37))),
                            const SizedBox(width: 24),
                            Text(
                              'Subtraction',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
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
