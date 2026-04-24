import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class WardrobeEmptyState extends StatelessWidget {
  const WardrobeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LCColors.gradientPink,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.checkroom_outlined,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Dein Kleiderschrank ist leer.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: LCColors.textDark,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Füge dein erstes Kleidungsstück hinzu.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: LCColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}
