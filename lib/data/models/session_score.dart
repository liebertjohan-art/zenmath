import 'package:isar/isar.dart';

part 'session_score.g.dart';

@collection
class SessionScore {
  Id id = Isar.autoIncrement;

  late String topic;
  late String difficulty;
  late int score;
  late int totalQuestions;
  late DateTime timestamp;

  double get accuracy => totalQuestions == 0 ? 0 : score / totalQuestions;
}
