import 'package:flutter/material.dart';

class Background2 extends StatelessWidget {
  final Widget child;
  const Background2({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            bottom: 0, child: Image.asset('assets/elements/Vector2.png')),
        Positioned(
            bottom: 0, child: Image.asset('assets/elements/Vector3.png')),
        child,
      ],
    );
  }
}
