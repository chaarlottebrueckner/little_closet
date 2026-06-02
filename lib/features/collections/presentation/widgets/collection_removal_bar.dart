import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CollectionRemovalBar extends StatelessWidget {
  final int count;
  final VoidCallback onCancel;
  final VoidCallback onRemove;

  const CollectionRemovalBar({
    super.key,
    required this.count,
    required this.onCancel,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
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
              filter: ImageFilter.blur(
                  sigmaX: LCGlass.blurSigma, sigmaY: LCGlass.blurSigma),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: LCGlass.sheetColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: LCGlass.borderColor, width: LCGlass.borderWidth),
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
                        '$count ausgewählt',
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: LCColors.textDark,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                    IconButton(
                      onPressed: onCancel,
                      icon: const Icon(Icons.close_rounded),
                      tooltip: 'Abbrechen',
                      style: IconButton.styleFrom(
                        foregroundColor: LCColors.primary,
                        side: BorderSide(
                            color: LCColors.primary.withValues(alpha: 0.5),
                            width: 1.2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.all(10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: count == 0 ? null : LCColors.gradientPink,
                        color: count == 0
                            ? const Color(0xFFE8A0BF).withValues(alpha: 0.25)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: count == 0
                            ? null
                            : [
                                BoxShadow(
                                  color:
                                      LCColors.primary.withValues(alpha: 0.30),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: TextButton.icon(
                        onPressed: count == 0 ? null : onRemove,
                        icon: const Icon(Icons.remove_circle_outline_rounded,
                            size: 17, color: Colors.white),
                        label: const Text(
                          'Entfernen',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
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
}
