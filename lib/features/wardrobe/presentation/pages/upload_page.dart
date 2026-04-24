import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/gemini_service.dart';
import '../../../../core/services/remove_bg_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_sheet.dart';
import '../../../../core/widgets/lc_chip.dart';
import '../../../../core/widgets/lc_section_label.dart';
import '../../../../data/database/app_database.dart';
import '../../../../data/repositories/clothing_repository.dart';
import '../widgets/image_source_sheet.dart';
import '../widgets/upload_image_header.dart';
import '../widgets/upload_save_bar.dart';

class UploadPage extends ConsumerStatefulWidget {
  final XFile? image;
  final ClothingItem? editItem;

  const UploadPage({super.key, this.image, this.editItem})
      : assert(image != null || editItem != null,
            'Either image or editItem must be provided');

  @override
  ConsumerState<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends ConsumerState<UploadPage> {
  XFile? _newImage;
  final _picker = ImagePicker();
  String? _category;
  String? _subcategory;
  final Set<String> _colors = {};
  final Set<String> _seasons = {};
  final Set<String> _styleTags = {};
  final Set<String> _weatherTags = {};
  bool _isSaving = false;
  bool _isAiLoading = false;
  String? _loadingStatus;
  Uint8List? _processedImageBytes;
  final Set<String> _aiFilledFields = {};
  final Set<String> _userTouchedFields = {};

  bool get _isEditing => widget.editItem != null;

  String get _imagePath =>
      _newImage?.path ?? widget.editItem!.imagePath;

  @override
  void initState() {
    super.initState();
    _newImage = widget.image;
    final e = widget.editItem;
    if (e != null) {
      _category = e.category;
      _subcategory = e.subcategory;
      _colors.addAll(e.colors);
      _seasons.addAll(e.seasons);
      _styleTags.addAll(e.styleTags);
      _weatherTags.addAll(e.weatherTags);
    } else if (widget.image != null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _processImage(widget.image!));
    }
  }

  Future<void> _processImage(XFile imageFile) async {
    if (!mounted) return;

    final sourceBytes = await imageFile.readAsBytes();
    Uint8List imageBytes = sourceBytes;

    setState(() => _loadingStatus = 'Hintergrund wird entfernt...');
    final removeBgService = ref.read(removeBgServiceProvider);
    final processedBytes = await removeBgService.removeBackground(sourceBytes);

    if (!mounted) return;

    if (processedBytes != null) {
      final trimmed = _trimTransparent(processedBytes);
      imageBytes = trimmed;
      setState(() => _processedImageBytes = trimmed);
    } else {
      _showRemoveBgFailureSnackbar();
    }

    setState(() {
      _loadingStatus = null;
      _isAiLoading = true;
    });

    final geminiService = ref.read(geminiServiceProvider);
    final result = await geminiService.classifyClothingFromBytes(
      imageBytes,
      mimeType: processedBytes != null ? 'image/png' : 'image/jpeg',
    );

    if (!mounted) return;
    if (result != null && result.hasAnyValue) {
      setState(() {
        if (result.category != null && !_userTouchedFields.contains('category')) {
          _category = result.category;
          _subcategory = null;
          _aiFilledFields.add('category');
        }
        if (result.subcategory != null &&
            !_userTouchedFields.contains('subcategory')) {
          _subcategory = result.subcategory;
          _aiFilledFields.add('subcategory');
        }
        if (result.colors.isNotEmpty && !_userTouchedFields.contains('color')) {
          _colors..clear()..addAll(result.colors);
          _aiFilledFields.add('color');
        }
        if (result.seasons.isNotEmpty &&
            !_userTouchedFields.contains('seasons')) {
          _seasons..clear()..addAll(result.seasons);
          _aiFilledFields.add('seasons');
        }
        if (result.styleTags.isNotEmpty &&
            !_userTouchedFields.contains('styleTags')) {
          _styleTags..clear()..addAll(result.styleTags);
          _aiFilledFields.add('styleTags');
        }
        if (result.weatherTags.isNotEmpty &&
            !_userTouchedFields.contains('weatherTags')) {
          _weatherTags..clear()..addAll(result.weatherTags);
          _aiFilledFields.add('weatherTags');
        }
      });
    }
    if (mounted) setState(() => _isAiLoading = false);
  }

  Uint8List _trimTransparent(Uint8List pngBytes) {
    final decoded = img.decodePng(pngBytes);
    if (decoded == null) return pngBytes;
    final trimmed = img.trim(decoded, mode: img.TrimMode.transparent);
    return Uint8List.fromList(img.encodePng(trimmed));
  }

  void _showRemoveBgFailureSnackbar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Hintergrund konnte nicht entfernt werden.'),
        backgroundColor: LCColors.primary.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _markUserTouched(String field) {
    _userTouchedFields.add(field);
    _aiFilledFields.remove(field);
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final repo = ref.read(clothingRepositoryProvider);
      final String imagePath;
      if (_newImage != null) {
        imagePath = _processedImageBytes != null
            ? await repo.saveImageBytes(_processedImageBytes!)
            : await repo.saveImage(_newImage!);
      } else {
        imagePath = widget.editItem!.imagePath;
      }

      if (_isEditing) {
        await repo.updateClothingItem(
          id: widget.editItem!.id,
          imagePath: imagePath,
          category: _category!,
          subcategory: _subcategory,
          colors: _colors.toList(),
          seasons: _seasons.toList(),
          styleTags: _styleTags.toList(),
          weatherTags: _weatherTags.toList(),
        );
      } else {
        await repo.saveClothingItem(
          imagePath: imagePath,
          category: _category!,
          subcategory: _subcategory,
          colors: _colors.toList(),
          seasons: _seasons.toList(),
          styleTags: _styleTags.toList(),
          weatherTags: _weatherTags.toList(),
        );
      }
      if (mounted) {
        Navigator.pop(context, _isEditing ? true : null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(_isEditing ? 'Gespeichert! ✨' : 'Gespeichert! 🎀')),
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
      builder: (_) => const ImageSourceSheet(),
    );
    if (source == null) return;
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      setState(() {
        _newImage = picked;
        _processedImageBytes = null;
      });
      _processImage(picked);
    }
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
            UploadImageHeader(
              imagePath: _imagePath,
              processedImageBytes: _processedImageBytes,
              loadingStatus: _loadingStatus,
              onBack: () => Navigator.pop(context),
              onEdit: _replaceImage,
            ),
            Expanded(child: _buildForm(scrollController)),
            UploadSaveBar(
              canSave: _category != null,
              isSaving: _isSaving,
              onSave: _save,
            ),
          ],
        ),
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
          LCSectionLabel('KATEGORIE',
              isRequired: true,
              isAiField: _aiFilledFields.contains('category'),
              isAiLoading: _isAiLoading),
          const SizedBox(height: 12),
          _buildChips(
            options: AppConstants.categories,
            isSelected: (v) => _category == v,
            onTap: (v) => setState(() {
              _markUserTouched('category');
              _markUserTouched('subcategory');
              _category = v == _category ? null : v;
              _subcategory = null;
            }),
          ),
          if (_category != null) ...[
            const SizedBox(height: 24),
            LCSectionLabel('UNTERKATEGORIE',
                isAiField: _aiFilledFields.contains('subcategory'),
                isAiLoading: _isAiLoading),
            const SizedBox(height: 12),
            _buildChips(
              options: AppConstants.subcategories[_category!] ?? [],
              isSelected: (v) => _subcategory == v,
              onTap: (v) => setState(() {
                _markUserTouched('subcategory');
                _subcategory = v == _subcategory ? null : v;
              }),
            ),
          ],
          const SizedBox(height: 24),
          LCSectionLabel('FARBE',
              isAiField: _aiFilledFields.contains('color'),
              isAiLoading: _isAiLoading),
          const SizedBox(height: 12),
          _buildChips(
            options: AppConstants.colorOptions,
            isSelected: (v) => _colors.contains(v),
            onTap: (v) => setState(() {
              _markUserTouched('color');
              _colors.contains(v) ? _colors.remove(v) : _colors.add(v);
            }),
          ),
          const SizedBox(height: 24),
          LCSectionLabel('SAISON',
              isAiField: _aiFilledFields.contains('seasons'),
              isAiLoading: _isAiLoading),
          const SizedBox(height: 12),
          _buildChips(
            options: AppConstants.seasons,
            isSelected: (v) => _seasons.contains(v),
            onTap: (v) => setState(() {
              _markUserTouched('seasons');
              _seasons.contains(v) ? _seasons.remove(v) : _seasons.add(v);
            }),
          ),
          const SizedBox(height: 24),
          LCSectionLabel('WETTER',
              isAiField: _aiFilledFields.contains('weatherTags'),
              isAiLoading: _isAiLoading),
          const SizedBox(height: 12),
          _buildChips(
            options: AppConstants.weatherTags,
            isSelected: (v) => _weatherTags.contains(v),
            onTap: (v) => setState(() {
              _markUserTouched('weatherTags');
              _weatherTags.contains(v)
                  ? _weatherTags.remove(v)
                  : _weatherTags.add(v);
            }),
          ),
          const SizedBox(height: 24),
          LCSectionLabel('STYLE',
              isAiField: _aiFilledFields.contains('styleTags'),
              isAiLoading: _isAiLoading),
          const SizedBox(height: 12),
          _buildChips(
            options: AppConstants.styleTags,
            isSelected: (v) => _styleTags.contains(v),
            onTap: (v) => setState(() {
              _markUserTouched('styleTags');
              _styleTags.contains(v) ? _styleTags.remove(v) : _styleTags.add(v);
            }),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildChips({
    required List<String> options,
    required bool Function(String) isSelected,
    required void Function(String) onTap,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options
          .map((opt) => LCChip(
                label: opt,
                isSelected: isSelected(opt),
                onTap: () => onTap(opt),
              ))
          .toList(),
    );
  }
}
