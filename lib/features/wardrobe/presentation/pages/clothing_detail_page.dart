import 'dart:io';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_sheet.dart';
import '../../../../core/widgets/lc_chip.dart';
import '../../../../core/widgets/lc_section_label.dart';
import '../../../../data/database/app_database.dart';
import '../../../../data/repositories/clothing_repository.dart';
import '../../../../data/repositories/outfit_repository.dart';
import '../../../outfits/domain/outfit_with_items.dart';
import '../../../outfits/presentation/pages/outfit_detail_page.dart';
import '../../../outfits/presentation/pages/outfit_editor_page.dart';
import '../widgets/outfit_usage_section.dart';

class ClothingDetailPage extends ConsumerWidget {
  final String itemId;
  final void Function(ClothingItem) onEdit;

  const ClothingDetailPage({
    super.key,
    required this.itemId,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(clothingItemByIdProvider(itemId));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: itemAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (item) {
          if (item == null) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (context.mounted && Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            });
            return const SizedBox();
          }
          return Stack(
            children: [
              // Hintergrund-Gradient (identisch zur WardrobePage)
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
              // Pinker Blob unten (stärker, da hinter Glass-Sheet)
              Positioned(
                bottom: -280,
                left: -60,
                right: -60,
                child: Container(
                  height: 600,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color(0xEEF4A7C3),
                        Color.fromARGB(160, 246, 109, 159),
                        Color.fromARGB(0, 255, 255, 255),
                      ],
                      stops: [0.0, 0.4, 1.0],
                      radius: 0.55,
                    ),
                  ),
                ),
              ),
              // Farbiger Blob hinter dem Foto (Farbe des Kleidungsstücks)
              Positioned(
                top: 10,
                left: -40,
                right: -40,
                child: Builder(builder: (context) {
                  final itemColor = item.colors.isNotEmpty
                      ? (AppConstants.colorMap[item.colors.first] ?? const Color(0xFFD4789C))
                      : const Color(0xFFD4789C);
                  return Container(
                    height: 500,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          itemColor.withValues(alpha: 0.60),
                          itemColor.withValues(alpha: 0.25),
                          itemColor.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                        radius: 0.55,
                      ),
                    ),
                  );
                }),
              ),
              // Bild oben mit Padding
              Positioned(
                top: MediaQuery.of(context).padding.top + 56,
                left: 24,
                right: 24,
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(item.imagePath),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.checkroom_outlined,
                          color: Color(0xFFD4789C), size: 48),
                    ),
                  ),
                ),
              ),
              // Zurück-Button
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.80),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 15,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.48,
                minChildSize: 0.43,
                maxChildSize: 0.82,
                builder: (ctx, scrollController) => GlassSheet(
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
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                          child: _buildInfo(context, ref, item),
                        ),
                      ),
                      _buildActionBar(context, ref, item),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfo(BuildContext context, WidgetRef ref, ClothingItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(label: 'KATEGORIE', value: item.category),
        if (item.subcategory != null)
          _InfoRow(label: 'UNTERKATEGORIE', value: item.subcategory!),
        if (item.colors.isNotEmpty) _ChipRow(label: 'FARBE', values: item.colors),
        if (item.seasons.isNotEmpty)
          _ChipRow(label: 'SAISON', values: item.seasons),
        if (item.weatherTags.isNotEmpty)
          _ChipRow(label: 'WETTER', values: item.weatherTags),
        if (item.styleTags.isNotEmpty)
          _ChipRow(label: 'STYLE', values: item.styleTags),
        OutfitUsageSection(
          itemId: item.id,
          onOutfitTap: (owi) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => OutfitDetailPage(
                  outfitWithItems: owi,
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
            );
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildActionBar(BuildContext context, WidgetRef ref, ClothingItem item) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onEdit(item);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                      color: LCColors.primary.withValues(alpha: 0.6),
                      width: 1.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'Bearbeiten',
                  style: TextStyle(
                    color: LCColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LCColors.gradientPink,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: LCColors.primary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () => _confirmDelete(context, ref, item),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Löschen',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
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

  void _confirmDelete(BuildContext context, WidgetRef ref, ClothingItem item) {
    final usedInOutfits =
        ref.read(outfitsContainingItemProvider(item.id)).valueOrNull ?? [];
    final outfitCount = usedInOutfits.length;

    final title = outfitCount > 0 ? 'In Outfits verwendet' : 'Löschen?';
    final body = outfitCount > 0
        ? 'Dieses Teil wird in $outfitCount Outfit${outfitCount == 1 ? '' : 's'} verwendet. Beim Löschen wird es aus allen Outfits entfernt.'
        : 'Dieses Teil wirklich aus der Garderobe entfernen?';
    final confirmLabel = outfitCount > 0 ? 'Trotzdem löschen' : 'Löschen';

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
                  Text(title, style: Theme.of(ctx).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    body,
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
                              Navigator.pop(ctx);
                              if (outfitCount > 0) {
                                await ref
                                    .read(outfitRepositoryProvider)
                                    .removeClothingItemFromAllOutfits(item.id);
                              }
                              await ref
                                  .read(clothingRepositoryProvider)
                                  .deleteClothingItem(item.id);
                              // detail page auto-pops via stream (item becomes null)
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(confirmLabel,
                                style: const TextStyle(
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LCSectionLabel(label),
          const SizedBox(height: 8),
          LCChip(label: value, isSelected: true),
        ],
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  final String label;
  final List<String> values;

  const _ChipRow({required this.label, required this.values});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LCSectionLabel(label),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values
                .map((v) => LCChip(label: v, isSelected: true))
                .toList(),
          ),
        ],
      ),
    );
  }
}
