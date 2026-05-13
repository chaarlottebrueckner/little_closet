import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LCSheetHandle extends StatelessWidget {
  const LCSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 3,
      decoration: BoxDecoration(
        gradient: LCColors.gradientPink,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
