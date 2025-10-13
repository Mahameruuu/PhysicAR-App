// lib/screens/modules/electricity/dynamic/experiment/experimen_canvas_seri.dart

import 'package:flutter/material.dart';
import 'components/battery_widget.dart';
import 'components/lamp_widget.dart';
import 'components/wire_painter.dart';
import 'components/ar_view_screen.dart';
import 'logic/simulation_logic.dart';
import 'models/component_model.dart';

class ExperimenCanvasSeri extends StatefulWidget {
  final dynamic target;
  const ExperimenCanvasSeri({super.key, required this.target});

  @override
  State<ExperimenCanvasSeri> createState() => _ExperimenCanvasSeriState();
}

class _ExperimenCanvasSeriState extends State<ExperimenCanvasSeri>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isSeriesSwitchOn = true;

  late CircuitComponent _lamp1;
  late CircuitComponent _lamp2;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();

    // Inisialisasi lampu setelah layout terbangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _lamp1 = CircuitComponent(
          id: 'L1',
          type: ComponentType.lamp,
          x: 90,
          y: 60,
        );
        _lamp2 = CircuitComponent(
          id: 'L2',
          type: ComponentType.lamp,
          x: 220,
          y: 60,
        );
        _updateCircuitStatus();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ⚙️ LOGIKA RANGKAIAN SERI
  void _updateCircuitStatus() {
    setState(() {
      final lamps = [_lamp1, _lamp2];
      final isAllOn =
          SimulationLogic.calculateSeriesLightStatus(_isSeriesSwitchOn, lamps);
      for (var lamp in lamps) {
        lamp.isWorking = isAllOn && lamp.isConnected;
      }
    });
  }

  void _toggleSeriesSwitch() {
    setState(() {
      _isSeriesSwitchOn = !_isSeriesSwitchOn;
      _updateCircuitStatus();
    });
  }

  void _toggleLampConnection(CircuitComponent lamp) {
    lamp.isConnected = !lamp.isConnected;
    _updateCircuitStatus();
  }

  // 🧩 UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FA),
      appBar: AppBar(
        title: Text('Eksperimen ${widget.target ?? 'Rangkaian Seri'}'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade400,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircuitCard(
                  title: "Rangkaian Seri (Dua Lampu)",
                  child: _buildSeriesCircuit(),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => const ARViewScreen(),
                    //   ),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  icon: const Icon(Icons.view_in_ar, color: Colors.white),
                  label: const Text(
                    "Lihat dalam AR",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔲 Kartu utama
  Widget _buildCircuitCard({required String title, required Widget child}) {
    return Container(
      width: 380,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  // 💡 Lampu interaktif
  Widget _buildInteractiveLamp(CircuitComponent lamp) {
    final bool isLit = lamp.isWorking;
    final brightness = 1.0;
    final isCurrentFlowing = isLit && lamp.isConnected;

    return GestureDetector(
      onTap: () => _toggleLampConnection(lamp),
      child: Stack(
        alignment: Alignment.center,
        children: [
          LampWidget(
            isLit: isLit,
            brightnessFactor: isCurrentFlowing ? brightness : 0.1,
          ),
          if (!lamp.isConnected)
            Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'PUTUS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 🔌 Saklar
  Widget _buildSwitchUI() {
    return GestureDetector(
      onTap: _toggleSeriesSwitch,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 60,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isSeriesSwitchOn
                ? [Colors.green.shade400, Colors.green.shade700]
                : [Colors.grey.shade400, Colors.grey.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          _isSeriesSwitchOn
              ? Icons.toggle_on_rounded
              : Icons.toggle_off_rounded,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }

  // 🔋 Gambar rangkaian
  Widget _buildSeriesCircuit() {
    final isCurrentFlowing = _isSeriesSwitchOn &&
        _lamp1.isConnected &&
        _lamp2.isConnected &&
        _lamp1.isWorking;

    return SizedBox(
      width: 360,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: SeriesCircuitPainter(
                isSwitchOn: isCurrentFlowing,
                animationValue: _animationController.value,
              ),
            ),
          ),
          // Lampu 1
          Positioned(top: 40, left: 90, child: _buildInteractiveLamp(_lamp1)),
          // Lampu 2
          Positioned(top: 40, left: 220, child: _buildInteractiveLamp(_lamp2)),
          // Saklar (kanan bawah)
          Positioned(bottom: 40, right: 40, child: _buildSwitchUI()),
          // Baterai di bawah tengah
          const Positioned(bottom: 20, left: 140, child: BatteryWidget()),
        ],
      ),
    );
  }
}
