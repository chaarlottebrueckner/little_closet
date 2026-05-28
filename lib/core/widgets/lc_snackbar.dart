import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LCSnackBar {
  LCSnackBar._();

  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    IconData? icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: icon != null
            ? Row(children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
              ])
            : Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: LCColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: duration,
        action: (actionLabel != null && onAction != null)
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }
}
