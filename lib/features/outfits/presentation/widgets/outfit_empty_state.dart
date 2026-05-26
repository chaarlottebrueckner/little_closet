import 'package:flutter/material.dart';

import '../../../../../shared/widgets/app_empty_state.dart';

enum OutfitEmptyReason { noClothing, noOutfits, filteredOut }

class OutfitEmptyState extends StatelessWidget {
  const OutfitEmptyState({super.key, required this.reason});

  final OutfitEmptyReason reason;

  @override
  Widget build(BuildContext context) {
    return switch (reason) {
      OutfitEmptyReason.noClothing => const AppEmptyState(
          icon: Icons.checkroom_outlined,
          title: 'Noch keine Kleidungsstücke.',
          subtitle: 'Füge dein erstes Kleidungsstück hinzu.',
        ),
      OutfitEmptyReason.noOutfits => const AppEmptyState(
          icon: Icons.style_outlined,
          title: 'Noch keine Outfits.',
          subtitle: 'Erstelle deinen ersten Look.',
        ),
      OutfitEmptyReason.filteredOut => const AppEmptyState(
          icon: Icons.filter_list_off,
          title: 'Keine Outfits gefunden.',
          subtitle: 'Passe die Filter an oder setze sie zurück.',
        ),
    };
  }
}
