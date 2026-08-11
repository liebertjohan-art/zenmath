import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final String defaultDifficulty;
  final int questionCount;
  final bool hapticsEnabled;
  final bool animationsEnabled;

  AppSettings({
    this.defaultDifficulty = 'easy',
    this.questionCount = 10,
    this.hapticsEnabled = true,
    this.animationsEnabled = true,
  });

  AppSettings copyWith({
    String? defaultDifficulty,
    int? questionCount,
    bool? hapticsEnabled,
    bool? animationsEnabled,
  }) {
    return AppSettings(
      defaultDifficulty: defaultDifficulty ?? this.defaultDifficulty,
      questionCount: questionCount ?? this.questionCount,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
    );
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = AppSettings(
      defaultDifficulty: prefs.getString('defaultDifficulty') ?? 'easy',
      questionCount: prefs.getInt('questionCount') ?? 10,
      hapticsEnabled: prefs.getBool('hapticsEnabled') ?? true,
      animationsEnabled: prefs.getBool('animationsEnabled') ?? true,
    );
  }

  Future<void> updateDifficulty(String diff) async {
    state = state.copyWith(defaultDifficulty: diff);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultDifficulty', diff);
  }

  Future<void> updateQuestionCount(int count) async {
    state = state.copyWith(questionCount: count);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('questionCount', count);
  }

  Future<void> toggleHaptics(bool val) async {
    state = state.copyWith(hapticsEnabled: val);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hapticsEnabled', val);
  }

  Future<void> toggleAnimations(bool val) async {
    state = state.copyWith(animationsEnabled: val);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('animationsEnabled', val);
  }
}
