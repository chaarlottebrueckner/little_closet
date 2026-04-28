import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/outfit_with_items.dart';

class OutfitCard extends StatelessWidget {
  final OutfitWithItems outfitWithItems;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const OutfitCard({
    super.key,
    required this.outfitWithItems,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: const Color(0xFFE8A0BF).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE8A0BF).withValues(alpha: 0.3),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4789C).withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: _buildPreview(),
              ),
            ),
            _buildInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    final sortedItems = [...outfitWithItems.items]
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    if (sortedItems.isEmpty) {
      return Container(
        color: const Color(0xFFF5EEF2),
        child: const Center(
          child: Icon(
            Icons.style_outlined,
            color: Color(0xFFD4789C),
            size: 36,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleX = constraints.maxWidth / kCanvasWidth;
        final scaleY = constraints.maxHeight / kCanvasHeight;
        // Use the smaller factor so items stay within bounds
        final sf = scaleX < scaleY ? scaleX : scaleY;

        return Container(
          color: Colors.white,
          child: Stack(
            children: sortedItems.map((p) {
              final w = kItemBaseWidth * p.scale * sf;
              final h = kItemBaseHeight * p.scale * sf;
              return Positioned(
                left: p.posX * sf,
                top: p.posY * sf,
                width: w,
                height: h,
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

  Widget _buildInfo(BuildContext context) {
    final name = outfitWithItems.outfit.name.isEmpty
        ? 'Outfit'
        : outfitWithItems.outfit.name;
    final tags = outfitWithItems.outfit.styleTags;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              tags.take(2).join(' · '),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: LCColors.textMuted,
                    fontSize: 11,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
