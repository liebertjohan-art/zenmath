import 'package:flutter/material.dart';
import '../theme/zen_design_tokens.dart';
import '../theme/zen_spacing.dart';
import '../utils/haptics.dart';
import '../utils/animations.dart';

class ZenSegmentedControl<T> extends StatelessWidget {
  final T groupValue;
  final List<T> values;
  final List<String> labels;
  final ValueChanged<T> onValueChanged;

  const ZenSegmentedControl({
    super.key,
    required this.groupValue,
    required this.values,
    required this.labels,
    required this.onValueChanged,
  }) : assert(values.length == labels.length);

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;

    return Container(
      height: 48,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: tokens.surfaceVariant,
        borderRadius: ZenRadii.fullRadius,
      ),
      child: Stack(
        children: [
          // Animated Selection Background
          AnimatedAlign(
            alignment: _getAlignment(),
            duration: ZenAnimations.tapFeedback,
            curve: ZenAnimations.easeOutUI,
            child: FractionallySizedBox(
              widthFactor: 1.0 / values.length,
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: tokens.surface,
                  borderRadius: ZenRadii.fullRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Labels
          Row(
            children: List.generate(values.length, (index) {
              final isSelected = groupValue == values[index];
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (!isSelected) {
                      ZenHaptics.selection();
                      onValueChanged(values[index]);
                    }
                  },
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: ZenAnimations.tapFeedback,
                      curve: ZenAnimations.easeOutUI,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: isSelected ? tokens.textPrimary : tokens.textSecondary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                      child: Text(labels[index]),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Alignment _getAlignment() {
    final index = values.indexOf(groupValue);
    if (values.length == 2) {
      return index == 0 ? Alignment.centerLeft : Alignment.centerRight;
    }
    // General case: map index to -1.0 .. 1.0
    final step = 2.0 / (values.length - 1);
    return Alignment(-1.0 + (step * index), 0);
  }
}
