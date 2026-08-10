import 'package:isar/isar.dart';

part 'topic_stats.g.dart';

@collection
class TopicStats {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String topic;

  late int totalPlayed;
  late int totalCorrect;

  double get averageAccuracy => totalPlayed == 0 ? 0 : totalCorrect / totalPlayed;
}
