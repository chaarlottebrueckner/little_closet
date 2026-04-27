import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/database/app_database.dart';

class ClothingCard extends StatelessWidget {
  final ClothingItem item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelectionMode;
  final bool isSelected;

  const ClothingCard({
    super.key,
    required this.item,
    this.onTap,
    this.onLongPress,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {

    final cardColor = _resolveCardColor();

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE8A0BF).withValues(alpha: 0.30)
              : cardColor.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4789C).withValues(alpha: 0.85)
                : const Color(0xFFE8A0BF).withValues(alpha: 0.3),
            width: isSelected ? 2.0 : 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFD4789C).withValues(alpha: 0.22)
                  : const Color(0xFFD4789C).withValues(alpha: 0.08),
              blurRadius: isSelected ? 18 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.file(
                      File(item.imagePath),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFF5EEF2),
                        child: const Icon(Icons.checkroom_outlined,
                            color: Color(0xFFD4789C), size: 36),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.subcategory ?? item.category,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.colors.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          item.colors.first,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: LCColors.textMuted,
                                fontSize: 11,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (isSelectionMode)
              Positioned(
                top: 10,
                right: 10,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? LCColors.primary
                        : Colors.white.withValues(alpha: 0.85),
                    border: Border.all(
                      color: isSelected
                          ? LCColors.primary
                          : const Color(0xFFD4789C).withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded,
                          size: 15, color: Colors.white)
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }


  Color _resolveCardColor() {
    if (item.colors.isEmpty){
      return Colors.white;
    }
    final colorName = item.colors.firstWhere(
        (c) => c != 'Gemustert',
        orElse: () => item.colors.first, 
      );
    return AppConstants.colorMap[colorName] ?? Colors.white;
       
   
  }
}

