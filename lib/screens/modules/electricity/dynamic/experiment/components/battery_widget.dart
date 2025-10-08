// lib/screens/modules/electricity/dynamic/experiment/components/battery_widget.dart

import 'package:flutter/material.dart';

class BatteryWidget extends StatelessWidget {
  const BatteryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 15,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.red, // Terminal Positif
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[400],
              child: const Center(
                child: Text('+ -', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
          ),
          Container(
            width: 15,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.blue, // Terminal Negatif
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}