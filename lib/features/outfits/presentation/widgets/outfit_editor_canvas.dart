import 'dart:math';

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
      alignment: Alignment.topCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
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
                onPan: (dx, dy) => onItemPan(item.id, dx, dy),
                onPinch: (s, r) => onItemPinch(item.id, s, r),
              ),
            if (selectedItemId != null)
              Builder(builder: (context) {
                final item = sorted.where((e) => e.id == selectedItemId).firstOrNull;
                if (item == null) return const SizedBox.shrink();
                final cx = item.posX + kItemBaseWidth / 2;
                final cy = item.posY + kItemBaseHeight / 2;
                final hw = kItemBaseWidth / 2 * item.scale;
                final hh = kItemBaseHeight / 2 * item.scale;
                final ca = cos(item.rotation);
                final sa = sin(item.rotation);
                final btnLeft = cx + hw * ca + hh * sa - 11;
                final btnTop = cy + hw * sa - hh * ca - 11;
                return Positioned(
                  left: btnLeft,
                  top: btnTop,
                  child: GestureDetector(
                    onTap: () => onItemRemove(selectedItemId!),
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: LCColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: LCColors.primary.withValues(alpha: 0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 14),
                    ),
                  ),
                );
              }),
          ],
        ),
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
