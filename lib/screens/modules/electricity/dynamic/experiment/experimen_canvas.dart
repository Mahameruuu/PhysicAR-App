import 'package:flutter/material.dart';
import 'components/battery_widget.dart';
import 'components/lamp_widget.dart';
import 'components/wire_painter.dart';
import 'logic/simulation_logic.dart';
import 'models/component_model.dart';

class ExperimenCanvas extends StatefulWidget {
  final dynamic target; // Parameter dari Navigator.push
  const ExperimenCanvas({super.key, required this.target});

  @override
  State<ExperimenCanvas> createState() => _ExperimentCanvasState();
}

class _ExperimentCanvasState extends State<ExperimenCanvas>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  bool _isParallelSwitchOn = true;

  late CircuitComponent _parallelLamp1;
  late CircuitComponent _parallelLamp2;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Inisialisasi posisi lampu paralel
    _parallelLamp1 = CircuitComponent(
      id: 'PL1',
      type: ComponentType.lamp,
      x: 170,
      y: 50,
    );
    _parallelLamp2 = CircuitComponent(
      id: 'PL2',
      type: ComponentType.lamp,
      x: 170,
      y: 150,
    );

    _updateCircuitStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // LOGIKA
  void _updateCircuitStatus() {
    setState(() {
      final parallelLamps = [_parallelLamp1, _parallelLamp2];
      SimulationLogic.calculateParallelLightStatus(
        _isParallelSwitchOn,
        parallelLamps,
      );
    });
  }

  void _toggleParallelSwitch() {
    setState(() {
      _isParallelSwitchOn = !_isParallelSwitchOn;
      _updateCircuitStatus();
    });
  }

  void _toggleLampConnection(CircuitComponent lamp) {
    lamp.isConnected = !lamp.isConnected;
    _updateCircuitStatus();
  }

  // WIDGET UTAMA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FA),
      appBar: AppBar(
        title: Text('Eksperimen ${widget.target ?? 'Listrik'}'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade400,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildCircuitCard(
              title: "Rangkaian Paralel",
              child: _buildParallelCircuit(),
            ),
          );
        },
      ),
    );
  }

  // Card pembungkus
  Widget _buildCircuitCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
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

  // Lampu interaktif
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

  // Saklar modern
  Widget _buildSwitchUI({
    required bool isOn,
    required String label,
    required Color onColor,
    required Color offColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8),
        width: 60,
        height: 110,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isOn
                ? [onColor.withOpacity(0.8), onColor]
                : [offColor.withOpacity(0.6), offColor],
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              isOn ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
              color: Colors.white,
              size: 40,
            ),
            Text(
              isOn ? "ON" : "OFF",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Rangkaian Paralel
  Widget _buildParallelCircuit() {
    const double batteryY = 400;

    final isCurrentFlowing =
        _isParallelSwitchOn &&
        ((_parallelLamp1.isConnected && _parallelLamp1.isWorking) ||
            (_parallelLamp2.isConnected && _parallelLamp2.isWorking));

    return SizedBox(
      width: 320,
      height: 480,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: ParallelCircuitPainter(
                isSwitchOn: isCurrentFlowing,
                animationValue: _animationController.value,
              ),
            ),
          ),
          Positioned(
            top: _parallelLamp1.y,
            left: _parallelLamp1.x,
            child: _buildInteractiveLamp(_parallelLamp1),
          ),
          Positioned(
            top: _parallelLamp2.y + 100,
            left: _parallelLamp2.x,
            child: _buildInteractiveLamp(_parallelLamp2),
          ),
          Positioned(
            top: 230,
            left: 120,
            child: _buildSwitchUI(
              isOn: _isParallelSwitchOn,
              label: "Paralel",
              onColor: Colors.green,
              offColor: Colors.grey,
              onTap: _toggleParallelSwitch,
            ),
          ),
          Positioned(top: batteryY, left: 100, child: const BatteryWidget()),
        ],
      ),
    );
  }
}
