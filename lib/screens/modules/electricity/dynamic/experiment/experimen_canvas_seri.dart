import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Import komponen baru (sesuaikan path Anda) ──
// import 'lamp_widget.dart';      ← gunakan versi baru di lamp_widget.dart
// import 'battery_widget.dart';   ← gunakan versi baru di battery_widget.dart

// ============================================================
//  MODEL & ENUM  (tidak berubah dari versi asli)
// ============================================================
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
  double? value;
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

// ============================================================
//  SCREEN UTAMA
// ============================================================
class ExperimenCanvasSeri extends StatefulWidget {
  final dynamic target;
  const ExperimenCanvasSeri({super.key, required this.target});

  @override
  State<ExperimenCanvasSeri> createState() => _ExperimentCanvasState();
}

class _ExperimentCanvasState extends State<ExperimenCanvasSeri>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _bgPulseCtrl;

  Map<String, CircuitNode> _nodes = {};
  Map<String, CircuitComponent> _components = {};
  String? _currentlyDraggingComponentId;
  bool _isConnectingMode = false;
  String? _firstSelectedNodeId;

  double _totalVoltage = 0.0;
  double _totalResistance = 0.0;
  double _current = 0.0;

  static const _darkBg = Color(0xFF0A0E1A);
  static const _panelBg = Color(0xFF0F172A);
  static const _cardBg = Color(0xFF1E293B);
  static const _accent = Color(0xFF3B82F6);
  static const _accentGlow = Color(0xFF60A5FA);
  static const _cyan = Color(0xFF06B6D4);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _bgPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _initializeDefaultCircuit();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bgPulseCtrl.dispose();
    super.dispose();
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

  // ── LOGIKA INTERAKSI (tidak berubah) ─────────────────────────
  void _addNewComponent(ComponentType type) {
    if (type == ComponentType.wire) {
      setState(() { _isConnectingMode = true; _firstSelectedNodeId = null; });
      return;
    }
    if (_isConnectingMode) setState(() { _isConnectingMode = false; _firstSelectedNodeId = null; });

    final newCompId = 'C${_components.length + 1}';
    final currentNodesCount = _nodes.length;
    final initialX = 200.0 + (_components.length % 5) * 60.0;
    final initialY = 150.0 + (_components.length ~/ 5) * 60.0;
    const componentSpacing = 60.0;

    final newNodeId1 = 'N${currentNodesCount + 1}';
    final newNode1 = CircuitNode(id: newNodeId1, position: Offset(initialX, initialY));
    final newNodeId2 = 'N${currentNodesCount + 2}';
    final newNode2 = CircuitNode(id: newNodeId2, position: Offset(initialX + componentSpacing, initialY));

    final newComponent = CircuitComponent(
      id: newCompId, type: type,
      startNodeId: newNodeId1, endNodeId: newNodeId2,
      value: type == ComponentType.lamp ? 2.0 : (type == ComponentType.battery ? 9.0 : null),
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
      if ((node.position - tapPosition).distance < tapTolerance) return node.id;
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
          setState(() { _isConnectingMode = false; _firstSelectedNodeId = null; _updateCurrentFlow(); });
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
    return _components.values.cast<CircuitComponent?>().firstWhere(
      (c) => c != null && (c.startNodeId == nodeId || c.endNodeId == nodeId),
      orElse: () => null,
    )?.id;
  }

  void _connectNodesThroughVirtualNode(String id1, String id2) {
    final node1 = _nodes[id1]; final node2 = _nodes[id2];
    if (node1 != null && node2 != null && node1.id != node2.id) {
      setState(() {
        final newVirtualNodeId = 'V${_nodes.length + 1}';
        final virtualNode = CircuitNode(
          id: newVirtualNodeId, position: (node1.position + node2.position) / 2,
          connectedTo: [id1, id2],
        );
        _nodes[newVirtualNodeId] = virtualNode;
        if (!node1.connectedTo.contains(newVirtualNodeId)) node1.connectedTo = [...node1.connectedTo, newVirtualNodeId];
        if (!node2.connectedTo.contains(newVirtualNodeId)) node2.connectedTo = [...node2.connectedTo, newVirtualNodeId];
      });
    }
  }

  void _toggleComponentConnection(String componentId) {
    setState(() {
      final comp = _components[componentId];
      if (comp != null) comp.isConnected = !comp.isConnected;
      _updateCurrentFlow();
    });
  }

  void _deleteComponent(String componentId) {
    setState(() {
      final comp = _components.remove(componentId);
      if (comp != null) {
        for (final nodeId in [comp.startNodeId, comp.endNodeId]) {
          final stillUsed = _components.values.any((c) => c.startNodeId == nodeId || c.endNodeId == nodeId);
          if (!stillUsed) {
            for (final other in _nodes.values) {
              if (other.connectedTo.contains(nodeId)) other.connectedTo = other.connectedTo.where((id) => id != nodeId).toList();
            }
            _nodes.remove(nodeId);
          }
        }
      }
      _updateCurrentFlow();
    });
  }

  void _updateCurrentFlow() {
    for (var node in _nodes.values) node.currentFlow = false;
    for (var comp in _components.values) {
      if (comp.type == ComponentType.lamp || comp.type == ComponentType.switchComponent) comp.isWorking = false;
    }
    CircuitComponent? batteryComp;
    for (final c in _components.values) { if (c.type == ComponentType.battery) { batteryComp = c; break; } }
    if (batteryComp == null) return;

    double totalResistance = 0;
    bool circuitBroken = false;
    for (final comp in _components.values) {
      if ((comp.type == ComponentType.lamp || comp.type == ComponentType.switchComponent) && !comp.isConnected) { circuitBroken = true; break; }
      if (comp.type == ComponentType.lamp) totalResistance += comp.value ?? 0;
    }

    _totalVoltage = batteryComp.value ?? 0;
    _totalResistance = circuitBroken ? double.infinity : totalResistance;
    _current = _totalResistance.isFinite ? _totalVoltage / _totalResistance : 0;

    if (_current > 0) _propagateCurrent(batteryComp.startNodeId, <String>{});
    setState(() {});
  }

  void _propagateCurrent(String nodeId, Set<String> visited) {
    if (visited.contains(nodeId)) return;
    visited.add(nodeId);
    final node = _nodes[nodeId];
    if (node == null) return;
    node.currentFlow = true;
    for (final comp in _components.values) {
      if (!comp.isConnected) continue;
      if (comp.startNodeId == nodeId) { if (comp.type == ComponentType.lamp) comp.isWorking = true; _propagateCurrent(comp.endNodeId, visited); }
      else if (comp.endNodeId == nodeId) { if (comp.type == ComponentType.lamp) comp.isWorking = true; _propagateCurrent(comp.startNodeId, visited); }
    }
    for (final id in node.connectedTo) _propagateCurrent(id, visited);
  }

  void _handleConnectingMode(String nodeId) {
    if (_firstSelectedNodeId == null) {
      setState(() => _firstSelectedNodeId = nodeId);
    } else if (_firstSelectedNodeId != nodeId) {
      _connectNodesThroughVirtualNode(_firstSelectedNodeId!, nodeId);
      setState(() { _isConnectingMode = false; _firstSelectedNodeId = null; _updateCurrentFlow(); });
    }
  }

  Color _getLampColor(CircuitComponent lamp) {
    if (!lamp.isConnected) return Colors.grey;
    if (_current > 2.0) return const Color(0xFFFF3D00);
    if (!lamp.isWorking) return Colors.grey;
    if (_current < 0.3) return const Color(0xFFFFE57F);
    if (_current < 1.0) return const Color(0xFFFFAB40);
    return const Color(0xFF00E676);
  }

  // ============================================================
  //  BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      body: AnimatedBuilder(
        animation: Listenable.merge([_animationController, _bgPulseCtrl]),
        builder: (context, child) {
          return Stack(
            children: [
              // ── Animated bg orbs ──
              _BackgroundOrbs(pulse: _bgPulseCtrl.value),
              // ── Main content ──
              SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            _buildCustomCircuit(),
                            const SizedBox(height: 12),
                            _buildARButton(),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                    _buildToolPanel(),
                    _buildVIRPanel(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── App Bar ───────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.07))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Eksperimen ${widget.target ?? 'Listrik Seri'}',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          _StatusPill(current: _current),
        ],
      ),
    );
  }

  // ── Canvas ───────────────────────────────────────────────────
  Widget _buildCustomCircuit() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 460,
        decoration: BoxDecoration(
          color: const Color(0xFF080D1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: _accent.withOpacity(0.08),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Grid overlay
              const Positioned.fill(child: _CanvasGrid()),
              // Main canvas
              InteractiveViewer(
                minScale: 0.5, maxScale: 2.5,
                boundaryMargin: const EdgeInsets.all(200),
                constrained: false,
                child: GestureDetector(
                  onTapUp: (d) => _handleCanvasTap(d.localPosition),
                  child: SizedBox(
                    width: 2000, height: 2000,
                    child: Stack(
                      children: [
                        // Wires
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _GlowWirePainter(
                              nodes: _nodes,
                              components: _components,
                              animationValue: _animationController.value,
                              current: _current,
                            ),
                          ),
                        ),
                        // Components
                        ..._components.values.map((comp) {
                          final startNode = _nodes[comp.startNodeId];
                          final endNode = _nodes[comp.endNodeId];
                          if (startNode == null || endNode == null) return const SizedBox.shrink();
                          final center = (startNode.position + endNode.position) / 2;
                          return Positioned(
                            left: center.dx - 40,
                            top: center.dy - 30,
                            child: _buildDraggableComponent(comp.id, _componentWidget(comp)),
                          );
                        }),
                        // Virtual nodes
                        ..._nodes.values
                            .where((n) => _findComponentByNodeId(n.id) == null)
                            .map((node) => Positioned(
                              left: node.position.dx - 8,
                              top: node.position.dy - 8,
                              child: GestureDetector(
                                onPanUpdate: (d) => setState(() { node.position += d.delta; _updateCurrentFlow(); }),
                                child: Container(
                                  width: 16, height: 16,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _cyan.withOpacity(0.6),
                                    border: Border.all(color: _cyan, width: 1.5),
                                    boxShadow: [BoxShadow(color: _cyan.withOpacity(0.4), blurRadius: 8)],
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              // Connecting mode overlay hint
              if (_isConnectingMode)
                Positioned(
                  top: 12, left: 0, right: 0,
                  child: Center(
                    child: _GlassPill(
                      label: _firstSelectedNodeId == null
                          ? 'Ketuk titik pertama'
                          : 'Ketuk titik kedua',
                      icon: Icons.cable_rounded,
                      color: _cyan,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _componentWidget(CircuitComponent comp) {
    switch (comp.type) {
      case ComponentType.lamp:
        return _buildInteractiveLamp(comp);
      case ComponentType.battery:
        return _buildInteractiveBattery(comp);
      case ComponentType.switchComponent:
        return _buildFuturisticSwitch(comp);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDraggableComponent(String id, Widget child) {
    return GestureDetector(
      onTap: () {
        final comp = _components[id];
        if (comp == null) return;
        if (_isConnectingMode) {
          _handleConnectingMode(comp.startNodeId);
        } else if (comp.type == ComponentType.switchComponent) {
          _toggleComponentConnection(id);
        }
      },
      onPanStart: (_) { if (!_isConnectingMode) setState(() => _currentlyDraggingComponentId = id); },
      onPanUpdate: (d) {
        if (_currentlyDraggingComponentId == id) {
          setState(() {
            _nodes[_components[id]!.startNodeId]?.position += d.delta;
            _nodes[_components[id]!.endNodeId]?.position += d.delta;
            _updateCurrentFlow();
          });
        }
      },
      onPanEnd: (_) => setState(() => _currentlyDraggingComponentId = null),
      onLongPress: () => _showDeleteDialog(id),
      child: child,
    );
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Hapus komponen?', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal', style: GoogleFonts.poppins(color: Colors.white60))),
          TextButton(
            onPressed: () { Navigator.pop(context); _deleteComponent(id); },
            child: Text('Hapus', style: GoogleFonts.poppins(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  // ── Lamp (3D glow via custom painter) ────────────────────────
  Widget _buildInteractiveLamp(CircuitComponent lamp) {
    final isOvercurrent = _current > 2.0;
    final lampColor = _getLampColor(lamp);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Glow dari LampWidget baru
            // ↓ Ganti dengan import LampWidget dari lamp_widget.dart
            _InlineLamp(isLit: lamp.isWorking && lamp.isConnected, color: lampColor),
            if (isOvercurrent) const _OvercurrentEffect(),
          ],
        ),
        if (!lamp.isConnected)
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.red.withOpacity(0.5)),
            ),
            child: Text('PUTUS', style: GoogleFonts.spaceGrotesk(color: Colors.redAccent, fontSize: 9, fontWeight: FontWeight.w700)),
          ),
        _buildStyledSlider(lamp),
      ],
    );
  }

  // ── Battery ───────────────────────────────────────────────────
  Widget _buildInteractiveBattery(CircuitComponent battery) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ↓ Ganti dengan import BatteryWidget dari battery_widget.dart
        _InlineBattery(voltage: battery.value ?? 9),
        _buildStyledSlider(battery),
      ],
    );
  }

  // ── Switch ────────────────────────────────────────────────────
  Widget _buildFuturisticSwitch(CircuitComponent sw) {
    final isOn = sw.isConnected;
    final col = isOn ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOn
              ? [const Color(0xFF166534), const Color(0xFF14532D)]
              : [const Color(0xFF7F1D1D), const Color(0xFF450A0A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: col.withOpacity(0.5), width: 1.2),
        boxShadow: [BoxShadow(color: col.withOpacity(0.3), blurRadius: 12, spreadRadius: 1)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isOn ? Icons.toggle_on_rounded : Icons.toggle_off_rounded, color: col, size: 28),
          const SizedBox(height: 2),
          Text(
            isOn ? 'TUTUP' : 'BUKA',
            style: GoogleFonts.spaceGrotesk(color: col, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1),
          ),
        ],
      ),
    );
  }

  // ── Slider ────────────────────────────────────────────────────
  Widget _buildStyledSlider(CircuitComponent comp) {
    if (comp.type != ComponentType.lamp && comp.type != ComponentType.battery) return const SizedBox.shrink();
    final label = comp.type == ComponentType.lamp ? 'R' : 'V';
    final unit = comp.type == ComponentType.lamp ? 'Ω' : 'V';
    final min = 1.0;
    final max = comp.type == ComponentType.lamp ? 10.0 : 20.0;
    final col = comp.type == ComponentType.lamp ? const Color(0xFF60A5FA) : const Color(0xFF4ADE80);

    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$label: ', style: GoogleFonts.spaceGrotesk(color: Colors.white54, fontSize: 10)),
              Text('${comp.value?.toStringAsFixed(1)}$unit',
                  style: GoogleFonts.spaceGrotesk(color: col, fontSize: 10, fontWeight: FontWeight.w700)),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              activeTrackColor: col,
              inactiveTrackColor: col.withOpacity(0.2),
              thumbColor: col,
              overlayColor: col.withOpacity(0.2),
            ),
            child: Slider(
              value: comp.value ?? min, min: min, max: max,
              divisions: ((max - min) * 2).toInt(),
              onChanged: (val) => setState(() { comp.value = val; _updateCurrentFlow(); }),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tool Panel ────────────────────────────────────────────────
  Widget _buildToolPanel() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _panelBg.withOpacity(0.9),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildToolBtn(Icons.lightbulb_rounded, 'Lampu', ComponentType.lamp, const Color(0xFFFFD54F)),
                const SizedBox(width: 10),
                _buildToolBtn(Icons.battery_full_rounded, 'Baterai', ComponentType.battery, const Color(0xFF4ADE80)),
                const SizedBox(width: 10),
                _buildToolBtn(Icons.power_settings_new_rounded, 'Saklar', ComponentType.switchComponent, const Color(0xFFFC8181)),
                const SizedBox(width: 10),
                _buildToolBtn(Icons.cable_rounded, 'Kabel', ComponentType.wire, _cyan,
                    active: _isConnectingMode),
                const SizedBox(width: 16),
                _buildActionBtn(Icons.refresh_rounded, 'Reset', Colors.redAccent.withOpacity(0.8), _initializeDefaultCircuit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolBtn(IconData icon, String label, ComponentType type, Color col, {bool active = false}) {
    return GestureDetector(
      onTap: () => _addNewComponent(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 64, height: 64,
        decoration: BoxDecoration(
          color: active ? col.withOpacity(0.2) : _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? col : Colors.white.withOpacity(0.08),
            width: active ? 1.5 : 1,
          ),
          boxShadow: active ? [BoxShadow(color: col.withOpacity(0.3), blurRadius: 12)] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: col, size: 26),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.poppins(color: Colors.white60, fontSize: 9)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label, Color col, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60, height: 60,
        decoration: BoxDecoration(
          color: col.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: col.withOpacity(0.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: col, size: 24),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.poppins(color: col, fontSize: 9, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ── VIR Panel ─────────────────────────────────────────────────
  Widget _buildVIRPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      decoration: BoxDecoration(
        color: _panelBg,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: Row(
        children: [
          _VIRCard(icon: Icons.bolt_rounded, label: 'Tegangan', value: _totalVoltage.toStringAsFixed(2), unit: 'V', color: const Color(0xFFFACC15)),
          const SizedBox(width: 8),
          _VIRCard(icon: Icons.waves_rounded, label: 'Hambatan', value: _totalResistance.isInfinite ? '∞' : _totalResistance.toStringAsFixed(2), unit: 'Ω', color: const Color(0xFF60A5FA)),
          const SizedBox(width: 8),
          _VIRCard(icon: Icons.electric_bolt_rounded, label: 'Arus', value: _current.toStringAsFixed(3), unit: 'A', color: const Color(0xFF4ADE80)),
        ],
      ),
    );
  }

  // ── AR Button ─────────────────────────────────────────────────
  Widget _buildARButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEA580C), Color(0xFFDC2626)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: const Color(0xFFEA580C).withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Text('Lihat dalam AR', style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
//  INLINE LAMP  (copy dari lamp_widget.dart untuk kenyamanan)
// ============================================================
class _InlineLamp extends StatefulWidget {
  final bool isLit;
  final Color color;
  const _InlineLamp({required this.isLit, required this.color});
  @override State<_InlineLamp> createState() => _InlineLampState();
}
class _InlineLampState extends State<_InlineLamp> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pulse;
  @override void initState() { super.initState(); _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat(reverse: true); _pulse = Tween<double>(begin: 0.82, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut)); }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: _pulse, builder: (_, __) => CustomPaint(size: const Size(72, 100), painter: _LampPainter2(isLit: widget.isLit, color: widget.color, pulse: widget.isLit ? _pulse.value : 0)));
}

class _LampPainter2 extends CustomPainter {
  final bool isLit; final Color color; final double pulse;
  _LampPainter2({required this.isLit, required this.color, required this.pulse});
  @override void paint(Canvas canvas, Size size) {
    final cx = size.width / 2; final cy = size.height * 0.37; final r = size.width * 0.37;
    final paint = Paint()..isAntiAlias = true;
    if (isLit && pulse > 0) {
      final hR = r * (1.9 + 0.35 * pulse);
      paint.shader = RadialGradient(colors: [color.withOpacity(0.5 * pulse), color.withOpacity(0.18 * pulse), Colors.transparent], stops: const [0, 0.5, 1]).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: hR));
      canvas.drawCircle(Offset(cx, cy), hR, paint);
    }
    final bulbPath = Path();
    final nW = r * 0.38; final nT = cy + r * 0.62; final nB = cy + r * 0.95;
    bulbPath.addArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), pi, pi);
    bulbPath.cubicTo(cx + r, nT, cx + nW, nT, cx + nW, nB);
    bulbPath.lineTo(cx - nW, nB); bulbPath.cubicTo(cx - nW, nT, cx - r, nT, cx - r, cy); bulbPath.close();
    if (isLit) {
      paint.shader = RadialGradient(center: const Alignment(-0.3, -0.4), radius: 1, colors: [Color.lerp(Colors.white, color, 0.25)!, color.withOpacity(0.9), color.withOpacity(0.55)]).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    } else {
      paint.shader = RadialGradient(center: const Alignment(-0.3, -0.4), radius: 1, colors: [const Color(0xFF2A2A3E), const Color(0xFF1A1A2E), const Color(0xFF111122)]).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    }
    paint.style = PaintingStyle.fill; canvas.drawPath(bulbPath, paint);
    paint.shader = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white.withOpacity(isLit ? 0.4 : 0.1), Colors.transparent]).createShader(Rect.fromCircle(center: Offset(cx - r * 0.3, cy - r * 0.4), radius: r * 0.5));
    canvas.drawPath(bulbPath, paint);
    paint.shader = null; paint.style = PaintingStyle.stroke;
    paint.color = isLit ? Colors.white.withOpacity(0.28) : const Color(0xFF44446A);
    paint.strokeWidth = 1.4; canvas.drawPath(bulbPath, paint);
    // Filament
    paint.style = PaintingStyle.stroke; paint.strokeCap = StrokeCap.round; paint.strokeWidth = isLit ? 2.0 : 1.5;
    final sX = cx - r * 0.38; final sY = cy + r * 0.08; final amp = isLit ? r * 0.22 * (0.7 + 0.3 * pulse) : r * 0.18;
    final fPath = Path(); fPath.moveTo(sX, sY);
    for (int i = 0; i < 6; i++) fPath.lineTo(sX + i * (r * 0.76 / 5), sY + (i.isEven ? -amp : amp));
    paint.shader = isLit ? LinearGradient(colors: [Colors.white.withOpacity(0.9), Color.lerp(Colors.white, color, 0.5)!, Colors.white.withOpacity(0.9)]).createShader(Rect.fromLTWH(sX, sY - amp, r * 0.76, amp * 2)) : null;
    if (!isLit) paint.color = const Color(0xFF666688);
    canvas.drawPath(fPath, paint);
    // Base
    paint.shader = null; paint.style = PaintingStyle.fill;
    for (int i = 0; i < 4; i++) {
      final w = r * 0.38 * (1 - i * 0.12); final top = nB + i * (size.height - nB) / 4;
      paint.shader = LinearGradient(colors: const [Color(0xFF475569), Color(0xFF64748B), Color(0xFF334155)]).createShader(Rect.fromLTWH(cx - w, top, w * 2, 6));
      canvas.drawRect(Rect.fromLTWH(cx - w, top, w * 2, (size.height - nB) / 4), paint);
    }
  }
  @override bool shouldRepaint(_LampPainter2 old) => old.isLit != isLit || old.pulse != pulse || old.color != color;
}

// ============================================================
//  INLINE BATTERY
// ============================================================
class _InlineBattery extends StatefulWidget {
  final double voltage;
  const _InlineBattery({required this.voltage});
  @override State<_InlineBattery> createState() => _InlineBatteryState();
}
class _InlineBatteryState extends State<_InlineBattery> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override void initState() { super.initState(); _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(); }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: _ctrl, builder: (_, __) => CustomPaint(size: const Size(100, 52), painter: _BatPainter(voltage: widget.voltage, shimmer: _ctrl.value)));
}
class _BatPainter extends CustomPainter {
  final double voltage; final double shimmer;
  _BatPainter({required this.voltage, required this.shimmer});
  @override void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;
    const tW = 7.0; final bW = size.width - tW; const bH = 36.0; final bY = (size.height - bH) / 2;
    paint.shader = const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF22C55E), Color(0xFF16A34A), Color(0xFF166534)]).createShader(Rect.fromLTWH(0, bY, bW, bH));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, bY, bW, bH), const Radius.circular(8)), paint);
    paint.shader = null; paint.color = Colors.black.withOpacity(0.2); paint.style = PaintingStyle.stroke; paint.strokeWidth = 1.5;
    for (int i = 1; i < 4; i++) canvas.drawLine(Offset(bW * i / 4, bY + 5), Offset(bW * i / 4, bY + bH - 5), paint);
    paint.shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white.withOpacity(0.3), Colors.transparent]).createShader(Rect.fromLTWH(4, bY + 2, bW - 8, bH / 2));
    paint.style = PaintingStyle.fill; canvas.drawRRect(RRect.fromRectAndCorners(Rect.fromLTWH(3, bY + 2, bW - 6, bH / 2 - 2), topLeft: const Radius.circular(6), topRight: const Radius.circular(6)), paint);
    // Shimmer
    final sX = -20 + (bW + 40) * shimmer;
    paint.shader = LinearGradient(colors: [Colors.transparent, Colors.white.withOpacity(0.2), Colors.transparent]).createShader(Rect.fromLTWH(sX - 15, bY, 30, bH));
    canvas.save(); canvas.clipRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, bY, bW, bH), const Radius.circular(8))); canvas.drawRect(Rect.fromLTWH(sX - 15, bY, 30, bH), paint); canvas.restore();
    // Terminal
    paint.shader = const LinearGradient(colors: [Color(0xFF4ADE80), Color(0xFF16A34A)]).createShader(Rect.fromLTWH(bW, bY + 8, tW, bH - 16));
    canvas.drawRRect(RRect.fromRectAndCorners(Rect.fromLTWH(bW, bY + 8, tW, bH - 16), topRight: const Radius.circular(4), bottomRight: const Radius.circular(4)), paint);
    // Label
    paint.shader = null;
    final tp = TextPainter(text: TextSpan(text: '${voltage.toStringAsFixed(0)}V', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')), textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset(bW / 2 - tp.width / 2, bY + bH / 2 - tp.height / 2));
  }
  @override bool shouldRepaint(_BatPainter old) => old.shimmer != shimmer || old.voltage != voltage;
}

// ============================================================
//  GLOW WIRE PAINTER (animasi arus dengan partikel)
// ============================================================
class _GlowWirePainter extends CustomPainter {
  final Map<String, CircuitNode> nodes;
  final Map<String, CircuitComponent> components;
  final double animationValue;
  final double current;

  _GlowWirePainter({required this.nodes, required this.components, required this.animationValue, required this.current});

  @override void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final drawn = <String>{};

    for (final node in nodes.values) {
      for (final connId in node.connectedTo) {
        final key = ([node.id, connId]..sort()).join('-');
        if (drawn.contains(key)) continue;
        final target = nodes[connId]; if (target == null) continue;

        final hasCurrent = _hasCurrent(node.id, connId);

        if (hasCurrent && current > 0) {
          // Glow shadow
          paint.color = const Color(0xFF3B82F6).withOpacity(0.3);
          paint.strokeWidth = 8;
          canvas.drawLine(node.position, target.position, paint);
          // Core wire
          paint.shader = LinearGradient(
            colors: [const Color(0xFFFFD700), const Color(0xFFFFAB40), const Color(0xFFFFD700)],
            stops: [
              (animationValue % 1),
              ((animationValue + 0.15) % 1).clamp(0, 1),
              ((animationValue + 0.3) % 1),
            ],
          ).createShader(Rect.fromPoints(node.position, target.position));
          paint.strokeWidth = 3;
          canvas.drawLine(node.position, target.position, paint);
          // Particle dot
          paint.shader = null;
          paint.color = Colors.white.withOpacity(0.8);
          paint.style = PaintingStyle.fill;
          final pFrac = animationValue % 1;
          final px = node.position.dx + (target.position.dx - node.position.dx) * pFrac;
          final py = node.position.dy + (target.position.dy - node.position.dy) * pFrac;
          canvas.drawCircle(Offset(px, py), 3.5, paint);
          paint.style = PaintingStyle.stroke;
        } else {
          paint.shader = null;
          paint.color = const Color(0xFF2A3A50);
          paint.strokeWidth = 2.5;
          canvas.drawLine(node.position, target.position, paint);
        }
        drawn.add(key);
      }
    }
  }

  bool _hasCurrent(String a, String b) {
    for (final comp in components.values) {
      if (!comp.isConnected) continue;
      if ((comp.startNodeId == a && comp.endNodeId == b) || (comp.startNodeId == b && comp.endNodeId == a)) return true;
    }
    final nA = nodes[a]; final nB = nodes[b];
    return nA?.currentFlow == true && nB?.currentFlow == true;
  }

  @override bool shouldRepaint(_GlowWirePainter old) => old.animationValue != animationValue || old.current != current || old.nodes.length != nodes.length;
}

// ============================================================
//  HELPER WIDGETS
// ============================================================
class _BackgroundOrbs extends StatelessWidget {
  final double pulse;
  const _BackgroundOrbs({required this.pulse});
  @override Widget build(BuildContext context) => Stack(children: [
    Positioned(top: -60, left: -60, child: _Orb(size: 220, color: const Color(0xFF3B82F6), opacity: 0.08 + 0.03 * pulse)),
    Positioned(bottom: 100, right: -40, child: _Orb(size: 180, color: const Color(0xFF8B5CF6), opacity: 0.07 + 0.02 * pulse)),
  ]);
}
class _Orb extends StatelessWidget {
  final double size; final Color color; final double opacity;
  const _Orb({required this.size, required this.color, required this.opacity});
  @override Widget build(BuildContext context) => Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [color.withOpacity(opacity), Colors.transparent])));
}

class _CanvasGrid extends StatelessWidget {
  const _CanvasGrid();
  @override Widget build(BuildContext context) => IgnorePointer(child: Opacity(opacity: 0.12, child: CustomPaint(painter: _GridPainter2(), size: Size.infinite)));
}
class _GridPainter2 extends CustomPainter {
  @override void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF3B82F6)..strokeWidth = 0.7;
    for (double y = 40; y < size.height; y += 80) canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    for (double x = 40; x < size.width; x += 80) canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
  }
  @override bool shouldRepaint(_) => false;
}

class _GlassPill extends StatelessWidget {
  final String label; final IconData icon; final Color color;
  const _GlassPill({required this.label, required this.icon, required this.color});
  @override Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(999),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), color: color.withOpacity(0.15), border: Border.all(color: color.withOpacity(0.4))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        ]),
      ),
    ),
  );
}

class _StatusPill extends StatelessWidget {
  final double current;
  const _StatusPill({required this.current});
  @override Widget build(BuildContext context) {
    final isActive = current > 0;
    final isOver = current > 2.0;
    final col = isOver ? Colors.redAccent : (isActive ? const Color(0xFF4ADE80) : Colors.white38);
    final label = isOver ? 'OVERCURRENT' : (isActive ? 'AKTIF' : 'MATI');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: col.withOpacity(0.12), border: Border.all(color: col.withOpacity(0.4))),
      child: Row(children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: col)),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.spaceGrotesk(color: col, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
      ]),
    );
  }
}

class _VIRCard extends StatelessWidget {
  final IconData icon; final String label; final String value; final String unit; final Color color;
  const _VIRCard({required this.icon, required this.label, required this.value, required this.unit, required this.color});
  @override Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    decoration: BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withOpacity(0.1), color.withOpacity(0.04)]),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.25)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, color: color, size: 12),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 9)),
      ]),
      const SizedBox(height: 4),
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(value, style: GoogleFonts.orbitron(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(width: 2),
        Padding(padding: const EdgeInsets.only(bottom: 1), child: Text(unit, style: GoogleFonts.spaceGrotesk(color: color.withOpacity(0.7), fontSize: 9))),
      ]),
    ]),
  ));
}

class _OvercurrentEffect extends StatefulWidget {
  const _OvercurrentEffect();
  @override State<_OvercurrentEffect> createState() => _OvercurrentEffectState();
}
class _OvercurrentEffectState extends State<_OvercurrentEffect> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override void initState() { super.initState(); _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400))..repeat(reverse: true); }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: _ctrl, builder: (_, __) => CustomPaint(size: const Size(50, 50), painter: _FirePainter2(_ctrl.value)));
}
class _FirePainter2 extends CustomPainter {
  final double p; _FirePainter2(this.p);
  @override void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true..style = PaintingStyle.fill;
    final cx = size.width / 2; final cy = size.height / 2;
    for (int i = 0; i < 5; i++) {
      final oY = cy - p * 18 - i * 3.5; final oX = cx + (i.isEven ? -2.5 : 2.5) * i;
      paint.shader = RadialGradient(colors: [Colors.red, Colors.orange, Colors.yellow.withOpacity(0)], stops: const [0, 0.5, 1]).createShader(Rect.fromCircle(center: Offset(oX, oY), radius: 7 + i * 1.5));
      canvas.drawCircle(Offset(oX, oY), 7 + i.toDouble(), paint);
    }
  }
  @override bool shouldRepaint(_FirePainter2 old) => old.p != p;
}