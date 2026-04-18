import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

class ClothingRepository {
  ClothingRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  Future<String> saveImage(XFile file) async {
    final dir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${dir.path}/little_closet_images');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    final destPath = '${imagesDir.path}/${_uuid.v4()}.jpg';
    await File(file.path).copy(destPath);
    return destPath;
  }

  Stream<List<ClothingItem>> watchAllItems() {
    return (_db.select(_db.clothingItems)
          ..orderBy([
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  Future<void> saveClothingItem({
    required String imagePath,
    required String category,
    String? subcategory,
    String? color,
    List<String> seasons = const [],
    List<String> styleTags = const [],
    List<String> weatherTags = const [],
  }) async {
    await _db.into(_db.clothingItems).insert(
          ClothingItemsCompanion.insert(
            id: _uuid.v4(),
            imagePath: imagePath,
            category: category,
            subcategory: Value(subcategory),
            color: Value(color),
            seasons: Value(seasons),
            styleTags: Value(styleTags),
            weatherTags: Value(weatherTags),
          ),
        );
  }
}

final clothingRepositoryProvider = Provider<ClothingRepository>((ref) {
  return ClothingRepository(ref.watch(appDatabaseProvider));
});

final clothingItemsProvider = StreamProvider<List<ClothingItem>>((ref) {
  return ref.watch(clothingRepositoryProvider).watchAllItems();
});
