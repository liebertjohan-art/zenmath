import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../data/models/daily_progress.dart';
import '../data/models/session_score.dart';
import 'db_provider.dart';

final progressProvider = Provider((ref) => ProgressService(ref));

final weeklyProgressProvider = FutureProvider.autoDispose<List<DailyProgress>>((ref) async {
  final isarService = ref.watch(dbProvider);
  final isar = await isarService.db;
  
  final now = DateTime.now();
  final weekAgo = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
  
  final allProgress = await isar.collection<DailyProgress>().where().findAll();
  
  final weekly = allProgress.where((p) => !p.date.isBefore(weekAgo)).toList();
  weekly.sort((a, b) => a.date.compareTo(b.date));
  
  return weekly;
});

class ProgressService {
  final ProviderRef ref;
  ProgressService(this.ref);

  Future<void> saveSession(String topic, String difficulty, int score, int totalQuestions) async {
    final isarService = ref.read(dbProvider);
    final isar = await isarService.db;

    final session = SessionScore()
      ..topic = topic
      ..difficulty = difficulty
      ..score = score
      ..totalQuestions = totalQuestions
      ..timestamp = DateTime.now();

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    await isar.writeTxn(() async {
      await isar.collection<SessionScore>().put(session);

      final existingProgress = await isar.collection<DailyProgress>().where().findAll();
      
      DailyProgress todayProgress;
      try {
        todayProgress = existingProgress.firstWhere((p) => p.date == todayStart);
      } catch (e) {
        todayProgress = DailyProgress()
          ..date = todayStart
          ..questionsAnswered = 0
          ..correctAnswers = 0
          ..xpEarned = 0;
      }

      todayProgress.questionsAnswered += totalQuestions;
      todayProgress.correctAnswers += score;
      // XP logic: 10 per correct answer, 5 per wrong answer
      todayProgress.xpEarned += (score * 10) + ((totalQuestions - score) * 5);

      await isar.collection<DailyProgress>().put(todayProgress);
    });
  }
}
