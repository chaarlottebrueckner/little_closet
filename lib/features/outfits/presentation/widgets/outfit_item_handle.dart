import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../outfits/domain/editable_item.dart';
import '../../../outfits/domain/outfit_with_items.dart';

class OutfitItemHandle extends StatefulWidget {
  final EditableItem editableItem;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onRemove;
  final void Function(double dx, double dy) onPan;
  final void Function(double scaleDelta, double rotationDelta) onPinch;

  const OutfitItemHandle({
    super.key,
    required this.editableItem,
    required this.isSelected,
    required this.onSelect,
    required this.onRemove,
    required this.onPan,
    required this.onPinch,
  });

  @override
  State<OutfitItemHandle> createState() => _OutfitItemHandleState();
}

class _OutfitItemHandleState extends State<OutfitItemHandle> {
  double _baseScale = 1.0;
  double _baseRotation = 0.0;

  void _onScaleStart(ScaleStartDetails details) {
    _baseScale = widget.editableItem.scale;
    _baseRotation = widget.editableItem.rotation;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount >= 2) {
      widget.onPinch(
        _baseScale * details.scale,
        _baseRotation + details.rotation,
      );
    } else {
      widget.onPan(details.focalPointDelta.dx, details.focalPointDelta.dy);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.editableItem;
    return Positioned(
      left: item.posX,
      top: item.posY,
      child: GestureDetector(
        onTap: widget.onSelect,
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        child: Transform.rotate(
          angle: item.rotation,
          child: Transform.scale(
            scale: item.scale,
            child: SizedBox(
              width: kItemBaseWidth,
              height: kItemBaseHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Item image
                  Container(
                    decoration: widget.isSelected
                        ? BoxDecoration(
                            border: Border.all(
                              color: LCColors.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          )
                        : null,
                    child: Image.file(
                      File(item.item.imagePath),
                      width: kItemBaseWidth,
                      height: kItemBaseHeight,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        width: kItemBaseWidth,
                        height: kItemBaseHeight,
                        color: LCColors.accent.withValues(alpha: 0.2),
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: LCColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                  // Remove button (only when selected)
                  if (widget.isSelected)
                    Positioned(
                      right: -10,
                      top: -10,
                      child: GestureDetector(
                        onTap: widget.onRemove,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: LCColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: LCColors.primary.withValues(alpha: 0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
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
