import 'dart:ui';
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE1F5FE);
const Color textColor = Color(0xFF01579B);
const Color secondaryTextColor = Color(0xFF607086);

class Module4Screen extends StatefulWidget {
  const Module4Screen({super.key});

  @override
  State<Module4Screen> createState() => _Module4ScreenState();
}

class _Module4ScreenState extends State<Module4Screen>
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
                _buildHeader(context, "Module 4: Beda Potensial & Energi"),

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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                _BulletText('Memahami beda potensial listrik'),
                                _BulletText('Menjelaskan energi potensial listrik'),
                                _BulletText('Menghubungkan energi dan medan listrik'),
                                _BulletText('Menganalisis fenomena listrik sehari-hari'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          _sectionCard(
                            title: "Materi Pembelajaran",
                            child: Column(
                              children: const [
                                _Topic(
                                  title: "1. Beda Potensial Listrik",
                                  content:
                                      "Beda potensial listrik (V) adalah energi yang diperlukan untuk memindahkan satu satuan muatan dari satu titik ke titik lain dalam medan listrik. "
                                      "Rumusnya adalah V = W / q, dengan W adalah usaha (Joule) dan q adalah muatan (Coulomb). "
                                      "Contohnya, pada peristiwa petir, terjadi beda potensial yang sangat besar antara awan dan tanah sehingga menimbulkan aliran listrik.", 
                                ),

                                _Topic(
                                  title: "2. Energi Potensial Listrik",
                                  content:
                                      "Energi potensial listrik (U) adalah energi yang dimiliki muatan karena posisinya dalam medan listrik. "
                                      "Rumusnya adalah U = k × q1 × q2 / r, yang menunjukkan hubungan antara muatan dan jarak. "
                                      "Energi ini menjelaskan bagaimana gaya tarik-menarik dan tolak-menolak antar muatan terjadi dalam kehidupan sehari-hari.",
                                ),

                                _Topic(
                                  title: "3. Hubungan Medan & Potensial",
                                  content:
                                      "Medan listrik (E) dan beda potensial (V) saling berhubungan melalui persamaan E = -dV/dr. "
                                      "Artinya, medan listrik merupakan perubahan dari potensial listrik, dan muatan positif akan bergerak dari potensial tinggi ke rendah secara alami.",
                                ),

                                _Topic(
                                  title: "4. Fenomena Sehari-hari",
                                  content:
                                      "Fenomena listrik dapat kita temukan dalam kehidupan sehari-hari seperti petir, percikan listrik saat menyentuh logam, kapasitor dalam rangkaian elektronik, dan balon yang menempel di dinding setelah digosok. "
                                      "Semua kejadian ini menunjukkan adanya perbedaan potensial dan perpindahan muatan listrik.",
                                ),

                                _Topic(
                                  title: "5. Percobaan Sederhana",
                                  content:
                                      "Percobaan sederhana dapat dilakukan dengan dua benda bermuatan. Siapkan kedua benda, lalu amati gaya interaksi yang terjadi. "
                                      "Kemudian analisis hubungan antara energi dan potensial listrik. Semakin besar jarak antar muatan, maka perubahan energi juga semakin terasa.",
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

  // ================= HEADER (CONSISTENT)
  Widget _buildHeader(BuildContext context, String title) {
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
                Text("Module 4",
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  "Beda Potensial",
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

// ================= TOPIC (NO DIVIDER FIX)
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
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          children: [
            Text(
              content,
              style: const TextStyle(
                height: 1.6,
                fontSize: 14,
                color: secondaryTextColor,
              ),
            )
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

// ================= BULLET
class _BulletText extends StatelessWidget {
  final String text;
  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}