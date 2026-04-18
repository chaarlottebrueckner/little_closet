import 'package:drift/drift.dart';

class OutfitClothingItems extends Table {
  TextColumn get outfitId => text()();
  TextColumn get clothingItemId => text()();
  RealColumn get posX => real().withDefault(const Constant(0.0))();
  RealColumn get posY => real().withDefault(const Constant(0.0))();
  RealColumn get scale => real().withDefault(const Constant(1.0))();
  RealColumn get rotation => real().withDefault(const Constant(0.0))();
  IntColumn get zIndex => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {outfitId, clothingItemId};
}
