import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/glass_sheet.dart';
import '../../../../data/repositories/clothing_repository.dart';

class UploadPage extends ConsumerStatefulWidget {
  final XFile image;
  const UploadPage({super.key, required this.image});

  @override
  ConsumerState<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends ConsumerState<UploadPage> {
  late XFile _image;
  final _picker = ImagePicker();
  String? _category;
  String? _subcategory;
  String? _color;
  final Set<String> _seasons = {};
  final Set<String> _styleTags = {};
  final Set<String> _weatherTags = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _image = widget.image;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final repo = ref.read(clothingRepositoryProvider);
      final imagePath = await repo.saveImage(_image);
      await repo.saveClothingItem(
        imagePath: imagePath,
        category: _category!,
        subcategory: _subcategory,
        color: _color,
        seasons: _seasons.toList(),
        styleTags: _styleTags.toList(),
        weatherTags: _weatherTags.toList(),
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gespeichert! 🎀')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _replaceImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (_) => _ImageSourceSheet(),
    );
    if (source == null) return;
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) setState(() => _image = picked);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.93,
      maxChildSize: 0.97,
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
            const SizedBox(height: 8),
            _buildImageHeader(),
            Expanded(child: _buildForm(scrollController)),
            _buildSaveBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 240,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  kIsWeb
                      ? Image.network(_image.path, fit: BoxFit.cover)
                      : Image.file(File(_image.path), fit: BoxFit.cover),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0x44000000)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: _replaceImage,
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
                  Icons.edit_outlined,
                  size: 16,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
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
        ],
      ),
    );
  }

  Widget _buildForm(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('KATEGORIE', isRequired: true),
          const SizedBox(height: 12),
          _buildSingleSelectChips(
            options: AppConstants.categories,
            selected: _category,
            onTap: (v) => setState(() {
              _category = v == _category ? null : v;
              _subcategory = null;
            }),
          ),
          if (_category != null) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('UNTERKATEGORIE'),
            const SizedBox(height: 12),
            _buildSingleSelectChips(
              options: AppConstants.subcategories[_category!] ?? [],
              selected: _subcategory,
              onTap: (v) => setState(
                () => _subcategory = v == _subcategory ? null : v,
              ),
            ),
          ],
          const SizedBox(height: 24),
          _buildSectionHeader('FARBE'),
          const SizedBox(height: 12),
          _buildSingleSelectChips(
            options: AppConstants.colorOptions,
            selected: _color,
            onTap: (v) => setState(() => _color = v == _color ? null : v),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('SAISON'),
          const SizedBox(height: 12),
          _buildMultiSelectChips(
            options: AppConstants.seasons,
            selected: _seasons,
            onTap: (v) => setState(() {
              _seasons.contains(v) ? _seasons.remove(v) : _seasons.add(v);
            }),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('WETTER'),
          const SizedBox(height: 12),
          _buildMultiSelectChips(
            options: AppConstants.weatherTags,
            selected: _weatherTags,
            onTap: (v) => setState(() {
              _weatherTags.contains(v)
                  ? _weatherTags.remove(v)
                  : _weatherTags.add(v);
            }),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('STYLE'),
          const SizedBox(height: 12),
          _buildMultiSelectChips(
            options: AppConstants.styleTags,
            selected: _styleTags,
            onTap: (v) => setState(() {
              _styleTags.contains(v) ? _styleTags.remove(v) : _styleTags.add(v);
            }),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool isRequired = false}) {
    return Row(
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
          title,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: LCColors.textMuted,
                letterSpacing: 1.8,
                fontWeight: FontWeight.w600,
              ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 3),
          const Text(
            '*',
            style: TextStyle(
              color: LCColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSingleSelectChips({
    required List<String> options,
    required String? selected,
    required void Function(String) onTap,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options
          .map((opt) => _buildChip(
                label: opt,
                isSelected: selected == opt,
                onTap: () => onTap(opt),
              ))
          .toList(),
    );
  }

  Widget _buildMultiSelectChips({
    required List<String> options,
    required Set<String> selected,
    required void Function(String) onTap,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options
          .map((opt) => _buildChip(
                label: opt,
                isSelected: selected.contains(opt),
                onTap: () => onTap(opt),
              ))
          .toList(),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
                    color: LCColors.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected ? LCColors.primary : LCColors.textMuted,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
        ),
      ),
    );
  }

  Widget _buildSaveBar() {
    final canSave = _category != null;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: canSave ? 1.0 : 0.42,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LCColors.gradientPink,
              borderRadius: BorderRadius.circular(14),
              boxShadow: canSave
                  ? [
                      BoxShadow(
                        color: LCColors.primary.withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: canSave && !_isSaving ? _save : null,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
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
      ),
    );
  }
}

class _ImageSourceSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassSheet(
      child: Padding(
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
              'Foto ändern',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Wähle, wie du ein neues Foto aufnehmen möchtest.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: LCColors.textMuted,
                  ),
            ),
            const SizedBox(height: 28),
            _SourceOption(
              icon: Icons.camera_alt_outlined,
              title: 'Kamera',
              subtitle: 'Jetzt ein Foto aufnehmen',
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            const SizedBox(height: 12),
            _SourceOption(
              icon: Icons.photo_library_outlined,
              title: 'Galerie',
              subtitle: 'Aus deinen Fotos auswählen',
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SourceOption({
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
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
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
