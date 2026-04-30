import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../outfits/domain/editable_item.dart';
import '../../../outfits/domain/outfit_with_items.dart';
import 'outfit_item_handle.dart';

class OutfitEditorCanvas extends StatelessWidget {
  final List<EditableItem> items;
  final String? selectedItemId;
  final void Function(String id) onItemSelect;
  final void Function(String id) onItemRemove;
  final void Function(String id, double dx, double dy) onItemPan;
  final void Function(String id, double newScale, double newRotation) onItemPinch;

  const OutfitEditorCanvas({
    super.key,
    required this.items,
    required this.selectedItemId,
    required this.onItemSelect,
    required this.onItemRemove,
    required this.onItemPan,
    required this.onItemPinch,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...items]..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: kCanvasWidth,
        height: kCanvasHeight,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            const Positioned.fill(child: _CanvasBackground()),
            for (final item in sorted)
              OutfitItemHandle(
                key: ValueKey(item.id),
                editableItem: item,
                isSelected: item.id == selectedItemId,
                onSelect: () => onItemSelect(item.id),
                onRemove: () => onItemRemove(item.id),
                onPan: (dx, dy) => onItemPan(item.id, dx, dy),
                onPinch: (s, r) => onItemPinch(item.id, s, r),
              ),
          ],
        ),
      ),
    );
  }
}

class _CanvasBackground extends StatelessWidget {
  const _CanvasBackground();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: LCColors.background);
  }
}
