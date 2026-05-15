import 'dart:ui';
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE1F5FE);

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
                                Text('- Menjelaskan prinsip kerja elektroskop.'),
                                Text('- Menunjukkan fenomena listrik statis.'),
                                Text('- Menjelaskan pembuktian muatan listrik.'),
                                Text('- Membedakan induksi dan konduksi.'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          _sectionCard(
                            title: "Materi Pembelajaran",
                            child: Column(
                              children: const [
                                _Topic(
                                  title: "1. Pengertian Elektroskop",
                                  content:
                                      "Elektroskop adalah alat untuk mendeteksi muatan listrik.\n\n"
                                      "Bagian:\n"
                                      "• Kepala logam\n"
                                      "• Batang logam\n"
                                      "• Daun logam\n\n"
                                      "Daun akan membuka jika ada muatan listrik.",
                                ),

                                _Topic(
                                  title: "2. Cara Kerja Elektroskop",
                                  content:
                                      "Muatan menyebabkan daun logam saling tolak-menolak.\n\n"
                                      "Semakin besar muatan → semakin terbuka daun elektroskop.",
                                ),

                                _Topic(
                                  title: "3. Konduksi & Induksi",
                                  content:
                                      "Konduksi: sentuhan langsung → muatan berpindah.\n\n"
                                      "Induksi: tanpa sentuhan → hanya pengaruh medan listrik.",
                                ),

                                _Topic(
                                  title: "4. Jenis Elektroskop",
                                  content:
                                      "• Elektroskop daun emas\n"
                                      "• Elektroskop digital\n\n"
                                      "Keduanya bekerja berdasarkan gaya tolak muatan sejenis.",
                                ),

                                _Topic(
                                  title: "5. Fenomena Listrik Statis",
                                  content:
                                      "Contoh sehari-hari:\n"
                                      "• Rambut berdiri karena sisir\n"
                                      "• Petir\n"
                                      "• Balon menempel di dinding\n"
                                      "• Debu tertarik ke layar TV",
                                ),

                                _Topic(
                                  title: "6. Percobaan Elektroskop",
                                  content:
                                      "Alat sederhana:\n"
                                      "• Botol kaca\n"
                                      "• Kawat\n"
                                      "• Aluminium foil\n\n"
                                      "Gosok sisir → dekatkan → daun membuka → ada muatan listrik.",
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

  // ================= HEADER (KONSISTEN SEMUA MODULE)
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
                Text("Module 4",
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  "Elektroskop & Listrik Statis",
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

// ================= TOPIC (KONSISTEN SEMUA MODULE)
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