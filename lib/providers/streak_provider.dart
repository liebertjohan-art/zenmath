import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../data/models/daily_progress.dart';
import 'db_provider.dart';

final streakProvider = FutureProvider.autoDispose<int>((ref) async {
  final isarService = ref.watch(dbProvider);
  final isar = await isarService.db;

  final allProgress = await isar.collection<DailyProgress>().where().findAll();
  if (allProgress.isEmpty) return 0;

  // Sort descending by date
  allProgress.sort((a, b) => b.date.compareTo(a.date));

  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);

  int streak = 0;
  DateTime expectedDate = todayStart;

  final firstDate = allProgress.first.date;
  if (firstDate.isBefore(todayStart.subtract(const Duration(days: 1)))) {
    return 0;
  }

  if (firstDate.isAtSameMomentAs(todayStart)) {
    expectedDate = todayStart;
  } else if (firstDate.isAtSameMomentAs(todayStart.subtract(const Duration(days: 1)))) {
    expectedDate = todayStart.subtract(const Duration(days: 1));
  } else {
    return 0;
  }

  for (final progress in allProgress) {
    if (progress.date.isAtSameMomentAs(expectedDate)) {
      streak++;
      expectedDate = expectedDate.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }

  return streak;
});
