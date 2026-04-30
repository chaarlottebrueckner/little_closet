import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_sheet.dart';
import '../../../../core/widgets/lc_chip.dart';
import '../../../../core/widgets/lc_section_label.dart';

class OutfitSaveSheet extends StatefulWidget {
  final List<String> suggestedStyleTags;
  final List<String> suggestedWeatherTags;
  final List<String> suggestedSeasons;
  final void Function(List<String> styleTags, List<String> weatherTags, List<String> seasons) onSave;

  const OutfitSaveSheet({
    super.key,
    required this.suggestedStyleTags,
    required this.suggestedWeatherTags,
    required this.suggestedSeasons,
    required this.onSave,
  });

  @override
  State<OutfitSaveSheet> createState() => _OutfitSaveSheetState();
}

class _OutfitSaveSheetState extends State<OutfitSaveSheet> {
  late Set<String> _selectedStyleTags;
  late Set<String> _selectedSeasons;
  late Set<String> _selectedWeatherTags;

  @override
  void initState() {
    super.initState();
    _selectedStyleTags = Set.of(widget.suggestedStyleTags);
    _selectedSeasons = Set.of(widget.suggestedSeasons);
    _selectedWeatherTags = Set.of(widget.suggestedWeatherTags);
  }

  void _save() {
    widget.onSave(
      _selectedStyleTags.toList(),
      _selectedWeatherTags.toList(),
      _selectedSeasons.toList(),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) => GlassSheet(
        child: Column(
          children: [
            const SizedBox(height: 14),
            Container(
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                gradient: LCColors.gradientPink,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFD4789C), Color(0xFFE8A0BF)],
                ).createShader(bounds),
                child: Text(
                  'OUTFIT SPEICHERN',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 1,
                decoration: const BoxDecoration(gradient: LCGlass.shimmerDivider),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                children: [
                  // Style
                  const LCSectionLabel('STYLE'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AppConstants.styleTags.map((tag) {
                      final isSelected = _selectedStyleTags.contains(tag);
                      return LCChip(
                        label: tag,
                        isSelected: isSelected,
                        onTap: () => setState(() {
                          if (isSelected) {
                            _selectedStyleTags.remove(tag);
                          } else {
                            _selectedStyleTags.add(tag);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Saison
                  const LCSectionLabel('SAISON'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AppConstants.seasons.map((tag) {
                      final isSelected = _selectedSeasons.contains(tag);
                      return LCChip(
                        label: tag,
                        isSelected: isSelected,
                        onTap: () => setState(() {
                          if (isSelected) {
                            _selectedSeasons.remove(tag);
                          } else {
                            _selectedSeasons.add(tag);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Wetter
                  const LCSectionLabel('WETTER'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AppConstants.weatherTags.map((tag) {
                      final isSelected = _selectedWeatherTags.contains(tag);
                      return LCChip(
                        label: tag,
                        isSelected: isSelected,
                        onTap: () => setState(() {
                          if (isSelected) {
                            _selectedWeatherTags.remove(tag);
                          } else {
                            _selectedWeatherTags.add(tag);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Save button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
              child: SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LCColors.gradientPink,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: LCColors.primary.withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: _save,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
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
          ],
        ),
      ),
    );
  }
}
