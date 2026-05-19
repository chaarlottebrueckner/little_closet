import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/repositories/collection_repository.dart';
import '../../../../features/wardrobe/presentation/widgets/selection_bar.dart';
import 'collection_detail_page.dart';
import '../widgets/collection_card.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/widgets/lc_gradient_fab.dart';
import '../../../../core/widgets/lc_page_background.dart';
import '../widgets/collections_header.dart';
import '../widgets/create_collection_sheet.dart';
import '../../domain/collection_with_outfits.dart';

class CollectionsPage extends ConsumerStatefulWidget {
  const CollectionsPage({super.key});

  @override
  ConsumerState<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends ConsumerState<CollectionsPage> {
  final Set<String> _selectedIds = {};

  bool get _isSelectionMode => _selectedIds.isNotEmpty;

  void _enterSelectionMode(String id) =>
      setState(() => _selectedIds
        ..clear()
        ..add(id));

  void _exitSelectionMode() => setState(() => _selectedIds.clear());

  void _toggleSelection(String id) => setState(() {
        _selectedIds.contains(id)
            ? _selectedIds.remove(id)
            : _selectedIds.add(id);
      });

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateCollectionSheet(
        onSubmit: (name) =>
            ref.read(collectionRepositoryProvider).createCollection(name),
        onCreated: (id) {
          if (!mounted) return;
          Navigator.push(
            context,
            slideUpRoute(
              CollectionDetailPage(collectionId: id, openPickerOnLoad: true),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    const CollectionsHeader(),
                    Expanded(child: _buildBody()),
                  ],
                ),
              ),
              if (_isSelectionMode)
                SelectionBar(
                  selectedIds: _selectedIds,
                  onCancel: _exitSelectionMode,
                  onDeleted: _exitSelectionMode,
                  onDeleteConfirmed: (ids) => ref
                      .read(collectionRepositoryProvider)
                      .deleteMultipleCollections(ids),
                  itemSingular: 'Kollektion',
                  itemPlural: 'Kollektionen',
                ),
            ],
          ),
        ),
        floatingActionButton: _isSelectionMode
            ? null
            : LCGradientFAB(
                onPressed: _showCreateSheet,
                label: 'Kollektion erstellen',
              ),
      ),
    );
  }

  Widget _buildBody() {
    return ref.watch(collectionsProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: LCColors.primary),
          ),
          error: (e, _) => Center(child: Text('Fehler: $e')),
          data: (collections) {
            final screenWidth = MediaQuery.of(context).size.width;
            const gap = 14.0;
            const hPad = 16.0;
            final cellW = (screenWidth - hPad * 2 - gap) / 2;
            final cellH = cellW * 0.9 + 44;
            final tallH = cellH * 1.45;

            final blocks = _splitIntoBlocks(collections);

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      hPad, 12, hPad, _isSelectionMode ? 140 : 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => Padding(
                        padding: EdgeInsets.only(
                            bottom: i < blocks.length - 1 ? gap : 0),
                        child: _buildBlock(
                          blocks[i],
                          gap: gap,
                          cellH: cellH,
                          tallH: tallH,
                        ),
                      ),
                      childCount: blocks.length,
                    ),
                  ),
                ),
              ],
            );
          },
        );
  }

  List<List<CollectionWithOutfits>> _splitIntoBlocks(List<CollectionWithOutfits> items) {
    final blocks = <List<CollectionWithOutfits>>[];
    var i = 0;
    while (i < items.length) {
      final remaining = items.length - i;
      int size;
      if (remaining <= 4) {
        size = remaining;
      } else if (remaining == 5) {
        size = 3;
      } else {
        size = 4;
      }
      blocks.add(items.sublist(i, i + size));
      i += size;
    }
    return blocks;
  }

  Widget _buildBlock(
    List<CollectionWithOutfits> block, {
    required double gap,
    required double cellH,
    required double tallH,
  }) {
    switch (block.length) {
      case 1:
        return SizedBox(height: cellH, child: _card(block[0]));
      case 2:
        return SizedBox(
          height: cellH,
          child: Row(children: [
            Expanded(child: _card(block[0])),
            SizedBox(width: gap),
            Expanded(child: _card(block[1])),
          ]),
        );
      case 3:
        final halfH = (tallH - gap) / 2;
        return SizedBox(
          height: tallH,
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(child: _card(block[0])),
            SizedBox(width: gap),
            Expanded(
              child: Column(children: [
                SizedBox(height: halfH, child: _card(block[1])),
                SizedBox(height: gap),
                SizedBox(height: halfH, child: _card(block[2])),
              ]),
            ),
          ]),
        );
      default: // 4
        final shortH = cellH * 0.75;
        return Column(children: [
          SizedBox(
            height: shortH,
            child: Row(children: [
              Expanded(flex: 3, child: _card(block[0])),
              SizedBox(width: gap),
              Expanded(flex: 2, child: _card(block[1])),
            ]),
          ),
          SizedBox(height: gap),
          SizedBox(
            height: shortH,
            child: Row(children: [
              Expanded(flex: 2, child: _card(block[2])),
              SizedBox(width: gap),
              Expanded(flex: 3, child: _card(block[3])),
            ]),
          ),
        ]);
    }
  }

  Widget _card(CollectionWithOutfits c) {
    return CollectionCard(
      collection: c,
      isSelectionMode: _isSelectionMode,
      isSelected: _selectedIds.contains(c.collection.id),
      onLongPress:
          _isSelectionMode ? null : () => _enterSelectionMode(c.collection.id),
      onTap: _isSelectionMode
          ? () => _toggleSelection(c.collection.id)
          : () => Navigator.push(
                context,
                slideUpRoute(CollectionDetailPage(collectionId: c.collection.id)),
              ),
    );
  }
}
