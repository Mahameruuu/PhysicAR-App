import 'dart:ui';
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE1F5FE);
const Color textColor = Color(0xFF01579B);

class Module2Screen extends StatefulWidget {
  const Module2Screen({super.key});

  @override
  State<Module2Screen> createState() => _Module2ScreenState();
}

class _Module2ScreenState extends State<Module2Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          const _BackgroundGlow(),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),

                Expanded(
                  child: FadeTransition(
                    opacity: _controller,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.08),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                        children: [
                          _sectionCard(
                            title: "Tujuan Modul",
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('- Memahami konsep arus listrik dan hambatan listrik'),
                                Text('- Menjelaskan hukum Ohm dan hukum Kirchoff'),
                                Text('- Menganalisis rangkaian listrik seri dan paralel'),
                                Text('- Mengetahui sumber dan penggunaan energi listrik'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          _sectionCard(
                            title: "Materi Pembelajaran",
                            child: Column(
                              children: const [
                                _Topic(
                                  title: '1. Hambatan Listrik',
                                  content:
                                      'Hambatan listrik adalah komponen yang menghambat aliran arus listrik dalam suatu rangkaian.\n\n'
                                      'Faktor yang memengaruhi hambatan antara lain jenis bahan resistor, panjang penghantar, luas penampang, dan suhu.\n\n'
                                      'R = ρ × (L / A)\n\n'
                                      'R = Hambatan (Ohm)\n'
                                      'ρ = Resistivitas bahan\n'
                                      'L = Panjang penghantar\n'
                                      'A = Luas penampang\n\n'
                                      'Semakin panjang penghantar → hambatan makin besar\n'
                                      'Semakin besar penampang → hambatan makin kecil',
                                ),

                                _Topic(
                                  title: '2. Arus Listrik',
                                  content:
                                      'Arus listrik adalah aliran muatan listrik akibat beda potensial.\n\n'
                                      'Arus konvensional: dari + ke -\n'
                                      'Elektron: dari - ke +\n\n'
                                      'DC = arus searah (baterai)\n'
                                      'AC = arus bolak-balik (PLN)\n\n'
                                      'I = V / R',
                                ),

                                _Topic(
                                  title: '3. Hukum Kirchoff',
                                  content:
                                      'Hukum Kirchoff menyatakan jumlah arus masuk = jumlah arus keluar pada titik cabang.\n\n'
                                      'Σ I masuk = Σ I keluar',
                                ),

                                _Topic(
                                  title: '4. Rangkaian Listrik',
                                  content:
                                      'SERIAL:\n'
                                      'V = V1 + V2\n'
                                      'I sama\n'
                                      'R = R1 + R2\n\n'
                                      'PARALEL:\n'
                                      'V sama\n'
                                      'I = I1 + I2\n'
                                      '1/R = 1/R1 + 1/R2\n\n'
                                      'Digunakan pada instalasi rumah agar lampu tidak saling memengaruhi.',
                                ),

                                _Topic(
                                  title: '5. Sumber Energi Listrik',
                                  content:
                                      'Sumber listrik:\n'
                                      '• Baterai\n'
                                      '• Aki\n'
                                      '• Generator\n\n'
                                      'Energi alternatif:\n'
                                      '• PLTA\n'
                                      '• PLTS\n'
                                      '• PLTB\n'
                                      '• PLTSa',
                                ),

                                _Topic(
                                  title: '6. Penggunaan Energi Listrik',
                                  content:
                                      'Energi listrik digunakan dalam kehidupan sehari-hari.\n\n'
                                      'W = P × t\n\n'
                                      'W = energi (Joule)\n'
                                      'P = daya (Watt)\n'
                                      't = waktu (detik)\n\n'
                                      'Biaya listrik = kWh × tarif PLN',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER (SAMA SEPERTI MODULE 1)
  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF36BFFA), Color(0xFF60A5FA)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x334FC3F7),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Expanded(
            child: Column(
              children: [
                Text("Module 2",
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  "Listrik Dinamis",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  // ================= SECTION CARD
  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF81D4FA)],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ================= TOPIC (FULL STYLE SAMA)
class _Topic extends StatelessWidget {
  final String title;
  final String content;

  const _Topic({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                content,
                style: const TextStyle(height: 1.6, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= BACKGROUND GLOW
class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -80,
          child: _orb(200, const Color(0x334FC3F7)),
        ),
        Positioned(
          bottom: -80,
          right: -60,
          child: _orb(220, const Color(0x224FC3F7)),
        ),
      ],
    );
  }

  Widget _orb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }
}