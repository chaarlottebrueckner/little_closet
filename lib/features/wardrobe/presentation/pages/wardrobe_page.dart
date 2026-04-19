import 'dart:io';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/glass_sheet.dart';
import '../../../../core/widgets/photo_tips_dialog.dart';
import '../../../../data/database/app_database.dart';
import '../../../../data/repositories/clothing_repository.dart';
import 'clothing_detail_page.dart';
import 'upload_page.dart';

class WardrobePage extends ConsumerStatefulWidget {
  const WardrobePage({super.key});

  @override
  ConsumerState<WardrobePage> createState() => _WardrobePageState();
}

class _ActiveFilters {
  Set<String> categories = {};
  String? season;
  String? color;
  String? styleTag;
  String? weather;

  bool get hasAny =>
      categories.isNotEmpty ||
      season != null ||
      color != null ||
      styleTag != null ||
      weather != null;

  int get count =>
      categories.length +
      [season, color, styleTag, weather].where((v) => v != null).length;

  void clear() {
    categories = {};
    season = null;
    color = null;
    styleTag = null;
    weather = null;
  }
}

class _WardrobePageState extends ConsumerState<WardrobePage> {
  late final _ActiveFilters _filters;
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _filters = _ActiveFilters();
  }

  void _enterSelectionMode(String firstId) {
    setState(() {
      _isSelectionMode = true;
      _selectedIds..clear()..add(firstId);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedIds.clear();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) _isSelectionMode = false;
      } else {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSelectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isSelectionMode) _exitSelectionMode();
      },
      child: Scaffold(
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
                  if (_filters.hasAny && !_isSelectionMode) _buildActiveFilterChips(),
                  Expanded(child: _buildContent()),
                ],
              ),
            ),
            if (_isSelectionMode) _buildSelectionBar(),
          ],
        ),
        floatingActionButton: _isSelectionMode ? null : _buildFAB(),
      ),
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
                        : const Color(0xFFEDE0E8).withValues(alpha: 0.5),
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
      for (final cat in _filters.categories)
        MapEntry(cat, () => setState(() => _filters.categories.remove(cat))),
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
          _filters.categories = updated.categories;
          _filters.season = updated.season;
          _filters.color = updated.color;
          _filters.styleTag = updated.styleTag;
          _filters.weather = updated.weather;
        }),
      ),
    );
  }

  Widget _buildContent() {
    final itemsAsync = ref.watch(clothingItemsProvider);
    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
      data: (items) {
        final filtered = _applyFilters(items);
        if (filtered.isEmpty) return _buildEmptyState();
        return GridView.builder(
          padding: EdgeInsets.fromLTRB(16, 12, 16, _isSelectionMode ? 140 : 100),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: filtered.length,
          itemBuilder: (context, i) {
            final item = filtered[i];
            return _ClothingCard(
              item: item,
              isSelectionMode: _isSelectionMode,
              isSelected: _selectedIds.contains(item.id),
              onTap: _isSelectionMode
                  ? () => _toggleSelection(item.id)
                  : () => _openDetailPage(item),
              onLongPress: _isSelectionMode
                  ? null
                  : () => _enterSelectionMode(item.id),
            );
          },
        );
      },
    );
  }

  List<ClothingItem> _applyFilters(List<ClothingItem> items) {
    return items.where((item) {
      if (_filters.categories.isNotEmpty && !_filters.categories.contains(item.category)) {
        return false;
      }
      if (_filters.color != null && !item.colors.contains(_filters.color)) return false;
      if (_filters.season != null &&
          !item.seasons.contains(_filters.season)) {
        return false;
      }
      if (_filters.styleTag != null &&
          !item.styleTags.contains(_filters.styleTag)) {
        return false;
      }
      if (_filters.weather != null &&
          !item.weatherTags.contains(_filters.weather)) {
        return false;
      }
      return true;
    }).toList();
  }

  Widget _buildEmptyState() {
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

  Future<void> _checkAndShowPhotoTips() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('photo_tips_shown') ?? false;
    if (!shown && mounted) {
      await showDialog(
        context: context,
        barrierColor: Colors.black26,
        builder: (_) => const PhotoTipsDialog(),
      );
      await prefs.setBool('photo_tips_shown', true);
    }
  }

  void _showAddClothingOptions() async {
    await _checkAndShowPhotoTips();
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => GlassSheet(
        child: _AddClothingSheet(
          onImagePicked: _openUploadPage,
        ),
      ),
    );
  }

  void _openDetailPage(ClothingItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ClothingDetailPage(
        itemId: item.id,
        onEdit: _openEditFromDetail,
      ),
    );
  }

  void _openEditFromDetail(ClothingItem item) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => UploadPage(editItem: item),
    );
    if (saved == true && mounted) {
      _openDetailPage(item);
    }
  }

  Widget _buildSelectionBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: LCGlass.sheetColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: LCGlass.borderColor,
                    width: LCGlass.borderWidth,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4789C).withValues(alpha: 0.18),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${_selectedIds.length} ausgewählt',
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: LCColors.textDark,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: _exitSelectionMode,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        side: BorderSide(
                          color: LCColors.primary.withValues(alpha: 0.5),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Abbrechen',
                        style: TextStyle(
                          color: LCColors.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: _selectedIds.isEmpty
                            ? null
                            : LCColors.gradientPink,
                        color: _selectedIds.isEmpty
                            ? const Color(0xFFE8A0BF).withValues(alpha: 0.25)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _selectedIds.isEmpty
                            ? null
                            : [
                                BoxShadow(
                                  color:
                                      LCColors.primary.withValues(alpha: 0.30),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: TextButton.icon(
                        onPressed: _selectedIds.isEmpty
                            ? null
                            : _confirmBatchDelete,
                        icon: const Icon(Icons.delete_outline_rounded,
                            size: 17, color: Colors.white),
                        label: const Text(
                          'Löschen',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmBatchDelete() {
    final count = _selectedIds.length;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                color: LCGlass.sheetColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: LCGlass.borderColor, width: LCGlass.borderWidth),
              ),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4789C).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: LCColors.primary, size: 26),
                  ),
                  const SizedBox(height: 16),
                  Text('$count ${count == 1 ? 'Teil' : 'Teile'} löschen?',
                      style: Theme.of(ctx).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    count == 1
                        ? 'Dieses Teil wirklich aus der Garderobe entfernen?'
                        : 'Diese $count Teile wirklich aus der Garderobe entfernen?',
                    textAlign: TextAlign.center,
                    style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          color: LCColors.textMuted,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(
                                color: LCColors.primary.withValues(alpha: 0.4)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Abbrechen',
                              style: TextStyle(color: LCColors.primary)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LCColors.gradientPink,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              final idsToDelete =
                                  List<String>.from(_selectedIds);
                              Navigator.pop(ctx);
                              await ref
                                  .read(clothingRepositoryProvider)
                                  .deleteMultipleClothingItems(idsToDelete);
                              if (mounted) _exitSelectionMode();
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Löschen',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openUploadPage(XFile image) {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => UploadPage(image: image),
    );
  }
}

class _ClothingCard extends StatelessWidget {
  final ClothingItem item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelectionMode;
  final bool isSelected;

  const _ClothingCard({
    required this.item,
    this.onTap,
    this.onLongPress,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE8A0BF).withValues(alpha: 0.30)
              : (item.colors.isNotEmpty
                      ? AppConstants.colorMap[item.colors.first] ?? Colors.white
                      : Colors.white)
                  .withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4789C).withValues(alpha: 0.85)
                : const Color(0xFFE8A0BF).withValues(alpha: 0.3),
            width: isSelected ? 2.0 : 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFD4789C).withValues(alpha: 0.22)
                  : const Color(0xFFD4789C).withValues(alpha: 0.08),
              blurRadius: isSelected ? 18 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.file(
                      File(item.imagePath),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFF5EEF2),
                        child: const Icon(Icons.checkroom_outlined,
                            color: Color(0xFFD4789C), size: 36),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.subcategory ?? item.category,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.colors.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          item.colors.first,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: LCColors.textMuted,
                                fontSize: 11,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (isSelectionMode)
              Positioned(
                top: 10,
                right: 10,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? LCColors.primary
                        : Colors.white.withValues(alpha: 0.85),
                    border: Border.all(
                      color: isSelected
                          ? LCColors.primary
                          : const Color(0xFFD4789C).withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded,
                          size: 15, color: Colors.white)
                      : null,
                ),
              ),
          ],
        ),
      ),
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
  late Set<String> _categories;
  late String? _season;
  late String? _color;
  late String? _styleTag;
  late String? _weather;

  @override
  void initState() {
    super.initState();
    _categories = Set.of(widget.filters.categories);
    _season = widget.filters.season;
    _color = widget.filters.color;
    _styleTag = widget.filters.styleTag;
    _weather = widget.filters.weather;
  }

  void _apply() {
    final updated = _ActiveFilters()
      ..categories = _categories
      ..season = _season
      ..color = _color
      ..styleTag = _styleTag
      ..weather = _weather;
    widget.onApply(updated);
    Navigator.pop(context);
  }

  void _reset() => setState(() {
        _categories = {};
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
                      _buildMultiSection('Kategorie', AppConstants.categories,
                          _categories,
                          (v) => setState(() => _categories.contains(v) ? _categories.remove(v) : _categories.add(v))),
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

class _AddClothingSheet extends StatefulWidget {
  final void Function(XFile) onImagePicked;

  const _AddClothingSheet({required this.onImagePicked});

  @override
  State<_AddClothingSheet> createState() => _AddClothingSheetState();
}

class _AddClothingSheetState extends State<_AddClothingSheet> {
  final _picker = ImagePicker();

  Future<void> _pick(ImageSource source) async {
    Navigator.pop(context);
    final file = await _picker.pickImage(source: source, imageQuality: 85);
    if (file != null) widget.onImagePicked(file);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            onTap: () => _pick(ImageSource.camera),
          ),
          const SizedBox(height: 12),
          _SheetOption(
            icon: Icons.photo_library_outlined,
            title: 'Galerie',
            subtitle: 'Aus deinen Fotos auswählen',
            onTap: () => _pick(ImageSource.gallery),
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.65),
          border: Border.all(
            color: const Color(0xFFE8A0BF).withValues(alpha: 0.4),
            width: 0.8,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: LCColors.primary.withValues(alpha: 0.1),
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
