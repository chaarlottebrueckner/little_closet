import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/repositories/collection_repository.dart';
import '../../../../features/wardrobe/presentation/widgets/selection_bar.dart';
import 'collection_detail_page.dart';
import '../widgets/collection_card.dart';
import '../widgets/collection_empty_state.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/widgets/lc_gradient_fab.dart';
import '../../../../core/widgets/lc_page_background.dart';
import '../widgets/collections_header.dart';
import '../widgets/create_collection_sheet.dart';

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
            if (collections.isEmpty) return const CollectionEmptyState();
            final itemWidth =
                (MediaQuery.of(context).size.width - 32 - 12) / 2;
            final mainAxisExtent = itemWidth + 44;
            return GridView.builder(
              padding: EdgeInsets.fromLTRB(
                  16, 12, 16, _isSelectionMode ? 140 : 100),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: mainAxisExtent,
              ),
              itemCount: collections.length,
              itemBuilder: (_, i) {
                final c = collections[i];
                return CollectionCard(
                  collection: c,
                  isSelectionMode: _isSelectionMode,
                  isSelected: _selectedIds.contains(c.collection.id),
                  onLongPress: _isSelectionMode
                      ? null
                      : () => _enterSelectionMode(c.collection.id),
                  onTap: _isSelectionMode
                      ? () => _toggleSelection(c.collection.id)
                      : () => Navigator.push(
                            context,
                            slideUpRoute(
                              CollectionDetailPage(
                                  collectionId: c.collection.id),
                            ),
                          ),
                );
              },
            );
          },
        );
  }
}
