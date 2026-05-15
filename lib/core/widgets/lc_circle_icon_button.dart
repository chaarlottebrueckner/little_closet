import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LCCircleIconButton extends StatelessWidget {
  const LCCircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 36.0,
    this.iconSize = 15.0,
    this.iconColor,
    this.isLoading = false,
    this.hasBorder = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final Color? iconColor;
  final bool isLoading;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.80),
          shape: BoxShape.circle,
          border: hasBorder
              ? Border.all(
                  color: LCColors.primary.withValues(alpha: 0.45),
                  width: 1.2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: LCColors.primary,
                ),
              )
            : Icon(icon, size: iconSize, color: iconColor ?? LCColors.textDark),
      ),
    );
  }
}
