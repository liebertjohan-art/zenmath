import 'package:flutter/services.dart';

class ZenHaptics {
  static bool enabled = true;

  /// Use for standard taps, numpad entry, button press
  static void light() {
    if (!enabled) return;
    HapticFeedback.lightImpact();
  }

  /// Use for correct answer, task completion
  static void medium() {
    if (!enabled) return;
    HapticFeedback.mediumImpact();
  }

  /// Use for wrong answer, errors, destructive actions
  static void heavy() {
    if (!enabled) return;
    HapticFeedback.heavyImpact();
  }

  /// Use for tab switching, segmented control toggles, sliders
  static void selection() {
    if (!enabled) return;
    HapticFeedback.selectionClick();
  }
}
