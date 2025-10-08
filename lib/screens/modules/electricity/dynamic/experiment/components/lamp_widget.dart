// lib/screens/modules/electricity/dynamic/experiment/components/lamp_widget.dart

import 'package:flutter/material.dart';

class LampWidget extends StatelessWidget {
  final bool isLit;
  final double brightnessFactor; // 0.0 - 1.0

  const LampWidget({
    super.key,
    required this.isLit,
    this.brightnessFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final Color lightColor = isLit
        ? Color.lerp(Colors.orange[100], Colors.yellow, brightnessFactor)!
        : Colors.grey[300]!;

    final List<BoxShadow> shadows = isLit
        ? [
            BoxShadow(
              color: lightColor.withOpacity(0.8),
              blurRadius: 15.0 * brightnessFactor,
              spreadRadius: 5.0 * brightnessFactor,
            ),
          ]
        : [];

    return Column(
      children: [
        // Filamen dan Kaca Lampu (50x60)
        Container(
          width: 50,
          height: 60,
          decoration: BoxDecoration(
            color: lightColor.withOpacity(0.6),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1),
            boxShadow: shadows,
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 15,
              decoration: BoxDecoration(
                color: isLit ? Colors.orange : Colors.grey[700],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        // Basis Lampu (50x10)
        Container(
          width: 25,
          height: 10,
          color: Colors.grey[700],
        ),
      ],
    );
  }
}