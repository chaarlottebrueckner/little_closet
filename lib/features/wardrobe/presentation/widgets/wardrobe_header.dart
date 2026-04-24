import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/active_filters.dart';

class WardrobeHeader extends StatelessWidget {
  final ActiveFilters filters;
  final VoidCallback onFilterTap;

  const WardrobeHeader({
    super.key,
    required this.filters,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFD4789C), Color(0xFFE8A0BF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: Text(
                    'LITTLE CLOSET',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                        ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LCColors.gradientPink,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Meine Garderobe',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: LCColors.textMuted,
                            letterSpacing: 1.5,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onFilterTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: filters.hasAny
                        ? LCColors.primary.withValues(alpha: 0.12)
                        : const Color(0xFFEDE0E8).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: filters.hasAny
                          ? LCColors.primary.withValues(alpha: 0.4)
                          : const Color(0xFFEDE0E8),
                    ),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: filters.hasAny ? LCColors.primary : LCColors.textMuted,
                    size: 22,
                  ),
                ),
                if (filters.hasAny)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        gradient: LCColors.gradientPink,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${filters.count}',
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
          ),
        ],
      ),
    );
  }
}
