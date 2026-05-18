import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_sheet.dart';
import '../../../../core/widgets/lc_gradient_button.dart';
import '../../../../core/widgets/lc_sheet_handle.dart';
import '../../../../data/repositories/collection_repository.dart';
import 'collection_cover_mosaic.dart';
import 'create_collection_sheet.dart';

class AddToCollectionSheet extends ConsumerStatefulWidget {
  const AddToCollectionSheet({
    super.key,
    required this.outfitId,
  });

  final String outfitId;

  @override
  ConsumerState<AddToCollectionSheet> createState() =>
      _AddToCollectionSheetState();
}

class _AddToCollectionSheetState extends ConsumerState<AddToCollectionSheet> {
  Set<String> _checkedIds = {};
  Set<String> _originalIds = {};
  bool _initialLoading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadInitialChecked();
  }

  Future<void> _loadInitialChecked() async {
    final repo = ref.read(collectionRepositoryProvider);
    final ids = await repo.collectionIdsContainingOutfit(widget.outfitId);
    if (!mounted) return;
    setState(() {
      _checkedIds = Set.from(ids);
      _originalIds = Set.from(ids);
      _initialLoading = false;
    });
  }

  Future<void> _createAndAssign() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateCollectionSheet(
        onSubmit: (name) async {
          final repo = ref.read(collectionRepositoryProvider);
          final newId = await repo.createCollection(name);
          await repo.addOutfitToCollection(newId, widget.outfitId);
          if (mounted) {
            setState(() {
              _checkedIds.add(newId);
              _originalIds.add(newId);
            });
          }
          return null;
        },
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final repo = ref.read(collectionRepositoryProvider);
    final added = _checkedIds.difference(_originalIds);
    final removed = _originalIds.difference(_checkedIds);
    for (final id in added) {
      await repo.addOutfitToCollection(id, widget.outfitId);
    }
    for (final id in removed) {
      await repo.removeOutfitFromCollection(id, widget.outfitId);
      await repo.deleteCollectionIfEmpty(id);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final collectionsAsync = ref.watch(collectionsProvider);

    return GlassSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 14),
          const Center(child: LCSheetHandle()),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  LCColors.gradientPink.createShader(bounds),
              child: Text(
                'ZU KOLLEKTION HINZUFÜGEN',
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
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: LCColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add_rounded, color: LCColors.primary, size: 22),
            ),
            title: const Text(
              'Neue Kollektion erstellen',
              style: TextStyle(color: LCColors.primary, fontWeight: FontWeight.w600),
            ),
            onTap: _createAndAssign,
          ),
          _shimmerDivider(),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.38,
            ),
            child: _initialLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CircularProgressIndicator(color: LCColors.primary),
                    ),
                  )
                : collectionsAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: CircularProgressIndicator(color: LCColors.primary),
                      ),
                    ),
                    error: (_, __) => const Center(child: Text('Fehler beim Laden')),
                    data: (collections) => ListView.builder(
                      shrinkWrap: true,
                      itemCount: collections.length,
                      itemBuilder: (_, i) {
                        final c = collections[i];
                        return CheckboxListTile(
                          secondary: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CollectionCoverMosaic(collection: c, size: 40),
                          ),
                          title: Text(
                            c.collection.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          subtitle: Text(
                            '${c.totalCount} Items',
                            style: const TextStyle(
                                color: LCColors.textMuted, fontSize: 12),
                          ),
                          value: _checkedIds.contains(c.collection.id),
                          activeColor: LCColors.primary,
                          checkColor: Colors.white,
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: _saving
                              ? null
                              : (v) => setState(() {
                                    if (v == true) {
                                      _checkedIds.add(c.collection.id);
                                    } else {
                                      _checkedIds.remove(c.collection.id);
                                    }
                                  }),
                        );
                      },
                    ),
                  ),
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
