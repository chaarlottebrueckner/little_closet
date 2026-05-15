import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_sheet.dart';
import '../../../../core/widgets/lc_gradient_button.dart';
import '../../../../core/widgets/lc_sheet_handle.dart';
import '../../../../data/repositories/collection_repository.dart';
import '../../../../data/repositories/outfit_repository.dart';
import '../../../outfits/domain/outfit_with_items.dart';
import '../../../outfits/presentation/widgets/outfit_canvas_preview.dart';

class OutfitPickerSheet extends ConsumerStatefulWidget {
  const OutfitPickerSheet({
    super.key,
    required this.collectionId,
    required this.initialOutfitIds,
  });

  final String collectionId;
  final Set<String> initialOutfitIds;

  @override
  ConsumerState<OutfitPickerSheet> createState() => _OutfitPickerSheetState();
}

class _OutfitPickerSheetState extends ConsumerState<OutfitPickerSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.initialOutfitIds);
  }

  bool get _hasChanges =>
      !_setsEqual(_selected, widget.initialOutfitIds);

  bool _setsEqual(Set<String> a, Set<String> b) =>
      a.length == b.length && a.containsAll(b);

  Future<void> _save() async {
    final repo = ref.read(collectionRepositoryProvider);
    final toAdd = _selected.difference(widget.initialOutfitIds);
    final toRemove = widget.initialOutfitIds.difference(_selected);
    for (final id in toAdd) {
      await repo.addOutfitToCollection(widget.collectionId, id);
    }
    for (final id in toRemove) {
      await repo.removeOutfitFromCollection(widget.collectionId, id);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final outfitsAsync = ref.watch(outfitsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => GlassSheet(
        child: Column(
          children: [
            const SizedBox(height: 14),
            const Center(child: LCSheetHandle()),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: ShaderMask(
                      shaderCallback: (bounds) =>
                          LCColors.gradientPink.createShader(bounds),
                      child: Text(
                        'OUTFITS HINZUFÜGEN',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  letterSpacing: 2.5,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 1,
                decoration:
                    const BoxDecoration(gradient: LCGlass.shimmerDivider),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: outfitsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: LCColors.primary),
                ),
                error: (e, _) =>
                    Center(child: Text('Fehler: $e')),
                data: (outfits) {
                  if (outfits.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.style_outlined,
                              size: 48, color: LCColors.primary),
                          const SizedBox(height: 12),
                          Text(
                            'Noch keine Outfits vorhanden',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: LCColors.textMuted),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: outfits.length,
                    itemBuilder: (_, i) =>
                        _OutfitPickerTile(
                      outfit: outfits[i],
                      selected: _selected.contains(outfits[i].outfit.id),
                      onChanged: (val) => setState(() {
                        val
                            ? _selected.add(outfits[i].outfit.id)
                            : _selected.remove(outfits[i].outfit.id);
                      }),
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: LCGradientButton(
                  label: 'Speichern',
                  onPressed: _hasChanges ? _save : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutfitPickerTile extends StatelessWidget {
  const _OutfitPickerTile({
    required this.outfit,
    required this.selected,
    required this.onChanged,
  });

  final OutfitWithItems outfit;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tags = outfit.outfit.styleTags;
    final seasons = outfit.outfit.seasons;

    return InkWell(
      onTap: () => onChanged(!selected),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 56,
                height: 56,
                child: ColoredBox(
                  color: Colors.white,
                  child: OutfitCanvasPreview(items: outfit.items),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tags.isNotEmpty)
                    Text(
                      tags.take(2).join(' · '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: LCColors.textMuted,
                            fontSize: 11,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (seasons.isNotEmpty)
                    Text(
                      seasons.join(', '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: LCColors.textMuted,
                            fontSize: 11,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (tags.isEmpty && seasons.isEmpty)
                    Text(
                      'Outfit',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? LCColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? LCColors.primary
                      : LCColors.primary.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check_rounded,
                      size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
