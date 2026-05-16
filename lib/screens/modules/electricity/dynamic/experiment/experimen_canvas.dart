import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================
//  MODEL & ENUM
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
//  SCREEN UTAMA - RANGKAIAN PARALEL
// ============================================================
class ExperimenCanvasParalel extends StatefulWidget {
  final dynamic target;
  const ExperimenCanvasParalel({super.key, required this.target});

  @override
  State<ExperimenCanvasParalel> createState() => _ExperimentCanvasParalelState();
}

class _ExperimentCanvasParalelState extends State<ExperimenCanvasParalel>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _bgPulseCtrl;

  // ── Komponen paralel default ──────────────────────────────
  // Topologi: baterai + 2 cabang paralel (masing2 berisi 1 lampu)
  // Bisa ditambah cabang baru lewat toolbar
  Map<String, CircuitNode> _nodes = {};
  Map<String, CircuitComponent> _components = {};
  String? _currentlyDraggingComponentId;
  bool _isConnectingMode = false;
  String? _firstSelectedNodeId;

  // VIR Paralel
  double _totalVoltage = 0.0;
  double _equivalentResistance = 0.0;
  double _totalCurrent = 0.0;
  List<double> _branchCurrents = [];

  // Cabang paralel (list of component ids per cabang)
  List<List<String>> _parallelBranches = [];

  // Warna tema
  static const _darkBg    = Color(0xFF07090F);
  static const _panelBg   = Color(0xFF0C1220);
  static const _cardBg    = Color(0xFF131D2E);
  static const _accent     = Color(0xFF38BDF8);
  static const _accentSoft = Color(0xFF0EA5E9);
  static const _purple     = Color(0xFFA78BFA);
  static const _green      = Color(0xFF34D399);
  static const _amber      = Color(0xFFFBBF24);
  static const _red        = Color(0xFFF87171);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    _bgPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
    _initParallelCircuit();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bgPulseCtrl.dispose();
    super.dispose();
  }

  // ── Setup awal: 1 baterai + 2 cabang lampu ───────────────
  void _initParallelCircuit() {
    _nodes = {};
    _components = {};
    _parallelBranches = [];

    // Node bus kiri & kanan (rel positif & negatif)
    const busLeftX  = 120.0;
    const busRightX = 500.0;
    const busTopY   = 100.0;
    const busBotY   = 400.0;

    _nodes['NL'] = CircuitNode(id: 'NL', position: const Offset(busLeftX, busTopY));
    _nodes['NLb'] = CircuitNode(id: 'NLb', position: const Offset(busLeftX, busBotY));
    _nodes['NR'] = CircuitNode(id: 'NR', position: const Offset(busRightX, busTopY));
    _nodes['NRb'] = CircuitNode(id: 'NRb', position: const Offset(busRightX, busBotY));

    // Sambungan bus horizontal atas & bawah (kawat)
    _nodes['NL']!.connectedTo = ['NR'];
    _nodes['NR']!.connectedTo = ['NL'];
    _nodes['NLb']!.connectedTo = ['NRb'];
    _nodes['NRb']!.connectedTo = ['NLb'];

    // Baterai (vertikal di sisi kiri)
    _components['CBAT'] = CircuitComponent(
      id: 'CBAT', type: ComponentType.battery,
      startNodeId: 'NL', endNodeId: 'NLb',
      value: 12.0, isConnected: true,
    );

    // 2 cabang awal (lampu)
    _addParallelBranch(branchIndex: 0, x: 230.0);
    _addParallelBranch(branchIndex: 1, x: 370.0);

    _updateParallelFlow();
    setState(() {});
  }

  // ── Tambah cabang paralel baru ────────────────────────────
  void _addParallelBranch({required int branchIndex, double? x}) {
    final posX = x ?? (230.0 + _parallelBranches.length * 100.0);
    final topY  = 100.0;
    final botY  = 400.0;
    final midY  = (topY + botY) / 2;

    final nTopId = 'NBT$branchIndex';
    final nBotId = 'NBB$branchIndex';
    final compId = 'CL$branchIndex';

    _nodes[nTopId] = CircuitNode(id: nTopId, position: Offset(posX, topY));
    _nodes[nBotId] = CircuitNode(id: nBotId, position: Offset(posX, botY));

    // Hubungkan ke bus
    _nodes['NL']!.connectedTo = [..._nodes['NL']!.connectedTo, nTopId];
    _nodes[nTopId]!.connectedTo = ['NL'];
    _nodes['NLb']!.connectedTo = [..._nodes['NLb']!.connectedTo, nBotId];
    _nodes[nBotId]!.connectedTo = ['NLb'];

    _components[compId] = CircuitComponent(
      id: compId, type: ComponentType.lamp,
      startNodeId: nTopId, endNodeId: nBotId,
      value: 4.0 + branchIndex * 2.0,
    );

    _parallelBranches.add([compId]);
  }

  // ── Hapus cabang terakhir ─────────────────────────────────
  void _removeLastBranch() {
    if (_parallelBranches.length <= 1) return;
    final idx = _parallelBranches.length - 1;
    final branch = _parallelBranches.removeLast();

    for (final compId in branch) {
      final comp = _components.remove(compId);
      if (comp != null) {
        for (final nodeId in [comp.startNodeId, comp.endNodeId]) {
          _nodes['NL']?.connectedTo = _nodes['NL']!.connectedTo.where((id) => id != nodeId).toList();
          _nodes['NLb']?.connectedTo = _nodes['NLb']!.connectedTo.where((id) => id != nodeId).toList();
          _nodes['NR']?.connectedTo = _nodes['NR']!.connectedTo.where((id) => id != nodeId).toList();
          _nodes['NRb']?.connectedTo = _nodes['NRb']!.connectedTo.where((id) => id != nodeId).toList();
          _nodes.remove(nodeId);
        }
      }
    }
    _updateParallelFlow();
    setState(() {});
  }

  // ── Tambah cabang dari toolbar ────────────────────────────
  void _addBranchFromToolbar() {
    final idx = _parallelBranches.length;
    final posX = 230.0 + idx * 100.0;
    setState(() {
      _addParallelBranch(branchIndex: idx, x: posX);
      _updateParallelFlow();
    });
  }

  // ── Reset ─────────────────────────────────────────────────
  void _reset() {
    setState(() { _initParallelCircuit(); });
  }

  // ── Toggle lampu ──────────────────────────────────────────
  void _toggleLamp(String compId) {
    setState(() {
      final comp = _components[compId];
      if (comp != null) comp.isConnected = !comp.isConnected;
      _updateParallelFlow();
    });
  }

  // ── Hitung VIR Paralel ────────────────────────────────────
  void _updateParallelFlow() {
    final bat = _components['CBAT'];
    if (bat == null) return;
    _totalVoltage = bat.value ?? 12.0;

    // Resistansi ekivalen paralel: 1/Req = Σ(1/Ri) untuk cabang aktif
    double sumInverse = 0.0;
    _branchCurrents = [];

    for (final branch in _parallelBranches) {
      double branchR = 0.0;
      bool branchActive = true;
      for (final compId in branch) {
        final comp = _components[compId];
        if (comp == null || !comp.isConnected) { branchActive = false; break; }
        branchR += comp.value ?? 0;
      }
      if (branchActive && branchR > 0) {
        sumInverse += 1.0 / branchR;
        _branchCurrents.add(_totalVoltage / branchR);
      } else {
        _branchCurrents.add(0.0);
      }
    }

    _equivalentResistance = sumInverse > 0 ? 1.0 / sumInverse : 0.0;
    _totalCurrent = _equivalentResistance > 0 ? _totalVoltage / _equivalentResistance : 0.0;

    // Update working state
    for (int i = 0; i < _parallelBranches.length; i++) {
      final branch = _parallelBranches[i];
      final hasFlow = i < _branchCurrents.length && _branchCurrents[i] > 0;
      for (final compId in branch) {
        final comp = _components[compId];
        if (comp != null && comp.type == ComponentType.lamp) {
          comp.isWorking = hasFlow && comp.isConnected;
        }
      }
    }
    // Baterai selalu "aktif" jika ada arus
    _components['CBAT']?.isWorking = _totalCurrent > 0;
  }

  Color _branchColor(int idx) {
    final colors = [_accent, _purple, _green, _amber, _red];
    return colors[idx % colors.length];
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
        builder: (context, _) {
          return Stack(
            children: [
              _BackgroundOrbs(pulse: _bgPulseCtrl.value),
              SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            _buildParallelCanvas(),
                            const SizedBox(height: 12),
                            _buildBranchDetailCards(),
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

  // ── App Bar ───────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Eksperimen ${widget.target ?? 'Listrik'}',
                style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Text(
                'Rangkaian Paralel',
                style: GoogleFonts.spaceGrotesk(color: _accent, fontSize: 11, letterSpacing: 1.2),
              ),
            ],
          ),
          const Spacer(),
          _StatusPill(current: _totalCurrent),
        ],
      ),
    );
  }

  // ── Canvas Paralel ────────────────────────────────────────
  Widget _buildParallelCanvas() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 460,
        decoration: BoxDecoration(
          color: const Color(0xFF080C16),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
          boxShadow: [
            BoxShadow(color: _accent.withOpacity(0.06), blurRadius: 30, spreadRadius: 2),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              const Positioned.fill(child: _CanvasGrid()),
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 2.5,
                boundaryMargin: const EdgeInsets.all(200),
                constrained: false,
                child: SizedBox(
                  width: 700,
                  height: 520,
                  child: Stack(
                    children: [
                      // Kabel & diagram paralel
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _ParallelWirePainter(
                            nodes: _nodes,
                            components: _components,
                            branches: _parallelBranches,
                            animValue: _animationController.value,
                            totalCurrent: _totalCurrent,
                            branchCurrents: _branchCurrents,
                            branchColors: List.generate(_parallelBranches.length, (i) => _branchColor(i)),
                          ),
                        ),
                      ),
                      // Baterai
                      ..._buildBatteryWidget(),
                      // Lampu per cabang
                      ..._buildLampWidgets(),
                    ],
                  ),
                ),
              ),
              // Label "Bus +" dan "Bus −"
              Positioned(
                top: 12, left: 20,
                child: _BusLabel(label: 'BUS +', color: _green),
              ),
              Positioned(
                bottom: 12, left: 20,
                child: _BusLabel(label: 'BUS −', color: _red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBatteryWidget() {
    final bat = _components['CBAT'];
    final nL = _nodes['NL'];
    final nLb = _nodes['NLb'];
    if (bat == null || nL == null || nLb == null) return [];

    final centerX = nL.position.dx;
    final centerY = (nL.position.dy + nLb.position.dy) / 2;

    return [
      Positioned(
        left: centerX - 30,
        top: centerY - 60,
        child: GestureDetector(
          onPanUpdate: (d) {
            setState(() {
              nL.position += Offset(d.delta.dx, 0);
              nLb.position += Offset(d.delta.dx, 0);
              _updateParallelFlow();
            });
          },
          child: _InlineBattery3D(voltage: bat.value ?? 12),
        ),
      ),
    ];
  }

  List<Widget> _buildLampWidgets() {
    final widgets = <Widget>[];
    for (int i = 0; i < _parallelBranches.length; i++) {
      final branch = _parallelBranches[i];
      for (final compId in branch) {
        final comp = _components[compId];
        final nTop = _nodes[comp?.startNodeId ?? ''];
        final nBot = _nodes[comp?.endNodeId ?? ''];
        if (comp == null || nTop == null || nBot == null) continue;

        final cx = nTop.position.dx;
        final cy = (nTop.position.dy + nBot.position.dy) / 2;
        final col = _branchColor(i);
        final branchI = i < _branchCurrents.length ? _branchCurrents[i] : 0.0;

        widgets.add(
          Positioned(
            left: cx - 36,
            top: cy - 70,
            child: GestureDetector(
              onTap: () => _toggleLamp(compId),
              onPanUpdate: (d) {
                setState(() {
                  nTop.position += Offset(d.delta.dx, 0);
                  nBot.position += Offset(d.delta.dx, 0);
                  _updateParallelFlow();
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _InlineLamp3D(
                    isLit: comp.isWorking && comp.isConnected,
                    color: col,
                    current: branchI,
                  ),
                  const SizedBox(height: 4),
                  _buildMiniSlider(comp, col),
                ],
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }

  Widget _buildMiniSlider(CircuitComponent comp, Color col) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Text(
            'R: ${comp.value?.toStringAsFixed(1)}Ω',
            style: GoogleFonts.spaceGrotesk(color: col, fontSize: 9, fontWeight: FontWeight.w600),
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              activeTrackColor: col,
              inactiveTrackColor: col.withOpacity(0.15),
              thumbColor: col,
              overlayColor: col.withOpacity(0.15),
            ),
            child: Slider(
              value: comp.value ?? 1,
              min: 1,
              max: 20,
              divisions: 38,
              onChanged: (v) => setState(() { comp.value = v; _updateParallelFlow(); }),
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu detail tiap cabang ──────────────────────────────
  Widget _buildBranchDetailCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 2),
            child: Text(
              'Detail Cabang',
              style: GoogleFonts.orbitron(color: Colors.white54, fontSize: 11, letterSpacing: 1),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_parallelBranches.length, (i) {
                final branch = _parallelBranches[i];
                final col = _branchColor(i);
                final I = i < _branchCurrents.length ? _branchCurrents[i] : 0.0;
                double R = 0;
                bool active = true;
                for (final cId in branch) {
                  final c = _components[cId];
                  if (c == null || !c.isConnected) { active = false; break; }
                  R += c.value ?? 0;
                }
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [col.withOpacity(0.12), col.withOpacity(0.04)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: col.withOpacity(active ? 0.35 : 0.15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: active ? col : Colors.grey)),
                        const SizedBox(width: 6),
                        Text('Cabang ${i + 1}', style: GoogleFonts.spaceGrotesk(color: col, fontSize: 11, fontWeight: FontWeight.w700)),
                      ]),
                      const SizedBox(height: 8),
                      _BranchStat(label: 'V', value: '${_totalVoltage.toStringAsFixed(1)} V', color: col),
                      _BranchStat(label: 'R', value: '${R.toStringAsFixed(1)} Ω', color: col),
                      _BranchStat(label: 'I', value: '${I.toStringAsFixed(3)} A', color: col),
                      if (!active)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: _red.withOpacity(0.4)),
                            ),
                            child: Text('PUTUS', style: GoogleFonts.spaceGrotesk(color: _red, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 1)),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tool Panel ────────────────────────────────────────────
  Widget _buildToolPanel() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _panelBg.withOpacity(0.92),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.07))),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildActionBtn(Icons.add_circle_outline_rounded, 'Tambah\nCabang', _green, _addBranchFromToolbar),
                const SizedBox(width: 10),
                _buildActionBtn(Icons.remove_circle_outline_rounded, 'Hapus\nCabang', _red, _removeLastBranch),
                const SizedBox(width: 16),
                _buildActionBtn(Icons.battery_full_rounded, 'Edit\nBaterai', _amber, _showBatteryDialog),
                const SizedBox(width: 16),
                _buildActionBtn(Icons.refresh_rounded, 'Reset', Colors.white38, _reset),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBatteryDialog() {
    final bat = _components['CBAT'];
    if (bat == null) return;
    double tempV = bat.value ?? 12.0;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (ctx, setD) => AlertDialog(
        backgroundColor: _cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Tegangan Baterai', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${tempV.toStringAsFixed(1)} V', style: GoogleFonts.orbitron(color: _amber, fontSize: 26, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: _amber, inactiveTrackColor: _amber.withOpacity(0.2),
                thumbColor: _amber, overlayColor: _amber.withOpacity(0.15),
                trackHeight: 4,
              ),
              child: Slider(
                value: tempV, min: 1, max: 30, divisions: 58,
                onChanged: (v) => setD(() { tempV = v; }),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Batal', style: GoogleFonts.poppins(color: Colors.white38))),
          TextButton(
            onPressed: () {
              setState(() { bat.value = tempV; _updateParallelFlow(); });
              Navigator.pop(ctx);
            },
            child: Text('Simpan', style: GoogleFonts.poppins(color: _amber, fontWeight: FontWeight.w600)),
          ),
        ],
      )),
    );
  }

  Widget _buildActionBtn(IconData icon, String label, Color col, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 68, height: 64,
        decoration: BoxDecoration(
          color: col.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: col.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: col, size: 22),
            const SizedBox(height: 3),
            Text(label, textAlign: TextAlign.center, style: GoogleFonts.poppins(color: col.withOpacity(0.85), fontSize: 8, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // ── VIR Panel Paralel ─────────────────────────────────────
  Widget _buildVIRPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
      decoration: BoxDecoration(
        color: _panelBg,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 2),
            child: Text('Rangkaian Paralel — Hukum Ohm', style: GoogleFonts.spaceGrotesk(color: Colors.white24, fontSize: 10, letterSpacing: 0.8)),
          ),
          Row(
            children: [
              _VIRCard(icon: Icons.bolt_rounded,          label: 'Tegangan', value: _totalVoltage.toStringAsFixed(2),        unit: 'V', color: _amber),
              const SizedBox(width: 8),
              _VIRCard(icon: Icons.waves_rounded,          label: 'Req Paralel', value: _equivalentResistance.toStringAsFixed(2), unit: 'Ω', color: _accent),
              const SizedBox(width: 8),
              _VIRCard(icon: Icons.electric_bolt_rounded, label: 'Arus Total', value: _totalCurrent.toStringAsFixed(3),       unit: 'A', color: _green),
            ],
          ),
          const SizedBox(height: 8),
          // Rumus Req paralel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Text(
              '1/Req = ${_parallelBranches.asMap().entries.map((e) => '1/R${e.key + 1}').join(' + ')}',
              style: GoogleFonts.spaceMono(color: Colors.white38, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildARButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: double.infinity, height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFEA580C), Color(0xFFDC2626)]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: const Color(0xFFEA580C).withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))],
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
//  PARALLEL WIRE PAINTER
// ============================================================
class _ParallelWirePainter extends CustomPainter {
  final Map<String, CircuitNode> nodes;
  final Map<String, CircuitComponent> components;
  final List<List<String>> branches;
  final double animValue;
  final double totalCurrent;
  final List<double> branchCurrents;
  final List<Color> branchColors;

  _ParallelWirePainter({
    required this.nodes, required this.components, required this.branches,
    required this.animValue, required this.totalCurrent,
    required this.branchCurrents, required this.branchColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final nL  = nodes['NL'];
    final nLb = nodes['NLb'];
    final nR  = nodes['NR'];
    final nRb = nodes['NRb'];
    if (nL == null || nLb == null) return;

    final paint = Paint()..isAntiAlias = true..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final hasFlow = totalCurrent > 0;

    // Bus kiri vertikal (baterai sisi)
    _drawWireSegment(canvas, paint, nL.position, nLb.position, hasFlow, const Color(0xFF38BDF8), animValue, isVertical: true);

    // Bus kanan vertikal (jika ada)
    if (nR != null && nRb != null) {
      _drawWireSegment(canvas, paint, nR.position, nRb.position, false, const Color(0xFF38BDF8), animValue, isVertical: true);
    }

    // Cabang paralel
    for (int i = 0; i < branches.length; i++) {
      final branch = branches[i];
      final col = i < branchColors.length ? branchColors[i] : const Color(0xFF38BDF8);
      final branchHasFlow = i < branchCurrents.length && branchCurrents[i] > 0;

      for (final compId in branch) {
        final comp = components[compId];
        if (comp == null) continue;
        final nTop = nodes[comp.startNodeId];
        final nBot = nodes[comp.endNodeId];
        if (nTop == null || nBot == null) continue;

        // Kawat dari bus ke komponen (atas)
        _drawWireSegment(canvas, paint, nL.position, nTop.position, branchHasFlow, col, animValue);
        // Kawat dari komponen ke bus (bawah)
        _drawWireSegment(canvas, paint, nBot.position, nLb.position, branchHasFlow, col, animValue, reversed: true);

        // Partikel arus di cabang
        if (branchHasFlow) {
          _drawParticles(canvas, nTop.position, nBot.position, col, animValue, vertical: true);
        }

        // Junction dot
        _drawJunction(canvas, nTop.position, col, branchHasFlow);
        _drawJunction(canvas, nBot.position, col, branchHasFlow);
      }
    }
  }

  void _drawWireSegment(Canvas canvas, Paint paint, Offset a, Offset b, bool active, Color col, double anim, {bool isVertical = false, bool reversed = false}) {
    if (active) {
      // Glow
      paint.color = col.withOpacity(0.2);
      paint.strokeWidth = 8;
      canvas.drawLine(a, b, paint);
      // Core wire animasi
      paint.shader = LinearGradient(
        colors: [col.withOpacity(0.3), col, col.withOpacity(0.3)],
        stops: [(anim % 1), ((anim + 0.25) % 1).clamp(0.0, 1.0), ((anim + 0.5) % 1)],
      ).createShader(Rect.fromPoints(a, b));
      paint.strokeWidth = 3;
      canvas.drawLine(a, b, paint);
      paint.shader = null;
      // Partikel
      _drawParticles(canvas, a, b, col, reversed ? 1.0 - anim : anim);
    } else {
      paint.shader = null;
      paint.color = const Color(0xFF1E3050);
      paint.strokeWidth = 2.5;
      canvas.drawLine(a, b, paint);
    }
  }

  void _drawParticles(Canvas canvas, Offset a, Offset b, Color col, double t, {bool vertical = false}) {
    final particlePaint = Paint()..isAntiAlias = true..style = PaintingStyle.fill;
    for (int p = 0; p < 3; p++) {
      final frac = (t + p / 3.0) % 1.0;
      final px = a.dx + (b.dx - a.dx) * frac;
      final py = a.dy + (b.dy - a.dy) * frac;
      final r = (3.5 - p * 0.7).clamp(1.5, 4.0);
      // Glow
      particlePaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      particlePaint.color = col.withOpacity(0.5);
      canvas.drawCircle(Offset(px, py), r * 2, particlePaint);
      // Core
      particlePaint.maskFilter = null;
      particlePaint.color = Colors.white.withOpacity(0.9 - p * 0.25);
      canvas.drawCircle(Offset(px, py), r, particlePaint);
    }
  }

  void _drawJunction(Canvas canvas, Offset pos, Color col, bool active) {
    final jPaint = Paint()..isAntiAlias = true..style = PaintingStyle.fill;
    if (active) {
      jPaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      jPaint.color = col.withOpacity(0.5);
      canvas.drawCircle(pos, 8, jPaint);
      jPaint.maskFilter = null;
      jPaint.color = col;
      canvas.drawCircle(pos, 4, jPaint);
      jPaint.color = Colors.white;
      canvas.drawCircle(pos, 1.5, jPaint);
    } else {
      jPaint.color = const Color(0xFF1E3050);
      canvas.drawCircle(pos, 4, jPaint);
      jPaint.style = PaintingStyle.stroke;
      jPaint.color = const Color(0xFF2A4060);
      jPaint.strokeWidth = 1;
      canvas.drawCircle(pos, 4, jPaint);
    }
  }

  @override
  bool shouldRepaint(_ParallelWirePainter old) =>
      old.animValue != animValue || old.totalCurrent != totalCurrent || old.nodes.length != nodes.length;
}

// ============================================================
//  INLINE LAMP 3D
// ============================================================
class _InlineLamp3D extends StatefulWidget {
  final bool isLit;
  final Color color;
  final double current;
  const _InlineLamp3D({required this.isLit, required this.color, required this.current});
  @override State<_InlineLamp3D> createState() => _InlineLamp3DState();
}
class _InlineLamp3DState extends State<_InlineLamp3D> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pulse;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.78, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(
    animation: _pulse,
    builder: (_, __) => CustomPaint(
      size: const Size(72, 96),
      painter: _Lamp3DPainter(
        isLit: widget.isLit,
        color: widget.color,
        pulse: widget.isLit ? _pulse.value : 0,
        current: widget.current,
      ),
    ),
  );
}

class _Lamp3DPainter extends CustomPainter {
  final bool isLit;
  final Color color;
  final double pulse;
  final double current;
  _Lamp3DPainter({required this.isLit, required this.color, required this.pulse, required this.current});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.36;
    final r  = size.width * 0.36;
    final paint = Paint()..isAntiAlias = true;

    // Aura luar
    if (isLit && pulse > 0) {
      final hR = r * (2.0 + 0.4 * pulse);
      paint.shader = RadialGradient(
        colors: [color.withOpacity(0.55 * pulse), color.withOpacity(0.18 * pulse), Colors.transparent],
        stops: const [0, 0.45, 1],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: hR));
      canvas.drawCircle(Offset(cx, cy), hR, paint);
    }

    // Body bohlam
    final bulbPath = Path();
    final nW = r * 0.38;
    final nT = cy + r * 0.65;
    final nB = cy + r * 0.95;
    bulbPath.addArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), pi, pi);
    bulbPath.cubicTo(cx + r, nT, cx + nW, nT, cx + nW, nB);
    bulbPath.lineTo(cx - nW, nB);
    bulbPath.cubicTo(cx - nW, nT, cx - r, nT, cx - r, cy);
    bulbPath.close();

    if (isLit) {
      final c2 = Color.lerp(Colors.white, color, 0.2)!;
      paint.shader = RadialGradient(
        center: const Alignment(-0.25, -0.4),
        radius: 1.1,
        colors: [c2, color.withOpacity(0.95), color.withOpacity(0.6)],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    } else {
      paint.shader = RadialGradient(
        center: const Alignment(-0.25, -0.4), radius: 1.1,
        colors: [const Color(0xFF252540), const Color(0xFF191930), const Color(0xFF0E0E22)],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    }
    paint.style = PaintingStyle.fill;
    canvas.drawPath(bulbPath, paint);

    // Highlight 3D
    paint.shader = LinearGradient(
      begin: Alignment.topLeft, end: Alignment.center,
      colors: [Colors.white.withOpacity(isLit ? 0.45 : 0.08), Colors.transparent],
    ).createShader(Rect.fromCircle(center: Offset(cx - r * 0.3, cy - r * 0.35), radius: r * 0.6));
    canvas.drawPath(bulbPath, paint);

    // Border
    paint.shader = null;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.5;
    paint.color = isLit ? color.withOpacity(0.5) : const Color(0xFF2A2A4A);
    canvas.drawPath(bulbPath, paint);

    // Filamen zigzag
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = isLit ? 2.2 : 1.5;
    final sX = cx - r * 0.36;
    final sY = cy + r * 0.05;
    final amp = isLit ? r * 0.22 * (0.75 + 0.25 * pulse) : r * 0.18;
    final fPath = Path();
    fPath.moveTo(sX, sY);
    for (int i = 0; i < 7; i++) {
      fPath.lineTo(sX + i * (r * 0.72 / 6), sY + (i.isEven ? -amp : amp));
    }
    if (isLit) {
      paint.shader = LinearGradient(
        colors: [Colors.white.withOpacity(0.9), Color.lerp(Colors.white, color, 0.4)!, Colors.white.withOpacity(0.9)],
      ).createShader(Rect.fromLTWH(sX, sY - amp, r * 0.72, amp * 2));
    } else {
      paint.shader = null;
      paint.color = const Color(0xFF44446A);
    }
    canvas.drawPath(fPath, paint);

    // Base (socket)
    paint.shader = null;
    paint.style = PaintingStyle.fill;
    final segments = 4;
    for (int i = 0; i < segments; i++) {
      final w = nW * (1.0 - i * 0.1);
      final top = nB + i * (size.height - nB) / segments;
      paint.shader = LinearGradient(
        colors: const [Color(0xFF334155), Color(0xFF475569), Color(0xFF1E293B)],
      ).createShader(Rect.fromLTWH(cx - w, top, w * 2, 5));
      canvas.drawRect(Rect.fromLTWH(cx - w, top, w * 2, (size.height - nB) / segments - 0.5), paint);
    }

    // Lingkaran terminal bawah
    paint.shader = null;
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFF64748B);
    canvas.drawCircle(Offset(cx, size.height - 3), 4, paint);
    if (isLit) {
      paint.color = color.withOpacity(0.5);
      canvas.drawCircle(Offset(cx, size.height - 3), 6, paint);
    }
  }

  @override bool shouldRepaint(_Lamp3DPainter old) =>
      old.isLit != isLit || old.pulse != pulse || old.color != color;
}

// ============================================================
//  INLINE BATTERY 3D
// ============================================================
class _InlineBattery3D extends StatefulWidget {
  final double voltage;
  const _InlineBattery3D({required this.voltage});
  @override State<_InlineBattery3D> createState() => _InlineBattery3DState();
}
class _InlineBattery3DState extends State<_InlineBattery3D> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override void initState() { super.initState(); _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(); }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) => CustomPaint(
      size: const Size(60, 120),
      painter: _Battery3DPainter(voltage: widget.voltage, shimmer: _ctrl.value),
    ),
  );
}

class _Battery3DPainter extends CustomPainter {
  final double voltage;
  final double shimmer;
  _Battery3DPainter({required this.voltage, required this.shimmer});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;
    const tH = 10.0;
    final bH = size.height - tH - 8;
    const bX = 4.0;
    final bW = size.width - 8;

    // Body baterai (vertikal)
    paint.shader = const LinearGradient(
      begin: Alignment.centerLeft, end: Alignment.centerRight,
      colors: [Color(0xFF166534), Color(0xFF22C55E), Color(0xFF16A34A), Color(0xFF166534)],
      stops: [0, 0.3, 0.7, 1],
    ).createShader(Rect.fromLTWH(bX, tH, bW, bH));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(bX, tH, bW, bH), const Radius.circular(8)), paint);

    // Garis segmen (level baterai visual)
    paint.shader = null;
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.black.withOpacity(0.18);
    paint.strokeWidth = 1.2;
    for (int i = 1; i < 4; i++) {
      final segY = tH + bH * i / 4;
      canvas.drawLine(Offset(bX + 6, segY), Offset(bX + bW - 6, segY), paint);
    }

    // Highlight sisi kiri
    paint.shader = LinearGradient(
      begin: Alignment.centerLeft, end: Alignment.center,
      colors: [Colors.white.withOpacity(0.22), Colors.transparent],
    ).createShader(Rect.fromLTWH(bX, tH, bW * 0.4, bH));
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndCorners(Rect.fromLTWH(bX, tH, bW * 0.35, bH),
          topLeft: const Radius.circular(8), bottomLeft: const Radius.circular(8)),
      paint,
    );

    // Shimmer
    final sY = tH + bH * shimmer - 20;
    paint.shader = LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [Colors.transparent, Colors.white.withOpacity(0.2), Colors.transparent],
    ).createShader(Rect.fromLTWH(bX, sY, bW, 40));
    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(Rect.fromLTWH(bX, tH, bW, bH), const Radius.circular(8)));
    canvas.drawRect(Rect.fromLTWH(bX, sY, bW, 40), paint);
    canvas.restore();

    // Terminal + (atas)
    paint.shader = const LinearGradient(
      colors: [Color(0xFF4ADE80), Color(0xFF16A34A)],
    ).createShader(Rect.fromLTWH(bX + bW * 0.3, 0, bW * 0.4, tH));
    canvas.drawRRect(
      RRect.fromRectAndCorners(Rect.fromLTWH(bX + bW * 0.3, 0, bW * 0.4, tH),
          topLeft: const Radius.circular(4), topRight: const Radius.circular(4)),
      paint,
    );
    // + simbol
    final tpPlus = TextPainter(text: const TextSpan(text: '+', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    tpPlus.paint(canvas, Offset(size.width / 2 - tpPlus.width / 2, 0));

    // Terminal − (bawah)
    paint.shader = const LinearGradient(
      colors: [Color(0xFF475569), Color(0xFF334155)],
    ).createShader(Rect.fromLTWH(bX + bW * 0.3, tH + bH + 2, bW * 0.4, 6));
    canvas.drawRRect(
      RRect.fromRectAndCorners(Rect.fromLTWH(bX + bW * 0.3, tH + bH + 2, bW * 0.4, 6),
          bottomLeft: const Radius.circular(3), bottomRight: const Radius.circular(3)),
      paint,
    );

    // Label voltase
    paint.shader = null;
    final tp = TextPainter(
      text: TextSpan(text: '${voltage.toStringAsFixed(0)}V', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(size.width / 2 - tp.width / 2, tH + bH / 2 - tp.height / 2));
  }

  @override bool shouldRepaint(_Battery3DPainter old) => old.shimmer != shimmer || old.voltage != voltage;
}

// ============================================================
//  HELPER WIDGETS
// ============================================================
class _BackgroundOrbs extends StatelessWidget {
  final double pulse;
  const _BackgroundOrbs({required this.pulse});
  @override Widget build(BuildContext context) => Stack(children: [
    Positioned(top: -80, left: -80, child: _Orb(size: 260, color: const Color(0xFF0EA5E9), opacity: 0.07 + 0.025 * pulse)),
    Positioned(bottom: 120, right: -60, child: _Orb(size: 200, color: const Color(0xFFA78BFA), opacity: 0.06 + 0.02 * pulse)),
    Positioned(top: 200, right: 40, child: _Orb(size: 140, color: const Color(0xFF34D399), opacity: 0.04 + 0.015 * pulse)),
  ]);
}
class _Orb extends StatelessWidget {
  final double size; final Color color; final double opacity;
  const _Orb({required this.size, required this.color, required this.opacity});
  @override Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [color.withOpacity(opacity), Colors.transparent])),
  );
}

class _CanvasGrid extends StatelessWidget {
  const _CanvasGrid();
  @override Widget build(BuildContext context) => IgnorePointer(
    child: Opacity(
      opacity: 0.1,
      child: CustomPaint(painter: _GridPainter(), size: Size.infinite),
    ),
  );
}
class _GridPainter extends CustomPainter {
  @override void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF38BDF8)..strokeWidth = 0.6;
    for (double y = 0; y < size.height; y += 60) canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    for (double x = 0; x < size.width; x += 60) canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
  }
  @override bool shouldRepaint(_) => false;
}

class _BusLabel extends StatelessWidget {
  final String label; final Color color;
  const _BusLabel({required this.label, required this.color});
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: color.withOpacity(0.35)),
    ),
    child: Text(label, style: GoogleFonts.spaceGrotesk(color: color, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
  );
}

class _StatusPill extends StatelessWidget {
  final double current;
  const _StatusPill({required this.current});
  @override Widget build(BuildContext context) {
    final isActive = current > 0;
    final isOver = current > 3.0;
    final col = isOver ? const Color(0xFFF87171) : (isActive ? const Color(0xFF34D399) : Colors.white30);
    final label = isOver ? 'OVERCURRENT' : (isActive ? 'AKTIF' : 'MATI');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: col.withOpacity(0.1), border: Border.all(color: col.withOpacity(0.35))),
      child: Row(children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: col,
          boxShadow: isActive ? [BoxShadow(color: col, blurRadius: 6)] : null,
        )),
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
      border: Border.all(color: color.withOpacity(0.22)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, color: color, size: 11),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.poppins(color: Colors.white30, fontSize: 9)),
      ]),
      const SizedBox(height: 4),
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Flexible(child: Text(value, style: GoogleFonts.orbitron(color: color, fontSize: 13, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 2),
        Padding(padding: const EdgeInsets.only(bottom: 1), child: Text(unit, style: GoogleFonts.spaceGrotesk(color: color.withOpacity(0.65), fontSize: 9))),
      ]),
    ]),
  ));
}

class _BranchStat extends StatelessWidget {
  final String label; final String value; final Color color;
  const _BranchStat({required this.label, required this.value, required this.color});
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 3),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: GoogleFonts.spaceGrotesk(color: Colors.white30, fontSize: 10)),
      Text(value, style: GoogleFonts.spaceGrotesk(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    ]),
  );
}