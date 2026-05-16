import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physic_lab_app/layouts/main_scaffold.dart';
import 'package:physic_lab_app/screens/auth/home_screen.dart';

import 'profile_screen.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({
    super.key,
    this.userName,
  });

  final String? userName;

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _floatController;

  final List<Map<String, dynamic>> _steps = const [
    {
      "step": "01",
      "title": "Login Sistem",
      "text": "Pengguna melakukan login ke aplikasi PhysicAR.",
      "color": Color(0xFFEF4444),
      "icon": Icons.login_rounded,
    },
    {
      "step": "02",
      "title": "Verifikasi Akun",
      "text":
          "Sistem memverifikasi akun. Jika gagal maka akan muncul pesan error.",
      "color": Color(0xFFF97316),
      "icon": Icons.security_rounded,
    },
    {
      "step": "03",
      "title": "Masuk Halaman Utama",
      "text": "Sistem menampilkan dashboard utama aplikasi.",
      "color": Color(0xFFEAB308),
      "icon": Icons.home_rounded,
    },
    {
      "step": "04",
      "title": "Pilih Modul",
      "text": "Pengguna memilih modul pembelajaran fisika.",
      "color": Color(0xFF22C55E),
      "icon": Icons.menu_book_rounded,
    },
    {
      "step": "05",
      "title": "Pilih Sub-Modul",
      "text": "Pengguna memilih topik eksperimen yang ingin dipelajari.",
      "color": Color(0xFF06B6D4),
      "icon": Icons.layers_rounded,
    },
    {
      "step": "06",
      "title": "Membaca Materi",
      "text": "Sistem menampilkan penjelasan materi interaktif.",
      "color": Color(0xFF8B5CF6),
      "icon": Icons.auto_stories_rounded,
    },
    {
      "step": "07",
      "title": "Masuk Virtual Lab?",
      "text": "Pengguna menentukan apakah ingin masuk ke laboratorium virtual.",
      "color": Color(0xFFEC4899),
      "icon": Icons.science_rounded,
    },
    {
      "step": "08",
      "title": "Kembali ke Materi",
      "text": "Jika tidak masuk lab, pengguna kembali ke halaman materi.",
      "color": Color(0xFF14B8A6),
      "icon": Icons.arrow_back_rounded,
    },
    {
      "step": "09",
      "title": "Masuk Virtual Lab",
      "text": "Pengguna masuk ke simulasi laboratorium virtual.",
      "color": Color(0xFFF97316),
      "icon": Icons.biotech_rounded,
    },
    {
      "step": "10",
      "title": "Melakukan Percobaan",
      "text":
          "Pengguna melakukan eksperimen dan berinteraksi dengan objek virtual.",
      "color": Color(0xFF6366F1),
      "icon": Icons.precision_manufacturing_rounded,
    },
    {
      "step": "11",
      "title": "Hasil Percobaan",
      "text": "Sistem menampilkan hasil simulasi dan eksperimen.",
      "color": Color(0xFF84CC16),
      "icon": Icons.analytics_rounded,
    },
    {
      "step": "12",
      "title": "Coba Lagi?",
      "text": "Pengguna menentukan apakah ingin mengulang percobaan.",
      "color": Color(0xFF06B6D4),
      "icon": Icons.restart_alt_rounded,
    },
    {
      "step": "13",
      "title": "Eksplorasi Ulang",
      "text": "Jika Ya, pengguna kembali memilih sub-modul lainnya.",
      "color": Color(0xFFF59E0B),
      "icon": Icons.loop_rounded,
    },
    {
      "step": "14",
      "title": "Selesai",
      "text": "Proses pembelajaran dan simulasi selesai.",
      "color": Color(0xFFFB7185),
      "icon": Icons.flag_rounded,
    },
  ];

  String get _resolvedUserName => widget.userName ?? 'PhysicAR Learner';

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 1) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(userName: _resolvedUserName),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(userName: _resolvedUserName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 1,
      userName: _resolvedUserName,
      onTapNav: _onItemTapped,
      child: Stack(
        children: [
          // BACKGROUND ANIMASI
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _BackgroundPainter(_bgController.value),
                );
              },
            ),
          ),

          // CONTENT
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // HEADER 3D
                AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    final dy = sin(_floatController.value * pi * 2) * 10;

                    return Transform.translate(
                      offset: Offset(0, dy),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF0F172A),
                              Color(0xFF111827),
                              Color(0xFF1E293B),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF38BDF8)
                                  .withValues(alpha: 0.3),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -20,
                              top: -20,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.cyan
                                      .withValues(alpha: 0.08),
                                ),
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF38BDF8),
                                            Color(0xFF8B5CF6),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.cyan
                                                .withValues(alpha: 0.4),
                                            blurRadius: 20,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.science_rounded,
                                        color: Colors.white,
                                        size: 34,
                                      ),
                                    ),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'SIMULASI PHYSICAR',
                                            style: GoogleFonts.orbitron(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Alur interaktif penggunaan aplikasi laboratorium virtual fisika.',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white70,
                                              fontSize: 13,
                                              height: 1.6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                Text(
                  'Alur Pembelajaran',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Jelajahi proses penggunaan aplikasi dari awal hingga eksperimen virtual.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF64748B),
                    height: 1.7,
                  ),
                ),

                const SizedBox(height: 28),

                // TIMELINE CARD
                ListView.builder(
                  itemCount: _steps.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final step = _steps[index];
                    final Color color = step['color'];

                    return TweenAnimationBuilder(
                      duration: Duration(
                        milliseconds: 500 + (index * 120),
                      ),
                      tween: Tween<double>(begin: 0, end: 1),
                      curve: Curves.easeOutBack,
                      builder: (context, double value, child) {
                        return Transform.translate(
                          offset: Offset(60 * (1 - value), 0),
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 22),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TIMELINE
                            Column(
                              children: [
                                Container(
                                  width: 62,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        color,
                                        color.withValues(alpha: 0.7),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            color.withValues(alpha: 0.5),
                                        blurRadius: 18,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      step['step'],
                                      style: GoogleFonts.orbitron(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),

                                if (index != _steps.length - 1)
                                  Container(
                                    width: 4,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: [
                                          color,
                                          color.withValues(alpha: 0.1),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(width: 18),

                            // CARD
                            Expanded(
                              child: Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateX(0.01)
                                  ..rotateY(-0.01),
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(28),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 20,
                                      sigmaY: 20,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(22),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(28),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white
                                                .withValues(alpha: 0.85),
                                            Colors.white
                                                .withValues(alpha: 0.65),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        border: Border.all(
                                          color: color
                                              .withValues(alpha: 0.25),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: color
                                                .withValues(alpha: 0.18),
                                            blurRadius: 24,
                                            offset:
                                                const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(
                                                        12),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                              16),
                                                  color: color
                                                      .withValues(
                                                          alpha: 0.12),
                                                ),
                                                child: Icon(
                                                  step['icon'],
                                                  color: color,
                                                  size: 28,
                                                ),
                                              ),
                                              const SizedBox(width: 14),
                                              Expanded(
                                                child: Text(
                                                  step['title'],
                                                  style: GoogleFonts
                                                      .poppins(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    color:
                                                        const Color(
                                                            0xFF0F172A),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 16),

                                          Text(
                                            step['text'],
                                            style:
                                                GoogleFonts.poppins(
                                              fontSize: 14,
                                              color:
                                                  const Color(0xFF475569),
                                              height: 1.8,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// BACKGROUND PAINTER
// ════════════════════════════════════════════════════════════════

class _BackgroundPainter extends CustomPainter {
  final double progress;

  _BackgroundPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Gradient Background
    final rect = Offset.zero & size;

    paint.shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFF8FAFC),
        Color(0xFFE0F2FE),
        Color(0xFFF1F5F9),
      ],
    ).createShader(rect);

    canvas.drawRect(rect, paint);

    // Floating circles
    for (int i = 0; i < 15; i++) {
      final dx =
          (size.width / 15) * i + sin(progress * pi * 2 + i) * 20;

      final dy =
          (size.height / 15) * i + cos(progress * pi * 2 + i) * 20;

      final radius = 30 + (i % 5) * 12;

      final circlePaint = Paint()
        ..color = Colors.cyan.withValues(alpha: 0.04);

      canvas.drawCircle(
        Offset(dx, dy),
        radius.toDouble(),
        circlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}