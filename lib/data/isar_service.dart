import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/session_score.dart';
import 'models/daily_progress.dart';
import 'models/topic_stats.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [SessionScoreSchema, DailyProgressSchema, TopicStatsSchema],
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
