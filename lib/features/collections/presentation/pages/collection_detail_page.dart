import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kollektion gelöscht – keine Outfits hinzugefügt'),
          duration: Duration(seconds: 3),
        ),
      );
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
              if (_isSelectionMode) _buildRemovalBar(context),
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

  Widget _buildRemovalBar(BuildContext context) {
    final count = _selectedIds.length;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: LCGlass.blurSigma, sigmaY: LCGlass.blurSigma),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: LCGlass.sheetColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: LCGlass.borderColor, width: LCGlass.borderWidth),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4789C).withValues(alpha: 0.18),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$count ausgewählt',
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: LCColors.textDark,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: _exitSelectionMode,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        side: BorderSide(
                            color: LCColors.primary.withValues(alpha: 0.5),
                            width: 1.2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Abbrechen',
                        style: TextStyle(
                            color: LCColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: count == 0 ? null : LCColors.gradientPink,
                        color: count == 0
                            ? const Color(0xFFE8A0BF).withValues(alpha: 0.25)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: count == 0
                            ? null
                            : [
                                BoxShadow(
                                  color:
                                      LCColors.primary.withValues(alpha: 0.30),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: TextButton.icon(
                        onPressed: count == 0 ? null : () => _confirmRemove(context),
                        icon: const Icon(Icons.remove_circle_outline_rounded,
                            size: 17, color: Colors.white),
                        label: const Text(
                          'Entfernen',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
