import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/repositories/collection_repository.dart';
import '../../domain/collection_with_outfits.dart';
import '../pages/collection_detail_page.dart';
import 'collection_card.dart';

class CollectionsEditorialTab extends ConsumerWidget {
  const CollectionsEditorialTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(collectionsProvider).when(
          loading: () =>
              const Center(child: CircularProgressIndicator(color: LCColors.primary)),
          error: (e, _) => Center(child: Text('Fehler: $e')),
          data: (collections) {
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 100),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: _buildRows(collections, context),
                    ),
                  ),
                ),
              ],
            );
          },
        );
  }

  List<Widget> _buildRows(
      List<CollectionWithOutfits> items, BuildContext context) {
    final rows = <Widget>[];
    int i = 0;
    bool isFull = true;
    while (i < items.length) {
      if (isFull) {
        rows.add(_FullCard(c: items[i], context: context));
        i++;
      } else {
        final right = i + 1 < items.length ? items[i + 1] : null;
        rows.add(_PairRow(left: items[i], right: right, context: context));
        i += right != null ? 2 : 1;
      }
      isFull = !isFull;
    }
    return rows;
  }
}

class _FullCard extends StatelessWidget {
  final CollectionWithOutfits c;
  final BuildContext context;

  const _FullCard({required this.c, required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: SizedBox(
        height: 240,
        child: CollectionCard(
          collection: c,
          onTap: () => Navigator.push(
            context,
            slideUpRoute(CollectionDetailPage(collectionId: c.collection.id)),
          ),
        ),
      ),
    );
  }
}

class _PairRow extends StatelessWidget {
  final CollectionWithOutfits left;
  final CollectionWithOutfits? right;
  final BuildContext context;

  const _PairRow({
    required this.left,
    required this.right,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              height: 190,
              child: CollectionCard(
                collection: left,
                onTap: () => Navigator.push(
                  context,
                  slideUpRoute(
                      CollectionDetailPage(collectionId: left.collection.id)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: right != null
                ? SizedBox(
                    height: 190,
                    child: CollectionCard(
                      collection: right!,
                      onTap: () => Navigator.push(
                        context,
                        slideUpRoute(CollectionDetailPage(
                            collectionId: right!.collection.id)),
                      ),
                    ),
                  )
                : const SizedBox(height: 190),
          ),
        ],
      ),
    );
  }
}
