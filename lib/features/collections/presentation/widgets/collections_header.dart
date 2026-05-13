import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CollectionsHeader extends StatelessWidget {
  const CollectionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFD4789C), Color(0xFFE8A0BF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: Text(
              'KOLLEKTIONEN',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                  ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 20,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LCColors.gradientPink,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Plane deine Events',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: LCColors.textMuted,
                      letterSpacing: 1.5,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
