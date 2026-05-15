import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/lc_filter_badge_button.dart';
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
                Image.asset(
                  'assets/images/logo.png',
                  height: 52,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.centerLeft,
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
          LCFilterBadgeButton(
            filterCount: filters.count,
            onTap: onFilterTap,
          ),
        ],
      ),
    );
  }
}
