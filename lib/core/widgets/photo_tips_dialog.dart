import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PhotoTipsDialog extends StatelessWidget {
  const PhotoTipsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: LCGlass.blurSigma, sigmaY: LCGlass.blurSigma),
          child: Container(
            decoration: BoxDecoration(
              color: LCGlass.sheetColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: LCGlass.borderColor, width: LCGlass.borderWidth),
            ),
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    gradient: LCColors.gradientPink,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_camera, color: Colors.white, size: 26),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Perfektes Foto',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: LCColors.textDark,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'So bekommt die KI die besten Ergebnisse',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 13,
                    color: LCColors.textMuted,
                  ),
                ),
                const SizedBox(height: 20),
                const _TipRow(icon: Icons.checkroom, text: 'Nicht am Körper tragen'),
                const SizedBox(height: 12),
                const _TipRow(icon: Icons.wb_sunny_outlined, text: 'Gutes, natürliches Licht'),
                const SizedBox(height: 12),
                const _TipRow(icon: Icons.crop_free, text: 'Cleaner, heller Hintergrund'),
                const SizedBox(height: 12),
                const _TipRow(icon: Icons.straighten, text: 'Glatt auslegen oder aufhängen'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LCColors.gradientPink,
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Verstanden',
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: LCColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: LCColors.primary),
        ),
        const SizedBox(width: 14),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: LCColors.textDark,
          ),
        ),
      ],
    );
  }
}
