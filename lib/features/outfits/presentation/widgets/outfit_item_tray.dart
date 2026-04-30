import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/database/app_database.dart';
import '../../../../data/repositories/clothing_repository.dart';

class OutfitItemSheet extends ConsumerStatefulWidget {
  final Set<String> alreadyAddedIds;
  final void Function(List<ClothingItem>) onItemsConfirmed;
  final ScrollController scrollController;

  const OutfitItemSheet({
    super.key,
    required this.alreadyAddedIds,
    required this.onItemsConfirmed,
    required this.scrollController,
  });

  @override
  ConsumerState<OutfitItemSheet> createState() => _OutfitItemSheetState();
}

class _OutfitItemSheetState extends ConsumerState<OutfitItemSheet> {
  String? _selectedCategory;
  final Set<String> _pendingIds = {};

  void _toggle(ClothingItem item) {
    if (widget.alreadyAddedIds.contains(item.id)) return;
    setState(() {
      if (_pendingIds.contains(item.id)) {
        _pendingIds.remove(item.id);
      } else {
        _pendingIds.add(item.id);
      }
    });
  }

  void _confirm(List<ClothingItem> allItems) {
    final selected = allItems.where((i) => _pendingIds.contains(i.id)).toList();
    if (selected.isEmpty) return;
    setState(() => _pendingIds.clear());
    widget.onItemsConfirmed(selected);
  }

  @override
  void didUpdateWidget(OutfitItemSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    _pendingIds.removeWhere((id) => widget.alreadyAddedIds.contains(id));
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(clothingItemsProvider);

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
      data: (items) {
        final filtered = _selectedCategory == null
            ? items
            : items.where((i) => i.category == _selectedCategory).toList();

        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: widget.scrollController,
                slivers: [
                  // Drag handle
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 36,
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LCColors.gradientPink,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Filter chips
                        SizedBox(
                          height: 34,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            children: [
                              _SheetChip(
                                label: 'Alle',
                                isSelected: _selectedCategory == null,
                                onTap: () => setState(() => _selectedCategory = null),
                              ),
                              ...AppConstants.categories.map(
                                (cat) => _SheetChip(
                                  label: cat,
                                  isSelected: _selectedCategory == cat,
                                  onTap: () => setState(() => _selectedCategory = cat),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 1,
                            decoration: const BoxDecoration(
                                gradient: LCGlass.shimmerDivider),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  // Grid
                  if (filtered.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Center(
                          child: Text(
                            'Keine Kleidung gefunden',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: LCColors.textMuted),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final item = filtered[i];
                            final alreadyAdded =
                                widget.alreadyAddedIds.contains(item.id);
                            final isPending = _pendingIds.contains(item.id);
                            return _SheetItemCard(
                              item: item,
                              alreadyAdded: alreadyAdded,
                              isPending: isPending,
                              onTap: alreadyAdded ? null : () => _toggle(item),
                            );
                          },
                          childCount: filtered.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Confirm button — fixed at bottom, only when pending
            if (_pendingIds.isNotEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  20 + MediaQuery.of(context).padding.bottom,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LCColors.gradientPink,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: LCColors.primary.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () => _confirm(items),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        '${_pendingIds.length} Teile hinzufügen',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SheetChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SheetChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFE8A0BF).withValues(alpha: 0.30)
                : Colors.white.withValues(alpha: 0.65),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFD4789C).withValues(alpha: 0.8)
                  : const Color(0xFFE8A0BF).withValues(alpha: 0.4),
              width: isSelected ? 1.2 : 0.8,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected ? LCColors.primary : LCColors.textMuted,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
          ),
        ),
      ),
    );
  }
}

class _SheetItemCard extends StatelessWidget {
  final ClothingItem item;
  final bool alreadyAdded;
  final bool isPending;
  final VoidCallback? onTap;

  const _SheetItemCard({
    required this.item,
    required this.alreadyAdded,
    required this.isPending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPending
                ? LCColors.primary
                : alreadyAdded
                    ? LCColors.primary.withValues(alpha: 0.4)
                    : const Color(0xFFEDE0E8),
            width: isPending ? 2.5 : 1,
          ),
          boxShadow: isPending
              ? [
                  BoxShadow(
                    color: LCColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Opacity(
                opacity: alreadyAdded ? 0.4 : 1.0,
                child: Image.file(
                  File(item.imagePath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.image_not_supported_outlined,
                        color: LCColors.textMuted),
                  ),
                ),
              ),
            ),
            if (isPending)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: LCColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                ),
              )
            else if (alreadyAdded)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: LCColors.textMuted.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
