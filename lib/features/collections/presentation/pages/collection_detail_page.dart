import 'dart:io';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_sheet.dart';
import '../../../../core/widgets/lc_section_label.dart';
import '../../../../data/repositories/collection_repository.dart';
import '../../../outfits/domain/outfit_with_items.dart';
import '../../../outfits/presentation/widgets/outfit_canvas_preview.dart';
import '../../domain/collection_with_content.dart';
import '../widgets/collection_cover_mosaic.dart';
import '../widgets/collection_item_picker_sheet.dart';
import '../widgets/create_collection_sheet.dart';

const double _kMinSheet = 0.44;

class CollectionDetailPage extends ConsumerWidget {
  final CollectionWithContent collection;

  const CollectionDetailPage({super.key, required this.collection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(collectionByIdProvider(collection.collection.id), (_, next) {
      if (next.hasValue && next.value == null && context.mounted) {
        Navigator.pop(context);
      }
    });

    final current =
        ref.watch(collectionByIdProvider(collection.collection.id)).valueOrNull ??
            collection;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Linear gradient background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFF0F7), Color(0xFFFAFAFA)],
                  stops: [0.0, 0.45],
                ),
              ),
            ),
          ),
          // Radial pink glow bottom
          Positioned(
            bottom: -280,
            left: -60,
            right: -60,
            child: Container(
              height: 600,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xEEF4A7C3),
                    Color.fromARGB(160, 246, 109, 159),
                    Color.fromARGB(0, 255, 255, 255),
                  ],
                  stops: [0.0, 0.4, 1.0],
                  radius: 0.55,
                ),
              ),
            ),
          ),
          // Square cover mosaic
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: CollectionCoverMosaic(
                  collection: current,
                  size: MediaQuery.of(context).size.width - 32,
                ),
              ),
            ),
          ),
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.80),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 15,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
          // Edit / rename button
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => CreateCollectionSheet(
                  existingName: current.collection.name,
                  onSubmit: (newName) => ref
                      .read(collectionRepositoryProvider)
                      .renameCollection(current.collection.id, newName),
                ),
              ),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.80),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: LCColors.primary.withValues(alpha: 0.45),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  size: 16,
                  color: LCColors.primary,
                ),
              ),
            ),
          ),
          // Draggable bottom sheet
          DraggableScrollableSheet(
            initialChildSize: _kMinSheet,
            minChildSize: _kMinSheet,
            maxChildSize: 0.9,
            builder: (ctx, scrollController) => GlassSheet(
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  Container(
                    width: 36,
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: LCColors.gradientPink,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: _buildContent(context, ref, current),
                    ),
                  ),
                  _buildActionBar(context, ref, current),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, CollectionWithContent current) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          current.collection.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '${current.totalCount} Items',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: LCColors.textMuted,
              ),
        ),
        const SizedBox(height: 24),
        if (current.outfits.isNotEmpty) ...[
          const LCSectionLabel('OUTFITS'),
          const SizedBox(height: 8),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemCount: current.outfits.length,
              itemBuilder: (_, i) {
                final outfit = current.outfits[i];
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: kCanvasWidth / kCanvasHeight,
                        child: OutfitCanvasPreview(items: outfit.items),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: _RemoveButton(
                        onTap: () => ref
                            .read(collectionRepositoryProvider)
                            .removeOutfitFromCollection(
                                current.collection.id, outfit.outfit.id),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
        if (current.clothingItems.isNotEmpty) ...[
          const LCSectionLabel('KLEIDUNGSSTÜCKE'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: current.clothingItems
                .map(
                  (item) => Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 72,
                          height: 72,
                          child: Image.file(
                            File(item.imagePath),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFF5EEF2),
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: LCColors.primary,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: _RemoveButton(
                          onTap: () => ref
                              .read(collectionRepositoryProvider)
                              .removeClothingItemFromCollection(
                                  current.collection.id, item.id),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
        ],
        const SizedBox(height: 56),
      ],
    );
  }

  Widget _buildActionBar(
      BuildContext context, WidgetRef ref, CollectionWithContent current) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => CollectionItemPickerSheet(
                    collectionId: current.collection.id,
                    initialOutfitIds:
                        Set.from(current.outfits.map((o) => o.outfit.id)),
                    initialClothingItemIds:
                        Set.from(current.clothingItems.map((c) => c.id)),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: LCColors.primary.withValues(alpha: 0.6),
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Hinzufügen',
                  style: TextStyle(
                    color: LCColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LCColors.gradientPink,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: LCColors.primary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () => _confirmDelete(context, ref, current),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Löschen',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, CollectionWithContent current) {
    final name = current.collection.name;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                color: LCGlass.sheetColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: LCGlass.borderColor,
                  width: LCGlass.borderWidth,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4789C).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: LCColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Kollektion löschen',
                    style: Theme.of(ctx).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Möchtest du "$name" wirklich löschen? Enthaltene Outfits und Kleidungsstücke bleiben erhalten.',
                    textAlign: TextAlign.center,
                    style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          color: LCColors.textMuted,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(
                              color: LCColors.primary.withValues(alpha: 0.4),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Abbrechen',
                            style: TextStyle(color: LCColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LCColors.gradientPink,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              await ref
                                  .read(collectionRepositoryProvider)
                                  .deleteCollection(current.collection.id);
                              if (context.mounted) Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Löschen',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          shape: BoxShape.circle,
          border: Border.all(
            color: LCColors.primary.withValues(alpha: 0.35),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Icon(
          Icons.close_rounded,
          size: 11,
          color: LCColors.primary,
        ),
      ),
    );
  }
}
