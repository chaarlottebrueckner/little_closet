import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassSheet extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;

  const GlassSheet({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(28)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: LCGlass.blurSigma,
          sigmaY: LCGlass.blurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: LCGlass.sheetColor,
            borderRadius: borderRadius,
            border: Border.all(
              color: LCGlass.borderColor,
              width: LCGlass.borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
