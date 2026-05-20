import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'components/ar_view_screen.dart';

// ============================================================
//  MODEL & ENUM
// ============================================================
enum ComponentType { battery, lamp, wire }

class CircuitBranch {
  final int index;
  double resistance; // Ohm
  bool isConnected;
  bool isWorking;
  double current;

  CircuitBranch({
    required this.index,
    this.resistance = 4.0,
    this.isConnected = true,
    this.isWorking = false,
    this.current = 0.0,
  });
}

// ============================================================
//  SCREEN UTAMA - RANGKAIAN PARALEL
// ============================================================
class ExperimenCanvasParalel extends StatefulWidget {
  final dynamic target;

  const ExperimenCanvasParalel({super.key, required this.target});

  @override
  State<ExperimenCanvasParalel> createState() =>
      _ExperimentCanvasParalelState();
}

class _ExperimentCanvasParalelState extends State<ExperimenCanvasParalel>
    with TickerProviderStateMixin {
  // ── Animation Controllers ─────────────────────────────────
  late AnimationController _flowCtrl;
  late AnimationController _bgPulseCtrl;
  late AnimationController _lampGlowCtrl;
  late AnimationController _entryCtrl;

  // ── Audio ─────────────────────────────────────────────────
  final AudioPlayer _audioPlayer = AudioPlayer();

  // ── State Rangkaian ───────────────────────────────────────
  double _voltage = 12.0;
  List<CircuitBranch> _branches = [];

  // ── VIR hasil hitung ──────────────────────────────────────
  double _equivalentResistance = 0.0;
  double _totalCurrent = 0.0;

  // ── Warna Tema (Physics Lab Neon) ─────────────────────────
  static const _darkBg = Color(0xFF050812);
  static const _panelBg = Color(0xFF080D1A);
  static const _cardBg = Color(0xFF0D1525);
  static const _accent = Color(0xFF00D4FF);
  static const _accentDeep = Color(0xFF0099BB);
  static const _purple = Color(0xFF9D4EFF);
  static const _green = Color(0xFF00FF88);
  static const _greenDeep = Color(0xFF00CC6A);
  static const _amber = Color(0xFFFFB800);
  static const _red = Color(0xFFFF3D6B);
  static const _orange = Color(0xFFFF6B35);

  static const List<Color> _branchPalette = [
    Color(0xFF00D4FF),
    Color(0xFF9D4EFF),
    Color(0xFF00FF88),
    Color(0xFFFFB800),
    Color(0xFFFF3D6B),
    Color(0xFF00FFCC),
  ];

  @override
  void initState() {
    super.initState();

    _flowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _bgPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _lampGlowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _initBranches();
    _compute();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(0.4);
      await _audioPlayer.play(AssetSource('sounds/lab.mp3'));
    } catch (e) {
      debugPrint('Audio init failed: $e');
    }
  }

  @override
  void dispose() {
    _flowCtrl.dispose();
    _bgPulseCtrl.dispose();
    _lampGlowCtrl.dispose();
    _entryCtrl.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  // ── Init 2 cabang default ─────────────────────────────────
  void _initBranches() {
    _branches = [
      CircuitBranch(index: 0, resistance: 6.0),
      CircuitBranch(index: 1, resistance: 4.0),
    ];
  }

  // ── HITUNG VIR PARALEL ────────────────────────────────────
  void _compute() {
    double sumInverse = 0.0;
    double sumCurrent = 0.0;

    for (final b in _branches) {
      if (b.isConnected && b.resistance > 0) {
        final currentValue = _voltage / b.resistance;
        b.current = currentValue;
        b.isWorking = true;
        sumInverse += 1.0 / b.resistance;
        sumCurrent += currentValue;
      } else {
        b.current = 0.0;
        b.isWorking = false;
      }
    }

    _equivalentResistance = sumInverse > 0 ? 1.0 / sumInverse : 0.0;
    _totalCurrent = sumCurrent;
  }

  // ── Tambah cabang ─────────────────────────────────────────
  void _addBranch() {
    if (_branches.length >= 6) return;
    setState(() {
      _branches.add(
        CircuitBranch(
          index: _branches.length,
          resistance: 4.0 + _branches.length * 2.0,
        ),
      );
      _compute();
    });
  }

  // ── Hapus cabang ──────────────────────────────────────────
  void _removeBranch() {
    if (_branches.length <= 1) return;
    setState(() {
      _branches.removeLast();
      _compute();
    });
  }

  // ── Toggle lampu ──────────────────────────────────────────
  void _toggleLamp(int idx) {
    setState(() {
      _branches[idx].isConnected = !_branches[idx].isConnected;
      _compute();
    });
  }

  Color _branchColor(int idx) => _branchPalette[idx % _branchPalette.length];

  // ============================================================
  //  BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _flowCtrl,
          _bgPulseCtrl,
          _lampGlowCtrl,
          _entryCtrl,
        ]),
        builder: (context, _) {
          return Stack(
            children: [
              _buildBackground(),
              SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            _buildParallelCanvas(),
                            const SizedBox(height: 16),
                            _buildBranchCards(),
                            const SizedBox(height: 16),
                            _buildFormulaPanel(),
                            const SizedBox(height: 16),
                            _buildARButton(),
                            const SizedBox(height: 20),
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

  Widget _buildBackground() {
    final pulse = _bgPulseCtrl.value;
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF050812),
                Color(0xFF080D18),
                Color(0xFF050812),
              ],
            ),
          ),
        ),
        Positioned(
          top: -120,
          left: -100,
          child: _Orb(
            size: 380,
            color: _accent,
            opacity: 0.04 + 0.02 * pulse,
          ),
        ),
        Positioned(
          bottom: 80,
          right: -80,
          child: _Orb(
            size: 300,
            color: _purple,
            opacity: 0.05 + 0.015 * pulse,
          ),
        ),
        Positioned(
          top: 300,
          right: 60,
          child: _Orb(
            size: 180,
            color: _green,
            opacity: 0.03 + 0.01 * pulse,
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.06,
              child: CustomPaint(
                painter: _GridPainter(),
                size: Size.infinite,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _accent.withValues(alpha: 0.12))),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_panelBg, _panelBg.withValues(alpha: 0.0)],
        ),
      ),
      child: Row(
        children: [
          _GlassButton(
            onTap: () async {
              await _audioPlayer.stop();
              if (context.mounted) {
                Navigator.maybePop(context);
              }
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lab Fisika — Paralel',
                  style: GoogleFonts.rajdhani(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _totalCurrent > 0 ? _green : Colors.grey,
                        boxShadow: _totalCurrent > 0
                            ? [BoxShadow(color: _green, blurRadius: 6)]
                            : null,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _totalCurrent > 0 ? 'ARUS MENGALIR' : 'TIDAK ADA ARUS',
                      style: GoogleFonts.rajdhani(
                        color: _totalCurrent > 0 ? _green : Colors.grey,
                        fontSize: 10,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _StatusPill(current: _totalCurrent),
        ],
      ),
    );
  }

  Widget _buildParallelCanvas() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
        ),
        child: FadeTransition(
          opacity: _entryCtrl,
          child: Container(
            height: 420,
            decoration: BoxDecoration(
              color: const Color(0xFF060A14),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _accent.withValues(alpha: 0.15)),
              boxShadow: [
                BoxShadow(
                  color: _accent.withValues(alpha: 0.07),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.08,
                      child: CustomPaint(
                        painter: _GridPainter(),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ParallelCircuitPainter(
                        branches: _branches,
                        voltage: _voltage,
                        totalCurrent: _totalCurrent,
                        animValue: _flowCtrl.value,
                        branchColors: List.generate(
                          _branches.length,
                          (i) => _branchColor(i),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 20,
                    child: _BusLabel(
                      label: 'V+ (${_voltage.toStringAsFixed(1)}V)',
                      color: _green,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 20,
                    child: _BusLabel(
                      label: 'V− (GND)',
                      color: _red,
                    ),
                  ),
                  ..._buildInteractiveComponents(),
                  _buildBatteryWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBatteryWidget() {
    return Positioned(
      left: 16,
      top: 80,
      bottom: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _AnimatedBattery3D(
            voltage: _voltage,
            isActive: _totalCurrent > 0,
            animValue: _flowCtrl.value,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInteractiveComponents() {
    final widgets = <Widget>[];
    final count = _branches.length;

    const canvasLeft = 110.0;
    const canvasRight = 16.0;
    final availableWidth =
        MediaQuery.of(context).size.width - 28 - canvasLeft - canvasRight;
    final spacing = availableWidth / (count + 1);

    for (int i = 0; i < count; i++) {
      final branch = _branches[i];
      final color = _branchColor(i);
      final x = canvasLeft + spacing * (i + 1) - 32;

      widgets.add(
        Positioned(
          left: x,
          top: 90,
          child: GestureDetector(
            onTap: () => _toggleLamp(i),
            child: Column(
              children: [
                _AnimatedLamp3D(
                  isLit: branch.isWorking,
                  color: color,
                  glowValue: _lampGlowCtrl.value,
                  current: branch.current,
                ),
                const SizedBox(height: 6),
                _buildResistanceSlider(branch, color),
                const SizedBox(height: 4),
                _buildBranchCurrentBadge(branch, color),
              ],
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _buildResistanceSlider(CircuitBranch branch, Color color) {
    return SizedBox(
      width: 76,
      child: Column(
        children: [
          Text(
            'R${branch.index + 1}: ${branch.resistance.toStringAsFixed(1)}Ω',
            style: GoogleFonts.rajdhani(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              activeTrackColor: color,
              inactiveTrackColor: color.withValues(alpha: 0.12),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: branch.resistance,
              min: 1,
              max: 20,
              divisions: 38,
              onChanged: (value) => setState(() {
                branch.resistance = value;
                _compute();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchCurrentBadge(CircuitBranch branch, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: branch.isWorking ? 0.4 : 0.15),
        ),
      ),
      child: Text(
        branch.isConnected
            ? 'I: ${branch.current.toStringAsFixed(3)}A'
            : 'PUTUS',
        style: GoogleFonts.rajdhani(
          color: branch.isConnected ? color : _red,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildBranchCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 10),
          child: Text(
            'DETAIL TIAP CABANG',
            style: GoogleFonts.rajdhani(
              color: Colors.white30,
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 148,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: _branches.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final branch = _branches[i];
              final color = _branchColor(i);
              return _BranchDetailCard(
                branch: branch,
                color: color,
                voltage: _voltage,
                index: i,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFormulaPanel() {
    final activeBranches = _branches.where((b) => b.isConnected).toList();
    final formulaR = activeBranches.isEmpty
        ? '—'
        : activeBranches.asMap().entries.map((e) => '1/R${e.key + 1}').join(' + ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _accent.withValues(alpha: 0.06),
              _purple.withValues(alpha: 0.04),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _accent.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.functions_rounded, color: _accent, size: 14),
                const SizedBox(width: 8),
                Text(
                  'HUKUM OHM — RANGKAIAN PARALEL',
                  style: GoogleFonts.rajdhani(
                    color: _accent,
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _green.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _green.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✓  Tegangan sama di setiap cabang: V₁ = V₂ = ... = ${_voltage.toStringAsFixed(1)} V',
                    style: GoogleFonts.rajdhani(
                      color: _green,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '✓  Arus cabang: Iₙ = V / Rₙ  (berbeda jika R berbeda)',
                    style: GoogleFonts.rajdhani(
                      color: _green,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '✓  Arus total: Itotal = ΣIₙ = ${_totalCurrent.toStringAsFixed(3)} A',
                    style: GoogleFonts.rajdhani(
                      color: _green,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
              ),
              child: Text(
                '1/Req = $formulaR  →  Req = ${_equivalentResistance.toStringAsFixed(3)} Ω',
                style: GoogleFonts.sourceCodePro(
                  color: Colors.white38,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolPanel() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _panelBg.withValues(alpha: 0.90),
            border: Border(top: BorderSide(color: _accent.withValues(alpha: 0.1))),
          ),
          child: Row(
            children: [
              _ToolBtn(
                icon: Icons.add_rounded,
                label: 'Tambah',
                color: _green,
                onTap: _addBranch,
              ),
              const SizedBox(width: 10),
              _ToolBtn(
                icon: Icons.remove_rounded,
                label: 'Hapus',
                color: _red,
                onTap: _removeBranch,
              ),
              const SizedBox(width: 14),
              _ToolBtn(
                icon: Icons.battery_charging_full_rounded,
                label: 'Baterai',
                color: _amber,
                onTap: _showBatteryDialog,
              ),
              const SizedBox(width: 14),
              _ToolBtn(
                icon: Icons.restart_alt_rounded,
                label: 'Reset',
                color: Colors.white38,
                onTap: () {
                  setState(() {
                    _initBranches();
                    _voltage = 12.0;
                    _compute();
                  });
                },
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _accent.withValues(alpha: 0.2)),
                ),
                child: Text(
                  '${_branches.length} cabang',
                  style: GoogleFonts.rajdhani(
                    color: _accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBatteryDialog() {
    double tempV = _voltage;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: _cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: _amber.withValues(alpha: 0.3)),
          ),
          title: Row(
            children: [
              Icon(Icons.battery_full_rounded, color: _amber, size: 20),
              const SizedBox(width: 8),
              Text(
                'Atur Tegangan',
                style: GoogleFonts.rajdhani(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${tempV.toStringAsFixed(1)} V',
                style: GoogleFonts.rajdhani(
                  color: _amber,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tegangan sama di SEMUA cabang paralel',
                style: GoogleFonts.rajdhani(
                  color: Colors.white38,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: _amber,
                  inactiveTrackColor: _amber.withValues(alpha: 0.15),
                  thumbColor: _amber,
                  overlayColor: _amber.withValues(alpha: 0.15),
                  trackHeight: 5,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 8),
                ),
                child: Slider(
                  value: tempV,
                  min: 1,
                  max: 30,
                  divisions: 58,
                  onChanged: (value) => setDialogState(() => tempV = value),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _amber.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _amber.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: _branches.map((branch) {
                    if (!branch.isConnected) {
                      return const SizedBox.shrink();
                    }

                    final newCurrent = tempV / branch.resistance;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cabang ${branch.index + 1}',
                            style: GoogleFonts.rajdhani(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            '${newCurrent.toStringAsFixed(3)} A',
                            style: GoogleFonts.rajdhani(
                              color: _amber,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Batal',
                style: GoogleFonts.rajdhani(
                  color: Colors.white38,
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _amber.withValues(alpha: 0.15),
                foregroundColor: _amber,
                side: BorderSide(color: _amber.withValues(alpha: 0.4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                setState(() {
                  _voltage = tempV;
                  _compute();
                });
                Navigator.pop(ctx);
              },
              child: Text(
                'Simpan',
                style: GoogleFonts.rajdhani(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVIRPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
      decoration: BoxDecoration(
        color: _panelBg,
        border: Border(top: BorderSide(color: _accent.withValues(alpha: 0.1))),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 2),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 14,
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'HUKUM OHM PARALEL',
                  style: GoogleFonts.rajdhani(
                    color: Colors.white24,
                    fontSize: 10,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _VIRCard(
                icon: Icons.bolt_rounded,
                label: 'Tegangan',
                value: _voltage.toStringAsFixed(2),
                unit: 'V',
                color: _amber,
              ),
              const SizedBox(width: 8),
              _VIRCard(
                icon: Icons.device_hub_rounded,
                label: 'Req Paralel',
                value: _equivalentResistance.toStringAsFixed(3),
                unit: 'Ω',
                color: _accent,
              ),
              const SizedBox(width: 8),
              _VIRCard(
                icon: Icons.electric_bolt_rounded,
                label: 'I Total',
                value: _totalCurrent.toStringAsFixed(3),
                unit: 'A',
                color: _green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildARButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (kIsWeb) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mode AR belum tersedia di Flutter Web.'),
                  ),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ARViewScreen(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.view_in_ar_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  'Lihat dalam AR',
                  style: GoogleFonts.rajdhani(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
//  PARALLEL CIRCUIT PAINTER — Wire + Animasi Arus
// ============================================================
class _ParallelCircuitPainter extends CustomPainter {
  final List<CircuitBranch> branches;
  final double voltage;
  final double totalCurrent;
  final double animValue;
  final List<Color> branchColors;

  _ParallelCircuitPainter({
    required this.branches,
    required this.voltage,
    required this.totalCurrent,
    required this.animValue,
    required this.branchColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final busTopY = size.height * 0.18;
    final busBottomY = size.height * 0.82;
    final busLeftX = 100.0;
    final busRightX = size.width - 20;

    _drawBusLine(
      canvas,
      paint,
      Offset(busLeftX, busTopY),
      Offset(busRightX, busTopY),
      totalCurrent > 0,
      const Color(0xFF00FF88),
      animValue,
    );

    _drawBusLine(
      canvas,
      paint,
      Offset(busLeftX, busBottomY),
      Offset(busRightX, busBottomY),
      totalCurrent > 0,
      const Color(0xFFFF3D6B),
      animValue,
      reversed: true,
    );

    _drawVerticalWire(
      canvas,
      paint,
      Offset(busLeftX, busTopY),
      Offset(busLeftX, busBottomY),
      totalCurrent > 0,
      const Color(0xFF00D4FF),
      animValue,
    );

    final count = branches.length;
    if (count == 0) return;

    final availableW = busRightX - busLeftX;
    final spacing = availableW / (count + 1);

    for (int i = 0; i < count; i++) {
      final branch = branches[i];
      final color =
          i < branchColors.length ? branchColors[i] : const Color(0xFF38BDF8);
      final cx = busLeftX + spacing * (i + 1);
      final branchActive = branch.isConnected && branch.current > 0;

      _drawVerticalWire(
        canvas,
        paint,
        Offset(cx, busTopY),
        Offset(cx, busBottomY),
        branchActive,
        color,
        animValue,
      );

      _drawJunction(canvas, Offset(cx, busTopY), color, branchActive);
      _drawJunction(canvas, Offset(cx, busBottomY), color, branchActive);

      if (!branchActive && !branch.isConnected) {
        _drawBreak(canvas, Offset(cx, (busTopY + busBottomY) / 2), color);
      }
    }
  }

  void _drawBusLine(
    Canvas canvas,
    Paint paint,
    Offset a,
    Offset b,
    bool active,
    Color color,
    double anim, {
    bool reversed = false,
  }) {
    if (active) {
      paint.color = color.withValues(alpha: 0.18);
      paint.strokeWidth = 10;
      canvas.drawLine(a, b, paint);

      final stops = [
        ((anim + (reversed ? 0.5 : 0)) % 1.0),
        ((anim + (reversed ? 0.5 : 0) + 0.3) % 1.0).clamp(0.0, 1.0),
        ((anim + (reversed ? 0.5 : 0) + 0.6) % 1.0).clamp(0.0, 1.0),
      ]..sort();

      paint.shader = LinearGradient(
        colors: [color.withValues(alpha: 0.4), color, color.withValues(alpha: 0.4)],
        stops: stops,
      ).createShader(Rect.fromPoints(a, b));
      paint.strokeWidth = 4;
      canvas.drawLine(a, b, paint);
      paint.shader = null;

      _drawParticles(canvas, a, b, color, reversed ? 1.0 - anim : anim);
    } else {
      paint.shader = null;
      paint.color = const Color(0xFF1A2840);
      paint.strokeWidth = 2.5;
      canvas.drawLine(a, b, paint);
    }
  }

  void _drawVerticalWire(
    Canvas canvas,
    Paint paint,
    Offset top,
    Offset bottom,
    bool active,
    Color color,
    double anim,
  ) {
    if (active) {
      paint.color = color.withValues(alpha: 0.2);
      paint.strokeWidth = 8;
      canvas.drawLine(top, bottom, paint);

      paint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.3),
          color,
          color.withValues(alpha: 0.3),
        ],
      ).createShader(Rect.fromPoints(top, bottom));
      paint.strokeWidth = 3.5;
      canvas.drawLine(top, bottom, paint);
      paint.shader = null;

      _drawParticles(canvas, top, bottom, color, anim, count: 4);
    } else {
      paint.shader = null;
      paint.color = const Color(0xFF1A2840);
      paint.strokeWidth = 2;
      canvas.drawLine(top, bottom, paint);
    }
  }

  void _drawParticles(
    Canvas canvas,
    Offset a,
    Offset b,
    Color color,
    double t, {
    int count = 3,
  }) {
    final particlePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    for (int p = 0; p < count; p++) {
      final frac = (t + p / count.toDouble()) % 1.0;
      final pos = Offset(
        a.dx + (b.dx - a.dx) * frac,
        a.dy + (b.dy - a.dy) * frac,
      );
      final radius = (4.0 - p * 0.6).clamp(1.5, 5.0);

      particlePaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      particlePaint.color = color.withValues(alpha: 0.6);
      canvas.drawCircle(pos, radius * 2.2, particlePaint);

      particlePaint.maskFilter = null;
      particlePaint.color = Colors.white.withValues(alpha: 0.95 - p * 0.2);
      canvas.drawCircle(pos, radius, particlePaint);

      final tailFrac = (frac - 0.04).clamp(0.0, 1.0);
      final tailPos = Offset(
        a.dx + (b.dx - a.dx) * tailFrac,
        a.dy + (b.dy - a.dy) * tailFrac,
      );
      particlePaint.color = color.withValues(alpha: 0.3);
      canvas.drawLine(tailPos, pos, particlePaint);
    }
  }

  void _drawJunction(Canvas canvas, Offset pos, Color color, bool active) {
    final junctionPaint = Paint()..isAntiAlias = true;

    if (active) {
      junctionPaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      junctionPaint.color = color.withValues(alpha: 0.6);
      junctionPaint.style = PaintingStyle.fill;
      canvas.drawCircle(pos, 10, junctionPaint);

      junctionPaint.maskFilter = null;
      junctionPaint.color = color;
      canvas.drawCircle(pos, 5.5, junctionPaint);

      junctionPaint.color = Colors.white;
      canvas.drawCircle(pos, 2, junctionPaint);
    } else {
      junctionPaint.style = PaintingStyle.fill;
      junctionPaint.color = const Color(0xFF1E3050);
      canvas.drawCircle(pos, 5, junctionPaint);

      junctionPaint.style = PaintingStyle.stroke;
      junctionPaint.color = const Color(0xFF2A4060);
      junctionPaint.strokeWidth = 1.2;
      canvas.drawCircle(pos, 5, junctionPaint);
    }
  }

  void _drawBreak(Canvas canvas, Offset center, Color color) {
    final breakPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..color = _ExperimentCanvasParalelState._red.withValues(alpha: 0.7);

    canvas.drawLine(
      center + const Offset(-6, -6),
      center + const Offset(6, 6),
      breakPaint,
    );
    canvas.drawLine(
      center + const Offset(-6, 6),
      center + const Offset(6, -6),
      breakPaint,
    );
  }

  @override
  bool shouldRepaint(_ParallelCircuitPainter old) {
    return old.animValue != animValue ||
        old.totalCurrent != totalCurrent ||
        old.branches.length != branches.length;
  }
}

// ============================================================
//  ANIMATED LAMP 3D
// ============================================================
class _AnimatedLamp3D extends StatelessWidget {
  final bool isLit;
  final Color color;
  final double glowValue;
  final double current;

  const _AnimatedLamp3D({
    required this.isLit,
    required this.color,
    required this.glowValue,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (isLit)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 90 + 12 * glowValue,
            height: 90 + 12 * glowValue,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3 + 0.15 * glowValue),
                  blurRadius: 30 + 10 * glowValue,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
        CustomPaint(
          size: const Size(72, 100),
          painter: _Lamp3DPainter(
            isLit: isLit,
            color: color,
            pulse: isLit ? glowValue : 0,
            current: current,
          ),
        ),
      ],
    );
  }
}

class _Lamp3DPainter extends CustomPainter {
  final bool isLit;
  final Color color;
  final double pulse;
  final double current;

  _Lamp3DPainter({
    required this.isLit,
    required this.color,
    required this.pulse,
    required this.current,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.34;
    final r = size.width * 0.38;
    final paint = Paint()..isAntiAlias = true;

    if (isLit && pulse > 0) {
      final hR = r * (2.2 + 0.5 * pulse);
      paint.shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.5 * pulse),
          color.withValues(alpha: 0.1 * pulse),
          Colors.transparent,
        ],
        stops: const [0, 0.4, 1],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: hR));
      canvas.drawCircle(Offset(cx, cy), hR, paint);
    }

    final nW = r * 0.36;
    final nT = cy + r * 0.65;
    final nB = cy + r * 0.92;
    final bulbPath = Path();
    bulbPath.addArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), pi, pi);
    bulbPath.cubicTo(cx + r, nT, cx + nW, nT, cx + nW, nB);
    bulbPath.lineTo(cx - nW, nB);
    bulbPath.cubicTo(cx - nW, nT, cx - r, nT, cx - r, cy);
    bulbPath.close();

    if (isLit) {
      final bright = Color.lerp(Colors.white, color, 0.15)!;
      paint.shader = RadialGradient(
        center: const Alignment(-0.28, -0.42),
        radius: 1.2,
        colors: [bright, color.withValues(alpha: 0.97), color.withValues(alpha: 0.55)],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    } else {
      paint.shader = const RadialGradient(
        center: Alignment(-0.28, -0.42),
        radius: 1.2,
        colors: [
          Color(0xFF1E2240),
          Color(0xFF131630),
          Color(0xFF0A0C1C),
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    }
    paint.style = PaintingStyle.fill;
    canvas.drawPath(bulbPath, paint);

    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.center,
      colors: [
        Colors.white.withValues(alpha: isLit ? 0.5 : 0.07),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(
      center: Offset(cx - r * 0.3, cy - r * 0.38),
      radius: r * 0.65,
    ));
    canvas.drawPath(bulbPath, paint);

    if (isLit) {
      paint.shader = null;
      paint.style = PaintingStyle.fill;
      paint.color = Colors.white.withValues(alpha: 0.6);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - r * 0.28, cy - r * 0.38),
          width: r * 0.3,
          height: r * 0.18,
        ),
        paint,
      );
    }

    paint.shader = null;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.8;
    paint.color = isLit ? color.withValues(alpha: 0.55) : const Color(0xFF232345);
    canvas.drawPath(bulbPath, paint);

    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = isLit ? 2.4 : 1.4;
    final sX = cx - r * 0.36;
    final sY = cy + r * 0.08;
    final amp = isLit ? r * 0.22 * (0.78 + 0.22 * pulse) : r * 0.17;
    final zigLen = r * 0.72;
    final filamentPath = Path();
    filamentPath.moveTo(sX, sY);
    for (int i = 0; i < 8; i++) {
      filamentPath.lineTo(
        sX + i * zigLen / 7,
        sY + (i.isEven ? -amp : amp),
      );
    }

    if (isLit) {
      paint.shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.95),
          Color.lerp(Colors.white, color, 0.35)!,
          Colors.white.withValues(alpha: 0.95),
        ],
      ).createShader(Rect.fromLTWH(sX, sY - amp, zigLen, amp * 2));
    } else {
      paint.shader = null;
      paint.color = const Color(0xFF3A3A60);
    }
    canvas.drawPath(filamentPath, paint);
    paint.shader = null;

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.6;
    paint.color = isLit ? color.withValues(alpha: 0.7) : const Color(0xFF3A3A60);
    canvas.drawLine(Offset(sX, sY), Offset(sX, nB), paint);
    canvas.drawLine(Offset(sX + zigLen, sY), Offset(sX + zigLen, nB), paint);

    paint.style = PaintingStyle.fill;
    final segments = 4;
    final segH = (size.height - nB) / segments;
    for (int i = 0; i < segments; i++) {
      final w = nW * (1.0 - i * 0.08);
      final top = nB + i * segH;
      final darkBase =
          i.isEven ? const Color(0xFF2E3F55) : const Color(0xFF1C2D40);
      paint.shader = LinearGradient(
        colors: [
          darkBase.withValues(alpha: 0.8),
          darkBase,
          darkBase.withValues(alpha: 0.6),
        ],
      ).createShader(Rect.fromLTWH(cx - w, top, w * 2, segH));
      canvas.drawRect(
        Rect.fromLTWH(cx - w, top, w * 2, segH - 0.8),
        paint,
      );
    }

    paint.shader = null;
    paint.style = PaintingStyle.fill;
    final termY = size.height - 4.0;
    paint.color = const Color(0xFF64748B);
    canvas.drawCircle(Offset(cx, termY), 5, paint);

    if (isLit) {
      paint.color = color.withValues(alpha: 0.4);
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(Offset(cx, termY), 8, paint);
      paint.maskFilter = null;
    }
  }

  @override
  bool shouldRepaint(_Lamp3DPainter old) {
    return old.isLit != isLit || old.pulse != pulse || old.color != color;
  }
}

// ============================================================
//  ANIMATED BATTERY 3D
// ============================================================
class _AnimatedBattery3D extends StatelessWidget {
  final double voltage;
  final bool isActive;
  final double animValue;

  const _AnimatedBattery3D({
    required this.voltage,
    required this.isActive,
    required this.animValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 55,
      height: 240,
      child: CustomPaint(
        painter: _Battery3DPainter(
          voltage: voltage,
          isActive: isActive,
          shimmer: animValue,
        ),
      ),
    );
  }
}

class _Battery3DPainter extends CustomPainter {
  final double voltage;
  final bool isActive;
  final double shimmer;

  _Battery3DPainter({
    required this.voltage,
    required this.isActive,
    required this.shimmer,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;
    const tH = 12.0;
    final bH = size.height - tH - 12;
    const bX = 5.0;
    final bW = size.width - 10;
    final fill = (voltage / 30.0).clamp(0.0, 1.0);

    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    paint.color = Colors.black.withValues(alpha: 0.5);
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bX + 3, tH + 4, bW, bH),
        const Radius.circular(10),
      ),
      paint,
    );
    paint.maskFilter = null;

    paint.shader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: isActive
          ? [
              const Color(0xFF065F46),
              const Color(0xFF059669),
              const Color(0xFF10B981),
              const Color(0xFF059669),
              const Color(0xFF065F46),
            ]
          : [
              const Color(0xFF1F2937),
              const Color(0xFF374151),
              const Color(0xFF4B5563),
              const Color(0xFF374151),
              const Color(0xFF1F2937),
            ],
      stops: const [0, 0.2, 0.5, 0.8, 1],
    ).createShader(Rect.fromLTWH(bX, tH, bW, bH));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bX, tH, bW, bH),
        const Radius.circular(10),
      ),
      paint,
    );

    if (isActive) {
      final fillH = bH * fill;
      final fillY = tH + bH - fillH;
      paint.shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          const Color(0xFF00AA55).withValues(alpha: 0.3),
          const Color(0xFF00FF88).withValues(alpha: 0.25),
        ],
      ).createShader(Rect.fromLTWH(bX, fillY, bW, fillH));
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(bX, fillY, bW, fillH),
          bottomLeft: const Radius.circular(10),
          bottomRight: const Radius.circular(10),
        ),
        paint,
      );
    }

    paint.shader = null;
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.black.withValues(alpha: 0.25);
    paint.strokeWidth = 1.5;
    for (int i = 1; i < 5; i++) {
      final lineY = tH + bH * i / 5;
      canvas.drawLine(
        Offset(bX + 6, lineY),
        Offset(bX + bW - 6, lineY),
        paint,
      );
    }

    paint.shader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.center,
      colors: [
        Colors.white.withValues(alpha: 0.22),
        Colors.transparent,
      ],
    ).createShader(Rect.fromLTWH(bX, tH, bW * 0.38, bH));
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(bX, tH, bW * 0.35, bH),
        topLeft: const Radius.circular(10),
        bottomLeft: const Radius.circular(10),
      ),
      paint,
    );

    if (isActive) {
      final sY = tH + bH * shimmer - 24;
      paint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.18),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(bX, sY, bW, 48));
      canvas.save();
      canvas.clipRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(bX, tH, bW, bH),
          const Radius.circular(10),
        ),
      );
      canvas.drawRect(Rect.fromLTWH(bX, sY, bW, 48), paint);
      canvas.restore();
    }

    paint.shader = LinearGradient(
      colors: isActive
          ? [const Color(0xFF4ADE80), const Color(0xFF16A34A)]
          : [const Color(0xFF6B7280), const Color(0xFF374151)],
    ).createShader(Rect.fromLTWH(bX + bW * 0.28, 0, bW * 0.44, tH));
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(bX + bW * 0.28, 0, bW * 0.44, tH),
        topLeft: const Radius.circular(5),
        topRight: const Radius.circular(5),
      ),
      paint,
    );

    final tpPlus = TextPainter(
      text: TextSpan(
        text: '+',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tpPlus.paint(canvas, Offset(size.width / 2 - tpPlus.width / 2, 0.5));

    paint.shader = const LinearGradient(
      colors: [Color(0xFF475569), Color(0xFF334155)],
    ).createShader(Rect.fromLTWH(bX + bW * 0.28, tH + bH + 2, bW * 0.44, 10));
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(bX + bW * 0.28, tH + bH + 2, bW * 0.44, 10),
        bottomLeft: const Radius.circular(4),
        bottomRight: const Radius.circular(4),
      ),
      paint,
    );

    final tpMinus = TextPainter(
      text: const TextSpan(
        text: '−',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tpMinus.paint(canvas, Offset(size.width / 2 - tpMinus.width / 2, tH + bH + 2));

    paint.shader = null;
    final tp = TextPainter(
      text: TextSpan(
        text: '${voltage.toStringAsFixed(0)}V',
        style: TextStyle(
          color: isActive ? const Color(0xFFBBF7D0) : Colors.white38,
          fontSize: 14,
          fontWeight: FontWeight.w900,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(size.width / 2 - tp.width / 2, tH + bH / 2 - tp.height / 2),
    );

    if (isActive) {
      paint.style = PaintingStyle.stroke;
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      paint.color = const Color(0xFF00FF88).withValues(alpha: 0.35);
      paint.strokeWidth = 3;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(bX, tH, bW, bH),
          const Radius.circular(10),
        ),
        paint,
      );
      paint.maskFilter = null;
    }
  }

  @override
  bool shouldRepaint(_Battery3DPainter old) {
    return old.shimmer != shimmer ||
        old.voltage != voltage ||
        old.isActive != isActive;
  }
}

// ============================================================
//  BRANCH DETAIL CARD
// ============================================================
class _BranchDetailCard extends StatelessWidget {
  final CircuitBranch branch;
  final Color color;
  final double voltage;
  final int index;

  const _BranchDetailCard({
    required this.branch,
    required this.color,
    required this.voltage,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final active = branch.isConnected && branch.current > 0;
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.12), color.withValues(alpha: 0.03)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: active ? 0.4 : 0.12),
        ),
        boxShadow: active
            ? [BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 16)]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? color : Colors.grey,
                  boxShadow: active
                      ? [BoxShadow(color: color, blurRadius: 6)]
                      : null,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Cabang ${index + 1}',
                style: GoogleFonts.rajdhani(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _Stat(label: 'V', value: '${voltage.toStringAsFixed(1)} V', color: color),
          _Stat(label: 'R', value: '${branch.resistance.toStringAsFixed(1)} Ω', color: color),
          _Stat(
            label: 'I',
            value: branch.isConnected
                ? '${branch.current.toStringAsFixed(3)} A'
                : '0.000 A',
            color: color,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: active
                  ? color.withValues(alpha: 0.12)
                  : const Color(0xFFFF3D6B).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: active
                    ? color.withValues(alpha: 0.35)
                    : const Color(0xFFFF3D6B).withValues(alpha: 0.4),
              ),
            ),
            child: Text(
              active ? 'MENYALA' : 'PUTUS',
              style: GoogleFonts.rajdhani(
                color: active ? color : const Color(0xFFFF3D6B),
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _Stat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.rajdhani(
              color: Colors.white30,
              fontSize: 11,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.rajdhani(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
//  HELPER WIDGETS
// ============================================================
class _GlassButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final Color? color;

  const _GlassButton({
    required this.onTap,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color ?? Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _Orb({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: opacity), Colors.transparent],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 0.5;

    for (double y = 0; y < size.height; y += 48) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    for (double x = 0; x < size.width; x += 48) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _BusLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _BusLabel({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: GoogleFonts.rajdhani(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final double current;

  const _StatusPill({required this.current});

  @override
  Widget build(BuildContext context) {
    final isOver = current > 5.0;
    final isActive = current > 0;
    final color = isOver
        ? const Color(0xFFFF3D6B)
        : isActive
            ? const Color(0xFF00FF88)
            : Colors.white30;
    final label = isOver ? 'LEBIH BEBAN' : isActive ? 'AKTIF' : 'MATI';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: isActive ? [BoxShadow(color: color, blurRadius: 6)] : null,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.rajdhani(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _VIRCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _VIRCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.04)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 12),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 12),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: GoogleFonts.rajdhani(
                    color: Colors.white30,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: GoogleFonts.rajdhani(
                      color: color,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 2),
                Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Text(
                    unit,
                    style: GoogleFonts.rajdhani(
                      color: color.withValues(alpha: 0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ToolBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 58,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: color.withValues(alpha: 0.28)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.rajdhani(
                color: color.withValues(alpha: 0.85),
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
