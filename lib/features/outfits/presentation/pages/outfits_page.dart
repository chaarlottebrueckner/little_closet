import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/repositories/outfit_repository.dart';
import '../../domain/outfit_filters.dart';
import '../../domain/outfit_with_items.dart';
import '../widgets/outfit_card.dart';
import '../widgets/outfit_empty_state.dart';
import '../widgets/outfit_filter_sheet.dart';
import '../widgets/outfits_header.dart';

class OutfitsPage extends ConsumerStatefulWidget {
  const OutfitsPage({super.key});

  @override
  ConsumerState<OutfitsPage> createState() => _OutfitsPageState();
}

class _OutfitsPageState extends ConsumerState<OutfitsPage> {
  late final OutfitActiveFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = OutfitActiveFilters();
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
      builder: (context) => OutfitFilterSheet(
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background gradient
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
          // Pink radial glow bottom
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
          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutfitsHeader(
                  filters: _filters,
                  onFilterTap: _showFilterSheet,
                ),
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

  Widget _buildContent() {
    final outfitsAsync = ref.watch(outfitsProvider);
    return outfitsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
      data: (outfits) {
        final filtered = _applyFilters(outfits);
        if (filtered.isEmpty) return const OutfitEmptyState();
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: filtered.length,
          itemBuilder: (context, i) => OutfitCard(
            outfitWithItems: filtered[i],
            // onTap and onLongPress wired in Phase 4
          ),
        );
      },
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
      child: const FloatingActionButton.extended(
        // Navigation to editor wired in Phase 3
        onPressed: null,
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Outfit erstellen',
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
}
