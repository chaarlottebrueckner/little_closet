import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';

class LCSectionLabel extends StatelessWidget {
  final String text;
  final bool isRequired;
  final bool isAiLoading;
  final bool isAiField;

  const LCSectionLabel(
    this.text, {
    super.key,
    this.isRequired = false,
    this.isAiLoading = false,
    this.isAiField = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 2,
          decoration: BoxDecoration(
            gradient: LCColors.gradientPink,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: LCColors.textMuted,
                letterSpacing: 1.8,
                fontWeight: FontWeight.w600,
              ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 3),
          const Text(
            '*',
            style: TextStyle(
              color: LCColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ],
        if (isAiLoading) ...[
          const SizedBox(width: 8),
          SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: LCColors.primary.withValues(alpha: 0.5),
            ),
          ),
        ] else if (isAiField) ...[
          const SizedBox(width: 6),
          const Text('✨', style: TextStyle(fontSize: 11))
              .animate(onPlay: (c) => c.repeat())
              .shimmer(duration: 2400.ms, color: LCColors.accent),
        ],
      ],
    );
  }
}
