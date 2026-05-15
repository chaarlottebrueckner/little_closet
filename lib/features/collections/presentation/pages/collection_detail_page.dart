import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/repositories/collection_repository.dart';
import '../../../outfits/domain/outfit_filters.dart';
import '../../../outfits/domain/outfit_with_items.dart';
import '../../../outfits/presentation/pages/outfit_detail_page.dart';
import '../../../outfits/presentation/pages/outfit_editor_page.dart';
import '../../../outfits/presentation/widgets/outfit_card.dart';
import '../../../outfits/presentation/widgets/outfit_filter_sheet.dart';
import '../../domain/collection_with_content.dart';
import '../widgets/create_collection_sheet.dart';
import '../widgets/outfit_picker_sheet.dart';

class CollectionDetailPage extends ConsumerStatefulWidget {
  const CollectionDetailPage({
    super.key,
    required this.collectionId,
    this.openPickerOnLoad = false,
  });

  final String collectionId;
  final bool openPickerOnLoad;

  @override
  ConsumerState<CollectionDetailPage> createState() =>
      _CollectionDetailPageState();
}

class _CollectionDetailPageState extends ConsumerState<CollectionDetailPage> {
  late final OutfitActiveFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = OutfitActiveFilters();
    if (widget.openPickerOnLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openPicker());
    }
  }

  void _openPicker() {
    if (!mounted) return;
    final current =
        ref.read(collectionByIdProvider(widget.collectionId)).valueOrNull;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OutfitPickerSheet(
        collectionId: widget.collectionId,
        initialOutfitIds:
            Set.from(current?.outfits.map((o) => o.outfit.id) ?? []),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => OutfitFilterSheet(
        filters: _filters,
        onApply: (updated) => setState(() {
          _filters.styleTags = updated.styleTags;
          _filters.weatherTags = updated.weatherTags;
          _filters.seasons = updated.seasons;
        }),
      ),
    );
  }

  List<OutfitWithItems> _applyFilters(List<OutfitWithItems> outfits) {
    return outfits.where((owi) {
      if (_filters.styleTags.isNotEmpty &&
          !_filters.styleTags.any(owi.outfit.styleTags.contains)) {
        return false;
      }
      if (_filters.seasons.isNotEmpty &&
          !_filters.seasons.any(owi.outfit.seasons.contains)) {
        return false;
      }
      if (_filters.weatherTags.isNotEmpty &&
          !_filters.weatherTags.any(owi.outfit.weatherTags.contains)) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(collectionByIdProvider(widget.collectionId), (_, next) {
      if (next.hasValue && next.value == null && context.mounted) {
        Navigator.pop(context);
      }
    });

    final data =
        ref.watch(collectionByIdProvider(widget.collectionId)).valueOrNull;

    final outfits = data?.outfits ?? [];
    final filtered = _applyFilters(outfits);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFF0F7), Color(0xFFFAFAFA)],
                  stops: [0.0, 0.45],
                ),
              ),
            ),
          ),
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
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context, data),
                if (_filters.hasAny) _buildActiveFilterChips(),
                const SizedBox(height: 8),
                Expanded(child: _buildContent(context, data, filtered)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: data != null ? _buildFAB() : null,
    );
  }

  Widget _buildAppBar(BuildContext context, CollectionWithContent? data) {
    final name = data?.collection.name ?? '';
    final filterCount = _filters.count;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Color(0xFF1A1A1A),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  LCColors.gradientPink.createShader(bounds),
              child: Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Filter button
          GestureDetector(
            onTap: _showFilterSheet,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: filterCount > 0
                        ? LCColors.primary.withValues(alpha: 0.12)
                        : const Color(0xFFEDE0E8).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: filterCount > 0
                          ? LCColors.primary.withValues(alpha: 0.4)
                          : const Color(0xFFEDE0E8),
                    ),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: filterCount > 0 ? LCColors.primary : LCColors.textMuted,
                    size: 22,
                  ),
                ),
                if (filterCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        gradient: LCColors.gradientPink,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$filterCount',
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
          const SizedBox(width: 4),
          if (data != null) ...[
            IconButton(
              icon: const Icon(Icons.edit_rounded,
                  size: 18, color: LCColors.primary),
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => CreateCollectionSheet(
                  existingName: data.collection.name,
                  onSubmit: (newName) async {
                    await ref
                        .read(collectionRepositoryProvider)
                        .renameCollection(data.collection.id, newName);
                    return null;
                  },
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  size: 18, color: LCColors.primary),
              onPressed: () => _confirmDelete(context, data),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveFilterChips() {
    final entries = <MapEntry<String, VoidCallback>>[
      for (final v in _filters.styleTags)
        MapEntry(v, () => setState(() => _filters.styleTags.remove(v))),
      for (final v in _filters.seasons)
        MapEntry(v, () => setState(() => _filters.seasons.remove(v))),
      for (final v in _filters.weatherTags)
        MapEntry(v, () => setState(() => _filters.weatherTags.remove(v))),
    ];

    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: entries.length,
        itemBuilder: (_, i) => Padding(
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

  Widget _buildContent(BuildContext context, CollectionWithContent? data,
      List<OutfitWithItems> filtered) {
    if (data == null) {
      return const Center(
          child: CircularProgressIndicator(color: LCColors.primary));
    }
    if (data.outfits.isEmpty) {
      return _buildEmptyState(isFiltered: false);
    }
    if (filtered.isEmpty) {
      return _buildEmptyState(isFiltered: true);
    }

    final itemWidth = (MediaQuery.of(context).size.width - 32 - 12) / 2;
    final mainAxisExtent = itemWidth / 0.65;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: mainAxisExtent,
      ),
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        final outfit = filtered[i];
        return OutfitCard(
          outfitWithItems: outfit,
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => OutfitDetailPage(
                outfitWithItems: outfit,
                onEdit: (o) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OutfitEditorPage(initialOutfit: o),
                  ),
                ),
              ),
              transitionsBuilder: (_, animation, __, child) => SlideTransition(
                position: Tween(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
              transitionDuration: const Duration(milliseconds: 350),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({required bool isFiltered}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: LCColors.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.style_outlined,
                size: 32, color: LCColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            isFiltered ? 'Keine Outfits gefunden' : 'Noch keine Outfits',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isFiltered
                ? 'Passe die Filter an'
                : 'Tippe auf + um Outfits hinzuzufügen',
            style: const TextStyle(color: LCColors.textMuted, fontSize: 13),
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
        onPressed: _openPicker,
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Outfit hinzufügen',
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

  void _confirmDelete(BuildContext context, CollectionWithContent data) {
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
                  Text('Kollektion löschen',
                      style: Theme.of(ctx).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    'Möchtest du "${data.collection.name}" wirklich löschen? Enthaltene Outfits bleiben erhalten.',
                    textAlign: TextAlign.center,
                    style: Theme.of(ctx)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: LCColors.textMuted),
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
                              Navigator.pop(ctx);
                              await ref
                                  .read(collectionRepositoryProvider)
                                  .deleteCollection(data.collection.id);
                              if (context.mounted) Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
}
