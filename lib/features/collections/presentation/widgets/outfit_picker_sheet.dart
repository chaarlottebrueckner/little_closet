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
              child: Text(
                'Outfits hinzufügen',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
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
                  return GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: outfits.length,
                    itemBuilder: (_, i) => _OutfitPickerCard(
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

class _OutfitPickerCard extends StatelessWidget {
  const _OutfitPickerCard({
    required this.outfit,
    required this.selected,
    required this.onChanged,
  });

  final OutfitWithItems outfit;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ColoredBox(
            color: Colors.white,
            child: OutfitCanvasPreview(items: outfit.items),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? LCColors.primary : Colors.transparent,
              width: 2,
            ),
            color: selected
                ? LCColors.primary.withValues(alpha: 0.15)
                : Colors.transparent,
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: Opacity(
            opacity: selected ? 1.0 : 0.0,
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: LCColors.primary,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 13,
                color: Colors.white,
              ),
            ),
          ),
        ),
        GestureDetector(onTap: () => onChanged(!selected)),
      ],
    );
  }
}
