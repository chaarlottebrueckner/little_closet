import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../../features/collections/domain/collection_with_outfits.dart';
import '../../features/outfits/domain/outfit_with_items.dart';

class CollectionRepository {
  CollectionRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  // ── Streams ────────────────────────────────────────────────────────────────

  Stream<List<CollectionWithOutfits>> watchAllCollections() {
    return _db.customSelect(
      'SELECT 1',
      readsFrom: {
        _db.collections,
        _db.collectionOutfits,
        _db.outfits,
        _db.outfitClothingItems,
        _db.clothingItems,
      },
    ).watch().asyncMap((_) => _fetchAllCollections());
  }

  Stream<CollectionWithOutfits?> watchCollectionById(String id) {
    return _db.customSelect(
      'SELECT 1',
      readsFrom: {
        _db.collections,
        _db.collectionOutfits,
        _db.outfits,
        _db.outfitClothingItems,
        _db.clothingItems,
      },
    ).watch().asyncMap((_) async {
      final rows = await (_db.select(_db.collections)
            ..where((t) => t.id.equals(id)))
          .get();
      if (rows.isEmpty) return null;
      return _fetchCollectionContent(rows.first);
    });
  }

  // ── Private fetch helpers ──────────────────────────────────────────────────

  Future<List<CollectionWithOutfits>> _fetchAllCollections() async {
    final collections = await (_db.select(_db.collections)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return Future.wait(collections.map(_fetchCollectionContent));
  }

  Future<CollectionWithOutfits> _fetchCollectionContent(
      Collection collection) async {
    final outfitJunctions = await (_db.select(_db.collectionOutfits)
          ..where((t) => t.collectionId.equals(collection.id)))
        .get();
    final outfits =
        (await Future.wait(outfitJunctions.map((r) => _fetchOutfitWithItems(r.outfitId))))
            .whereType<OutfitWithItems>()
            .toList();

    return CollectionWithOutfits(
      collection: collection,
      outfits: outfits,
    );
  }

  Future<OutfitWithItems?> _fetchOutfitWithItems(String outfitId) async {
    final query = _db.select(_db.outfits).join([
      leftOuterJoin(_db.outfitClothingItems,
          _db.outfitClothingItems.outfitId.equalsExp(_db.outfits.id)),
      leftOuterJoin(_db.clothingItems,
          _db.clothingItems.id
              .equalsExp(_db.outfitClothingItems.clothingItemId)),
    ])
      ..where(_db.outfits.id.equals(outfitId))
      ..orderBy([OrderingTerm.asc(_db.outfitClothingItems.zIndex)]);

    final rows = await query.get();
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
  }

  // ── Write operations ───────────────────────────────────────────────────────

  Future<String> createCollection(String name) async {
    final id = _uuid.v4();
    await _db
        .into(_db.collections)
        .insert(CollectionsCompanion.insert(id: id, name: name));
    return id;
  }

  Future<void> renameCollection(String id, String name) async {
    await (_db.update(_db.collections)..where((t) => t.id.equals(id)))
        .write(CollectionsCompanion(name: Value(name)));
  }

  Future<bool> deleteCollectionIfEmpty(String id) async {
    final outfitRows = await (_db.select(_db.collectionOutfits)
          ..where((t) => t.collectionId.equals(id)))
        .get();
    if (outfitRows.isEmpty) {
      await deleteCollection(id);
      return true;
    }
    return false;
  }

  Future<void> deleteCollection(String id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.collectionOutfits)
            ..where((t) => t.collectionId.equals(id)))
          .go();
      await (_db.delete(_db.collections)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<void> deleteMultipleCollections(List<String> ids) async {
    await _db.transaction(() async {
      for (final id in ids) {
        await deleteCollection(id);
      }
    });
  }

  Future<void> addOutfitToCollection(
      String collectionId, String outfitId) async {
    await _db.into(_db.collectionOutfits).insert(
          CollectionOutfitsCompanion.insert(
            collectionId: collectionId,
            outfitId: outfitId,
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<void> removeOutfitFromCollection(
      String collectionId, String outfitId) async {
    await (_db.delete(_db.collectionOutfits)
          ..where((t) =>
              t.collectionId.equals(collectionId) &
              t.outfitId.equals(outfitId)))
        .go();
  }

  Future<void> addOutfitsToCollection(
      String collectionId, List<String> outfitIds) async {
    await _db.transaction(() async {
      for (final outfitId in outfitIds) {
        await addOutfitToCollection(collectionId, outfitId);
      }
    });
  }

  Future<void> removeOutfitsFromCollection(
      String collectionId, List<String> outfitIds) async {
    await _db.transaction(() async {
      for (final outfitId in outfitIds) {
        await removeOutfitFromCollection(collectionId, outfitId);
      }
    });
  }

  // ── Lookup helpers ─────────────────────────────────────────────────────────

  Future<List<String>> collectionIdsContainingOutfit(String outfitId) async {
    final rows = await (_db.select(_db.collectionOutfits)
          ..where((t) => t.outfitId.equals(outfitId)))
        .get();
    return rows.map((r) => r.collectionId).toList();
  }
}

// ── Providers ──────────────────────────────────────────────────────────────

final collectionRepositoryProvider = Provider<CollectionRepository>((ref) {
  return CollectionRepository(ref.watch(appDatabaseProvider));
});

final collectionsProvider =
    StreamProvider<List<CollectionWithOutfits>>((ref) {
  return ref.watch(collectionRepositoryProvider).watchAllCollections();
});

final collectionByIdProvider =
    StreamProvider.family<CollectionWithOutfits?, String>((ref, id) {
  return ref.watch(collectionRepositoryProvider).watchCollectionById(id);
});
