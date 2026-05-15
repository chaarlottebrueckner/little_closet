import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LCGradientFAB extends StatelessWidget {
  const LCGradientFAB({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon = Icons.add,
  });

  final VoidCallback onPressed;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LCColors.gradientPink,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: LCColors.primary.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                letterSpacing: 0.5,
              ),
        ),
      ),
    );
  }
}
