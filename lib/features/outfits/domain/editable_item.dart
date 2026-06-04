import 'package:uuid/uuid.dart';

import '../../../data/database/app_database.dart';

class EditableItem {
  final String id;
  final ClothingItem item;
  double posX;
  double posY;
  double scale;
  double rotation;
  int zIndex;

  EditableItem({
    required this.item,
    this.posX = 150.0,
    this.posY = 190.0,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.zIndex = 0,
  }) : id = const Uuid().v4();

  EditableItem._copy({
    required this.id,
    required this.item,
    required this.posX,
    required this.posY,
    required this.scale,
    required this.rotation,
    required this.zIndex,
  });

  EditableItem copy() => EditableItem._copy(
        id: id,
        item: item,
        posX: posX,
        posY: posY,
        scale: scale,
        rotation: rotation,
        zIndex: zIndex,
      );
}
