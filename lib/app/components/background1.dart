import 'package:flutter/material.dart';

class Background1 extends StatelessWidget {
  final Widget child;
  const Background1({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 0, child: Image.asset('assets/elements/Vector1.png')),
        Positioned(
            bottom: 0, child: Image.asset('assets/elements/Vector2.png')),
        Positioned(
            bottom: 0, child: Image.asset('assets/elements/Vector3.png')),
        child,
      ],
    );
  }
}
