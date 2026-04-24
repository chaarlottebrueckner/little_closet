import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LCChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const LCChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chip = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFE8A0BF).withValues(alpha: 0.30)
            : Colors.white.withValues(alpha: 0.65),
        border: Border.all(
          color: isSelected
              ? const Color(0xFFD4789C).withValues(alpha: 0.8)
              : const Color(0xFFE8A0BF).withValues(alpha: 0.4),
          width: isSelected ? 1.2 : 0.8,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: LCColors.primary.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isSelected ? LCColors.primary : LCColors.textMuted,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
      ),
    );

    if (onTap == null) return chip;
    return GestureDetector(onTap: onTap, child: chip);
  }
}
