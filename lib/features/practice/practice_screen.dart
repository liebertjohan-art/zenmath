import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/zen_scaffold.dart';
import '../../core/widgets/zen_numpad.dart';
import '../../providers/progress_provider.dart';
import '../../providers/streak_provider.dart';

class PracticeScreen extends ConsumerStatefulWidget {
  final String topic;
  final String difficulty;

  const PracticeScreen({super.key, required this.topic, required this.difficulty});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  final Random _random = Random();
  late int answer;
  String questionText = '';
  String userInput = '';
  int currentQuestionIndex = 0;
  int score = 0;
  final int totalQuestions = 10;
  Color _feedbackColor = Colors.transparent;
  double _shakeOffset = 0;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    int maxNum = widget.difficulty == 'easy' ? 10 : (widget.difficulty == 'medium' ? 50 : 100);
    
    if (widget.topic == 'Addition') {
      int n1 = _random.nextInt(maxNum) + 1;
      int n2 = _random.nextInt(maxNum) + 1;
      answer = n1 + n2;
      questionText = '$n1 + $n2';
    } else if (widget.topic == 'Subtraction') {
      int n1 = _random.nextInt(maxNum) + maxNum;
      int n2 = _random.nextInt(maxNum) + 1;
      answer = n1 - n2;
      questionText = '$n1 - $n2';
    } else if (widget.topic == 'Multiplication') {
      int mulMax = widget.difficulty == 'easy' ? 5 : (widget.difficulty == 'medium' ? 10 : 20);
      int n1 = _random.nextInt(mulMax) + 1;
      int n2 = _random.nextInt(mulMax) + 1;
      answer = n1 * n2;
      questionText = '$n1 × $n2';
    } else if (widget.topic == 'Division') {
      int divMax = widget.difficulty == 'easy' ? 5 : (widget.difficulty == 'medium' ? 10 : 20);
      int n2 = _random.nextInt(divMax) + 1;
      answer = _random.nextInt(divMax) + 1;
      int n1 = n2 * answer;
      questionText = '$n1 ÷ $n2';
    } else if (widget.topic == 'Percentages') {
      List<int> percs = widget.difficulty == 'easy' ? [10, 50] : (widget.difficulty == 'medium' ? [20, 25, 50] : [5, 15, 75]);
      int perc = percs[_random.nextInt(percs.length)];
      int multiplier = _random.nextInt(10) + 1;
      int n2 = multiplier * 20 * (widget.difficulty == 'hard' ? 5 : 1);
      answer = (n2 * perc) ~/ 100;
      questionText = '$perc% of $n2';
    } else if (widget.topic == 'Fractions') {
      List<int> denoms = widget.difficulty == 'easy' ? [2] : (widget.difficulty == 'medium' ? [3, 4] : [5, 8]);
      int denom = denoms[_random.nextInt(denoms.length)];
      int num = _random.nextInt(denom - 1) + 1;
      int multiplier = _random.nextInt(10) + 1;
      int n2 = multiplier * denom * (widget.difficulty == 'hard' ? 2 : 1);
      answer = (n2 * num) ~/ denom;
      questionText = '$num/$denom of $n2';
    } else if (widget.topic == 'Decimals') {
      int whole1 = _random.nextInt(10) + 1;
      int whole2 = _random.nextInt(10) + 1;
      int dec1 = _random.nextInt(9) + 1;
      int dec2 = 10 - dec1;
      double d1 = whole1 + (dec1 / 10);
      double d2 = whole2 + (dec2 / 10);
      answer = whole1 + whole2 + 1;
      questionText = '${d1.toStringAsFixed(1)} + ${d2.toStringAsFixed(1)}';
    } else { // Algebra
      int type = _random.nextInt(2);
      if (type == 0) {
        int a = _random.nextInt(maxNum) + 1;
        answer = _random.nextInt(maxNum) + 1;
        int b = answer + a;
        questionText = 'x + $a = $b';
      } else {
        int a = _random.nextInt(10) + 2;
        answer = _random.nextInt(10) + 2;
        int b = a * answer;
        questionText = '${a}x = $b';
      }
    }
  }

  void _onNumber(int num) {
    if (userInput.length < 5) {
      HapticFeedback.lightImpact();
      setState(() {
        userInput += num.toString();
        _feedbackColor = Colors.transparent;
      });
    }
  }

  void _onDelete() {
    if (userInput.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() {
        userInput = userInput.substring(0, userInput.length - 1);
        _feedbackColor = Colors.transparent;
      });
    }
  }

  void _onSubmit() {
    if (userInput.isEmpty) return;

    int parsedInput = int.parse(userInput);
    bool isCorrect = parsedInput == answer;

    setState(() {
      _feedbackColor = isCorrect ? const Color(0xFF8BA888) : const Color(0xFFE07A5F);
      if (isCorrect) {
        score++;
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.heavyImpact();
        _shakeOffset = 15;
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted) setState(() => _shakeOffset = -15);
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) setState(() => _shakeOffset = 15);
        });
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) setState(() => _shakeOffset = 0);
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      if (currentQuestionIndex < totalQuestions - 1) {
        setState(() {
          currentQuestionIndex++;
          _generateQuestion();
          userInput = '';
          _feedbackColor = Colors.transparent;
        });
      } else {
        ref.read(progressProvider).saveSession(
          widget.topic,
          widget.difficulty,
          score,
          totalQuestions,
        );
        ref.invalidate(streakProvider);
        context.pushReplacement('/results', extra: {
          'topic': widget.topic,
          'difficulty': widget.difficulty,
          'score': score,
          'totalQuestions': totalQuestions,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZenScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text('${currentQuestionIndex + 1} / $totalQuestions', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Transform.translate(
                  offset: Offset(_shakeOffset, 0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(48),
                    decoration: BoxDecoration(
                      color: _feedbackColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: _feedbackColor == Colors.transparent
                          ? []
                          : [
                              BoxShadow(
                                color: _feedbackColor.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            questionText,
                            key: ValueKey<int>(currentQuestionIndex),
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: questionText.length > 8 ? 48 : 64,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          child: Text(
                            userInput.isEmpty ? '?' : userInput,
                            key: ValueKey<String>(userInput),
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: userInput.isEmpty ? Colors.grey : const Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: ZenNumPad(
                onNumber: _onNumber,
                onDelete: _onDelete,
                onSubmit: _onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
