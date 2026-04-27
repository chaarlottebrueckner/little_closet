import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class UploadImageHeader extends StatelessWidget {
  final Uint8List? processedImageBytes;
  final String imagePath;
  final String? loadingStatus;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  const UploadImageHeader({
    super.key,
    required this.imagePath,
    required this.onBack,
    required this.onEdit,
    this.processedImageBytes,
    this.loadingStatus,
  });

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
                  processedImageBytes != null
                      ? Image.memory(processedImageBytes!, fit: BoxFit.contain)
                      : kIsWeb
                          ? Image.network(imagePath, fit: BoxFit.contain)
                          : Image.file(File(imagePath), fit: BoxFit.contain),
if (loadingStatus != null)
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
                              loadingStatus!,
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
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: _CircleButton(icon: Icons.edit_outlined, onTap: onEdit),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: _CircleButton(
                icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
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
