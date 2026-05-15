import 'dart:ui';
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE1F5FE);

class Module5Screen extends StatefulWidget {
  const Module5Screen({super.key});

  @override
  State<Module5Screen> createState() => _Module5ScreenState();
}

class _Module5ScreenState extends State<Module5Screen>
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
                                Text(
                                    '- Menjelaskan penerapan konsep listrik statis di kehidupan sehari-hari.'),
                                Text(
                                    '- Mengidentifikasi alat dan fenomena yang memanfaatkan listrik statis.'),
                                Text(
                                    '- Menumbuhkan rasa ingin tahu terhadap aplikasi konsep fisika di sekitar.'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          _sectionCard(
                            title: "Materi Pembelajaran",
                            child: Column(
                              children: const [
                                _Topic(
                                  title:
                                      '1. Penerapan Listrik Statis pada Mesin Fotokopi',
                                  content:
                                      'Mesin fotokopi bekerja berdasarkan prinsip listrik statis.\n\n'
                                      'Drum fotokonduktor diisi muatan listrik, lalu cahaya pantulan dari dokumen menyebabkan sebagian muatan hilang sesuai pola gambar. '
                                      'Toner bermuatan menempel pada bagian yang bermuatan berlawanan, dan kemudian dipindahkan ke kertas serta dipanaskan untuk menempel permanen.',
                                ),
                                _Topic(
                                  title:
                                      '2. Penerapan pada Cat Semprot (Spray Painting)',
                                  content:
                                      'Dalam proses pengecatan mobil atau logam, digunakan prinsip listrik statis untuk efisiensi.\n\n'
                                      'Butiran cat diberi muatan listrik, sedangkan benda yang dicat diberi muatan berlawanan. '
                                      'Akibatnya, butiran cat tertarik merata ke seluruh permukaan dan mengurangi pemborosan cat.',
                                ),
                                _Topic(
                                  title:
                                      '3. Penerapan pada Alat Pengendap Elektrostatik',
                                  content:
                                      'Alat ini digunakan di pabrik dan pembangkit listrik untuk mengurangi polusi udara.\n\n'
                                      'Partikel debu bermuatan listrik statis dan ditarik ke pelat logam bermuatan berlawanan. '
                                      'Debu menempel dan kemudian dikumpulkan sehingga udara yang keluar lebih bersih.',
                                ),
                                _Topic(
                                  title:
                                      '4. Penerapan pada Mesin Penangkal Petir',
                                  content:
                                      'Petir terjadi karena perbedaan potensial besar antara awan dan bumi.\n\n'
                                      'Penangkal petir bekerja dengan mengalirkan muatan listrik dari awan ke tanah secara aman melalui konduktor logam, '
                                      'sehingga bangunan tidak rusak akibat sambaran langsung.',
                                ),
                                _Topic(
                                  title:
                                      '5. Penerapan pada Alat Pemisah Debu (Smoke Precipitator)',
                                  content:
                                      'Pada alat pemisah asap, partikel asap bermuatan negatif diarahkan melalui medan listrik menuju pelat bermuatan positif.\n\n'
                                      'Partikel menempel dan tidak ikut keluar bersama gas buangan. Teknologi ini digunakan di industri semen dan baja.',
                                ),
                                _Topic(
                                  title:
                                      '6. Contoh Lain dalam Kehidupan Sehari-hari',
                                  content:
                                      'Selain penerapan di industri, listrik statis juga dapat ditemukan di sekitar kita:\n\n'
                                      '• Rambut berdiri setelah disisir.\n'
                                      '• Balon menempel di dinding.\n'
                                      '• Pakaian menempel setelah dikeringkan.\n'
                                      '• Serbuk debu tertarik ke layar TV.\n\n'
                                      'Semua fenomena ini melibatkan interaksi antara muatan positif dan negatif akibat gesekan atau induksi.',
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

  // ================= HEADER
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
                Text(
                  "Module 5",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  "Penerapan Listrik Statis",
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

// ================= TOPIC
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