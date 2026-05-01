import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/lc_section_label.dart';
import '../../../../data/repositories/outfit_repository.dart';
import '../../../outfits/domain/outfit_with_items.dart';

class OutfitUsageSection extends ConsumerWidget {
  final String itemId;
  final void Function(OutfitWithItems outfit) onOutfitTap;

  const OutfitUsageSection({
    super.key,
    required this.itemId,
    required this.onOutfitTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outfitsAsync = ref.watch(outfitsContainingItemProvider(itemId));
    return outfitsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (outfits) {
        if (outfits.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LCSectionLabel('IN OUTFITS'),
              const SizedBox(height: 8),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: outfits.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) => _OutfitPreviewTile(
                    outfitId: outfits[i].id,
                    onTap: onOutfitTap,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OutfitPreviewTile extends ConsumerWidget {
  final String outfitId;
  final void Function(OutfitWithItems) onTap;

  const _OutfitPreviewTile({
    required this.outfitId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owi = ref.watch(outfitByIdProvider(outfitId)).valueOrNull;

    return GestureDetector(
      onTap: owi != null ? () => onTap(owi) : null,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFE8A0BF).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE8A0BF).withValues(alpha: 0.3),
            width: 0.8,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: _buildPreview(owi),
        ),
      ),
    );
  }

  Widget _buildPreview(OutfitWithItems? owi) {
    if (owi == null || owi.items.isEmpty) {
      return Container(
        color: const Color(0xFFF5EEF2),
        child: const Center(
          child: Icon(Icons.style_outlined, color: Color(0xFFD4789C), size: 20),
        ),
      );
    }

    final sortedItems = [...owi.items]
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleX = constraints.maxWidth / kCanvasWidth;
        final scaleY = constraints.maxHeight / kCanvasHeight;
        final sf = scaleX < scaleY ? scaleX : scaleY;

        return Container(
          color: Colors.white,
          child: Stack(
            children: sortedItems.map((p) {
              final scaledW = kItemBaseWidth * p.scale;
              final scaledH = kItemBaseHeight * p.scale;
              final visualLeft =
                  (p.posX + kItemBaseWidth / 2 - scaledW / 2) * sf;
              final visualTop =
                  (p.posY + kItemBaseHeight / 2 - scaledH / 2) * sf;
              return Positioned(
                left: visualLeft,
                top: visualTop,
                width: scaledW * sf,
                height: scaledH * sf,
                child: Transform.rotate(
                  angle: p.rotation,
                  child: Image.file(
                    File(p.item.imagePath),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
