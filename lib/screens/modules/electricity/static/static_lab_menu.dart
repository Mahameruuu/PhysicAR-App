import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'module_balon_screen.dart';
import 'module_petir_screen.dart';
import 'module_rambut_screen.dart';

class StaticLabMenu extends StatefulWidget {
  const StaticLabMenu({super.key});

  @override
  State<StaticLabMenu> createState() => _StaticLabMenuState();
}

class _StaticLabMenuState extends State<StaticLabMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _LabMenuBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildIntroCard(),
                        const SizedBox(height: 18),
                        const Text(
                          'Interactive Experiments',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F3C67),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Pilih eksperimen virtual untuk melihat bagaimana listrik statis bekerja dalam situasi nyata.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.55,
                            color: Color(0xFF61758A),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            physics: const BouncingScrollPhysics(),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.9,
                            children: [
                              _buildExperimentCard(
                                context,
                                title: "Gosokan Balon & Kertas",
                                icon: Icons.bubble_chart,
                                color1: Colors.orangeAccent,
                                color2: Colors.deepOrange,
                                page: const ModuleBalonScreen(),
                                delay: 0,
                              ),
                              _buildExperimentCard(
                                context,
                                title: "Petir (Awan & Tanah)",
                                icon: Icons.bolt,
                                color1: Colors.amber,
                                color2: Colors.orange,
                                page: const ModulePetirScreen(),
                                delay: 0.4,
                              ),
                              _buildExperimentCard(
                                context,
                                title: "Rambut Berdiri",
                                icon: Icons.face,
                                color1: Colors.pinkAccent,
                                color2: Colors.purpleAccent,
                                page: const ModuleRambutScreen(),
                                delay: 0.8,
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x284DA8FF),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Navigator.pop(context),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lab Virtual",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Eksperimen interaktif listrik statis",
                  style: TextStyle(
                    color: Color(0xFFE0F2FE),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.science_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.82),
                Colors.white.withValues(alpha: 0.62),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.72),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x180F172A),
                blurRadius: 22,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Experiment Zone',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F3C67),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Belajar lewat simulasi geser, gosok, dan observasi untuk memahami efek muatan listrik statis.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.55,
                        color: Color(0xFF61758A),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              _LabBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExperimentCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color1,
    required Color color2,
    required Widget page,
    required double delay,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: color2.withValues(alpha: 0.32),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Interactive',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final offsetY = sin((_controller.value + delay) * 2 * pi) * 5;
                  final scale = 1 + sin((_controller.value + delay) * 2 * pi) * 0.05;
                  return Transform.translate(
                    offset: Offset(0, offsetY),
                    child: Transform.scale(scale: scale, child: child),
                  );
                },
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(icon, color: Colors.white, size: 38),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Text(
                    'Buka Eksperimen',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabMenuBackground extends StatelessWidget {
  const _LabMenuBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF7FCFF), Color(0xFFE6F5FF), Color(0xFFDBF1FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: const [
          _MenuOrb(alignment: Alignment(-1.0, -0.85), size: 170, color: Color(0x3353C8F8)),
          _MenuOrb(alignment: Alignment(1.0, 0.0), size: 220, color: Color(0x224DA8FF)),
          _MenuOrb(alignment: Alignment(-0.8, 1.0), size: 190, color: Color(0x1F80DEEA)),
        ],
      ),
    );
  }
}

class _MenuOrb extends StatelessWidget {
  const _MenuOrb({
    required this.alignment,
    required this.size,
    required this.color,
  });

  final Alignment alignment;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class _LabBadge extends StatelessWidget {
  const _LabBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7DD3FC), Color(0xFF3B82F6)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x264DA8FF),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 40),
    );
  }
}
