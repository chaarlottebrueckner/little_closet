import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LCActiveFilterChips extends StatelessWidget {
  const LCActiveFilterChips({super.key, required this.entries});

  /// Each entry: key = chip label, value = onDelete callback.
  final List<MapEntry<String, VoidCallback>> entries;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: entries.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InputChip(
            label: Text(entries[i].key),
            onDeleted: entries[i].value,
            deleteIconColor: LCColors.primary,
          ),
        ),
      ),
    );
  }
}
