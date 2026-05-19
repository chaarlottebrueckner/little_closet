import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/collection_with_outfits.dart';
import 'collection_cover_mosaic.dart';

class CollectionCard extends StatelessWidget {
  const CollectionCard({
    super.key,
    required this.collection,
    this.onTap,
    this.onLongPress,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  final CollectionWithOutfits collection;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelectionMode;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: isSelected
              ? LCColors.surfaceWarm.withValues(alpha: 0.85)
              : LCColors.surfaceWarm.withValues(alpha: 0.60),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFD4789C).withValues(alpha: 0.22)
                  : const Color(0xFFD4789C).withValues(alpha: 0.08),
              blurRadius: isSelected ? 18 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4789C).withValues(alpha: 0.85)
                : const Color(0xFFE8A0BF).withValues(alpha: 0.31),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (_, constraints) => CollectionCoverMosaic(
                      collection: collection,
                      size: constraints.maxWidth,
                    ),
                  ),
                ),
                _buildInfo(context),
              ],
            ),
            if (isSelectionMode)
              Positioned(
                top: 10,
                right: 10,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? LCColors.primary
                        : Colors.white.withValues(alpha: 0.85),
                    border: Border.all(
                      color: isSelected
                          ? LCColors.primary
                          : const Color(0xFFD4789C).withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded,
                          size: 15, color: Colors.white)
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              collection.collection.name,
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: LCColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: LCColors.primary.withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              '${collection.totalCount}',
              style: const TextStyle(
                color: LCColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
