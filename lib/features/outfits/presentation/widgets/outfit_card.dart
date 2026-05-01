import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/outfit_with_items.dart';

class OutfitCard extends StatelessWidget {
  final OutfitWithItems outfitWithItems;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelectionMode;
  final bool isSelected;

  const OutfitCard({
    super.key,
    required this.outfitWithItems,
    this.onTap,
    this.onLongPress,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE8A0BF).withValues(alpha: 0.30)
              : const Color(0xFFE8A0BF).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4789C).withValues(alpha: 0.85)
                : const Color(0xFFE8A0BF).withValues(alpha: 0.3),
            width: isSelected ? 2.0 : 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFD4789C).withValues(alpha: 0.22)
                  : const Color(0xFFD4789C).withValues(alpha: 0.08),
              blurRadius: isSelected ? 18 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: _buildPreview(),
                  ),
                ),
                _buildInfo(context),
              ],
            ),
            if (isSelectionMode)
              Positioned(
                top: 10,
                right: 10,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? LCColors.primary
                        : Colors.white.withValues(alpha: 0.85),
                    border: Border.all(
                      color: isSelected
                          ? LCColors.primary
                          : const Color(0xFFD4789C).withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    final sortedItems = [...outfitWithItems.items]
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    if (sortedItems.isEmpty) {
      return Container(
        color: const Color(0xFFF5EEF2),
        child: const Center(
          child: Icon(
            Icons.style_outlined,
            color: Color(0xFFD4789C),
            size: 36,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleX = constraints.maxWidth / kCanvasWidth;
        final scaleY = constraints.maxHeight / kCanvasHeight;
        // Use the smaller factor so items stay within bounds
        final sf = scaleX < scaleY ? scaleX : scaleY;

        return Container(
          color: Colors.white,
          child: Stack(
            children: sortedItems.map((p) {
              final scaledW = kItemBaseWidth * p.scale;
              final scaledH = kItemBaseHeight * p.scale;
              // Editor uses Transform.scale from center, so visual top-left
              // is at center − scaled_half, not at posX/posY directly.
              final visualLeft = (p.posX + kItemBaseWidth / 2 - scaledW / 2) * sf;
              final visualTop = (p.posY + kItemBaseHeight / 2 - scaledH / 2) * sf;
              return Positioned(
                left: visualLeft,
                top: visualTop,
                width: scaledW * sf,
                height: scaledH * sf,
                child: Transform.rotate(
                  angle: p.rotation,
                  child: Image.file(
                    File(p.item.imagePath),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildInfo(BuildContext context) {
    const seasonIcons = {
      'Frühling': Icons.local_florist,
      'Sommer': Icons.wb_sunny,
      'Herbst': Icons.eco,
      'Winter': Icons.ac_unit,
    };
    const seasonOrder = ['Frühling', 'Sommer', 'Herbst', 'Winter'];

    final seasons = outfitWithItems.outfit.seasons;
    final activeSeasons = seasonOrder.where(seasons.contains).toList();
    final tags = outfitWithItems.outfit.styleTags;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (activeSeasons.isNotEmpty)
            Row(
              children: activeSeasons
                  .map((s) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          seasonIcons[s],
                          size: 15,
                          color: LCColors.primary,
                        ),
                      ))
                  .toList(),
            ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              tags.take(2).join(' · '),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: LCColors.textMuted,
                    fontSize: 11,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
