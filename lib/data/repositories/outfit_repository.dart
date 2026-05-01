import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../../features/outfits/domain/outfit_with_items.dart';

class OutfitRepository {
  OutfitRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  // ── Streams ────────────────────────────────────────────────────────────────

  Stream<List<OutfitWithItems>> watchAllOutfits() {
    final query = _db.select(_db.outfits).join([
      leftOuterJoin(_db.outfitClothingItems,
          _db.outfitClothingItems.outfitId.equalsExp(_db.outfits.id)),
      leftOuterJoin(_db.clothingItems,
          _db.clothingItems.id
              .equalsExp(_db.outfitClothingItems.clothingItemId)),
    ])
      ..orderBy([
        OrderingTerm.asc(_db.outfits.sortOrder),
        OrderingTerm.desc(_db.outfits.createdAt),
      ]);

    return query.watch().map((rows) {
      final outfitMap = <String, (Outfit, List<PositionedItem>)>{};
      for (final row in rows) {
        final outfit = row.readTable(_db.outfits);
        outfitMap.putIfAbsent(outfit.id, () => (outfit, []));
        final junction = row.readTableOrNull(_db.outfitClothingItems);
        final clothing = row.readTableOrNull(_db.clothingItems);
        if (junction != null && clothing != null) {
          outfitMap[outfit.id]!.$2.add(PositionedItem(
            item: clothing,
            posX: junction.posX,
            posY: junction.posY,
            scale: junction.scale,
            rotation: junction.rotation,
            zIndex: junction.zIndex,
          ));
        }
      }
      return outfitMap.values.map((e) {
        final items = e.$2..sort((a, b) => a.zIndex.compareTo(b.zIndex));
        return OutfitWithItems(outfit: e.$1, items: items);
      }).toList();
    });
  }

  Stream<OutfitWithItems?> watchOutfitById(String id) {
    final query = _db.select(_db.outfits).join([
      leftOuterJoin(_db.outfitClothingItems,
          _db.outfitClothingItems.outfitId.equalsExp(_db.outfits.id)),
      leftOuterJoin(_db.clothingItems,
          _db.clothingItems.id
              .equalsExp(_db.outfitClothingItems.clothingItemId)),
    ])
      ..where(_db.outfits.id.equals(id))
      ..orderBy([OrderingTerm.asc(_db.outfitClothingItems.zIndex)]);

    return query.watch().map((rows) {
      if (rows.isEmpty) return null;
      final outfit = rows.first.readTable(_db.outfits);
      final items = rows
          .where((r) => r.readTableOrNull(_db.clothingItems) != null)
          .map((r) {
            final junction = r.readTable(_db.outfitClothingItems);
            final clothing = r.readTable(_db.clothingItems);
            return PositionedItem(
              item: clothing,
              posX: junction.posX,
              posY: junction.posY,
              scale: junction.scale,
              rotation: junction.rotation,
              zIndex: junction.zIndex,
            );
          })
          .toList();
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

  Future<void> deleteMultipleOutfits(List<String> ids) async {
    await _db.transaction(() async {
      for (final id in ids) {
        await deleteOutfit(id);
      }
    });
  }

  Future<int> countItemsUsedInOutfits(List<String> ids) async {
    if (ids.isEmpty) return 0;
    final rows = await (_db.selectOnly(_db.outfitClothingItems, distinct: true)
          ..addColumns([_db.outfitClothingItems.clothingItemId])
          ..where(_db.outfitClothingItems.clothingItemId.isIn(ids)))
        .get();
    return rows.length;
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
