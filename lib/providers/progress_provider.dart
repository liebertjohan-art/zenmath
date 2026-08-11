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

final xpProvider = FutureProvider.autoDispose<Map<String, int>>((ref) async {
  final isarService = ref.watch(dbProvider);
  final isar = await isarService.db;
  final allProgress = await isar.collection<DailyProgress>().where().findAll();
  
  int totalXp = 0;
  for (var p in allProgress) {
    totalXp += p.xpEarned;
  }
  
  int level = (totalXp / 500).floor() + 1;
  int currentLevelXp = totalXp % 500;
  
  return {'totalXp': totalXp, 'level': level, 'currentLevelXp': currentLevelXp, 'nextLevelXp': 500};
});

final sessionsProvider = FutureProvider.autoDispose<List<SessionScore>>((ref) async {
  final isarService = ref.watch(dbProvider);
  final isar = await isarService.db;
  final sessions = await isar.collection<SessionScore>().where().sortByTimestampDesc().findAll();
  return sessions;
});

final statsProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, days) async {
  final isarService = ref.watch(dbProvider);
  final isar = await isarService.db;
  
  final now = DateTime.now();
  final cutoff = days > 0 ? DateTime(now.year, now.month, now.day).subtract(Duration(days: days)) : DateTime.fromMillisecondsSinceEpoch(0);
  
  final sessions = await isar.collection<SessionScore>().where().filter().timestampGreaterThan(cutoff).findAll();
  final progress = await isar.collection<DailyProgress>().where().filter().dateGreaterThan(cutoff).findAll();
  
  int totalSessions = sessions.length;
  double avgAccuracy = 0;
  if (totalSessions > 0) {
    double totalAcc = sessions.fold(0.0, (sum, s) => sum + s.accuracy);
    avgAccuracy = totalAcc / totalSessions;
  }
  
  int totalXp = progress.fold(0, (sum, p) => sum + p.xpEarned);
  
  // Topic breakdown
  Map<String, List<SessionScore>> byTopic = {};
  for (var s in sessions) {
    byTopic.putIfAbsent(s.topic, () => []).add(s);
  }
  
  List<Map<String, dynamic>> topicStats = [];
  byTopic.forEach((topic, list) {
    double acc = list.fold(0.0, (sum, s) => sum + s.accuracy) / list.length;
    topicStats.add({'topic': topic, 'accuracy': acc, 'sessions': list.length});
  });
  topicStats.sort((a, b) => (b['sessions'] as int).compareTo(a['sessions'] as int));
  
  // Chart data: daily accuracy
  Map<DateTime, double> dailyAcc = {};
  Map<DateTime, int> dailyCount = {};
  for (var s in sessions) {
    final d = DateTime(s.timestamp.year, s.timestamp.month, s.timestamp.day);
    dailyAcc[d] = (dailyAcc[d] ?? 0.0) + s.accuracy;
    dailyCount[d] = (dailyCount[d] ?? 0) + 1;
  }
  
  List<Map<String, dynamic>> chartData = [];
  dailyAcc.forEach((d, accSum) {
    chartData.add({
      'date': d,
      'accuracy': accSum / dailyCount[d]!,
    });
  });
  chartData.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
  
  return {
    'totalSessions': totalSessions,
    'avgAccuracy': avgAccuracy,
    'totalXp': totalXp,
    'topicStats': topicStats,
    'chartData': chartData,
  };
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
