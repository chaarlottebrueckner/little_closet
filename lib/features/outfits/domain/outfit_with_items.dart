import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/database/app_database.dart';

const double kCanvasWidth = 360.0;
const double kCanvasHeight = 640.0;
const double kItemBaseWidth = 100.0;
const double kItemBaseHeight = 120.0;

class PositionedItem {
  final ClothingItem item;
  final double posX;
  final double posY;
  final double scale;
  final double rotation;
  final int zIndex;

  const PositionedItem({
    required this.item,
    required this.posX,
    required this.posY,
    required this.scale,
    required this.rotation,
    required this.zIndex,
  });

  PositionedItem copyWith({
    ClothingItem? item,
    double? posX,
    double? posY,
    double? scale,
    double? rotation,
    int? zIndex,
  }) {
    return PositionedItem(
      item: item ?? this.item,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      zIndex: zIndex ?? this.zIndex,
    );
  }
}

class OutfitWithItems {
  final Outfit outfit;
  final List<PositionedItem> items;

  const OutfitWithItems({
    required this.outfit,
    required this.items,
  });

}

extension OutfitDominantColor on OutfitWithItems {
  Color get dominantColor {
    const fallback = Color(0xFFE8A0BF);
    for (final tier in AppConstants.categoryTiers) {
      Color? best;
      double bestSaturation = -1;
      for (final positioned in items) {
        if (!tier.contains(positioned.item.category)) continue;
        for (final colorName in positioned.item.colors) {
          final color = AppConstants.colorMap[colorName];
          if (color == null) continue;
          final saturation = HSLColor.fromColor(color).saturation;
          if (saturation > bestSaturation) {
            bestSaturation = saturation;
            best = color;
          }
        }
      }
      if (best != null) return best;
    }
    return fallback;
  }
}
