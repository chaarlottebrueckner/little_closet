import 'package:flutter/material.dart';

class LCPageBackground extends StatelessWidget {
  const LCPageBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        child,
      ],
    );
  }
}
