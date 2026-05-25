import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class OutfitTutorialOverlay extends StatefulWidget {
  final VoidCallback onDismiss;

  const OutfitTutorialOverlay({super.key, required this.onDismiss});

  @override
  State<OutfitTutorialOverlay> createState() => _OutfitTutorialOverlayState();
}

class _OutfitTutorialOverlayState extends State<OutfitTutorialOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final AnimationController _dragCtrl;
  late final AnimationController _pinchCtrl;
  late final AnimationController _rotateCtrl;

  late final Animation<double> _fadeAnim;
  late final Animation<double> _dragAnim;
  late final Animation<double> _pinchAnim;
  late final Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
      ..forward();
    _dragCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _pinchCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))
      ..repeat(reverse: true);
    _rotateCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))
      ..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _dragAnim = CurvedAnimation(parent: _dragCtrl, curve: Curves.easeInOut);
    _pinchAnim = CurvedAnimation(parent: _pinchCtrl, curve: Curves.easeInOut);
    _rotateAnim = CurvedAnimation(parent: _rotateCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _dragCtrl.dispose();
    _pinchCtrl.dispose();
    _rotateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: GestureDetector(
        onTap: widget.onDismiss,
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.black.withValues(alpha: 0.55),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {},
            child: _TutorialCard(
              dragAnimation: _dragAnim,
              pinchAnimation: _pinchAnim,
              rotateAnimation: _rotateAnim,
              onDismiss: widget.onDismiss,
            ),
          ),
        ),
      ),
    );
  }
}

class _TutorialCard extends StatelessWidget {
  final Animation<double> dragAnimation;
  final Animation<double> pinchAnimation;
  final Animation<double> rotateAnimation;
  final VoidCallback onDismiss;

  const _TutorialCard({
    required this.dragAnimation,
    required this.pinchAnimation,
    required this.rotateAnimation,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: LCGlass.blurSigma, sigmaY: LCGlass.blurSigma),
          child: Container(
            decoration: BoxDecoration(
              color: LCGlass.sheetColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: LCGlass.borderColor, width: LCGlass.borderWidth),
            ),
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFD4789C), Color(0xFFE8A0BF)],
                  ).createShader(bounds),
                  child: const Text(
                    'SO GEHT\'S',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Gestalte deinen Look',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: LCColors.textDark,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _DragHint(animation: dragAnimation),
                    _PinchHint(animation: pinchAnimation),
                    _RotateHint(animation: rotateAnimation),
                  ],
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onDismiss,
                    child: const Text('Verstanden!'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DragHint extends StatelessWidget {
  final Animation<double> animation;

  const _DragHint({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 76,
          height: 76,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              final t = animation.value;
              return Stack(
                alignment: Alignment.center,
                children: [
                  const _MiniItem(),
                  Transform.translate(
                    offset: Offset(-16.0 + 32.0 * t, 10.0 - 20.0 * t),
                    child: const _FingerDot(),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Verschieben',
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: LCColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _PinchHint extends StatelessWidget {
  final Animation<double> animation;

  const _PinchHint({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 76,
          height: 76,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              final t = animation.value;
              final dist = 10.0 + 22.0 * t;
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 26.0 + 12.0 * t,
                    height: 32.0 + 14.0 * t,
                    decoration: BoxDecoration(
                      color: LCColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: LCColors.primary.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(-dist, -dist * 0.6),
                    child: const _FingerDot(),
                  ),
                  Transform.translate(
                    offset: Offset(dist, dist * 0.6),
                    child: const _FingerDot(),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Skalieren',
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: LCColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _RotateHint extends StatelessWidget {
  final Animation<double> animation;

  const _RotateHint({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 76,
          height: 76,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              final angle = -0.5 + 1.2 * animation.value;
              const radius = 26.0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: angle * 0.5,
                    child: const _MiniItem(),
                  ),
                  Transform.translate(
                    offset: Offset(
                      radius * math.cos(angle),
                      radius * math.sin(angle),
                    ),
                    child: const _FingerDot(),
                  ),
                  Transform.translate(
                    offset: Offset(
                      radius * math.cos(angle + math.pi),
                      radius * math.sin(angle + math.pi),
                    ),
                    child: const _FingerDot(),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Drehen',
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: LCColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _MiniItem extends StatelessWidget {
  const _MiniItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 36,
      decoration: BoxDecoration(
        color: LCColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: LCColors.primary.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
    );
  }
}

class _FingerDot extends StatelessWidget {
  const _FingerDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: LCColors.primary.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: LCColors.primary.withValues(alpha: 0.4),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
