import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/collection_with_content.dart';
import '../../../outfits/domain/outfit_with_items.dart';
import '../../../outfits/presentation/widgets/outfit_canvas_preview.dart';

class CollectionCoverMosaic extends StatelessWidget {
  const CollectionCoverMosaic({
    super.key,
    required this.collection,
    this.size = 160,
  });

  final CollectionWithContent collection;
  final double size;

  @override
  Widget build(BuildContext context) {
    final slots = <Widget>[
      ...collection.outfits.map((o) => _outfitSlot(o)),
      ...collection.clothingItems.map((c) => _clothingSlot(c.imagePath)),
    ];

    Widget mosaic;
    if (slots.isEmpty) {
      mosaic = _emptySlot();
    } else if (slots.length == 1) {
      mosaic = slots[0];
    } else if (slots.length == 2) {
      mosaic = Row(children: [
        Expanded(child: slots[0]),
        _vDivider(),
        Expanded(child: slots[1]),
      ]);
    } else if (slots.length == 3) {
      mosaic = Row(children: [
        Expanded(child: slots[0]),
        _vDivider(),
        Expanded(
          child: Column(children: [
            Expanded(child: slots[1]),
            _hDivider(),
            Expanded(child: slots[2]),
          ]),
        ),
      ]);
    } else {
      mosaic = Column(children: [
        Expanded(
          child: Row(children: [
            Expanded(child: slots[0]),
            _vDivider(),
            Expanded(child: slots[1]),
          ]),
        ),
        _hDivider(),
        Expanded(
          child: Row(children: [
            Expanded(child: slots[2]),
            _vDivider(),
            Expanded(child: slots[3]),
          ]),
        ),
      ]);
    }

    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: mosaic,
      ),
    );
  }

  Widget _outfitSlot(OutfitWithItems outfit) {
    return ColoredBox(
      color: LCColors.surfaceWarm,
      child: OutfitCanvasPreview(items: outfit.items),
    );
  }

  Widget _clothingSlot(String imagePath) {
    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _errorSlot(),
    );
  }

  Widget _emptySlot() {
    return Container(
      decoration: const BoxDecoration(gradient: LCColors.gradientPink),
      child: const Center(
        child: Icon(
          Icons.collections_bookmark_outlined,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _errorSlot() {
    return const ColoredBox(
      color: LCColors.surfaceWarm,
      child: Center(
        child: Icon(Icons.broken_image_outlined, color: LCColors.primary, size: 24),
      ),
    );
  }

  Widget _vDivider() =>
      Container(width: 1, color: Colors.white.withValues(alpha: 0.4));

  Widget _hDivider() =>
      Container(height: 1, color: Colors.white.withValues(alpha: 0.4));
}
