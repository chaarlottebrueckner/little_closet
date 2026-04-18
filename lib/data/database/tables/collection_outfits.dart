import 'package:drift/drift.dart';

class CollectionOutfits extends Table {
  TextColumn get collectionId => text()();
  TextColumn get outfitId => text()();

  @override
  Set<Column> get primaryKey => {collectionId, outfitId};
}
