import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_sheet.dart';
import '../../../../core/widgets/lc_sheet_option.dart';

class ImageSourceSheet extends StatelessWidget {
  const ImageSourceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassSheet(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                gradient: LCColors.gradientPink,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Foto ändern',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Wähle, wie du ein neues Foto aufnehmen möchtest.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: LCColors.textMuted,
                  ),
            ),
            const SizedBox(height: 28),
            LCSheetOption(
              icon: Icons.camera_alt_outlined,
              title: 'Kamera',
              subtitle: 'Jetzt ein Foto aufnehmen',
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            const SizedBox(height: 12),
            LCSheetOption(
              icon: Icons.photo_library_outlined,
              title: 'Galerie',
              subtitle: 'Aus deinen Fotos auswählen',
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
