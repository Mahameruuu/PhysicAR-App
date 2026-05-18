import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:physic_lab_app/screens/modules/electricity/dynamic/experiment/experimen_canvas_seri.dart';
import 'experiment/experimen_canvas.dart';

class StaticLabMenu extends StatefulWidget {
  const StaticLabMenu({super.key});

  @override
  State<StaticLabMenu> createState() => _StaticLabMenuState();
}

class _StaticLabMenuState extends State<StaticLabMenu>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF031B34),
      body: Stack(
        children: [
          // ================= BACKGROUND ANIMATED =================
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: -100 +
                        sin(_bgController.value * 2 * pi) * 30,
                    left: -80,
                    child: _glowCircle(
                      250,
                      Colors.cyanAccent.withOpacity(0.18),
                    ),
                  ),

                  Positioned(
                    bottom: -120 +
                        cos(_bgController.value * 2 * pi) * 25,
                    right: -100,
                    child: _glowCircle(
                      300,
                      Colors.blueAccent.withOpacity(0.18),
                    ),
                  ),

                  Positioned(
                    top: size.height * 0.35,
                    right: -60,
                    child: _glowCircle(
                      180,
                      Colors.lightBlue.withOpacity(0.12),
                    ),
                  ),
                ],
              );
            },
          ),

          // ================= MAIN CONTENT =================
          SafeArea(
            child: Column(
              children: [
                // ================= APPBAR =================
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 12,
                        sigmaY: 12,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.18),
                              Colors.white.withOpacity(0.06),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.18),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.12),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            if (Navigator.canPop(context))
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),

                            const SizedBox(width: 16),

                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "⚡ Virtual Electric Lab",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Eksperimen listrik interaktif modern",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ================= TITLE =================
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 12,
                    bottom: 10,
                  ),
                  child: Row(
                    children: const [
                      Text(
                        "Pilih Eksperimen",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // ================= GRID =================
                Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.82,
                    children: [
                      _build3DCard(
                        context,
                        title: "Listrik Seri",
                        subtitle: "Arus mengalir dalam satu jalur",
                        icon: Icons.linear_scale_rounded,
                        color1: const Color(0xFF00C6FF),
                        color2: const Color(0xFF0072FF),
                        page:
                            const ExperimenCanvasSeri(target: null),
                        delay: 0,
                      ),

                      _build3DCard(
                        context,
                        title: "Listrik Paralel",
                        subtitle: "Arus terbagi ke beberapa jalur",
                        icon:
                            Icons.battery_charging_full_rounded,
                        color1: const Color(0xFF00E676),
                        color2: const Color(0xFF00C853),
                        page:
                            ExperimenCanvasParalel(target: null),
                        delay: 0.5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= 3D CARD =================
  Widget _build3DCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color1,
    required Color color2,
    required Widget page,
    required double delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.85, end: 1),
      duration: Duration(
        milliseconds: 900 + (delay * 300).toInt(),
      ),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration:
                  const Duration(milliseconds: 700),
              pageBuilder: (_, animation, __) {
                return FadeTransition(
                  opacity: animation,
                  child: page,
                );
              },
            ),
          );
        },
        child: AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            final float =
                sin((_floatingController.value + delay) * 2 * pi) *
                    10;

            final rotate =
                sin((_floatingController.value + delay) * 2 * pi) *
                    0.03;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(rotate)
                ..rotateY(-rotate),
              child: Transform.translate(
                offset: Offset(0, float),
                child: child,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color1,
                  color2,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: color2.withOpacity(0.45),
                  blurRadius: 25,
                  spreadRadius: 3,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Stack(
              children: [
                // LIGHT EFFECT
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.14),
                    ),
                  ),
                ),

                Positioned(
                  bottom: -30,
                  left: -30,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),

                // CONTENT
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // ICON
                      Center(
                        child: Hero(
                          tag: title,
                          child: Container(
                            margin:
                                const EdgeInsets.only(top: 12),
                            padding:
                                const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Colors.white.withOpacity(0.18),
                              border: Border.all(
                                color: Colors.white24,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white
                                      .withOpacity(0.18),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: Icon(
                              icon,
                              size: 58,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // TITLE
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // BUTTON
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius:
                              BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white24,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Mulai",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= GLOW EFFECT =================
  Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}