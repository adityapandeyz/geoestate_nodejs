import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';

class InnerShadowMod extends StatelessWidget {
  final Widget child;
  const InnerShadowMod({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return InnerShadow(
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 3,
          offset: const Offset(10, 10),
        )
      ],
      child: child,
    );
  }
}
