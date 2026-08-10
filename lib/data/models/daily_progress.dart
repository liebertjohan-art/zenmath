import 'package:isar/isar.dart';

part 'daily_progress.g.dart';

@collection
class DailyProgress {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime date; // Start of day

  late int questionsAnswered;
  late int correctAnswers;
  late int xpEarned;
}
