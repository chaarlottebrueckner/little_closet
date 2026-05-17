import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/repositories/collection_repository.dart';
import '../../../../features/wardrobe/presentation/widgets/selection_bar.dart';
import '../../domain/collection_with_content.dart';
import '../pages/collection_detail_page.dart';
import 'collection_card.dart';
import 'collection_empty_state.dart';

class CollectionsMasonryTab extends ConsumerStatefulWidget {
  const CollectionsMasonryTab({super.key});

  @override
  ConsumerState<CollectionsMasonryTab> createState() =>
      _CollectionsMasonryTabState();
}

class _CollectionsMasonryTabState
    extends ConsumerState<CollectionsMasonryTab> {
  final Set<String> _selectedIds = {};

  bool get _isSelectionMode => _selectedIds.isNotEmpty;

  void _enterSelectionMode(String id) => setState(() => _selectedIds
    ..clear()
    ..add(id));

  void _exitSelectionMode() => setState(() => _selectedIds.clear());

  void _toggleSelection(String id) => setState(() {
        _selectedIds.contains(id)
            ? _selectedIds.remove(id)
            : _selectedIds.add(id);
      });

  double _cardHeight(CollectionWithContent c) {
    final n = c.totalCount;
    if (n <= 1) return 160.0;
    if (n == 2) return 200.0;
    return 240.0;
  }

  List<List<CollectionWithContent>> _buildColumns(
      List<CollectionWithContent> items) {
    final col0 = <CollectionWithContent>[];
    final col1 = <CollectionWithContent>[];
    double h0 = 0, h1 = 0;
    for (final item in items) {
      final h = _cardHeight(item);
      if (h0 <= h1) {
        col0.add(item);
        h0 += h + 2;
      } else {
        col1.add(item);
        h1 += h + 2;
      }
    }
    return [col0, col1];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSelectionMode,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _isSelectionMode) _exitSelectionMode();
      },
      child: Stack(
        children: [
          ref.watch(collectionsProvider).when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: LCColors.primary),
                ),
                error: (e, _) => Center(child: Text('Fehler: $e')),
                data: (collections) {
                  if (collections.isEmpty) {
                    return const CollectionEmptyState();
                  }
                  final cols = _buildColumns(collections);
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: _isSelectionMode ? 140 : 100),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildColumn(cols[0])),
                          const SizedBox(width: 2),
                          Expanded(child: _buildColumn(cols[1])),
                        ],
                      ),
                    ),
                  );
                },
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
    );
  }

  Widget _buildColumn(List<CollectionWithContent> items) {
    return Column(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: SizedBox(
                  height: _cardHeight(item),
                  child: _card(item),
                ),
              ))
          .toList(),
    );
  }

  Widget _card(CollectionWithContent c) {
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
                slideUpRoute(
                    CollectionDetailPage(collectionId: c.collection.id)),
              ),
    );
  }
}
