import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE0FFFF);
const Color textColor = Color(0xFF37474F);

// Kelas untuk menyimpan data kertas
class KertasData {
  Offset position;
  final Color color;
  final double rotation;
  double floatOffset; // tambahan untuk floating effect

  KertasData({required this.position, required this.color, required this.rotation, this.floatOffset = 0.0});
}

class ModuleBalonScreen extends StatefulWidget {
  const ModuleBalonScreen({super.key});

  @override
  _ModuleBalonScreenState createState() => _ModuleBalonScreenState();
}

class _ModuleBalonScreenState extends State<ModuleBalonScreen> with SingleTickerProviderStateMixin {
  final double _balonSize = 100.0;
  final double _kertasSize = 20.0;
  final double _containerWidth = 350.0;
  final double _containerHeight = 500.0;
  final int _numberOfPapers = 15;

  Offset balonPosition = const Offset(50, 50);
  List<KertasData> kertasList = [];

  double muatanBalon = 0.0;
  final double muatanMax = 1.0;

  late Ticker _ticker;
  final Random _random = Random();

  final List<Color> _paperColors = [
    Colors.red[300]!,
    Colors.yellow[300]!,
    Colors.green[300]!,
    Colors.purple[300]!,
    Colors.orange[300]!,
  ];

  @override
  void initState() {
    super.initState();

    // Init kertas dengan floatOffset untuk animasi floating
    for (int i = 0; i < _numberOfPapers; i++) {
      kertasList.add(KertasData(
        position: Offset(
          _random.nextDouble() * (_containerWidth - _kertasSize),
          _random.nextDouble() * (_containerHeight - _kertasSize) * 0.8 + 80,
        ),
        color: _paperColors[_random.nextInt(_paperColors.length)],
        rotation: _random.nextDouble() * 2 * pi,
        floatOffset: _random.nextDouble() * 2 * pi,
      ));
    }

    // Ticker untuk update animasi
    _ticker = createTicker((elapsed) {
      setState(() {
        double t = elapsed.inMilliseconds / 500.0;
        for (int i = 0; i < kertasList.length; i++) {
          // Floating effect kertas
          kertasList[i].floatOffset += 0.02;
          double dxFloat = sin(kertasList[i].floatOffset) * 2;
          double dyFloat = cos(kertasList[i].floatOffset) * 2;

          // Tarik kertas ke balon jika ada muatan
          double dx = balonPosition.dx + (_balonSize / 2) - (kertasList[i].position.dx + (_kertasSize / 2));
          double dy = balonPosition.dy + (_balonSize / 2) - (kertasList[i].position.dy + (_kertasSize * 1.2 / 2));
          double distance = sqrt(dx * dx + dy * dy);

          if (muatanBalon > 0.1 && distance < 200) {
            double moveX = dx * 0.035 * muatanBalon;
            double moveY = dy * 0.035 * muatanBalon;
            kertasList[i].position = Offset(
              kertasList[i].position.dx + moveX + dxFloat,
              kertasList[i].position.dy + moveY + dyFloat,
            );
          } else {
            // floating tanpa tarik balon
            kertasList[i].position = Offset(
              kertasList[i].position.dx + dxFloat,
              kertasList[i].position.dy + dyFloat,
            );
          }
        }
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Widget _buildPaper(KertasData kertas) {
    return Positioned(
      left: kertas.position.dx,
      top: kertas.position.dy,
      child: Transform.rotate(
        angle: kertas.rotation,
        child: Container(
          width: _kertasSize,
          height: _kertasSize * 1.2,
          decoration: BoxDecoration(
            color: kertas.color,
            border: Border.all(color: Colors.brown[400]!, width: 0.5),
            borderRadius: BorderRadius.circular(2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(2, 2),
                blurRadius: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Modul 4: Listrik Statis ⚡"),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          width: _containerWidth,
          height: _containerHeight,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 5),
                blurRadius: 10,
              ),
            ],
          ),
          child: Stack(
            children: [
              const Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Text(
                  "Gosok balon dengan menyeretnya (drag) untuk menambah muatan dan menarik kertas-kertas berwarna-warni! ✨",
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: textColor),
                  textAlign: TextAlign.center,
                ),
              ),

              ...kertasList.map((kertas) => _buildPaper(kertas)),

              Positioned(
                left: balonPosition.dx,
                top: balonPosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      balonPosition += details.delta;
                      balonPosition = Offset(
                        balonPosition.dx.clamp(0, _containerWidth - _balonSize),
                        balonPosition.dy.clamp(60, _containerHeight - _balonSize - 10),
                      );
                      muatanBalon += 0.003;
                      if (muatanBalon > muatanMax) muatanBalon = muatanMax;
                    });
                  },
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.004) // perspektif lebih kuat
                      ..rotateX(-0.15)
                      ..rotateY(0.25)
                      ..scale(1.0 + (muatanBalon * 0.15)),
                    alignment: FractionalOffset.center,
                    child: Container(
                      width: _balonSize,
                      height: _balonSize,
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.8),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.red[900]!,
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(muatanBalon * 0.6),
                            offset: const Offset(0, 8),
                            blurRadius: 20.0 + (muatanBalon * 15),
                            spreadRadius: 3.0,
                          ),
                        ],
                        gradient: RadialGradient(
                          colors: [
                            Colors.red[200]!,
                            Colors.red[500]!,
                            Colors.red[900]!,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "${(muatanBalon * 100).toInt()}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            shadows: [Shadow(blurRadius: 2, color: Colors.black54)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  "Muatan Balon (Q): ${(muatanBalon * 100).toInt()}%",
                  style: const TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
