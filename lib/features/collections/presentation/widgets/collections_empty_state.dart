import 'package:flutter/material.dart';

import '../../../../../shared/widgets/app_empty_state.dart';

enum CollectionsEmptyReason { noClothing, noOutfits, noCollections }

class CollectionsEmptyState extends StatelessWidget {
  const CollectionsEmptyState({super.key, required this.reason});

  final CollectionsEmptyReason reason;

  @override
  Widget build(BuildContext context) {
    return switch (reason) {
      CollectionsEmptyReason.noClothing => const AppEmptyState(
          icon: Icons.checkroom_outlined,
          title: 'Noch keine Kleidungsstücke.',
          subtitle: 'Füge dein erstes Kleidungsstück hinzu.',
        ),
      CollectionsEmptyReason.noOutfits => const AppEmptyState(
          icon: Icons.style_outlined,
          title: 'Noch keine Outfits.',
          subtitle: 'Erstelle zuerst ein Outfit.',
        ),
      CollectionsEmptyReason.noCollections => const AppEmptyState(
          icon: Icons.collections_outlined,
          title: 'Noch keine Kollektionen.',
          subtitle: 'Erstelle deine erste Kollektion.',
        ),
    };
  }
}
