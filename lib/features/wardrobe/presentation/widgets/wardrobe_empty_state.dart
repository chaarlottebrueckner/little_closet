import 'package:flutter/material.dart';

import '../../../../../shared/widgets/app_empty_state.dart';

enum WardrobeEmptyReason { noClothing, filteredOut }

class WardrobeEmptyState extends StatelessWidget {
  const WardrobeEmptyState({super.key, required this.reason});

  final WardrobeEmptyReason reason;

  @override
  Widget build(BuildContext context) {
    return switch (reason) {
      WardrobeEmptyReason.noClothing => const AppEmptyState(
          icon: Icons.checkroom_outlined,
          title: 'Noch keine Kleidungsstücke.',
          subtitle: 'Füge dein erstes Kleidungsstück hinzu.',
        ),
      WardrobeEmptyReason.filteredOut => const AppEmptyState(
          icon: Icons.filter_list_off,
          title: 'Keine Kleidungsstücke gefunden.',
          subtitle: 'Passe die Filter an oder setze sie zurück.',
        ),
    };
  }
}
