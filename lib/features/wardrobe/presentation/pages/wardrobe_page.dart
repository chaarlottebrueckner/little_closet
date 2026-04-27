import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_sheet.dart';
import '../../../../core/widgets/photo_tips_dialog.dart';
import '../../../../data/database/app_database.dart';
import '../../../../data/repositories/clothing_repository.dart';
import 'clothing_detail_page.dart';
import 'upload_page.dart';

import '../../domain/active_filters.dart';
import '../widgets/clothing_card.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/add_clothing_sheet.dart';
import '../widgets/wardrobe_header.dart';
import '../widgets/selection_bar.dart';
import '../widgets/wardrobe_empty_state.dart';

class WardrobePage extends ConsumerStatefulWidget {
  const WardrobePage({super.key});

  @override
  ConsumerState<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends ConsumerState<WardrobePage> {
  late final ActiveFilters _filters;
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _filters = ActiveFilters();
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
            //1. Hintergrund Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFF0F7), Color(0xFFFAFAFA)],
                  stops: [0.0, 0.45],
                ),
              ),
            ),
            //2. Pinker circular Gradient unten 
            Positioned(
              bottom: -210,
              left: -150,
              right: -150,
              child: Container(
                height: 700,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color(0x88F4A7C3),
                      Color.fromARGB(44, 246, 109, 159),
                      Color.fromARGB(0, 255, 255, 255),
                    ],
                    stops: [0.0, 0.45, 1.0],
                    radius: 0.5,
                  ),
                ),
              ),
            ),
            
            // 3. Inhalt: Header, Filterchips, Grid
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WardrobeHeader(
                    filters: _filters,
                    onFilterTap: _showFilterSheet,
                  ),
                  if (_filters.hasAny && !_isSelectionMode)
                    _buildActiveFilterChips(),
                  Expanded(child: _buildContent()),
                ],
              ),
            ),
            
            //4. Selection Bar - nur in Selection Mode
            if (_isSelectionMode)
              SelectionBar(
                selectedIds: _selectedIds,
                onCancel: _exitSelectionMode,
                onDeleted: _exitSelectionMode,
              ),
          ],
        ),
        floatingActionButton: _isSelectionMode ? null : _buildFAB(),
      ),
    );
  }

  Widget _buildActiveFilterChips() {
    final entries = <MapEntry<String, VoidCallback>>[
      for (final v in _filters.categories)
        MapEntry(v, () => setState(() => _filters.categories.remove(v))),
      for (final v in _filters.seasons)
        MapEntry(v, () => setState(() => _filters.seasons.remove(v))),
      for (final v in _filters.colors)
        MapEntry(v, () => setState(() => _filters.colors.remove(v))),
      for (final v in _filters.styleTags)
        MapEntry(v, () => setState(() => _filters.styleTags.remove(v))),
      for (final v in _filters.weatherTags)
        MapEntry(v, () => setState(() => _filters.weatherTags.remove(v))),
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
      builder: (context) => FilterSheet(
        filters: _filters,
        onApply: (updated) => setState(() {
          _filters.categories = updated.categories;
          _filters.seasons = updated.seasons;
          _filters.colors = updated.colors;
          _filters.styleTags = updated.styleTags;
          _filters.weatherTags = updated.weatherTags;
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
        if (filtered.isEmpty) return const WardrobeEmptyState();
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
            return ClothingCard(
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
      if (_filters.categories.isNotEmpty &&
          !_filters.categories.contains(item.category)) return false;
      if (_filters.colors.isNotEmpty && !_filters.colors.any(item.colors.contains)) return false;
      if (_filters.seasons.isNotEmpty && !_filters.seasons.any(item.seasons.contains)) return false;
      if (_filters.styleTags.isNotEmpty && !_filters.styleTags.any(item.styleTags.contains)) return false;
      if (_filters.weatherTags.isNotEmpty && !_filters.weatherTags.any(item.weatherTags.contains)) return false;
      return true;
    }).toList();
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
        child: AddClothingSheet(onImagePicked: _openUploadPage),
      ),
    );
  }

  void _openDetailPage(ClothingItem item) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ClothingDetailPage(
          itemId: item.id,
          onEdit: _openEditFromDetail,
        ),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
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
    if (saved == true && mounted) { _openDetailPage(item); }
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
