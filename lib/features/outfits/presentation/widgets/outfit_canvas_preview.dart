import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/outfit_with_items.dart';

class OutfitCanvasPreview extends StatelessWidget {
  final List<PositionedItem> items;
  final Color? backgroundColor;
  final GlobalKey? repaintKey;
  final BoxFit fit;

  const OutfitCanvasPreview({
    super.key,
    required this.items,
    this.backgroundColor = Colors.white,
    this.repaintKey,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...items]..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    if (sorted.isEmpty) {
      return const ColoredBox(
        color: LCColors.surfaceWarm,
        child: Center(
          child: Icon(Icons.style_outlined, color: LCColors.primary, size: 48),
        ),
      );
    }

    final fittedContent = FittedBox(
      fit: fit,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: RepaintBoundary(
          key: repaintKey,
          child: SizedBox(
            width: kCanvasWidth,
            height: kCanvasHeight,
            child: Stack(
              clipBehavior: Clip.hardEdge,
            children: [
              if (backgroundColor != null)
                Positioned.fill(child: ColoredBox(color: backgroundColor!)),
              ...sorted.map((p) {
                final cx = p.posX + kItemBaseWidth / 2;
                final cy = p.posY + kItemBaseHeight / 2;
                final sw = kItemBaseWidth * p.scale;
                final sh = kItemBaseHeight * p.scale;
                final cosR = cos(p.rotation).abs();
                final sinR = sin(p.rotation).abs();
                final bboxW = sw * cosR + sh * sinR;
                final bboxH = sw * sinR + sh * cosR;
                return Positioned(
                  left: cx - bboxW / 2,
                  top: cy - bboxH / 2,
                  child: SizedBox(
                    width: bboxW,
                    height: bboxH,
                    child: Center(
                      child: Transform.rotate(
                        angle: p.rotation,
                        child: Transform.scale(
                          scale: p.scale,
                          child: SizedBox(
                            width: kItemBaseWidth,
                            height: kItemBaseHeight,
                            child: Image.file(
                              File(p.item.imagePath),
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const SizedBox(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          ),
        ),
      ),
    );

    return fit == BoxFit.cover ? ClipRect(child: fittedContent) : fittedContent;
  }
}
