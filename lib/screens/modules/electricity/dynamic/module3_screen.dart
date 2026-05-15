import 'dart:ui';
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE1F5FE);

class Module3Screen extends StatefulWidget {
  const Module3Screen({super.key});

  @override
  State<Module3Screen> createState() => _Module3ScreenState();
}

class _Module3ScreenState extends State<Module3Screen>
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
                                Text('- Memahami konsep medan listrik.'),
                                Text('- Menjelaskan arah dan garis gaya medan listrik.'),
                                Text('- Menentukan kuat medan listrik dari satu dan beberapa muatan.'),
                                Text('- Menghubungkan konsep potensial listrik dengan energi listrik.'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          _sectionCard(
                            title: "Materi Pembelajaran",
                            child: Column(
                              children: const [
                                _Topic(
                                  title: '1. Pengertian Medan Listrik',
                                  content:
                                      'Medan listrik adalah daerah di sekitar muatan listrik di mana muatan lain mengalami gaya listrik.\n\n'
                                      '🔹 Setiap muatan listrik menghasilkan medan listrik.\n'
                                      '🔹 Medan listrik digambarkan dengan garis-garis gaya yang menunjukkan arah dan kekuatan medan.\n\n'
                                      'Arah garis gaya keluar dari muatan positif dan masuk ke muatan negatif.',
                                ),

                                _Topic(
                                  title: '2. Kuat Medan Listrik (E)',
                                  content:
                                      'Kuat medan listrik menyatakan besar gaya listrik pada muatan uji.\n\n'
                                      'E = F / q\n'
                                      'E = k × (Q / r²)\n\n'
                                      'E = kuat medan listrik\n'
                                      'F = gaya listrik\n'
                                      'q = muatan uji\n'
                                      'Q = muatan sumber\n'
                                      'r = jarak',
                                ),

                                _Topic(
                                  title: '3. Garis Gaya Medan Listrik',
                                  content:
                                      '• Tidak pernah berpotongan\n'
                                      '• Keluar dari muatan positif dan masuk ke negatif\n'
                                      '• Kerapatan garis menunjukkan kuat medan\n\n'
                                      'Muatan sejenis saling tolak, berbeda jenis saling tarik.',
                                ),

                                _Topic(
                                  title: '4. Medan Listrik oleh Beberapa Muatan',
                                  content:
                                      'E total = E1 + E2 + E3 + ...\n\n'
                                      'Menggunakan prinsip superposisi vektor.',
                                ),

                                _Topic(
                                  title: '5. Potensial Listrik',
                                  content:
                                      'Potensial listrik adalah energi listrik per satuan muatan.\n\n'
                                      'V = k × (Q / r)\n\n'
                                      'V = potensial listrik\n'
                                      'Q = muatan sumber\n'
                                      'r = jarak',
                                ),

                                _Topic(
                                  title: '6. Energi Potensial Listrik',
                                  content:
                                      'Energi potensial listrik adalah energi akibat posisi muatan dalam medan listrik.\n\n'
                                      'U = q × V\n\n'
                                      'U = energi potensial\n'
                                      'q = muatan\n'
                                      'V = potensial listrik',
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

  // ================= HEADER (SAMA SEMUA MODULE)
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
                Text("Module 3",
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  "Medan Listrik",
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

// ================= TOPIC (SAMA STYLE MODULE 1 & 2)
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