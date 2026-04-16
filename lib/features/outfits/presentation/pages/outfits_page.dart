import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class OutfitsPage extends StatelessWidget {
  const OutfitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LCColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Outfits',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: LCColors.primary,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 2,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Erstelle deine Looks',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: LCColors.textMuted,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: LCColors.accent.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.style_outlined,
                        color: LCColors.primary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Noch keine Outfits.',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kommt bald! Füge zuerst Kleidung hinzu.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: LCColors.textMuted,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
