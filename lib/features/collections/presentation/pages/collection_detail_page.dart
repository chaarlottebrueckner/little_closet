import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/lc_snackbar.dart';
import '../../../../data/repositories/collection_repository.dart';
import '../../../outfits/presentation/widgets/outfit_empty_state.dart';
import '../../../outfits/domain/outfit_filters.dart';
import '../../../outfits/domain/outfit_with_items.dart';
import '../../../outfits/presentation/pages/outfit_detail_page.dart';
import '../../../outfits/presentation/pages/outfit_editor_page.dart';
import '../../../outfits/presentation/widgets/outfit_card.dart';
import '../../../outfits/presentation/widgets/outfit_filter_sheet.dart';
import '../../domain/collection_with_outfits.dart';
import '../../../../core/widgets/lc_active_filter_chips.dart';
import '../../../../core/widgets/lc_filter_badge_button.dart';
import '../../../../core/widgets/lc_gradient_fab.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/widgets/lc_delete_confirm_dialog.dart';
import '../../../../core/widgets/lc_page_background.dart';
import '../widgets/collection_removal_bar.dart';
import '../widgets/create_collection_sheet.dart';
import '../widgets/outfit_picker_sheet.dart';

class CollectionDetailPage extends ConsumerStatefulWidget {
  const CollectionDetailPage({
    super.key,
    required this.collectionId,
    this.openPickerOnLoad = false,
  });

  final String collectionId;
  final bool openPickerOnLoad;

  @override
  ConsumerState<CollectionDetailPage> createState() =>
      _CollectionDetailPageState();
}

class _CollectionDetailPageState extends ConsumerState<CollectionDetailPage> {
  late final OutfitActiveFilters _filters;
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _filters = OutfitActiveFilters();
    if (widget.openPickerOnLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openPicker());
    }
  }

  void _enterSelectionMode(String firstId) {
    setState(() {
      _isSelectionMode = true;
      _selectedIds..clear()..add(firstId);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedIds.clear();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) _isSelectionMode = false;
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _openPicker() {
    if (!mounted) return;
    final current =
        ref.read(collectionByIdProvider(widget.collectionId)).valueOrNull;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OutfitPickerSheet(
        collectionId: widget.collectionId,
        initialOutfitIds:
            Set.from(current?.outfits.map((o) => o.outfit.id) ?? []),
      ),
    ).then((_) => _deleteIfEmpty());
  }

  Future<void> _deleteIfEmpty() async {
    if (!mounted) return;
    final deleted = await ref
        .read(collectionRepositoryProvider)
        .deleteCollectionIfEmpty(widget.collectionId);
    if (deleted && mounted) {
      LCSnackBar.show(context, 'Kollektion gelöscht – keine Outfits hinzugefügt');
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => OutfitFilterSheet(
        filters: _filters,
        onApply: (updated) => setState(() {
          _filters.styleTags = updated.styleTags;
          _filters.weatherTags = updated.weatherTags;
          _filters.seasons = updated.seasons;
        }),
      ),
    );
  }

  List<OutfitWithItems> _applyFilters(List<OutfitWithItems> outfits) {
    return outfits.where((owi) {
      if (_filters.styleTags.isNotEmpty &&
          !_filters.styleTags.any(owi.outfit.styleTags.contains)) {
        return false;
      }
      if (_filters.seasons.isNotEmpty &&
          !_filters.seasons.any(owi.outfit.seasons.contains)) {
        return false;
      }
      if (_filters.weatherTags.isNotEmpty &&
          !_filters.weatherTags.any(owi.outfit.weatherTags.contains)) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(collectionByIdProvider(widget.collectionId), (_, next) {
      if (next.hasValue && next.value == null && context.mounted) {
        Navigator.pop(context);
      }
    });

    final data =
        ref.watch(collectionByIdProvider(widget.collectionId)).valueOrNull;

    final outfits = data?.outfits ?? [];
    final filtered = _applyFilters(outfits);

    return PopScope(
      canPop: !_isSelectionMode,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _isSelectionMode) _exitSelectionMode();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LCPageBackground(
          child: Stack(
            children: [
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAppBar(context, data),
                    if (_filters.hasAny) _buildActiveFilterChips(),
                    const SizedBox(height: 8),
                    Expanded(child: _buildContent(context, data, filtered)),
                  ],
                ),
              ),
              if (_isSelectionMode)
                CollectionRemovalBar(
                  count: _selectedIds.length,
                  onCancel: _exitSelectionMode,
                  onRemove: () => _confirmRemove(context),
                ),
            ],
          ),
        ),
        floatingActionButton: data != null && !_isSelectionMode
            ? LCGradientFAB(
                onPressed: _openPicker,
                label: 'Outfit hinzufügen',
              )
            : null,
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, CollectionWithOutfits? data) {
    final name = data?.collection.name ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: LCColors.textDark,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  LCColors.gradientPink.createShader(bounds),
              child: Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          LCFilterBadgeButton(
            filterCount: _filters.count,
            onTap: _showFilterSheet,
          ),
          const SizedBox(width: 4),
          if (data != null) ...[
            IconButton(
              icon: const Icon(Icons.edit_rounded,
                  size: 18, color: LCColors.primary),
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => CreateCollectionSheet(
                  existingName: data.collection.name,
                  onSubmit: (newName) async {
                    await ref
                        .read(collectionRepositoryProvider)
                        .renameCollection(data.collection.id, newName);
                    return null;
                  },
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  size: 18, color: LCColors.primary),
              onPressed: () => showLCDeleteConfirmDialog(
                context: context,
                title: 'Kollektion löschen',
                body: 'Möchtest du "${data.collection.name}" wirklich löschen? Enthaltene Outfits bleiben erhalten.',
                onConfirm: () => ref
                    .read(collectionRepositoryProvider)
                    .deleteCollection(data.collection.id),
                onAfterConfirm: () {
                  if (context.mounted) {
                    LCSnackBar.show(context, 'Kollektion gelöscht',
                        icon: Icons.delete_outline_rounded);
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveFilterChips() {
    return LCActiveFilterChips(entries: [
      for (final v in _filters.styleTags)
        MapEntry(v, () => setState(() => _filters.styleTags.remove(v))),
      for (final v in _filters.seasons)
        MapEntry(v, () => setState(() => _filters.seasons.remove(v))),
      for (final v in _filters.weatherTags)
        MapEntry(v, () => setState(() => _filters.weatherTags.remove(v))),
    ]);
  }

  Widget _buildContent(BuildContext context, CollectionWithOutfits? data,
      List<OutfitWithItems> filtered) {
    if (data == null) {
      return const Center(
          child: CircularProgressIndicator(color: LCColors.primary));
    }
    if (filtered.isEmpty) {
      return const OutfitEmptyState(reason: OutfitEmptyReason.filteredOut);
    }

    final itemWidth = (MediaQuery.of(context).size.width - 32 - 12) / 2;
    final mainAxisExtent = itemWidth / 0.65;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: mainAxisExtent,
      ),
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        final outfit = filtered[i];
        final id = outfit.outfit.id;
        return OutfitCard(
          outfitWithItems: outfit,
          isSelectionMode: _isSelectionMode,
          isSelected: _selectedIds.contains(id),
          onLongPress: _isSelectionMode ? null : () => _enterSelectionMode(id),
          onTap: _isSelectionMode
              ? () => _toggleSelection(id)
              : () => Navigator.push(context, slideUpRoute(
                    OutfitDetailPage(
                      outfitWithItems: outfit,
                      onEdit: (o) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OutfitEditorPage(initialOutfit: o),
                        ),
                      ),
                    ),
                  )),
        );
      },
    );
  }

  void _confirmRemove(BuildContext context) {
    final count = _selectedIds.length;
    final ids = List<String>.from(_selectedIds);
    showLCDeleteConfirmDialog(
      context: context,
      title: count == 1
          ? 'Outfit entfernen?'
          : '$count Outfits entfernen?',
      body: count == 1
          ? 'Dieses Outfit aus der Kollektion entfernen? Das Outfit bleibt erhalten.'
          : 'Diese $count Outfits aus der Kollektion entfernen? Die Outfits bleiben erhalten.',
      onConfirm: () async {
        await ref
            .read(collectionRepositoryProvider)
            .removeOutfitsFromCollection(widget.collectionId, ids);
        await _deleteIfEmpty();
      },
      onAfterConfirm: _exitSelectionMode,
    );
  }

}
