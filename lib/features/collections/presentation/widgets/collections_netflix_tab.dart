import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/repositories/collection_repository.dart';
import '../../domain/collection_with_content.dart';
import '../../../../features/outfits/domain/outfit_with_items.dart';
import '../../../../features/outfits/presentation/widgets/outfit_canvas_preview.dart';
import '../pages/collection_detail_page.dart';
import 'collection_empty_state.dart';

class CollectionsNetflixTab extends ConsumerWidget {
  const CollectionsNetflixTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(collectionsProvider).when(
          loading: () =>
              const Center(child: CircularProgressIndicator(color: LCColors.primary)),
          error: (e, _) => Center(child: Text('Fehler: $e')),
          data: (collections) {
            if (collections.isEmpty) return const CollectionEmptyState();
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(top: 8, bottom: 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _CollectionRow(collection: collections[i]),
                      childCount: collections.length,
                    ),
                  ),
                ),
              ],
            );
          },
        );
  }
}

class _CollectionRow extends StatelessWidget {
  final CollectionWithContent collection;

  const _CollectionRow({required this.collection});

  void _openDetail(BuildContext context) {
    Navigator.push(
      context,
      slideUpRoute(CollectionDetailPage(collectionId: collection.collection.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RowHeader(collection: collection, onTap: () => _openDetail(context)),
          const SizedBox(height: 4),
          SizedBox(
            height: 150,
            child: collection.totalCount == 0
                ? _emptyRowHint(context)
                : _itemList(context),
          ),
        ],
      ),
    );
  }

  Widget _itemList(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 16),
          for (final outfit in collection.outfits) ...[
            _OutfitCard(outfit: outfit, onTap: () => _openDetail(context)),
            const SizedBox(width: 8),
          ],
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _emptyRowHint(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Text(
          'Noch nichts hinzugefügt',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: LCColors.textMuted),
        ),
      ),
    );
  }
}

class _RowHeader extends StatelessWidget {
  final CollectionWithContent collection;
  final VoidCallback onTap;

  const _RowHeader({required this.collection, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final count = collection.totalCount;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Text(
                collection.collection.name,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: LCColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: LCColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: LCColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: LCColors.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _OutfitCard extends StatelessWidget {
  final OutfitWithItems outfit;
  final VoidCallback onTap;

  const _OutfitCard({required this.outfit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = Color.lerp(Colors.white, outfit.dominantColor, 0.30)!;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 110,
          height: 150,
          child: ColoredBox(
            color: bg,
            child: OutfitCanvasPreview(
              items: outfit.items,
              backgroundColor: bg,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
