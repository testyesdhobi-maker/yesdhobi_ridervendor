import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final double borderRadius;
  final double iconSize;

  const AppLogo({
    super.key,
    this.size = 80,
    this.backgroundColor = const Color(0xFF5C71F2), 
    this.iconColor = Colors.white,
    this.borderRadius = 20,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(
          Icons.u_turn_left, // Alternatively Icons.undo could work
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
