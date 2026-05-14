import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/repositories/collection_repository.dart';
import '../../../../features/wardrobe/presentation/widgets/selection_bar.dart';
import 'collection_detail_page.dart';
import '../widgets/collection_card.dart';
import '../widgets/collection_empty_state.dart';
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
        body: Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFF0F7), Color(0xFFFAFAFA)],
                  stops: [0.0, 0.45],
                ),
              ),
            ),
            // Pink radial glow bottom
            Positioned(
              bottom: -210,
              left: -150,
              right: -150,
              child: Container(
                height: 700,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color(0x88F4A7C3),
                      Color.fromARGB(44, 246, 109, 159),
                      Color.fromARGB(0, 255, 255, 255),
                    ],
                    stops: [0.0, 0.45, 1.0],
                    radius: 0.5,
                  ),
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CollectionsHeader(),
                  Expanded(child: _buildBody()),
                ],
              ),
            ),
            // Selection bar
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
        floatingActionButton: _isSelectionMode ? null : _buildFAB(),
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
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  CollectionDetailPage(collection: c),
                              transitionsBuilder:
                                  (_, animation, __, child) => SlideTransition(
                                position: Tween(
                                  begin: const Offset(0, 1),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                )),
                                child: child,
                              ),
                              transitionDuration:
                                  const Duration(milliseconds: 350),
                            ),
                          ),
                );
              },
            );
          },
        );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        gradient: LCColors.gradientPink,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: LCColors.primary.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: _showCreateSheet,
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Kollektion erstellen',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'DMSans',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
