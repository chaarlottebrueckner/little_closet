import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

enum OutfitEmptyReason { noClothing, noOutfits, filteredOut }

class OutfitEmptyState extends StatelessWidget {
  const OutfitEmptyState({super.key, required this.reason});

  final OutfitEmptyReason reason;

  @override
  Widget build(BuildContext context) {
    final (title, subtitle, icon) = switch (reason) {
      OutfitEmptyReason.noClothing => (
          'Noch keine Kleidungsstücke.',
          'Füge zuerst Kleidung zum Schrank hinzu.',
          Icons.checkroom_outlined,
        ),
      OutfitEmptyReason.noOutfits => (
          'Noch keine Outfits.',
          'Erstelle deinen ersten Look.',
          Icons.style_outlined,
        ),
      OutfitEmptyReason.filteredOut => (
          'Keine Outfits gefunden.',
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
