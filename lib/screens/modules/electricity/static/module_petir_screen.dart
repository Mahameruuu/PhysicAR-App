import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class ModulePetirScreen extends StatefulWidget {
  const ModulePetirScreen({super.key});

  @override
  State<ModulePetirScreen> createState() => _ModulePetirScreenState();
}

class _ModulePetirScreenState extends State<ModulePetirScreen>
    with TickerProviderStateMixin {
  double awanCharge = 0.0;
  bool isLightning = false;
  late Ticker _ticker;
  late AnimationController _cloudPulse;
  late AnimationController _cameraShake;

  List<Offset> chargeTrails = [];

  @override
  void initState() {
    super.initState();

    // Animasi awan berdenyut
    _cloudPulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true);

    // Efek kamera bergoyang saat petir
    _cameraShake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    // Ticker untuk update animasi dan logika petir
    _ticker = createTicker((_) {
      setState(() {
        // Trigger petir saat muatan penuh
        if (awanCharge >= 1.0 && !isLightning) {
          isLightning = true;
          _cameraShake.forward(from: 0);
          HapticFeedback.heavyImpact();
          Future.delayed(const Duration(milliseconds: 600), () {
            setState(() {
              isLightning = false;
              awanCharge = 0.0;
            });
          });
        }

        // Peluruhan muatan otomatis
        if (!isLightning && awanCharge > 0.0) {
          awanCharge -= 0.003;
          if (awanCharge < 0.0) awanCharge = 0.0;
        }

        // Update trail muatan agar bergerak pelan (AR-like)
        for (int i = 0; i < chargeTrails.length; i++) {
          chargeTrails[i] = chargeTrails[i] +
              Offset(sin(i + awanCharge * pi) * 0.5, cos(i + awanCharge * pi) * 0.5);
        }
        // Batasi jumlah trail
        if (chargeTrails.length > 50) chargeTrails.removeAt(0);
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _cloudPulse.dispose();
    _cameraShake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shakeOffset = sin(_cameraShake.value * pi * 15) * 12;

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text("⚡ Petir 3D AR Simulation"),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([_cloudPulse, _cameraShake]),
        builder: (context, child) {
          return Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspektif 3D
              ..rotateX(0.03)
              ..rotateY(shakeOffset / 100),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ===== Layer 1: Gradient background dinamis =====
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.lerp(Colors.blueGrey[900], Colors.deepPurple[900], awanCharge)!,
                        Color.lerp(Colors.blueGrey[700], Colors.red[900], awanCharge)!,
                      ],
                    ),
                  ),
                ),

                // ===== Layer 2: Awan samar bergerak (parallax) =====
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MovingCloudPainter(animationValue: _cloudPulse.value),
                  ),
                ),

                // ===== Layer 3: Partikel cahaya =====
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ParticlePainter(animationValue: _cloudPulse.value),
                  ),
                ),

                // ===== Layer 4: Tanah =====
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[800]!, Colors.green[600]!],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // ===== Layer 5: Awan interaktif + trail muatan =====
                Positioned(
                  top: 100,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      final double swipeDelta = details.delta.distance;
                      setState(() {
                        if (swipeDelta > 1.0) {
                          awanCharge += swipeDelta * 0.0015;
                          if (awanCharge > 1.0) awanCharge = 1.0;
                          chargeTrails.add(details.localPosition);
                        }
                      });
                    },
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.002)
                        ..rotateX(sin(awanCharge * pi) * 0.1)
                        ..rotateY(cos(awanCharge * pi) * 0.1)
                        ..scale(1.0 + awanCharge * 0.05),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.cloud,
                            size: 200,
                            color: Color.lerp(
                                Colors.grey[300], Colors.blueGrey[700], awanCharge),
                          ),
                          CustomPaint(
                            size: const Size(200, 200),
                            painter: _ChargeTrailPainter(chargeTrails: chargeTrails),
                          ),
                          Text(
                            "${(awanCharge * 100).toInt()}%",
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ===== Layer 6: Efek petir =====
                if (isLightning)
                  Container(
                    color: Colors.white.withOpacity(_cameraShake.value * 0.8),
                  ),
                if (isLightning)
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 400),
                    painter:
                        _LightningPainter3D(randomSeed: DateTime.now().millisecondsSinceEpoch),
                  ),

                // ===== Layer 7: Instruksi =====
                Positioned(
                  bottom: 120,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "⚡ GOSOK awan untuk menambah muatan.\nMuatan: ${(awanCharge * 100).toInt()}%",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
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
}

// =================== Custom Painter Trail ===================
class _ChargeTrailPainter extends CustomPainter {
  final List<Offset> chargeTrails;

  _ChargeTrailPainter({required this.chargeTrails});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < chargeTrails.length; i++) {
      final offset = chargeTrails[i];
      final double opacity = i / chargeTrails.length;
      final double radius = 3.0 + opacity * 5.0;
      final paint = Paint()
        ..color = Colors.lightBlueAccent.withOpacity(opacity * 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ChargeTrailPainter oldDelegate) => true;
}

// =================== Custom Painter Petir ===================
class _LightningPainter3D extends CustomPainter {
  final int randomSeed;
  _LightningPainter3D({required this.randomSeed});
  late final Random random = Random(randomSeed);

  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..color = Colors.yellowAccent.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    final mainPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double startX = size.width / 2;
    double startY = 150;
    double y = startY;

    for (int i = 0; i < 15; i++) {
      double x = startX + (random.nextDouble() - 0.5) * 80;
      double nextY = y + 25 + random.nextDouble() * 15;
      double currentStrokeWidth = 3.0 + random.nextDouble() * 3;
      mainPaint.strokeWidth = currentStrokeWidth;
      canvas.drawLine(
          Offset(startX, y), Offset(x, nextY), glowPaint..strokeWidth = currentStrokeWidth * 3);
      canvas.drawLine(Offset(startX, y), Offset(x, nextY), mainPaint);
      startX = x;
      y = nextY;
      if (y > size.height - 100) break;
    }

    for (int i = 0; i < 6; i++) {
      double bx = size.width / 2 + (random.nextDouble() - 0.5) * 80;
      double by = 200 + random.nextDouble() * 150;
      double ex = bx + (random.nextDouble() - 0.5) * 80;
      double ey = by + random.nextDouble() * 50;
      canvas.drawLine(Offset(bx, by), Offset(ex, ey), glowPaint..strokeWidth = 2);
    }
  }

  @override
  bool shouldRepaint(covariant _LightningPainter3D oldDelegate) =>
      oldDelegate.randomSeed != randomSeed;
}

// =================== Custom Painter Awan Bergerak ===================
class _MovingCloudPainter extends CustomPainter {
  final double animationValue;
  _MovingCloudPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.05);
    for (int i = 0; i < 10; i++) {
      final dx = (i * 60 + animationValue * 50) % size.width;
      final dy = 50.0 + i * 30;
      canvas.drawOval(Rect.fromLTWH(dx, dy, 100, 50), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MovingCloudPainter oldDelegate) => true;
}

// =================== Custom Painter Partikel ===================
class _ParticlePainter extends CustomPainter {
  final double animationValue;
  _ParticlePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.yellowAccent.withOpacity(0.2);
    final rand = Random(0);
    for (int i = 0; i < 30; i++) {
      final x = (rand.nextDouble() * size.width + animationValue * 30) % size.width;
      final y = rand.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), rand.nextDouble() * 2 + 1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
