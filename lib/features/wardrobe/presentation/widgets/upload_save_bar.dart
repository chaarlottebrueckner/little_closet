import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class UploadSaveBar extends StatelessWidget {
  final bool canSave;
  final bool isSaving;
  final VoidCallback? onSave;

  const UploadSaveBar({
    super.key,
    required this.canSave,
    required this.isSaving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: canSave ? 1.0 : 0.42,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LCColors.gradientPink,
              borderRadius: BorderRadius.circular(14),
              boxShadow: canSave
                  ? [
                      BoxShadow(
                        color: LCColors.primary.withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: canSave && !isSaving ? onSave : null,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Speichern',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
