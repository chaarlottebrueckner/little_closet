import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

enum WardrobeEmptyReason { noClothing, filteredOut }

class WardrobeEmptyState extends StatelessWidget {
  const WardrobeEmptyState({super.key, required this.reason});

  final WardrobeEmptyReason reason;

  @override
  Widget build(BuildContext context) {
    final (title, subtitle, icon) = switch (reason) {
      WardrobeEmptyReason.noClothing => (
          'Dein Kleiderschrank ist leer.',
          'Füge dein erstes Kleidungsstück hinzu.',
          Icons.checkroom_outlined,
        ),
      WardrobeEmptyReason.filteredOut => (
          'Keine Kleidungsstücke gefunden.',
          'Passe die Filter an oder setze sie zurück.',
          Icons.filter_list_off,
        ),
    };

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              gradient: LCColors.gradientPink,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: LCColors.textDark,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: LCColors.textMuted,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
