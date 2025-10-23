import 'package:flutter/material.dart';
import 'components/battery_widget.dart';
import 'components/lamp_widget.dart';
import 'components/ar_view_screen.dart';

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
  double? value; // untuk battery: V, lamp: R
  bool isWorking;
  bool isConnected;

  CircuitComponent({
    required this.id,
    required this.type,
    required this.startNodeId,
    required this.endNodeId,
    this.value,
    this.isWorking = false,
    this.isConnected = true,
  });

  List<String> getNodeIds() => [startNodeId, endNodeId];
}

// ============================================

class ExperimenCanvasSeri extends StatefulWidget {
  final dynamic target;
  const ExperimenCanvasSeri({super.key, required this.target});

  @override
  State<ExperimenCanvasSeri> createState() => _ExperimentCanvasState();
}

class _ExperimentCanvasState extends State<ExperimenCanvasSeri> with TickerProviderStateMixin {
  late AnimationController _animationController;

  Map<String, CircuitNode> _nodes = {};
  Map<String, CircuitComponent> _components = {};
  String? _currentlyDraggingComponentId;

  bool _isConnectingMode = false;
  String? _firstSelectedNodeId;

  // ============= Tambahan Variabel Perhitungan VIR =============
  double _totalVoltage = 0.0;
  double _totalResistance = 0.0;
  double _current = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _initializeDefaultCircuit();
  }

  void _turnOffAllLamps() {
    setState(() {
      for (final comp in _components.values) {
        if (comp.type == ComponentType.lamp) {
          comp.isWorking = false;
          comp.isConnected = false; // Supaya muncul 'PUTUS'
        }
      }
      _updateCurrentFlow();
    });
  }

  void _initializeDefaultCircuit() {
    setState(() {
      _nodes = {};
      _components = {};
      _isConnectingMode = false;
      _firstSelectedNodeId = null;
      _totalVoltage = 0;
      _totalResistance = 0;
      _current = 0;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ================= LOGIKA INTERAKSI =================
  void _addNewComponent(ComponentType type) {
    if (type == ComponentType.wire) {
      setState(() {
        _isConnectingMode = true;
        _firstSelectedNodeId = null;
      });
      return;
    }

    if (_isConnectingMode) {
      setState(() {
        _isConnectingMode = false;
        _firstSelectedNodeId = null;
      });
    }

    final newCompId = 'C${_components.length + 1}';
    final currentNodesCount = _nodes.length;

    final initialX = 200.0 + (_components.length % 5) * 60.0;
    final initialY = 150.0 + (_components.length ~/ 5) * 60.0;
    const componentSpacing = 50.0;

    final newNodeId1 = 'N${currentNodesCount + 1}';
    final node1Position = Offset(initialX, initialY);
    final newNode1 = CircuitNode(id: newNodeId1, position: node1Position);

    final newNodeId2 = 'N${currentNodesCount + 2}';
    final node2Position = Offset(initialX + componentSpacing, initialY);
    final newNode2 = CircuitNode(id: newNodeId2, position: node2Position);

    final newComponent = CircuitComponent(
      id: newCompId,
      type: type,
      startNodeId: newNodeId1,
      endNodeId: newNodeId2,
      value: type == ComponentType.lamp
          ? 2.0
          : (type == ComponentType.battery ? 9.0 : null), // default R lampu=2Ω, V baterai=9V
    );

    setState(() {
      _nodes[newNodeId1] = newNode1;
      _nodes[newNodeId2] = newNode2;
      _components[newCompId] = newComponent;
      _currentlyDraggingComponentId = newCompId;
      _updateCurrentFlow();
    });
  }

  String? _findClosestNode(Offset tapPosition) {
    const double tapTolerance = 30.0;
    for (final node in _nodes.values) {
      final distance = (node.position - tapPosition).distance;
      if (distance < tapTolerance) {
        return node.id;
      }
    }
    return null;
  }

  void _handleCanvasTap(Offset tapPosition) {
    final tappedNodeId = _findClosestNode(tapPosition);

    if (_isConnectingMode) {
      if (tappedNodeId != null) {
        if (_firstSelectedNodeId == null) {
          setState(() => _firstSelectedNodeId = tappedNodeId);
        } else if (_firstSelectedNodeId != tappedNodeId) {
          _connectNodesThroughVirtualNode(_firstSelectedNodeId!, tappedNodeId);
          setState(() {
            _isConnectingMode = false;
            _firstSelectedNodeId = null;
            _updateCurrentFlow();
          });
        }
      }
    } else {
      final tappedCompId = _findComponentByNodeId(tappedNodeId);
      if (tappedCompId != null) {
        final comp = _components[tappedCompId];
        if (comp != null && (comp.type == ComponentType.switchComponent || comp.type == ComponentType.lamp)) {
          _toggleComponentConnection(tappedCompId);
        }
      }
    }
  }

  String? _findComponentByNodeId(String? nodeId) {
    if (nodeId == null) return null;
    final comp = _components.values.cast<CircuitComponent?>().firstWhere(
      (comp) => comp != null && (comp.startNodeId == nodeId || comp.endNodeId == nodeId),
      orElse: () => null,
    );
    return comp?.id;
  }

  void _connectNodesThroughVirtualNode(String id1, String id2) {
    final node1 = _nodes[id1];
    final node2 = _nodes[id2];

    if (node1 != null && node2 != null && node1.id != node2.id) {
      setState(() {
        final midPosition = (node1.position + node2.position) / 2;
        final newVirtualNodeId = 'V${_nodes.length + 1}';

        final virtualNode = CircuitNode(
          id: newVirtualNodeId,
          position: midPosition,
          connectedTo: [id1, id2],
        );
        _nodes[newVirtualNodeId] = virtualNode;

        if (!node1.connectedTo.contains(newVirtualNodeId)) {
          node1.connectedTo = [...node1.connectedTo, newVirtualNodeId];
        }
        if (!node2.connectedTo.contains(newVirtualNodeId)) {
          node2.connectedTo = [...node2.connectedTo, newVirtualNodeId];
        }
      });
    }
  }

  void _toggleComponentConnection(String componentId) {
    setState(() {
      final comp = _components[componentId];
      if (comp != null && (comp.type == ComponentType.switchComponent || comp.type == ComponentType.lamp)) {
        comp.isConnected = !comp.isConnected;
      }
      _updateCurrentFlow();
    });
  }


  // ================= HAPUS KOMPONEN (SATUAN) =================
  void _deleteComponent(String componentId) {
    setState(() {
      final comp = _components.remove(componentId);
      if (comp != null) {
        // Hapus node jika tidak lagi terhubung ke komponen lain
        for (final nodeId in [comp.startNodeId, comp.endNodeId]) {
          final stillUsed = _components.values.any(
            (c) => c.startNodeId == nodeId || c.endNodeId == nodeId,
          );
          if (!stillUsed) {
            // sebelum remove node, bersihkan referensi 'connectedTo' di node lain
            for (final other in _nodes.values) {
              if (other.connectedTo.contains(nodeId)) {
                other.connectedTo = other.connectedTo.where((id) => id != nodeId).toList();
              }
            }
            _nodes.remove(nodeId);
          }
        }

        // Juga cek virtual nodes yang mungkin jadi orphan (tidak terhubung ke komponen)
        final orphans = <String>[];
        for (final nodeEntry in _nodes.entries) {
          final nodeId = nodeEntry.key;
          final node = nodeEntry.value;
          // node orphan = tidak ada komponen yang menggunakan node ini dan tidak punya connectedTo
          final usedByComp = _components.values.any((c) => c.startNodeId == nodeId || c.endNodeId == nodeId);
          if (!usedByComp && (node.connectedTo.isEmpty)) {
            orphans.add(nodeId);
          }
        }
        for (final orphanId in orphans) {
          // bersihkan referensi di node lain (probabilitas kecil, tapi aman)
          for (final other in _nodes.values) {
            if (other.connectedTo.contains(orphanId)) {
              other.connectedTo = other.connectedTo.where((id) => id != orphanId).toList();
            }
          }
          _nodes.remove(orphanId);
        }
      }
      _updateCurrentFlow();
    });
  }

  // ================= LOGIKA ARUS LISTRIK (VIR) =================
  void _updateCurrentFlow() {
    // Reset semua node & komponen
    for (var node in _nodes.values) node.currentFlow = false;
    for (var comp in _components.values) {
      if (comp.type == ComponentType.lamp || comp.type == ComponentType.switchComponent) {
        comp.isWorking = false;
      }
    }

    // Cari baterai
    CircuitComponent? batteryComp;
    for (final c in _components.values) {
      if (c.type == ComponentType.battery) {
        batteryComp = c;
        break;
      }
    }
    if (batteryComp == null) return;

    // Perhitungan arus untuk rangkaian seri
    double totalResistance = 0;
    bool circuitBroken = false;

    for (final comp in _components.values) {
      // Jika lampu atau saklar OFF → arus berhenti
      if ((comp.type == ComponentType.lamp || comp.type == ComponentType.switchComponent) && !comp.isConnected) {
        circuitBroken = true;
        break;
      }
      if (comp.type == ComponentType.lamp) totalResistance += comp.value ?? 0;
    }

    _totalVoltage = batteryComp.value ?? 0;
    _totalResistance = circuitBroken ? double.infinity : totalResistance;
    _current = _totalResistance.isFinite ? _totalVoltage / _totalResistance : 0;

    // Propagasi arus: nyala hanya jika arus > 0
    if (_current > 0) {
      _propagateCurrent(batteryComp.startNodeId, <String>{});
    }

    setState(() {});
  }


  void _propagateCurrent(String nodeId, Set<String> visitedNodes) {
    if (visitedNodes.contains(nodeId)) return;
    visitedNodes.add(nodeId);

    final node = _nodes[nodeId];
    if (node == null) return;

    node.currentFlow = true;

    for (final comp in _components.values) {
      if (comp.type == ComponentType.switchComponent && !comp.isConnected) continue;
      if (!comp.isConnected) continue;

      if (comp.startNodeId == nodeId) {
        if (comp.type == ComponentType.lamp) comp.isWorking = true;
        _propagateCurrent(comp.endNodeId, visitedNodes);
      } else if (comp.endNodeId == nodeId) {
        if (comp.type == ComponentType.lamp) comp.isWorking = true;
        _propagateCurrent(comp.startNodeId, visitedNodes);
      }
    }

    for (final connectedNodeId in node.connectedTo) {
      _propagateCurrent(connectedNodeId, visitedNodes);
    }
  }

  // ================= WIDGET UTAMA =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Eksperimen ${widget.target ?? 'Listrik'}'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade700,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _buildToolPanel(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Rangkaian Kustom",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            _buildCustomCircuit(),
                            const SizedBox(height: 20),
                            _buildARButton(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // =========== PANEL VISUAL VIR ===========
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                color: Colors.blueGrey.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("🔋 Tegangan Total (V): ${_totalVoltage.toStringAsFixed(2)} V",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text("💡 Hambatan Total (R): ${_totalResistance.toStringAsFixed(2)} Ω",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text("⚡ Arus Total (I): ${_current.toStringAsFixed(3)} A",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= TOOL PANEL =================
  Widget _buildToolPanel() {
    return Container(
      width: 110,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          _buildToolButton(Icons.lightbulb_outline, 'Lampu', ComponentType.lamp),
          _buildToolButton(Icons.battery_full, 'Baterai', ComponentType.battery),
          _buildToolButton(Icons.power_settings_new, 'Saklar', ComponentType.switchComponent),
          _buildToolButton(Icons.cable, 'Kabel', ComponentType.wire),
          const Spacer(),
          // _buildIconButton(Icons.delete, 'Hapus Semua', Colors.red, () async {
          //   final confirm = await showDialog<bool>(
          //     context: context,
          //     builder: (context) => AlertDialog(
          //       title: const Text("Hapus Semua Komponen"),
          //       content: const Text("Apakah kamu yakin ingin menghapus semua komponen?"),
          //       actions: [
          //         TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          //         TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
          //       ],
          //     ),
          //   );
          //   if (confirm == true) {
          //     setState(() {
          //       _components.clear();
          //       _nodes.clear();
          //       _updateCurrentFlow();
          //     });
          //   }
          // }),
          const SizedBox(height: 8),
          _buildIconButton(Icons.clear_all, 'Reset Sirkuit', Colors.blue, () {
            _initializeDefaultCircuit();
          }),
        ],
      ),
    );
  }

  Widget _buildToolButton(IconData icon, String label, ComponentType type) {
    final bool isActive = _isConnectingMode && type == ComponentType.wire;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Material(
        color: isActive ? Colors.lightBlue.shade200 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _addNewComponent(type),
          child: SizedBox(
            width: 60,
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.blue.shade600, size: 30),
                const SizedBox(height: 2),
                Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String tooltip, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: 60,
          height: 50,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 2),
              Text(tooltip, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9)),
            ],
          ),
        ),
      ),
    );
  }

  // ================= CUSTOM CIRCUIT =================
  Widget _buildCustomCircuit() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Container(
        width: double.infinity,
        height: 480,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueGrey.shade200, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        // Tambahkan InteractiveViewer agar bisa di-zoom & scroll
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 2.5,
            boundaryMargin: const EdgeInsets.all(200),
            constrained: false,
            child: GestureDetector(
              onTapUp: (details) => _handleCanvasTap(details.localPosition),
              child: SizedBox(
                width: 2000, // area kerja luas
                height: 2000,
                child: Stack(
                  children: [
                    // ============ Gambar kabel =============
                    Positioned.fill(
                      child: CustomPaint(
                        painter: FlexibleWirePainter(
                          nodes: _nodes,
                          components: _components,
                          animationValue: _animationController.value,
                        ),
                      ),
                    ),

                    // ============ Komponen =============
                    ..._components.values.map((comp) {
                      final startNode = _nodes[comp.startNodeId];
                      final endNode = _nodes[comp.endNodeId];
                      if (startNode == null || endNode == null) return const SizedBox.shrink();

                      final centerPosition = (startNode.position + endNode.position) / 2;

                      Widget componentWidget;
                      switch (comp.type) {
                        case ComponentType.lamp:
                          componentWidget = _buildInteractiveLamp(comp);
                          break;
                        case ComponentType.battery:
                          componentWidget = _buildInteractiveBattery(comp);
                          break;
                        case ComponentType.switchComponent:
                          componentWidget = _buildSimpleSwitch(comp);
                          break;
                        default:
                          componentWidget = const SizedBox.shrink();
                      }

                      return Positioned(
                        left: centerPosition.dx - 30,
                        top: centerPosition.dy - 15,
                        child: _buildDraggableComponent(comp.id, componentWidget),
                      );
                    }),

                    // ============ Node =============
                    ..._nodes.values
                        .where((node) => _findComponentByNodeId(node.id) == null)
                        .map((node) {
                      return Positioned(
                        left: node.position.dx - 10,
                        top: node.position.dy - 10,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              node.position += details.delta;
                              _updateCurrentFlow();
                            });
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.5),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.purple.shade900, width: 2),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableComponent(String componentId, Widget child) {
    return GestureDetector(
      onTap: () {
        final comp = _components[componentId];
        if (comp != null) {
          if (comp.type == ComponentType.switchComponent) {
            // Toggle saklar
            _toggleComponentConnection(componentId);
          } else if (comp.type == ComponentType.lamp) {
            // Toggle lampu sendiri → putus atau sambung
            comp.isConnected = !comp.isConnected;
            _updateCurrentFlow(); // otomatis hitung arus, efek seri terjadi
          }
        }
      },
      onPanStart: (details) {
        if (!_isConnectingMode) {
          setState(() => _currentlyDraggingComponentId = componentId);
        }
      },
      onPanUpdate: (details) {
        if (_currentlyDraggingComponentId == componentId) {
          setState(() {
            final comp = _components[componentId];
            if (comp != null) {
              _nodes[comp.startNodeId]?.position += details.delta;
              _nodes[comp.endNodeId]?.position += details.delta;
              _updateCurrentFlow();
            }
          });
        }
      },
      onPanEnd: (_) => setState(() => _currentlyDraggingComponentId = null),
      child: child,
    );
  }

  Widget _buildSimpleSwitch(CircuitComponent switchComp) {
    final isOn = switchComp.isConnected;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isOn ? Colors.green.shade600 : Colors.red.shade600,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isOn ? Icons.toggle_on_rounded : Icons.toggle_off_rounded, color: Colors.white, size: 24),
          Text(isOn ? "TUTUP" : "BUKA", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
        ],
      ),
    );
  }

  // ================= WIDGET LAMPU + SLIDER =================
  Widget _buildInteractiveLamp(CircuitComponent lamp) {
    final isLit = lamp.isWorking && lamp.isConnected;
    return Column(
      children: [
        LampWidget(
          isLit: isLit,
          brightnessFactor: isLit ? 1.0 : 0.15,
        ),
        if (!lamp.isConnected)
          const Text('PUTUS', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
        _buildComponentSlider(lamp),
      ],
    );
  }

  Widget _buildInteractiveBattery(CircuitComponent battery) {
    return Column(
      children: [
        const BatteryWidget(),
        _buildComponentSlider(battery),
      ],
    );
  }

  // ================= SLIDER VIR =================
  Widget _buildComponentSlider(CircuitComponent comp) {
    if (comp.type != ComponentType.lamp && comp.type != ComponentType.battery) return const SizedBox.shrink();

    final label = comp.type == ComponentType.lamp ? 'R (Ω)' : 'V (V)';
    final min = comp.type == ComponentType.lamp ? 1.0 : 1.0;
    final max = comp.type == ComponentType.lamp ? 10.0 : 20.0;

    return Column(
      children: [
        Text('$label: ${comp.value?.toStringAsFixed(1)}', style: const TextStyle(fontSize: 12)),
        Slider(
          value: comp.value ?? min,
          min: min,
          max: max,
          divisions: ((max - min) * 2).toInt(),
          label: comp.value?.toStringAsFixed(1),
          onChanged: (val) {
            setState(() {
              comp.value = val;
              _updateCurrentFlow();
            });
          },
        ),
      ],
    );
  }

  Widget _buildARButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
      icon: const Icon(Icons.view_in_ar, color: Colors.white),
      label: const Text("Lihat dalam AR", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}

// ============== CUSTOM PAINTER KABEL DENGAN WARNA ARUS ==============
class FlexibleWirePainter extends CustomPainter {
  final Map<String, CircuitNode> nodes;
  final Map<String, CircuitComponent> components;
  final double animationValue;

  FlexibleWirePainter({
    required this.nodes,
    required this.components,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Set<String> drawnConnections = {};

    for (final node in nodes.values) {
      for (final connectedNodeId in node.connectedTo) {
        final connectionId = [node.id, connectedNodeId]..sort();
        final connectionKey = connectionId.join('-');

        if (!drawnConnections.contains(connectionKey)) {
          final targetNode = nodes[connectedNodeId];
          if (targetNode != null) {
            bool hasCurrent = _isCurrentBetweenNodes(node.id, connectedNodeId);

            if (hasCurrent) {
              final path = Path()
                ..moveTo(node.position.dx, node.position.dy)
                ..lineTo(targetNode.position.dx, targetNode.position.dy);

              final gradient = LinearGradient(
                colors: [Colors.yellow, Colors.orange, Colors.yellow],
                stops: [
                  (animationValue % 1),
                  ((animationValue + 0.1) % 1),
                  ((animationValue + 0.2) % 1)
                ],
              );

              final rect = Rect.fromPoints(node.position, targetNode.position);
              paint.shader = gradient.createShader(rect);
            } else {
              paint.shader = null;
              paint.color = Colors.grey.shade400;
            }

            canvas.drawLine(node.position, targetNode.position, paint);
            drawnConnections.add(connectionKey);
          }
        }
      }
    }
  }

  bool _isCurrentBetweenNodes(String nodeAId, String nodeBId) {
    for (final comp in components.values) {
      if (!comp.isConnected) continue;

      if ((comp.startNodeId == nodeAId && comp.endNodeId == nodeBId) ||
          (comp.startNodeId == nodeBId && comp.endNodeId == nodeAId)) {
        return true;
      }
    }

    final nodeA = nodes[nodeAId];
    final nodeB = nodes[nodeBId];
    if ((nodeA?.currentFlow == true && nodeB?.currentFlow == true)) {
      return true;
    }

    return false;
  }

  @override
  bool shouldRepaint(covariant FlexibleWirePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.nodes.length != nodes.length ||
           oldDelegate.components.length != components.length;
  }
}
