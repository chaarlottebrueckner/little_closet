import '../../../data/database/app_database.dart';
import '../../../features/outfits/domain/outfit_with_items.dart';

class CollectionWithOutfits {
  const CollectionWithOutfits({
    required this.collection,
    required this.outfits,
  });

  final Collection collection;
  final List<OutfitWithItems> outfits;

  int get totalCount => outfits.length;
}
