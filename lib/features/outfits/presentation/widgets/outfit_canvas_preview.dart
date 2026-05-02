import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../domain/outfit_with_items.dart';

class OutfitCanvasPreview extends StatelessWidget {
  final List<PositionedItem> items;

  const OutfitCanvasPreview({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final sorted = [...items]..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    if (sorted.isEmpty) {
      return const ColoredBox(
        color: Color(0xFFF5EEF2),
        child: Center(
          child: Icon(Icons.style_outlined, color: Color(0xFFD4789C), size: 48),
        ),
      );
    }

    return FittedBox(
      fit: BoxFit.contain,
      alignment: Alignment.center,
      child: SizedBox(
        width: kCanvasWidth,
        height: kCanvasHeight,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            const Positioned.fill(child: ColoredBox(color: Colors.white)),
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
    );
  }
}
