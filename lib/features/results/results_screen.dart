import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/zen_scaffold.dart';

class ResultsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    double accuracy = score / totalQuestions;
    Color resultColor = accuracy >= 0.8 ? const Color(0xFF8BA888) : (accuracy >= 0.5 ? const Color(0xFFD4AF37) : const Color(0xFFE07A5F));

    return ZenScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Session Complete',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: accuracy),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: 16,
                            backgroundColor: const Color(0xFF242623),
                            valueColor: AlwaysStoppedAnimation<Color>(resultColor),
                          ),
                        ),
                        Text(
                          '${(value * 100).toInt()}%',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '$score / $totalQuestions Correct',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: const Color(0xFF121212),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => context.go('/'),
                child: const Text('Back to Home', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
