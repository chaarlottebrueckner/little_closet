import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_sheet.dart';
import '../../../../core/widgets/lc_gradient_button.dart';
import '../../../../core/widgets/lc_sheet_handle.dart';

class CreateCollectionSheet extends StatefulWidget {
  const CreateCollectionSheet({
    super.key,
    this.existingName,
    required this.onSubmit,
    this.onCreated,
  });

  /// Non-null puts the sheet into rename mode.
  final String? existingName;

  /// Called with the trimmed name. The sheet closes itself after awaiting.
  /// In create mode, should return the new collection's ID; in rename mode null is fine.
  final Future<String?> Function(String name) onSubmit;

  /// Called with the new collection ID after creation (create mode only).
  final void Function(String collectionId)? onCreated;

  @override
  State<CreateCollectionSheet> createState() => _CreateCollectionSheetState();
}

class _CreateCollectionSheetState extends State<CreateCollectionSheet> {
  late final TextEditingController _controller;
  bool _loading = false;

  bool get _isRename => widget.existingName != null;
  bool get _canSubmit =>
      _controller.text.trim().isNotEmpty && !_loading;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existingName ?? '');
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() => _loading = true);
    final resultId = await widget.onSubmit(_controller.text.trim());
    if (mounted) {
      Navigator.pop(context);
      if (resultId != null) widget.onCreated?.call(resultId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return GlassSheet(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),
            const Center(child: LCSheetHandle()),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: ShaderMask(
                shaderCallback: (bounds) => LCColors.gradientPink
                    .createShader(bounds),
                child: Text(
                  _isRename ? 'UMBENENNEN' : 'KOLLEKTION ERSTELLEN',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 1,
                decoration:
                    const BoxDecoration(gradient: LCGlass.shimmerDivider),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: TextField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: const TextStyle(color: LCColors.textMuted),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: LCColors.accent.withValues(alpha: 0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: LCColors.primary, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: LCGradientButton(
                label: _isRename ? 'Speichern' : 'Erstellen',
                onPressed: _canSubmit ? _submit : null,
                isLoading: _loading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
