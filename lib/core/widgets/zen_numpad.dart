import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ZenNumPad extends StatelessWidget {
  final Function(int) onNumber;
  final VoidCallback onDelete;
  final VoidCallback onSubmit;

  const ZenNumPad({
    super.key,
    required this.onNumber,
    required this.onDelete,
    required this.onSubmit,
  });

  Widget _buildButton(BuildContext context, String text, VoidCallback onTap, {Color? color, bool isAction = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            if (isAction) {
              HapticFeedback.mediumImpact();
            } else {
              HapticFeedback.lightImpact();
            }
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: color ?? const Color(0xFF242623), // Zen Deep Slate
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                text,
                style: isAction
                    ? Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: color != null ? const Color(0xFF121212) : Colors.white,
                          fontWeight: FontWeight.bold,
                        )
                    : Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++)
          Row(
            children: [
              for (var j = 1; j <= 3; j++)
                _buildButton(context, '${i * 3 + j}', () => onNumber(i * 3 + j)),
            ],
          ),
        Row(
          children: [
            _buildButton(context, 'DEL', onDelete, isAction: true),
            _buildButton(context, '0', () => onNumber(0)),
            _buildButton(context, 'GO', onSubmit, color: const Color(0xFFD4AF37), isAction: true), // Zen Gold
          ],
        ),
      ],
    );
  }
}
