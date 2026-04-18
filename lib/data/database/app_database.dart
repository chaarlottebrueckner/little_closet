import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'converters.dart';
import 'tables/clothing_items.dart';
import 'tables/outfits.dart';
import 'tables/outfit_clothing_items.dart';
import 'tables/collections.dart';
import 'tables/collection_outfits.dart';
import 'tables/collection_clothing_items.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  ClothingItems,
  Outfits,
  OutfitClothingItems,
  Collections,
  CollectionOutfits,
  CollectionClothingItems,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return SqfliteQueryExecutor.inDatabaseFolder(
    path: 'little_closet.db',
    logStatements: false,
  );
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
