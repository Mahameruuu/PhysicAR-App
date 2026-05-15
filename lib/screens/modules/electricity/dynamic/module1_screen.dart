import 'dart:ui';
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE1F5FE);
const Color textColor = Color(0xFF01579B);

class Module1Screen extends StatefulWidget {
  const Module1Screen({super.key});

  @override
  State<Module1Screen> createState() => _Module1ScreenState();
}

class _Module1ScreenState extends State<Module1Screen>
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
                                Text('- Mengenal jenis-jenis bahan listrik: konduktor, isolator, dan semikonduktor'),
                                Text('- Memahami sifat kelistrikan dari masing-masing bahan'),
                                Text('- Menjelaskan penerapan bahan-bahan tersebut dalam kehidupan sehari-hari'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          _sectionCard(
                            title: "Materi Pembelajaran",
                            child: Column(
                              children: const [
                                _Topic(
                                  title: '1. Pengantar Listrik Dinamis',
                                  content:
                                      'Listrik dinamis adalah listrik yang dapat mengalir melalui penghantar. '
                                      'Pemahaman dasar tentang bahan penghantar listrik sangat penting agar kita tahu bagaimana arus listrik dapat bergerak dari satu titik ke titik lainnya.',
                                ),
                                _Topic(
                                  title: '2. Konduktor',
                                  content:
                                      'Konduktor adalah bahan yang mudah menghantarkan listrik. '
                                      'Elektron-elektron pada konduktor bergerak bebas sehingga arus listrik mudah mengalir.\n\n'
                                      '🔹 Ciri-ciri konduktor:\n'
                                      '• Hambatan listrik rendah\n'
                                      '• Elektron mudah bergerak\n'
                                      '• Banyak digunakan dalam kabel dan rangkaian listrik',
                                ),
                                _Topic(
                                  title: '3. Isolator',
                                  content:
                                      'Isolator adalah bahan yang tidak dapat menghantarkan listrik dengan baik. '
                                      'Elektron terikat kuat pada atomnya sehingga tidak mudah bergerak.\n\n'
                                      '🔹 Ciri-ciri isolator:\n'
                                      '• Hambatan listrik sangat tinggi\n'
                                      '• Elektron tidak bebas bergerak\n'
                                      '• Digunakan sebagai pelindung kabel',
                                ),
                                _Topic(
                                  title: '4. Semikonduktor',
                                  content:
                                      'Semikonduktor memiliki sifat di antara konduktor dan isolator. '
                                      'Dapat menghantarkan listrik dalam kondisi tertentu seperti suhu atau tegangan.\n\n'
                                      '🔹 Ciri-ciri semikonduktor:\n'
                                      '• Konduktivitas meningkat dengan suhu\n'
                                      '• Digunakan pada transistor dan dioda',
                                ),
                                _Topic(
                                  title: '5. Penerapan dalam Kehidupan Sehari-hari',
                                  content:
                                      '• Kabel listrik = tembaga + plastik\n'
                                      '• Smartphone & komputer = semikonduktor\n'
                                      '• Peralatan rumah tangga = kombinasi isolator & konduktor',
                                ),
                                _Topic(
                                  title: '6. Refleksi dan Kesimpulan',
                                  content:
                                      'Konduktor menghantarkan listrik, isolator melindungi, dan semikonduktor mengatur arus listrik. '
                                      'Ketiganya penting dalam sistem kelistrikan modern.',
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

  // ================= HEADER (SAMAKAN DENGAN SCREEN UTAMA)
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
                Text("Module 1",
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  "Konduktor & Isolator",
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

  // ================= CARD SECTION
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

// ================= EXPANDABLE TOPIC (FULL CONTENT)
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