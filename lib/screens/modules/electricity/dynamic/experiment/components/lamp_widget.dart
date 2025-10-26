import 'package:flutter/material.dart';

class LampWidget extends StatelessWidget {
  final bool isLit;
  final double brightnessFactor;
  final Color color;             

  const LampWidget({
    Key? key,
    required this.isLit,
    this.brightnessFactor = 1.0,
    this.color = Colors.yellow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Warna utama lampu (dinamis)
    final Color lightColor = isLit
        ? color.withOpacity(brightnessFactor.clamp(0.0, 1.0))
        : Colors.grey[300]!;

    final List<BoxShadow> shadows = isLit
        ? [
            BoxShadow(
              color: lightColor.withOpacity(0.7),
              blurRadius: 25.0 * brightnessFactor,
              spreadRadius: 10.0 * brightnessFactor,
            ),
            BoxShadow(
              color: lightColor.withOpacity(0.3),
              blurRadius: 50.0 * brightnessFactor,
              spreadRadius: 20.0 * brightnessFactor,
            ),
          ]
        : [];

    return Column(
      children: [
        // Kaca Lampu
        Container(
          width: 50,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isLit
                ? RadialGradient(
                    colors: [lightColor.withOpacity(0.9), Colors.transparent],
                    center: Alignment.topCenter,
                    radius: 0.8,
                  )
                : null,
            color: isLit ? lightColor.withOpacity(0.6) : Colors.grey[300],
            border: Border.all(color: Colors.black87, width: 1.5),
            boxShadow: shadows,
          ),
          child: Center(
            child: Container(
              width: 12,
              height: 20,
              decoration: BoxDecoration(
                color: isLit ? lightColor : Colors.grey[600],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        // Basis Lampu
        Container(
          width: 28,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              colors: [Colors.grey[800]!, Colors.grey[600]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}
