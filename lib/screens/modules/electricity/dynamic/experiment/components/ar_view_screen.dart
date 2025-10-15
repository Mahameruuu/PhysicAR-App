import 'dart:async';
import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class ARViewScreen extends StatefulWidget {
  final Stream<Map<String, dynamic>> arStateStream;

  const ARViewScreen({super.key, required this.arStateStream});

  @override
  State<ARViewScreen> createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen> {
  final Map<String, ArCoreNode> _arNodes = {};
  ArCoreController? _arCoreController;
  StreamSubscription<Map<String, dynamic>>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = widget.arStateStream.listen(_syncAr);
  }

  void _onARViewCreated(ArCoreController controller) {
    _arCoreController = controller;

    controller.onPlaneDetected = (plane) {
      debugPrint("Plane detected: ${plane.toString()}");
    };
  }

  Future<void> _syncAr(Map<String, dynamic> state) async {
    if (_arCoreController == null) return;

    final comps = Map<String, dynamic>.from(state['components'] ?? {});
    final nodes = Map<String, dynamic>.from(state['nodes'] ?? {});

    // Hapus node yang tidak ada di state baru
    final toRemove = _arNodes.keys.where((id) => !comps.containsKey(id)).toList();
    for (final id in toRemove) {
      final node = _arNodes.remove(id);
      if (node != null) {
        await _arCoreController?.removeNode(nodeName: node.name);
      }
    }

    // Tambah atau update node
    for (final entry in comps.entries) {
      final id = entry.key;
      final comp = Map<String, dynamic>.from(entry.value);
      final start = nodes[comp['start']];
      final end = nodes[comp['end']];
      if (start == null || end == null) continue;

      final avgX = ((start['x'] as num) + (end['x'] as num)) / 2.0;
      final avgY = ((start['y'] as num) + (end['y'] as num)) / 2.0;

      final position = vm.Vector3(avgX / 100.0, 0.0, avgY / 100.0);

      final isWorking = comp['isWorking'] == true;
      final color = isWorking ? Colors.yellow : Colors.grey;

      if (!_arNodes.containsKey(id)) {
        final material = ArCoreMaterial(color: color);
        final sphere = ArCoreSphere(materials: [material], radius: 0.05);

        final node = ArCoreNode(
          name: id,
          shape: sphere,
          position: position,
        );

        await _arCoreController?.addArCoreNode(node);
        _arNodes[id] = node;
      } else {
        // Karena arcore_flutter_plugin belum dukung updateNode langsung,
        // kita hapus dan tambahkan ulang node-nya.
        final node = _arNodes[id]!;
        await _arCoreController?.removeNode(nodeName: node.name);

        final updatedNode = ArCoreNode(
          name: id,
          shape: ArCoreSphere(
            materials: [ArCoreMaterial(color: color)],
            radius: 0.05,
          ),
          position: position,
        );

        await _arCoreController?.addArCoreNode(updatedNode);
        _arNodes[id] = updatedNode;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AR View")),
      body: ArCoreView(
        onArCoreViewCreated: _onARViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    _arCoreController?.dispose();
    super.dispose();
  }
}
