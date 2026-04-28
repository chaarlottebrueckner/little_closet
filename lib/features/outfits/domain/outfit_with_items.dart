import '../../../data/database/app_database.dart';

// Logical canvas dimensions — shared between editor and preview cards
const double kCanvasWidth = 400.0;
const double kCanvasHeight = 500.0;
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

  List<String> get derivedStyleTags =>
      items.expand((i) => i.item.styleTags).toSet().toList();

  List<String> get derivedWeatherTags =>
      items.expand((i) => i.item.weatherTags).toSet().toList();

  List<String> get derivedSeasons =>
      items.expand((i) => i.item.seasons).toSet().toList();
}
