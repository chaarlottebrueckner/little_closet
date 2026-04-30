import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../../features/outfits/domain/outfit_with_items.dart';

class OutfitRepository {
  OutfitRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  // ── Queries ────────────────────────────────────────────────────────────────

  Future<List<PositionedItem>> _getItemsForOutfit(String outfitId) async {
    final query = _db.select(_db.outfitClothingItems).join([
      innerJoin(
        _db.clothingItems,
        _db.clothingItems.id.equalsExp(_db.outfitClothingItems.clothingItemId),
      ),
    ])
      ..where(_db.outfitClothingItems.outfitId.equals(outfitId))
      ..orderBy([OrderingTerm.asc(_db.outfitClothingItems.zIndex)]);

    final rows = await query.get();
    return rows.map((row) {
      final junction = row.readTable(_db.outfitClothingItems);
      final item = row.readTable(_db.clothingItems);
      return PositionedItem(
        item: item,
        posX: junction.posX,
        posY: junction.posY,
        scale: junction.scale,
        rotation: junction.rotation,
        zIndex: junction.zIndex,
      );
    }).toList();
  }

  // ── Streams ────────────────────────────────────────────────────────────────

  Stream<List<OutfitWithItems>> watchAllOutfits() {
    return (_db.select(_db.outfits)
          ..orderBy([
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch()
        .asyncMap(
          (outfits) => Future.wait(
            outfits.map((outfit) async {
              final items = await _getItemsForOutfit(outfit.id);
              return OutfitWithItems(outfit: outfit, items: items);
            }),
          ),
        );
  }

  Stream<OutfitWithItems?> watchOutfitById(String id) {
    return (_db.select(_db.outfits)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .asyncMap((outfit) async {
      if (outfit == null) return null;
      final items = await _getItemsForOutfit(outfit.id);
      return OutfitWithItems(outfit: outfit, items: items);
    });
  }

  // Reacts to both junction changes and outfit metadata changes via the join.
  Stream<List<Outfit>> watchOutfitsContainingItem(String clothingItemId) {
    final query = _db.select(_db.outfitClothingItems).join([
      innerJoin(
        _db.outfits,
        _db.outfits.id.equalsExp(_db.outfitClothingItems.outfitId),
      ),
    ])
      ..where(_db.outfitClothingItems.clothingItemId.equals(clothingItemId));

    return query
        .watch()
        .map((rows) => rows.map((r) => r.readTable(_db.outfits)).toList());
  }

  // ── Write operations ───────────────────────────────────────────────────────

  Future<bool> isItemUsedInAnyOutfit(String clothingItemId) async {
    final result = await (_db.select(_db.outfitClothingItems)
          ..where((t) => t.clothingItemId.equals(clothingItemId))
          ..limit(1))
        .getSingleOrNull();
    return result != null;
  }

  Future<String> createOutfit() async {
    final id = _uuid.v4();
    await _db.into(_db.outfits).insert(
          OutfitsCompanion.insert(id: id, name: ''),
        );
    return id;
  }

  Future<void> saveOutfitWithItems({
    required String outfitId,
    required String name,
    required List<PositionedItem> items,
    List<String>? styleTags,
    List<String>? weatherTags,
    List<String>? seasons,
  }) async {
    final resolvedStyleTags =
        styleTags ?? items.expand((i) => i.item.styleTags).toSet().toList();
    final resolvedWeatherTags =
        weatherTags ?? items.expand((i) => i.item.weatherTags).toSet().toList();
    final resolvedSeasons =
        seasons ?? items.expand((i) => i.item.seasons).toSet().toList();

    await _db.transaction(() async {
      await (_db.update(_db.outfits)..where((t) => t.id.equals(outfitId)))
          .write(OutfitsCompanion(
        name: Value(name),
        styleTags: Value(resolvedStyleTags),
        weatherTags: Value(resolvedWeatherTags),
        seasons: Value(resolvedSeasons),
      ));

      await (_db.delete(_db.outfitClothingItems)
            ..where((t) => t.outfitId.equals(outfitId)))
          .go();

      for (final positioned in items) {
        await _db.into(_db.outfitClothingItems).insert(
              OutfitClothingItemsCompanion.insert(
                outfitId: outfitId,
                clothingItemId: positioned.item.id,
                posX: Value(positioned.posX),
                posY: Value(positioned.posY),
                scale: Value(positioned.scale),
                rotation: Value(positioned.rotation),
                zIndex: Value(positioned.zIndex),
              ),
            );
      }
    });
  }

  Future<void> deleteOutfit(String id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.outfitClothingItems)
            ..where((t) => t.outfitId.equals(id)))
          .go();
      await (_db.delete(_db.outfits)..where((t) => t.id.equals(id))).go();
    });
  }

  // Called when deleting a clothing item to clean up orphaned junction rows.
  Future<void> removeClothingItemFromAllOutfits(String clothingItemId) async {
    await (_db.delete(_db.outfitClothingItems)
          ..where((t) => t.clothingItemId.equals(clothingItemId)))
        .go();
  }
}

// ── Providers ──────────────────────────────────────────────────────────────

final outfitRepositoryProvider = Provider<OutfitRepository>((ref) {
  return OutfitRepository(ref.watch(appDatabaseProvider));
});

final outfitsProvider = StreamProvider<List<OutfitWithItems>>((ref) {
  return ref.watch(outfitRepositoryProvider).watchAllOutfits();
});

final outfitByIdProvider =
    StreamProvider.family<OutfitWithItems?, String>((ref, id) {
  return ref.watch(outfitRepositoryProvider).watchOutfitById(id);
});

final outfitsContainingItemProvider =
    StreamProvider.family<List<Outfit>, String>((ref, clothingItemId) {
  return ref
      .watch(outfitRepositoryProvider)
      .watchOutfitsContainingItem(clothingItemId);
});
