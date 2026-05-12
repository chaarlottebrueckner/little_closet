import '../../../data/database/app_database.dart';
import '../../../features/outfits/domain/outfit_with_items.dart';

class CollectionWithContent {
  const CollectionWithContent({
    required this.collection,
    required this.outfits,
    required this.clothingItems,
  });

  final Collection collection;
  final List<OutfitWithItems> outfits;
  final List<ClothingItem> clothingItems;

  int get totalCount => outfits.length + clothingItems.length;
}
