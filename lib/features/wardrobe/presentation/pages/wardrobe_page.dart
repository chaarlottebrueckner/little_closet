import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/glass_sheet.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _ActiveFilters {
  String? category;
  String? season;
  String? color;
  String? styleTag;
  String? weather;

  bool get hasAny =>
      category != null ||
      season != null ||
      color != null ||
      styleTag != null ||
      weather != null;

  int get count => [category, season, color, styleTag, weather]
      .where((v) => v != null)
      .length;

  void clear() {
    category = null;
    season = null;
    color = null;
    styleTag = null;
    weather = null;
  }
}

class _WardrobePageState extends State<WardrobePage> {
  late final _ActiveFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = _ActiveFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background: subtle linear gradient from top
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF0F7), // very light pink at top
                  Color(0xFFFAFAFA), // near-white in middle/bottom
                ],
                stops: [0.0, 0.45],
              ),
            ),
          ),
          // Background: radial pink glow blob at bottom
          Positioned(
            bottom: -210,
            left: -150,
            right: -150,
            child: Container(
              height: 700,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0x88F4A7C3), // warm pink, visible center
                    Color.fromARGB(44, 246, 109, 159), // mid fade
                    Color.fromARGB(0, 255, 255, 255),
                  ],
                  stops: [0.0, 0.45, 1.0],
                  radius: 0.5,
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                if (_filters.hasAny) _buildActiveFilterChips(),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFD4789C), Color(0xFFE8A0BF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: Text(
                    'LITTLE CLOSET',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                        ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LCColors.gradientPink,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Meine Garderobe',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: LCColors.textMuted,
                            letterSpacing: 1.5,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Filter icon button
          GestureDetector(
            onTap: _showFilterSheet,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _filters.hasAny
                        ? LCColors.primary.withValues(alpha: 0.12)
                        : const Color(0xFFEDE0E8).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _filters.hasAny
                          ? LCColors.primary.withValues(alpha: 0.4)
                          : const Color(0xFFEDE0E8),
                    ),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: _filters.hasAny ? LCColors.primary : LCColors.textMuted,
                    size: 22,
                  ),
                ),
                if (_filters.hasAny)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        gradient: LCColors.gradientPink,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${_filters.count}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChips() {
    final entries = <MapEntry<String, VoidCallback>>[
      if (_filters.category != null)
        MapEntry(_filters.category!, () => setState(() => _filters.category = null)),
      if (_filters.season != null)
        MapEntry(_filters.season!, () => setState(() => _filters.season = null)),
      if (_filters.color != null)
        MapEntry(_filters.color!, () => setState(() => _filters.color = null)),
      if (_filters.styleTag != null)
        MapEntry(_filters.styleTag!, () => setState(() => _filters.styleTag = null)),
      if (_filters.weather != null)
        MapEntry(_filters.weather!, () => setState(() => _filters.weather = null)),
    ];

    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: entries.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InputChip(
            label: Text(entries[i].key),
            onDeleted: entries[i].value,
            deleteIconColor: LCColors.primary,
          ),
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _FilterSheet(
        filters: _filters,
        onApply: (updated) => setState(() {
          _filters.category = updated.category;
          _filters.season = updated.season;
          _filters.color = updated.color;
          _filters.styleTag = updated.styleTag;
          _filters.weather = updated.weather;
        }),
      ),
    );
  }

  Widget _buildContent() {
    // Placeholder — wird in späteren Schritten mit echten Daten gefüllt
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LCColors.gradientPink,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.checkroom_outlined,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Dein Kleiderschrank ist leer.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: LCColors.textDark,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Füge dein erstes Kleidungsstück hinzu.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: LCColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
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
        onPressed: _showAddClothingOptions,
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Kleidung hinzufügen',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'DMSans',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  void _showAddClothingOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: LCColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _AddClothingSheet(),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final _ActiveFilters filters;
  final void Function(_ActiveFilters) onApply;

  const _FilterSheet({required this.filters, required this.onApply});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String? _category;
  late String? _season;
  late String? _color;
  late String? _styleTag;
  late String? _weather;

  @override
  void initState() {
    super.initState();
    _category = widget.filters.category;
    _season = widget.filters.season;
    _color = widget.filters.color;
    _styleTag = widget.filters.styleTag;
    _weather = widget.filters.weather;
  }

  void _apply() {
    final updated = _ActiveFilters()
      ..category = _category
      ..season = _season
      ..color = _color
      ..styleTag = _styleTag
      ..weather = _weather;
    widget.onApply(updated);
    Navigator.pop(context);
  }

  void _reset() => setState(() {
        _category = null;
        _season = null;
        _color = null;
        _styleTag = null;
        _weather = null;
      });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
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
                      _buildSection('Kategorie', AppConstants.categories,
                          _category, (v) => setState(() => _category = v)),
                      _buildSection('Saison', AppConstants.seasons, _season,
                          (v) => setState(() => _season = v)),
                      _buildSection('Farbe', AppConstants.colorOptions, _color,
                          (v) => setState(() => _color = v)),
                      _buildSection('Style', AppConstants.styleTags, _styleTag,
                          (v) => setState(() => _styleTag = v)),
                      _buildSection('Wetter', AppConstants.weatherTags,
                          _weather, (v) => setState(() => _weather = v)),
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

  Widget _buildSection(
    String title,
    List<String> options,
    String? selected,
    void Function(String?) onTap,
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
            final isSelected = selected == opt;
            return GestureDetector(
              onTap: () => onTap(isSelected ? null : opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFE8A0BF).withValues(alpha: 0.22)
                      : Colors.white.withValues(alpha: 0.45),
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
                        color:
                            isSelected ? LCColors.primary : LCColors.textMuted,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
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

class _AddClothingSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: LCColors.chrome,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Kleidung hinzufügen',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Wähle, wie du ein Foto aufnehmen möchtest.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: LCColors.textMuted,
                ),
          ),
          const SizedBox(height: 28),
          _SheetOption(
            icon: Icons.camera_alt_outlined,
            title: 'Kamera',
            subtitle: 'Jetzt ein Foto aufnehmen',
            onTap: () {
              Navigator.pop(context);
              // TODO: Kamera öffnen (Schritt 2)
            },
          ),
          const SizedBox(height: 12),
          _SheetOption(
            icon: Icons.photo_library_outlined,
            title: 'Galerie',
            subtitle: 'Aus deinen Fotos auswählen',
            onTap: () {
              Navigator.pop(context);
              // TODO: Galerie öffnen (Schritt 2)
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFEDE0E8)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: LCColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: LCColors.primary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  Text(subtitle,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: LCColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
