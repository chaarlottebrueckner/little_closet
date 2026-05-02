import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class UploadImageHeader extends StatefulWidget {
  final Uint8List? processedImageBytes;
  final String imagePath;
  final String? loadingStatus;
  final bool isAiLoading;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  const UploadImageHeader({
    super.key,
    required this.imagePath,
    required this.onBack,
    required this.onEdit,
    this.processedImageBytes,
    this.loadingStatus,
    this.isAiLoading = false,
  });

  @override
  State<UploadImageHeader> createState() => _UploadImageHeaderState();
}

class _UploadImageHeaderState extends State<UploadImageHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.processedImageBytes != null
                      ? Image.memory(widget.processedImageBytes!, fit: BoxFit.contain)
                      : kIsWeb
                          ? Image.network(widget.imagePath, fit: BoxFit.contain)
                          : Image.file(File(widget.imagePath), fit: BoxFit.contain),
                  if (widget.loadingStatus != null)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.loadingStatus!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.isAiLoading)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.82),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ScaleTransition(
                              scale: _scale,
                              child: Image.asset(
                                'assets/images/heart.png',
                                width: 80,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'KI analysiert dein Kleidungsstück...',
                              style: TextStyle(
                                color: Color(0xFFD4789C),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
            child: _CircleButton(icon: Icons.edit_outlined, onTap: widget.onEdit),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: _CircleButton(
                icon: Icons.arrow_back_ios_new_rounded, onTap: widget.onBack),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
        child: Icon(icon, size: 15, color: const Color(0xFF1A1A1A)),
      ),
    );
  }
}
