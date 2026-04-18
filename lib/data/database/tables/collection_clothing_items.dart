import 'package:drift/drift.dart';

class CollectionClothingItems extends Table {
  TextColumn get collectionId => text()();
  TextColumn get clothingItemId => text()();

  @override
  Set<Column> get primaryKey => {collectionId, clothingItemId};
}
