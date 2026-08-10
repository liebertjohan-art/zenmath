import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/zen_scaffold.dart';
import '../../core/widgets/zen_numpad.dart';

class PracticeScreen extends StatefulWidget {
  final String topic;
  final String difficulty;

  const PracticeScreen({super.key, required this.topic, required this.difficulty});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final Random _random = Random();
  late int num1;
  late int num2;
  late int answer;
  String userInput = '';
  int currentQuestionIndex = 0;
  int score = 0;
  final int totalQuestions = 10;
  Color _feedbackColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    int maxNum = widget.difficulty == 'easy' ? 10 : (widget.difficulty == 'medium' ? 50 : 100);
    
    if (widget.topic == 'Addition') {
      num1 = _random.nextInt(maxNum) + 1;
      num2 = _random.nextInt(maxNum) + 1;
      answer = num1 + num2;
    } else { // Subtraction
      num1 = _random.nextInt(maxNum) + maxNum; // ensure positive result
      num2 = _random.nextInt(maxNum) + 1;
      answer = num1 - num2;
    }
  }

  void _onNumber(int num) {
    if (userInput.length < 5) {
      setState(() {
        userInput += num.toString();
        _feedbackColor = Colors.transparent;
      });
    }
  }

  void _onDelete() {
    if (userInput.isNotEmpty) {
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
    String operatorSymbol = widget.topic == 'Addition' ? '+' : '-';

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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    color: _feedbackColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$num1 $operatorSymbol $num2',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 64),
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
