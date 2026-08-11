import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/zen_design_tokens.dart';
import '../theme/zen_spacing.dart';

class ZenNumPad extends StatelessWidget {
  final Function(int) onNumber;
  final VoidCallback onDelete;

  const ZenNumPad({
    super.key,
    required this.onNumber,
    required this.onDelete,
  });

  Widget _buildButton(BuildContext context, String text, VoidCallback onTap, ZenDesignTokens tokens, {bool isSubmit = false, bool isDelete = false}) {
    Color bgColor = tokens.surfaceVariant;
    Color textColor = tokens.textPrimary;

    if (isSubmit) {
      bgColor = tokens.primary;
      textColor = tokens.background;
    } else if (isDelete) {
      bgColor = Colors.transparent;
      textColor = tokens.error;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(ZenSpacing.xs),
        child: _NumPadKey(
          text: text,
          onTap: () {
            if (isSubmit || isDelete) {
              HapticFeedback.mediumImpact();
            } else {
              HapticFeedback.lightImpact();
            }
            onTap();
          },
          bgColor: bgColor,
          textColor: textColor,
          isAction: isSubmit || isDelete,
          tokens: tokens,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ZenDesignTokens>()!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++)
          Row(
            children: [
              for (var j = 1; j <= 3; j++)
                _buildButton(context, '${i * 3 + j}', () => onNumber(i * 3 + j), tokens),
            ],
          ),
        Row(
          children: [
            _buildButton(context, 'DEL', onDelete, tokens, isDelete: true),
            _buildButton(context, '0', () => onNumber(0), tokens),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }
}

class _NumPadKey extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color bgColor;
  final Color textColor;
  final bool isAction;
  final ZenDesignTokens tokens;

  const _NumPadKey({
    required this.text,
    required this.onTap,
    required this.bgColor,
    required this.textColor,
    required this.isAction,
    required this.tokens,
  });

  @override
  State<_NumPadKey> createState() => _NumPadKeyState();
}

class _NumPadKeyState extends State<_NumPadKey> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    
    // Default color shift for standard keys
    Color endColor = widget.bgColor;
    if (!widget.isAction) {
      endColor = widget.tokens.surfaceBright;
    }
    
    _colorAnimation = ColorTween(
      begin: widget.bgColor,
      end: endColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: _colorAnimation.value,
              borderRadius: ZenRadii.mdRadius,
            ),
            child: Center(
              child: widget.isAction && widget.text == 'DEL'
                  ? Icon(Icons.backspace_rounded, color: widget.textColor)
                  : Text(
                      widget.text,
                      style: widget.isAction
                          ? Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: widget.textColor,
                                fontWeight: FontWeight.bold,
                              )
                          : Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: widget.textColor,
                              ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
