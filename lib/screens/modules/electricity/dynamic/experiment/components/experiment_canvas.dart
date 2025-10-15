import 'dart:async';
import 'package:flutter/material.dart';
import 'ar_view_screen.dart';

// ============== MODEL DAN ENUM ==============
enum ComponentType { battery, lamp, switchComponent, wire }

class CircuitNode {
  final String id;
  Offset position;
  List<String> connectedTo;
  bool currentFlow;

  CircuitNode({
    required this.id,
    required this.position,
    this.connectedTo = const [],
    this.currentFlow = false,
  });
}

class CircuitComponent {
  final String id;
  final ComponentType type;
  final String startNodeId;
  final String endNodeId;
  bool isConnected;
  bool isWorking;
  double value;

  CircuitComponent({
    required this.id,
    required this.type,
    required this.startNodeId,
    required this.endNodeId,
    this.isConnected = false,
    this.isWorking = false,
    this.value = 0.0,
  });
}

// ============== MAIN CANVAS ==============
class ExperimentCanvas extends StatefulWidget {
  const ExperimentCanvas({super.key});

  @override
  State<ExperimentCanvas> createState() => _ExperimentCanvasState();
}

class _ExperimentCanvasState extends State<ExperimentCanvas> {
  final Map<String, CircuitNode> _nodes = {};
  final Map<String, CircuitComponent> _components = {};

  // Stream untuk dikirim ke AR
  final StreamController<Map<String, dynamic>> _arStateStream =
      StreamController<Map<String, dynamic>>.broadcast();

  void _updateCurrentFlow() {
    // Contoh logika sederhana untuk menyalakan komponen
    for (var comp in _components.values) {
      comp.isWorking = comp.isConnected;
    }

    _pushStateToAr(); // kirim update ke AR
  }

  void _pushStateToAr() {
    final payload = {
      'nodes': _nodes.map((k, v) => MapEntry(k, {
            'x': v.position.dx,
            'y': v.position.dy,
            'currentFlow': v.currentFlow,
          })),
      'components': _components.map((k, v) => MapEntry(k, {
            'type': v.type.toString(),
            'start': v.startNodeId,
            'end': v.endNodeId,
            'isConnected': v.isConnected,
            'isWorking': v.isWorking,
          })),
    };

    _arStateStream.add(payload);
  }

  void _openARView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ARViewScreen(arStateStream: _arStateStream.stream),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Experiment Canvas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('⚡ Desain rangkaian kamu di sini'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateCurrentFlow,
              child: const Text('Simulasikan Arus'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _openARView,
              child: const Text('Lihat di AR'),
            ),
          ],
        ),
      ),
    );
  }
}
