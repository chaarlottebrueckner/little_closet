import 'dart:ui' show ImageFilter;

import '../../../../core/widgets/lc_delete_confirm_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/repositories/outfit_repository.dart';

class SelectionBar extends ConsumerWidget {
  final Set<String> selectedIds;
  final VoidCallback onCancel;
  final VoidCallback onDeleted;
  final Future<void> Function(List<String> ids) onDeleteConfirmed;
  final String itemSingular;
  final String itemPlural;

  const SelectionBar({
    super.key,
    required this.selectedIds,
    required this.onCancel,
    required this.onDeleted,
    required this.onDeleteConfirmed,
    this.itemSingular = 'Teil',
    this.itemPlural = 'Teile',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              filter: ImageFilter.blur(sigmaX: LCGlass.blurSigma, sigmaY: LCGlass.blurSigma),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: LCGlass.sheetColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: LCGlass.borderColor,
                    width: LCGlass.borderWidth,
                  ),
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
                        '${selectedIds.length} ausgewählt',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: LCColors.textDark,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        side: BorderSide(
                          color: LCColors.primary.withValues(alpha: 0.5),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Abbrechen',
                        style: TextStyle(
                          color: LCColors.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: selectedIds.isEmpty ? null : LCColors.gradientPink,
                        color: selectedIds.isEmpty
                            ? const Color(0xFFE8A0BF).withValues(alpha: 0.25)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: selectedIds.isEmpty
                            ? null
                            : [
                                BoxShadow(
                                  color: LCColors.primary.withValues(alpha: 0.30),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: TextButton.icon(
                        onPressed: selectedIds.isEmpty
                            ? null
                            : () async {
                                final outfitCount = await ref
                                    .read(outfitRepositoryProvider)
                                    .countItemsUsedInOutfits(
                                        selectedIds.toList());
                                if (context.mounted) {
                                  _confirmDelete(context, outfitCount);
                                }
                              },
                        icon: const Icon(Icons.delete_outline_rounded,
                            size: 17, color: Colors.white),
                        label: const Text(
                          'Löschen',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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

  void _confirmDelete(BuildContext context, int outfitCount) {
    final count = selectedIds.length;
    final idsToDelete = List<String>.from(selectedIds);
    showLCDeleteConfirmDialog(
      context: context,
      title: outfitCount > 0
          ? 'In Outfits verwendet'
          : '$count ${count == 1 ? itemSingular : itemPlural} löschen?',
      body: outfitCount > 0
          ? '$outfitCount ${outfitCount == 1 ? 'Teil wird' : 'Teile werden'} in Outfits verwendet und beim Löschen daraus entfernt.'
          : count == 1
              ? 'Dieses $itemSingular wirklich löschen?'
              : 'Diese $count $itemPlural wirklich löschen?',
      onConfirm: () => onDeleteConfirmed(idsToDelete),
      onAfterConfirm: onDeleted,
    );
  }
}
