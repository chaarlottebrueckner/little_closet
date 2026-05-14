import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_sheet.dart';
import '../../../../core/widgets/lc_gradient_button.dart';
import '../../../../core/widgets/lc_sheet_handle.dart';
import '../../../../data/repositories/clothing_repository.dart';
import '../../../../data/repositories/collection_repository.dart';
import '../../../../data/repositories/outfit_repository.dart';
import '../../../outfits/presentation/widgets/outfit_canvas_preview.dart';

class CollectionItemPickerSheet extends ConsumerStatefulWidget {
  const CollectionItemPickerSheet({
    super.key,
    required this.collectionId,
    required this.initialOutfitIds,
    required this.initialClothingItemIds,
  });

  final String collectionId;
  final Set<String> initialOutfitIds;
  final Set<String> initialClothingItemIds;

  @override
  ConsumerState<CollectionItemPickerSheet> createState() =>
      _CollectionItemPickerSheetState();
}

class _CollectionItemPickerSheetState
    extends ConsumerState<CollectionItemPickerSheet> {
  late Set<String> _outfitIds;
  late Set<String> _clothingIds;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _outfitIds = Set.from(widget.initialOutfitIds);
    _clothingIds = Set.from(widget.initialClothingItemIds);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final repo = ref.read(collectionRepositoryProvider);

    final addedOutfits = _outfitIds.difference(widget.initialOutfitIds);
    final removedOutfits = widget.initialOutfitIds.difference(_outfitIds);
    final addedClothing = _clothingIds.difference(widget.initialClothingItemIds);
    final removedClothing =
        widget.initialClothingItemIds.difference(_clothingIds);

    for (final id in addedOutfits) {
      await repo.addOutfitToCollection(widget.collectionId, id);
    }
    for (final id in removedOutfits) {
      await repo.removeOutfitFromCollection(widget.collectionId, id);
    }
    for (final id in addedClothing) {
      await repo.addClothingItemToCollection(widget.collectionId, id);
    }
    for (final id in removedClothing) {
      await repo.removeClothingItemFromCollection(widget.collectionId, id);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final outfitsAsync = ref.watch(outfitsProvider);
    final clothingAsync = ref.watch(clothingItemsProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) => GlassSheet(
        child: Column(
          children: [
            const SizedBox(height: 14),
            const Center(child: LCSheetHandle()),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    LCColors.gradientPink.createShader(bounds),
                child: Text(
                  'ITEMS HINZUFÜGEN',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _shimmerDivider(),
            Expanded(
              child: _buildList(context, scrollController, outfitsAsync, clothingAsync),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: LCGradientButton(
                label: 'Speichern',
                onPressed: _saving ? null : _save,
                isLoading: _saving,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    ScrollController scrollController,
    AsyncValue outfitsAsync,
    AsyncValue clothingAsync,
  ) {
    if (outfitsAsync.isLoading || clothingAsync.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: LCColors.primary),
      );
    }

    final outfits = outfitsAsync.valueOrNull ?? [];
    final clothing = clothingAsync.valueOrNull ?? [];

    if (outfits.isEmpty && clothing.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.style_outlined,
                size: 48, color: LCColors.primary.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text(
              'Keine Outfits oder Kleidung vorhanden.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: LCColors.textMuted,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView(
      controller: scrollController,
      children: [
        if (outfits.isNotEmpty) ...[
          _sectionHeader('OUTFITS'),
          ...outfits.map((o) => CheckboxListTile(
                secondary: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: OutfitCanvasPreview(items: o.items),
                  ),
                ),
                title: Text(
                  o.outfit.name.isNotEmpty ? o.outfit.name : 'Outfit',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 14),
                ),
                subtitle: Text(
                  '${o.items.length} Teile',
                  style: const TextStyle(
                      color: LCColors.textMuted, fontSize: 12),
                ),
                value: _outfitIds.contains(o.outfit.id),
                activeColor: LCColors.primary,
                checkColor: Colors.white,
                controlAffinity: ListTileControlAffinity.trailing,
                onChanged: _saving
                    ? null
                    : (v) => setState(() {
                          if (v == true) {
                            _outfitIds.add(o.outfit.id);
                          } else {
                            _outfitIds.remove(o.outfit.id);
                          }
                        }),
              )),
        ],
        if (clothing.isNotEmpty) ...[
          _sectionHeader('KLEIDUNGSSTÜCKE'),
          ...clothing.map((item) => CheckboxListTile(
                secondary: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.file(
                      File(item.imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFF5EEF2),
                        child: const Icon(Icons.checkroom_outlined,
                            color: LCColors.primary, size: 20),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  item.category,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 14),
                ),
                subtitle: item.subcategory != null
                    ? Text(
                        item.subcategory!,
                        style: const TextStyle(
                            color: LCColors.textMuted, fontSize: 12),
                      )
                    : null,
                value: _clothingIds.contains(item.id),
                activeColor: LCColors.primary,
                checkColor: Colors.white,
                controlAffinity: ListTileControlAffinity.trailing,
                onChanged: _saving
                    ? null
                    : (v) => setState(() {
                          if (v == true) {
                            _clothingIds.add(item.id);
                          } else {
                            _clothingIds.remove(item.id);
                          }
                        }),
              )),
        ],
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _sectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 2,
            decoration: const BoxDecoration(gradient: LCColors.gradientPink),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: LCColors.textMuted,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerDivider() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          height: 1,
          decoration: const BoxDecoration(gradient: LCGlass.shimmerDivider),
        ),
      );
}
