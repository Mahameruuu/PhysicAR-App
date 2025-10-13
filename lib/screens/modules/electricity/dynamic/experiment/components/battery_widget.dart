import 'package:flutter/material.dart';

class BatteryWidget extends StatelessWidget {
  const BatteryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Ukuran Baterai
    const double width = 140;
    const double height = 60;
    const double terminalHeight = 25;
    const double terminalWidth = 8;
    
    return Container(
      width: width,
      height: height,
      // Gunakan gradien untuk efek logam/plastik mengkilap
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.blueGrey.shade700,
            Colors.blueGrey.shade900,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Badan utama baterai
          Container(
            width: width - 20,
            height: height - 10,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'POWER',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5
                ),
              ),
            ),
          ),
          
          // Terminal Positif (+) - Kanan
          Positioned(
            right: 0,
            child: Container(
              width: terminalWidth,
              height: terminalHeight,
              decoration: BoxDecoration(
                color: Colors.red.shade700,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                border: Border.all(color: Colors.yellow.shade700, width: 2),
              ),
              alignment: Alignment.center,
              child: const Text('+', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          
          // Terminal Negatif (-) - Kiri
          Positioned(
            left: 0,
            child: Container(
              width: terminalWidth,
              height: terminalHeight,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
                border: Border.all(color: Colors.yellow.shade700, width: 2),
              ),
              alignment: Alignment.center,
              child: const Text('-', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}