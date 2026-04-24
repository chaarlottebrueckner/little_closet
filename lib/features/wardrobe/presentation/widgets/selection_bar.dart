import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/repositories/clothing_repository.dart';

class SelectionBar extends ConsumerWidget {
  final Set<String> selectedIds;
  final VoidCallback onCancel;
  final VoidCallback onDeleted;

  const SelectionBar({
    super.key,
    required this.selectedIds,
    required this.onCancel,
    required this.onDeleted,
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
                            : () => _confirmDelete(context, ref),
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

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final count = selectedIds.length;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: LCGlass.blurSigma, sigmaY: LCGlass.blurSigma),
            child: Container(
              decoration: BoxDecoration(
                color: LCGlass.sheetColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: LCGlass.borderColor, width: LCGlass.borderWidth),
              ),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4789C).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: LCColors.primary, size: 26),
                  ),
                  const SizedBox(height: 16),
                  Text('$count ${count == 1 ? 'Teil' : 'Teile'} löschen?',
                      style: Theme.of(ctx).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    count == 1
                        ? 'Dieses Teil wirklich aus der Garderobe entfernen?'
                        : 'Diese $count Teile wirklich aus der Garderobe entfernen?',
                    textAlign: TextAlign.center,
                    style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          color: LCColors.textMuted,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(
                                color: LCColors.primary.withValues(alpha: 0.4)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Abbrechen',
                              style: TextStyle(color: LCColors.primary)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LCColors.gradientPink,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              final idsToDelete = List<String>.from(selectedIds);
                              Navigator.pop(ctx);
                              await ref
                                  .read(clothingRepositoryProvider)
                                  .deleteMultipleClothingItems(idsToDelete);
                              onDeleted();
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Löschen',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
