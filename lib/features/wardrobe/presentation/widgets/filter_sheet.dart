import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/glass_sheet.dart';
import '../../domain/active_filters.dart';

class FilterSheet extends StatefulWidget {
  final ActiveFilters filters;
  final void Function(ActiveFilters) onApply;

  final List<String> customStyleTags;

  const FilterSheet({
    super.key,
    required this.filters,
    required this.onApply,
    this.customStyleTags = const [],
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late Set<String> _categories;
  late Set<String> _seasons;
  late Set<String> _colors;
  late Set<String> _styleTags;
  late Set<String> _weatherTags;

  @override
  void initState() {
    super.initState();
    _categories = Set.of(widget.filters.categories);
    _seasons = Set.of(widget.filters.seasons);
    _colors = Set.of(widget.filters.colors);
    _styleTags = Set.of(widget.filters.styleTags);
    _weatherTags = Set.of(widget.filters.weatherTags);
  }

  void _apply() {
    final updated = ActiveFilters()
      ..categories = _categories
      ..seasons = _seasons
      ..colors = _colors
      ..styleTags = _styleTags
      ..weatherTags = _weatherTags;
    widget.onApply(updated);
    Navigator.pop(context);
  }

  void _reset() => setState(() {
        _categories = {};
        _seasons = {};
        _colors = {};
        _styleTags = {};
        _weatherTags = {};
      });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.40,
      maxChildSize: 0.92,
      builder: (context, scrollController) => GlassSheet(
        child: Column(
              children: [
                const SizedBox(height: 14),
                // Gradient handle
                Container(
                  width: 36,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LCColors.gradientPink,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 18, 16, 0),
                  child: Row(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFD4789C), Color(0xFFE8A0BF)],
                        ).createShader(bounds),
                        child: Text(
                          'FILTER',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                letterSpacing: 2.5,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _reset,
                        child: Text(
                          'Zurücksetzen',
                          style: TextStyle(
                            color: LCColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Shimmer divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 1,
                    decoration: const BoxDecoration(
                      gradient: LCGlass.shimmerDivider,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Scrollable filter sections
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    children: [
                      _buildMultiSection('Kategorie', AppConstants.categories,
                          _categories,
                          (v) => setState(() => _categories.contains(v) ? _categories.remove(v) : _categories.add(v))),
                      _buildMultiSection('Saison', AppConstants.seasons,
                          _seasons,
                          (v) => setState(() => _seasons.contains(v) ? _seasons.remove(v) : _seasons.add(v))),
                      _buildMultiSection('Farbe', AppConstants.colorOptions,
                          _colors,
                          (v) => setState(() => _colors.contains(v) ? _colors.remove(v) : _colors.add(v))),
                      _buildMultiSection(
                          'Style',
                          [...AppConstants.styleTags, ...widget.customStyleTags],
                          _styleTags,
                          (v) => setState(() => _styleTags.contains(v) ? _styleTags.remove(v) : _styleTags.add(v))),
                      _buildMultiSection('Wetter', AppConstants.weatherTags,
                          _weatherTags,
                          (v) => setState(() => _weatherTags.contains(v) ? _weatherTags.remove(v) : _weatherTags.add(v))),
                    ],
                  ),
                ),
                // Apply button
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
                        onPressed: _apply,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text(
                          'Anwenden',
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

  Widget _buildMultiSection(
    String title,
    List<String> options,
    Set<String> selected,
    void Function(String) onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 2,
              decoration: BoxDecoration(
                gradient: LCColors.gradientPink,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: LCColors.textMuted,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSelected = selected.contains(opt);
            return GestureDetector(
              onTap: () => onTap(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFE8A0BF).withValues(alpha: 0.30)
                      : Colors.white.withValues(alpha: 0.65),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFD4789C).withValues(alpha: 0.8)
                        : const Color(0xFFE8A0BF).withValues(alpha: 0.4),
                    width: isSelected ? 1.2 : 0.8,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: LCColors.primary.withValues(alpha: 0.18),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  opt,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected ? LCColors.primary : LCColors.textMuted,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}
