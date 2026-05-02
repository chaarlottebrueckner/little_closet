import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_sheet.dart';
import '../../../../core/widgets/lc_chip.dart';
import '../../../../core/widgets/lc_section_label.dart';
import '../../../../data/database/app_database.dart';
import '../../../../data/repositories/outfit_repository.dart';
import '../../domain/outfit_with_items.dart';
import '../widgets/outfit_canvas_preview.dart';

const double _kMinSheet = 0.44;

class OutfitDetailPage extends ConsumerWidget {
  final OutfitWithItems outfitWithItems;
  final void Function(OutfitWithItems) onEdit;

  const OutfitDetailPage({
    super.key,
    required this.outfitWithItems,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(outfitByIdProvider(outfitWithItems.outfit.id), (_, next) {
      if (next.hasValue && next.value == null && context.mounted) {
        Navigator.pop(context);
      }
    });
    final current = ref
            .watch(outfitByIdProvider(outfitWithItems.outfit.id))
            .valueOrNull ??
        outfitWithItems;
    final outfit = current.outfit;
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
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 0,
            right: 0,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 32,
                  maxHeight: MediaQuery.of(context).size.height * (1 - _kMinSheet) -
                      MediaQuery.of(context).padding.top -
                      24,
                ),
                child: AspectRatio(
                  aspectRatio: kCanvasWidth / kCanvasHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: _buildCanvasPreview(current),
                  ),
                ),
              ),
            ),
          ),
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
            initialChildSize: _kMinSheet,
            minChildSize: _kMinSheet,
            maxChildSize: 0.85,
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
                      child: _buildInfo(context, outfit),
                    ),
                  ),
                  _buildActionBar(context, ref, current),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvasPreview(OutfitWithItems current) =>
      OutfitCanvasPreview(items: current.items);

  Widget _buildInfo(BuildContext context, Outfit outfit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (outfit.name.isNotEmpty) ...[
          Text(
            outfit.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 20),
        ],
        if (outfit.styleTags.isNotEmpty)
          _ChipRow(label: 'STYLE', values: outfit.styleTags),
        if (outfit.weatherTags.isNotEmpty)
          _ChipRow(label: 'WETTER', values: outfit.weatherTags),
        if (outfit.seasons.isNotEmpty)
          _ChipRow(label: 'SAISON', values: outfit.seasons),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildActionBar(BuildContext context, WidgetRef ref, OutfitWithItems current) {
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
                  onEdit(current);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: LCColors.primary.withValues(alpha: 0.6),
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
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
                  onPressed: () => _confirmDelete(context, ref, current),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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

  void _confirmDelete(BuildContext context, WidgetRef ref, OutfitWithItems current) {
    final name = current.outfit.name.isNotEmpty
        ? current.outfit.name
        : 'Dieses Outfit';
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
                  color: LCGlass.borderColor,
                  width: LCGlass.borderWidth,
                ),
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
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: LCColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Outfit löschen',
                    style: Theme.of(ctx).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Möchtest du "$name" wirklich löschen?',
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
                              color: LCColors.primary.withValues(alpha: 0.4),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Abbrechen',
                            style: TextStyle(color: LCColors.primary),
                          ),
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
                                  .read(outfitRepositoryProvider)
                                  .deleteOutfit(outfitWithItems.outfit.id);
                              if (context.mounted) Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Löschen',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
            children: values.map((v) => LCChip(label: v, isSelected: true)).toList(),
          ),
        ],
      ),
    );
  }
}
