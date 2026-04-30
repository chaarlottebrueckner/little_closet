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
  bool isSelected;

  EditableItem({
    required this.item,
    this.posX = 150.0,
    this.posY = 190.0,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.zIndex = 0,
    this.isSelected = false,
  }) : id = const Uuid().v4();
}
