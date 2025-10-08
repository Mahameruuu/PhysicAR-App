import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

// --- Widget Utama ---
class ModuleRambutScreen extends StatefulWidget {
  const ModuleRambutScreen({super.key});

  @override
  State<ModuleRambutScreen> createState() => _ModuleRambutScreenState();
}

class _ModuleRambutScreenState extends State<ModuleRambutScreen>
    with SingleTickerProviderStateMixin {
  double combX = 150;
  double combY = 250;
  double charge = 0.0;
  late AnimationController _controller;
  final Random random = Random();

  late List<Offset> papers;
  late List<Offset> sparks; // partikel listrik

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    papers = List.generate(
        5, (index) => Offset(80.0 + index * 40, 580 + random.nextDouble() * 20));
    sparks = List.generate(
        20, (index) => Offset(random.nextDouble() * 400, random.nextDouble() * 400));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _distanceToHead() {
    const headX = 200.0;
    const headY = 320.0;
    final dx = (combX - headX);
    final dy = (combY - headY);
    return sqrt(dx * dx + dy * dy);
  }

  void _updateState(VoidCallback callback) {
    if (mounted) {
      setState(callback);
    }
  }

  @override
  Widget build(BuildContext context) {
    final distance = _distanceToHead();
    if (distance < 120) {
      charge += 0.015;
      if (charge > 1.0) charge = 1.0;
    } else {
      charge -= 0.005;
      if (charge < 0.0) charge = 0.0;
    }

    // Tarik kertas ke sisir jika muatan cukup
    for (int i = 0; i < papers.length; i++) {
      double dx = (combX + 35) - papers[i].dx;
      double dy = (combY + 35) - papers[i].dy;
      double dist = sqrt(dx * dx + dy * dy);
      if (charge > 0.6 && dist < 200) {
        papers[i] = Offset(
          papers[i].dx + dx * charge * 0.02,
          papers[i].dy + dy * charge * 0.02,
        );
      } else if (papers[i].dy < 580) {
        papers[i] = Offset(papers[i].dx, papers[i].dy + 0.5);
      }
    }

    // Update posisi sparks (partikel)
    for (int i = 0; i < sparks.length; i++) {
      sparks[i] = Offset(
          sparks[i].dx + (random.nextDouble() - 0.5) * 2,
          sparks[i].dy + (random.nextDouble() - 0.5) * 2);
      if (sparks[i].dx < 0 || sparks[i].dx > 400 || sparks[i].dy < 0 || sparks[i].dy > 700) {
        sparks[i] = Offset(random.nextDouble() * 400, random.nextDouble() * 400);
      }
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text("⚡️ Eksperimen Listrik Statis AR"),
        backgroundColor: Colors.blue[800],
      ),
      body: Stack(
        children: [
          // ===== Background gradient dinamis =====
          Positioned.fill(
            child: CustomPaint(
              painter: _DynamicBackgroundPainter(charge: charge),
            ),
          ),

          // ===== Partikel cahaya =====
          Positioned.fill(
            child: CustomPaint(
              painter: _SparkPainter(sparks: sparks, charge: charge),
            ),
          ),

          // --- Kertas besar di lantai ---
          Positioned(
            left: 50,
            bottom: 50,
            child: Container(
              width: 300,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(color: Colors.grey),
              ),
            ),
          ),

          // --- Kepala (Placeholder Kepala) ---
          Positioned(
            left: 140,
            top: 250,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002)
                    ..rotateX(sin(_controller.value * pi * 2) * 0.05)
                    ..rotateY(cos(_controller.value * pi * 2) * 0.05),
                  child: Container(
                    width: 140,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.orange[200],
                      borderRadius: BorderRadius.circular(70),
                      border: Border.all(color: Colors.brown, width: 2),
                    ),
                    child: const Center(
                      child: Text(
                        "Kepala",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // --- Efek Rambut Statis (CustomPainter di atas kepala) ---
          Positioned(
            left: 150,
            top: 250,
            child: CustomPaint(
              painter: _StaticHairPainter(
                  charge: charge, wiggle: sin(_controller.value * pi * 2) * 0.2),
              size: const Size(120, 200),
            ),
          ),

          // --- Kertas kecil ---
          for (int i = 0; i < papers.length; i++)
            Positioned(
              left: papers[i].dx,
              top: papers[i].dy,
              child: Transform.rotate(
                angle: random.nextDouble() * pi * 2,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black26),
                  ),
                ),
              ),
            ),

          // --- Sisir (Sisir Foto Realistis) ---
          Positioned(
            left: combX,
            top: combY,
            child: GestureDetector(
              onPanUpdate: (details) {
                _updateState(() {
                  combX += details.delta.dx;
                  combY += details.delta.dy;
                });
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(-0.05 + charge * 0.05)
                  ..rotateY(-0.05 + charge * 0.05),
                child: Image.asset(
                  'assets/images/sisir.jpg', // pastikan path benar
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // --- Indikator muatan ---
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Muatan Sisir: ${(charge * 100).toInt()}%",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 250,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: charge,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange, Colors.redAccent.shade700],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- CustomPainter Rambut (Hanya untuk efek statis) ---
class _StaticHairPainter extends CustomPainter {
  final double charge;
  final double wiggle;
  final Random random = Random();
  _StaticHairPainter({required this.charge, required this.wiggle});

  @override
  void paint(Canvas canvas, Size size) {
    final hairPaint = Paint()
      ..color = Colors.brown[800]!.withOpacity(charge > 0.1 ? 1.0 : 0.0)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    int hairCount = 60;
    double maxHairLength = 20;

    for (int i = 0; i < hairCount; i++) {
      double dx = size.width / 2 - 40 + random.nextDouble() * 80;
      double dy = size.height - 140;
      final base = Offset(dx, dy);

      double angle = -pi / 2 + (random.nextDouble() - 0.5) * 0.5 + wiggle * charge + charge * 1.5;
      double length = maxHairLength + random.nextDouble() * 20 + 40 * charge;

      final end = Offset(base.dx + cos(angle) * length, base.dy + sin(angle) * length);
      canvas.drawLine(base, end, hairPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StaticHairPainter oldDelegate) => true;
}

// --- Background Dinamis ---
class _DynamicBackgroundPainter extends CustomPainter {
  final double charge;
  _DynamicBackgroundPainter({required this.charge});

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.lerp(Colors.blueGrey[900], Colors.deepPurple[900], charge)!,
        Color.lerp(Colors.blueGrey[700], Colors.red[900], charge)!,
      ],
    );
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant _DynamicBackgroundPainter oldDelegate) => true;
}

// --- Partikel Listrik / Sparks ---
class _SparkPainter extends CustomPainter {
  final List<Offset> sparks;
  final double charge;
  _SparkPainter({required this.sparks, required this.charge});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.yellowAccent.withOpacity(charge * 0.7);
    for (final s in sparks) {
      double radius = 2 + charge * 3;
      canvas.drawCircle(s, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparkPainter oldDelegate) => true;
}
