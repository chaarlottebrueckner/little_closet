import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/lc_active_filter_chips.dart';
import '../../../../core/widgets/lc_gradient_fab.dart';
import '../../../../core/widgets/lc_page_background.dart';
import '../../../../data/repositories/clothing_repository.dart';
import '../../../../data/repositories/outfit_repository.dart';
import '../../domain/outfit_filters.dart';
import '../../domain/outfit_with_items.dart';
import '../widgets/outfit_card.dart';
import '../widgets/outfit_empty_state.dart';
import '../widgets/outfit_filter_sheet.dart';
import '../widgets/outfits_header.dart';
import '../../../../features/wardrobe/presentation/widgets/selection_bar.dart';
import '../../../../core/navigation/app_routes.dart';
import 'outfit_detail_page.dart';
import 'outfit_editor_page.dart';

class OutfitsPage extends ConsumerStatefulWidget {
  const OutfitsPage({super.key});

  @override
  ConsumerState<OutfitsPage> createState() => _OutfitsPageState();
}

class _OutfitsPageState extends ConsumerState<OutfitsPage> {
  late final OutfitActiveFilters _filters;
  final Set<String> _selectedIds = {};

  bool get _isSelectionMode => _selectedIds.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _filters = OutfitActiveFilters();
  }

  void _enterSelectionMode(String firstId) {
    setState(() {
      _selectedIds..clear()..add(firstId);
    });
  }

  void _exitSelectionMode() {
    setState(() => _selectedIds.clear());
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => OutfitFilterSheet(
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
    return PopScope(
      canPop: !_isSelectionMode,
      onPopInvokedWithResult: (didPop, result) {
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
                    OutfitsHeader(
                      filters: _filters,
                      onFilterTap: _showFilterSheet,
                    ),
                    if (_filters.hasAny && !_isSelectionMode) _buildActiveFilterChips(),
                    Expanded(child: _buildContent()),
                  ],
                ),
              ),
              if (_isSelectionMode)
                SelectionBar(
                  selectedIds: _selectedIds,
                  onCancel: _exitSelectionMode,
                  onDeleted: _exitSelectionMode,
                  onDeleteConfirmed: (ids) => ref
                      .read(outfitRepositoryProvider)
                      .deleteMultipleOutfits(ids),
                  itemSingular: 'Outfit',
                  itemPlural: 'Outfits',
                ),
            ],
          ),
        ),
        floatingActionButton: _isSelectionMode
            ? null
            : ref.watch(clothingItemsProvider).valueOrNull?.isNotEmpty == true
                ? _buildFAB()
                : null,
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

  Widget _buildContent() {
    final outfitsAsync = ref.watch(outfitsProvider);
    final clothingAsync = ref.watch(clothingItemsProvider);
    return outfitsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
      data: (outfits) {
        final filtered = _applyFilters(outfits);
        if (filtered.isEmpty) {
          final reason = clothingAsync.when(
            data: (items) {
              if (items.isEmpty) return OutfitEmptyReason.noClothing;
              if (outfits.isEmpty) return OutfitEmptyReason.noOutfits;
              return OutfitEmptyReason.filteredOut;
            },
            loading: () => OutfitEmptyReason.noOutfits,
            error: (_, __) => OutfitEmptyReason.noOutfits,
          );
          return OutfitEmptyState(reason: reason);
        }
        final screenWidth = MediaQuery.of(context).size.width;
        final itemWidth = (screenWidth - 32 - 12) / 2;
        final mainAxisExtent = itemWidth * kCanvasHeight / kCanvasWidth + 44;
        return GridView.builder(
          padding: EdgeInsets.fromLTRB(16, 12, 16, _isSelectionMode ? 140 : 100),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: mainAxisExtent,
          ),
          itemCount: filtered.length,
          itemBuilder: (context, i) {
            final outfit = filtered[i];
            final id = outfit.outfit.id;
            return OutfitCard(
              outfitWithItems: outfit,
              isSelectionMode: _isSelectionMode,
              isSelected: _selectedIds.contains(id),
              onLongPress: _isSelectionMode ? null : () => _enterSelectionMode(id),
              onTap: _isSelectionMode
                  ? () => _toggleSelection(id)
                  : () => Navigator.push(
                        context,
                        slideUpRoute(OutfitDetailPage(
                          outfitWithItems: outfit,
                          onEdit: (o) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OutfitEditorPage(initialOutfit: o),
                            ),
                          ),
                        )),
                      ),
            );
          },
        );
      },
    );
  }

  Widget _buildFAB() {
    return LCGradientFAB(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OutfitEditorPage()),
      ),
      label: 'Outfit erstellen',
    );
  }
}
