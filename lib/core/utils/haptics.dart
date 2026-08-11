import 'package:flutter/services.dart';

class ZenHaptics {
  /// Use for standard taps, numpad entry, button press
  static void light() {
    HapticFeedback.lightImpact();
  }

  /// Use for correct answer, task completion
  static void medium() {
    HapticFeedback.mediumImpact();
  }

  /// Use for wrong answer, errors, destructive actions
  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  /// Use for tab switching, segmented control toggles, sliders
  static void selection() {
    HapticFeedback.selectionClick();
  }
}
