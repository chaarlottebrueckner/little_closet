import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_sheet.dart';
import '../../../../data/database/app_database.dart';
import '../../../../data/repositories/outfit_repository.dart';
import '../../../outfits/domain/editable_item.dart';
import '../../../outfits/domain/outfit_with_items.dart';
import '../widgets/outfit_editor_canvas.dart';
import '../widgets/outfit_item_tray.dart';
import '../widgets/outfit_save_sheet.dart';

class OutfitEditorPage extends ConsumerStatefulWidget {
  final OutfitWithItems? initialOutfit;

  const OutfitEditorPage({super.key, this.initialOutfit});

  @override
  ConsumerState<OutfitEditorPage> createState() => _OutfitEditorPageState();
}

class _OutfitEditorPageState extends ConsumerState<OutfitEditorPage> {
  final List<EditableItem> _items = [];
  String? _selectedItemId;
  bool _isSaving = false;
  final _sheetController = DraggableScrollableController();

  static const double _sheetMin = 0.35;
  static const double _sheetMax = 0.78;

  @override
  void initState() {
    super.initState();
    if (widget.initialOutfit != null) {
      _items.addAll(
        widget.initialOutfit!.items.map(
          (p) => EditableItem(
            item: p.item,
            posX: p.posX,
            posY: p.posY,
            scale: p.scale,
            rotation: p.rotation,
            zIndex: p.zIndex,
          ),
        ),
      );
    } else {
      // Peek animation to hint that the sheet is draggable
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        await _sheetController.animateTo(
          0.75,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
        await Future.delayed(const Duration(milliseconds: 700));
        if (!mounted) return;
        await _sheetController.animateTo(
          _sheetMin,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      });
    }
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _addItems(List<ClothingItem> items) {
    setState(() {
      for (final item in items) {
        final maxZ = _items.fold(0, (max, i) => i.zIndex > max ? i.zIndex : max);
        _items.add(EditableItem(
          item: item,
          posX: 130,
          posY: 230,
          scale: 1.8,
          zIndex: _items.isEmpty ? 0 : maxZ + 1,
        ));
      }
    });
    // Collapse sheet so user sees items appear on canvas
    _sheetController.animateTo(
      _sheetMin,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  void _bringToFront(String id) {
    final maxZ = _items.fold(0, (max, i) => i.zIndex > max ? i.zIndex : max);
    final item = _items.firstWhere((i) => i.id == id);
    if (item.zIndex < maxZ) {
      setState(() => item.zIndex = maxZ + 1);
    }
  }

  void _selectItem(String id) {
    _bringToFront(id);
    setState(() => _selectedItemId = id);
  }

  void _removeItem(String id) {
    setState(() {
      _items.removeWhere((e) => e.id == id);
      if (_selectedItemId == id) _selectedItemId = null;
      for (var i = 0; i < _items.length; i++) {
        _items[i].zIndex = i;
      }
    });
  }

  void _panItem(String id, double dx, double dy) {
    setState(() {
      final idx = _items.indexWhere((e) => e.id == id);
      if (idx == -1) return;
      final item = _items[idx];
      item.posX = (item.posX + dx).clamp(0.0, kCanvasWidth - kItemBaseWidth);
      item.posY = (item.posY + dy).clamp(0.0, kCanvasHeight - kItemBaseHeight);
    });
  }

  void _pinchItem(String id, double newScale, double newRotation) {
    setState(() {
      final idx = _items.indexWhere((e) => e.id == id);
      if (idx == -1) return;
      final item = _items[idx];
      item.scale = newScale.clamp(0.3, 3.0);
      item.rotation = newRotation;
    });
  }

  List<String> _intersectTags(List<String> Function(ClothingItem) getter) {
    if (_items.isEmpty) return [];
    final first = getter(_items.first.item).toSet();
    return _items
        .skip(1)
        .fold(first, (acc, e) => acc.intersection(getter(e.item).toSet()))
        .toList();
  }

  Future<void> _startSave() async {
    if (_items.isEmpty) return;
    setState(() => _isSaving = true);

    final isCreate = widget.initialOutfit == null;
    final outfitId = isCreate
        ? await ref.read(outfitRepositoryProvider).createOutfit()
        : widget.initialOutfit!.outfit.id;

    final suggestedStyle = isCreate
        ? _intersectTags((i) => i.styleTags)
        : widget.initialOutfit!.outfit.styleTags;
    final derivedWeather = isCreate
        ? _intersectTags((i) => i.weatherTags)
        : widget.initialOutfit!.outfit.weatherTags;
    final derivedSeasons = isCreate
        ? _intersectTags((i) => i.seasons)
        : widget.initialOutfit!.outfit.seasons;

    setState(() => _isSaving = false);

    if (!mounted) return;
    var saved = false;
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => OutfitSaveSheet(
        suggestedStyleTags: suggestedStyle,
        suggestedWeatherTags: derivedWeather,
        suggestedSeasons: derivedSeasons,
        onSave: (styleTags, weatherTags, seasons) {
          saved = true;
          _persistOutfit(outfitId, styleTags, weatherTags, seasons);
        },
      ),
    );

    if (!saved && mounted && isCreate) {
      ref.read(outfitRepositoryProvider).deleteOutfit(outfitId);
    }
  }

  Future<void> _persistOutfit(
    String outfitId,
    List<String> styleTags,
    List<String> weatherTags,
    List<String> seasons,
  ) async {
    final positionedItems = _items.map((e) => PositionedItem(
          item: e.item,
          posX: e.posX,
          posY: e.posY,
          scale: e.scale,
          rotation: e.rotation,
          zIndex: e.zIndex,
        )).toList();

    await ref.read(outfitRepositoryProvider).saveOutfitWithItems(
          outfitId: outfitId,
          name: '',
          items: positionedItems,
          styleTags: styleTags,
          weatherTags: weatherTags,
          seasons: seasons,
        );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.initialOutfit != null;
    return Scaffold(
      backgroundColor: LCColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFD4789C), Color(0xFFE8A0BF)],
          ).createShader(bounds),
          child: Text(
            isEditMode ? 'OUTFIT BEARBEITEN' : 'OUTFIT ERSTELLEN',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 1.5,
            ),
          ),
        ),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _items.isEmpty ? null : _startSave,
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: _items.isEmpty
                      ? [LCColors.textMuted, LCColors.textMuted]
                      : [const Color(0xFFD4789C), const Color(0xFFE8A0BF)],
                ).createShader(bounds),
                child: const Text(
                  'Speichern',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'DMSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final canvasAreaHeight = constraints.maxHeight * (1 - _sheetMin);
                return Column(
                  children: [
                    SizedBox(
                      height: canvasAreaHeight,
                      child: Stack(
                        children: [
                          // Pink gradient fills the side gaps
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: RadialGradient(
                                  center: Alignment.bottomCenter,
                                  radius: 1.2,
                                  colors: [
                                    Color(0xFFFFF0F7),
                                    Color(0xFFFAFAFA),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _selectedItemId = null),
                            behavior: HitTestBehavior.opaque,
                            child: OutfitEditorCanvas(
                              items: _items,
                              selectedItemId: _selectedItemId,
                              onItemSelect: _selectItem,
                              onItemRemove: _removeItem,
                              onItemPan: _panItem,
                              onItemPinch: _pinchItem,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: _sheetMin,
            minChildSize: _sheetMin,
            maxChildSize: _sheetMax,
            builder: (context, scrollController) => GlassSheet(
              child: OutfitItemSheet(
                scrollController: scrollController,
                alreadyAddedIds: _items.map((e) => e.item.id).toSet(),
                onItemsConfirmed: _addItems,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
