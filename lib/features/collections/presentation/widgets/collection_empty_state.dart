import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CollectionEmptyState extends StatelessWidget {
  const CollectionEmptyState({super.key});

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
              color: LCColors.deep.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.collections_bookmark_outlined,
              color: LCColors.deep,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Noch keine Kollektionen',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Erstelle deine erste Kollektion',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: LCColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}
