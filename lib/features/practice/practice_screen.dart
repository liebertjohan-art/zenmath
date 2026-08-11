import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/zen_design_tokens.dart';
import '../../core/theme/zen_spacing.dart';
import '../../core/widgets/zen_scaffold.dart';
import '../../core/widgets/zen_numpad.dart';
import '../../core/utils/animations.dart';
import '../../core/utils/haptics.dart';
import '../../providers/progress_provider.dart';
import '../../providers/streak_provider.dart';

class PracticeScreen extends ConsumerStatefulWidget {
  final String topic;
  final String difficulty;
  final bool isTimed;

  const PracticeScreen({
    super.key, 
    required this.topic, 
    required this.difficulty, 
    this.isTimed = false,
  });

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> with TickerProviderStateMixin {
  final Random _random = Random();
  late int answer;
  String questionText = '';
  String userInput = '';
  int currentQuestionIndex = 0;
  int score = 0;
  final int totalQuestions = 10;
  
  // Feedback state
  Color _feedbackColor = Colors.transparent;
  
  // Timer state
  Timer? _timer;
  int timeLeft = 60;
  
  // Animation controllers
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    // Spring-like shake physics
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -12).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12, end: 12).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12, end: -8).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 4).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 4, end: 0).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 1),
    ]).animate(_shakeController);

    _generateQuestion();
    if (widget.isTimed) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        _timer?.cancel();
        _finishSession();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  void _generateQuestion() {
    String currentTopic = widget.topic;
    if (currentTopic == 'Mixed') {
      List<String> all = ['Addition', 'Subtraction', 'Multiplication', 'Division', 'Percentages', 'Fractions', 'Decimals', 'Algebra'];
      currentTopic = all[_random.nextInt(all.length)];
    }
    
    int maxNum = widget.difficulty == 'easy' ? 10 : (widget.difficulty == 'medium' ? 50 : 100);
    
    if (currentTopic == 'Addition') {
      int n1 = _random.nextInt(maxNum) + 1;
      int n2 = _random.nextInt(maxNum) + 1;
      answer = n1 + n2;
      questionText = '$n1 + $n2';
    } else if (currentTopic == 'Subtraction') {
      int n1 = _random.nextInt(maxNum) + maxNum;
      int n2 = _random.nextInt(maxNum) + 1;
      answer = n1 - n2;
      questionText = '$n1 - $n2';
    } else if (currentTopic == 'Multiplication') {
      int mulMax = widget.difficulty == 'easy' ? 5 : (widget.difficulty == 'medium' ? 10 : 20);
      int n1 = _random.nextInt(mulMax) + 1;
      int n2 = _random.nextInt(mulMax) + 1;
      answer = n1 * n2;
      questionText = '$n1 × $n2';
    } else if (currentTopic == 'Division') {
      int divMax = widget.difficulty == 'easy' ? 5 : (widget.difficulty == 'medium' ? 10 : 20);
      int n2 = _random.nextInt(divMax) + 1;
      answer = _random.nextInt(divMax) + 1;
      int n1 = n2 * answer;
      questionText = '$n1 ÷ $n2';
    } else if (currentTopic == 'Percentages') {
      List<int> percs = widget.difficulty == 'easy' ? [10, 50] : (widget.difficulty == 'medium' ? [20, 25, 50] : [5, 15, 75]);
      int perc = percs[_random.nextInt(percs.length)];
      int multiplier = _random.nextInt(10) + 1;
      int n2 = multiplier * 20 * (widget.difficulty == 'hard' ? 5 : 1);
      answer = (n2 * perc) ~/ 100;
      questionText = '$perc% of $n2';
    } else if (currentTopic == 'Fractions') {
      List<int> denoms = widget.difficulty == 'easy' ? [2] : (widget.difficulty == 'medium' ? [3, 4] : [5, 8]);
      int denom = denoms[_random.nextInt(denoms.length)];
      int num = _random.nextInt(denom - 1) + 1;
      int multiplier = _random.nextInt(10) + 1;
      int n2 = multiplier * denom * (widget.difficulty == 'hard' ? 2 : 1);
      answer = (n2 * num) ~/ denom;
      questionText = '$num/$denom of $n2';
    } else if (currentTopic == 'Decimals') {
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

    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    int parsedInput = int.parse(userInput);
    bool isCorrect = parsedInput == answer;

    setState(() {
      _feedbackColor = isCorrect ? tokens.success : tokens.error;
    });

    if (isCorrect) {
      score++;
      ZenHaptics.medium();
    } else {
      ZenHaptics.heavy();
      _shakeController.forward(from: 0);
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      if (widget.isTimed || currentQuestionIndex < totalQuestions - 1) {
        setState(() {
          currentQuestionIndex++;
          _generateQuestion();
          userInput = '';
          _feedbackColor = Colors.transparent;
        });
      } else {
        _finishSession();
      }
    });
  }

  void _finishSession() {
    if (!mounted) return;
    int answered = widget.isTimed ? max(currentQuestionIndex, score) : totalQuestions;
    ref.read(progressProvider).saveSession(
      widget.topic,
      widget.difficulty,
      score,
      answered,
    );
    ref.invalidate(streakProvider);
    context.pushReplacement('/results', extra: {
      'topic': widget.topic,
      'difficulty': widget.difficulty,
      'score': score,
      'totalQuestions': answered,
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;
    
    return ZenScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: tokens.textSecondary),
          onPressed: () => context.pop(),
        ),
        title: widget.isTimed
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_rounded, color: tokens.primary, size: 20),
                  const SizedBox(width: ZenSpacing.xs),
                  Text(
                    '$timeLeft s', 
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: timeLeft <= 10 ? tokens.error : tokens.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Text(
                '${currentQuestionIndex + 1} / $totalQuestions', 
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_shakeAnimation.value, 0),
                      child: child,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: ZenAnimations.easeOutUI,
                    padding: const EdgeInsets.symmetric(horizontal: ZenSpacing.xxl, vertical: ZenSpacing.xxl * 2),
                    decoration: BoxDecoration(
                      color: _feedbackColor == Colors.transparent 
                          ? Colors.transparent 
                          : _feedbackColor.withOpacity(0.1),
                      borderRadius: ZenRadii.xxlRadius,
                      border: Border.all(
                        color: _feedbackColor == Colors.transparent 
                            ? Colors.transparent 
                            : _feedbackColor.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                                  CurvedAnimation(parent: animation, curve: Curves.easeOutBack)
                                ),
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            questionText,
                            key: ValueKey<int>(currentQuestionIndex),
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w700,
                              fontSize: questionText.length > 8 ? 56 : 72,
                              color: tokens.textPrimary,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: ZenSpacing.xxl),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          child: Text(
                            userInput.isEmpty ? '?' : userInput,
                            key: ValueKey<String>(userInput),
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w600,
                              fontSize: 48,
                              color: userInput.isEmpty ? tokens.textTertiary : tokens.primary,
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
              padding: const EdgeInsets.symmetric(horizontal: ZenSpacing.sm, vertical: ZenSpacing.md),
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
