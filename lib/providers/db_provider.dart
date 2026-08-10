import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/isar_service.dart';

final dbProvider = Provider<IsarService>((ref) {
  return IsarService();
});
