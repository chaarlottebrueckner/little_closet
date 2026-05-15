import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LCFilterBadgeButton extends StatelessWidget {
  const LCFilterBadgeButton({
    super.key,
    required this.filterCount,
    required this.onTap,
  });

  final int filterCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: filterCount > 0
                  ? LCColors.primary.withValues(alpha: 0.12)
                  : const Color(0xFFEDE0E8).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: filterCount > 0
                    ? LCColors.primary.withValues(alpha: 0.4)
                    : const Color(0xFFEDE0E8),
              ),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: filterCount > 0 ? LCColors.primary : LCColors.textMuted,
              size: 22,
            ),
          ),
          if (filterCount > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  gradient: LCColors.gradientPink,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$filterCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
