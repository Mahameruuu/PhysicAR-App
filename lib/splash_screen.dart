import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'screens/auth/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Controllers
  late AnimationController _orbitController;
  late AnimationController _pulseController;
  late AnimationController _fadeInController;
  late AnimationController _textSlideController;
  late AnimationController _logoScaleController;
  late AnimationController _shimmerController;
  late AnimationController _particleController;

  // Animations
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _textOpacity;
  late Animation<double> _pulseAnim;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _bootstrapApp();
  }

  void _setupAnimations() {
    // Orbit (rings rotating)
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Pulse (glow breathing)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Logo entrance
    _logoScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoScaleController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoScaleController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Text slide
    _textSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _textSlideController, curve: Curves.easeOut),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textSlideController, curve: Curves.easeIn),
    );

    // Shimmer
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );

    // Fade-in overall
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Particles
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Sequence: fade → logo → text
    _fadeInController.forward().then((_) {
      _logoScaleController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) _textSlideController.forward();
        });
      });
    });
  }

  Future<void> _bootstrapApp() async {
    await AuthService.instance.initialize();
    await Future<void>.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final currentUser = await AuthService.instance.getCurrentUser();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: currentUser != null
              ? HomeScreen(userName: currentUser.name)
              : const LoginScreen(),
        ),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _pulseController.dispose();
    _fadeInController.dispose();
    _textSlideController.dispose();
    _logoScaleController.dispose();
    _shimmerController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeInController,
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.3),
              radius: 1.4,
              colors: [
                Color(0xFF1A3A6B),
                Color(0xFF0A1628),
                Color(0xFF040D1A),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Floating particles
              ..._buildParticles(),

              // Grid lines background
              CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _GridPainter(),
              ),

              // Main content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 3D orbit + logo
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glow pulse
                          AnimatedBuilder(
                            animation: _pulseAnim,
                            builder: (_, __) => Transform.scale(
                              scale: _pulseAnim.value,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00C6FF)
                                          .withOpacity(0.18),
                                      blurRadius: 60,
                                      spreadRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Orbit ring 1
                          AnimatedBuilder(
                            animation: _orbitController,
                            builder: (_, __) => Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateX(0.8)
                                ..rotateZ(
                                    _orbitController.value * 2 * math.pi),
                              alignment: Alignment.center,
                              child: CustomPaint(
                                size: const Size(200, 200),
                                painter: _OrbitRingPainter(
                                  color: const Color(0xFF00C6FF),
                                  strokeWidth: 1.5,
                                  dashCount: 20,
                                ),
                              ),
                            ),
                          ),

                          // Orbit ring 2 (counter-rotate)
                          AnimatedBuilder(
                            animation: _orbitController,
                            builder: (_, __) => Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateX(0.5)
                                ..rotateY(0.4)
                                ..rotateZ(
                                    -_orbitController.value * 2 * math.pi *
                                        0.7),
                              alignment: Alignment.center,
                              child: CustomPaint(
                                size: const Size(160, 160),
                                painter: _OrbitRingPainter(
                                  color: const Color(0xFF6A9BFD),
                                  strokeWidth: 1.2,
                                  dashCount: 16,
                                ),
                              ),
                            ),
                          ),

                          // Orbit dot 1
                          AnimatedBuilder(
                            animation: _orbitController,
                            builder: (_, __) {
                              final angle =
                                  _orbitController.value * 2 * math.pi;
                              return Transform.translate(
                                offset: Offset(
                                  math.cos(angle) * 100,
                                  math.sin(angle) * 38,
                                ),
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF00C6FF),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00C6FF)
                                            .withOpacity(0.9),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // Orbit dot 2
                          AnimatedBuilder(
                            animation: _orbitController,
                            builder: (_, __) {
                              final angle =
                                  -_orbitController.value * 2 * math.pi * 0.7 +
                                      math.pi * 0.5;
                              return Transform.translate(
                                offset: Offset(
                                  math.cos(angle) * 80,
                                  math.sin(angle) * 40,
                                ),
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF6A9BFD),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF6A9BFD)
                                            .withOpacity(0.9),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // Center logo cluster
                          ScaleTransition(
                            scale: _logoScale,
                            child: FadeTransition(
                              opacity: _logoOpacity,
                              child: Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const RadialGradient(
                                    colors: [
                                      Color(0xFF1E4FA3),
                                      Color(0xFF0A1E4A),
                                    ],
                                  ),
                                  border: Border.all(
                                    color:
                                        const Color(0xFF00C6FF).withOpacity(0.6),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF1E88E5)
                                          .withOpacity(0.5),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Image.asset(
                                            'images/logo_mts.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Image.asset(
                                            'images/logo_kemenag.png',
                                            fit: BoxFit.contain,
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

                    const SizedBox(height: 32),

                    // Title with shimmer
                    AnimatedBuilder(
                      animation: _textSlide,
                      builder: (_, __) => Transform.translate(
                        offset: Offset(0, _textSlide.value),
                        child: FadeTransition(
                          opacity: _textOpacity,
                          child: AnimatedBuilder(
                            animation: _shimmerAnim,
                            builder: (_, __) => ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: const [
                                  Color(0xFFFFFFFF),
                                  Color(0xFF00C6FF),
                                  Color(0xFFFFFFFF),
                                  Color(0xFF6A9BFD),
                                  Color(0xFFFFFFFF),
                                ],
                                stops: [
                                  (_shimmerAnim.value - 0.8).clamp(0.0, 1.0),
                                  (_shimmerAnim.value - 0.4).clamp(0.0, 1.0),
                                  _shimmerAnim.value.clamp(0.0, 1.0),
                                  (_shimmerAnim.value + 0.4).clamp(0.0, 1.0),
                                  (_shimmerAnim.value + 0.8).clamp(0.0, 1.0),
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                'Physic Lab',
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 2.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    AnimatedBuilder(
                      animation: _textSlide,
                      builder: (_, __) => Transform.translate(
                        offset: Offset(0, _textSlide.value * 1.4),
                        child: FadeTransition(
                          opacity: _textOpacity,
                          child: const Text(
                            'EXPLORE · LEARN · DISCOVER',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6A9BFD),
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 56),

                    // Loader
                    AnimatedBuilder(
                      animation: _textOpacity,
                      builder: (_, __) => FadeTransition(
                        opacity: _textOpacity,
                        child: _PulsingLoader(controller: _pulseController),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildParticles() {
    final particles = [
      _ParticleData(0.15, 0.2, 3, 0.0, 3.5),
      _ParticleData(0.8, 0.15, 2, 0.3, 4.0),
      _ParticleData(0.6, 0.75, 4, 0.6, 5.0),
      _ParticleData(0.25, 0.85, 2.5, 1.0, 3.0),
      _ParticleData(0.9, 0.55, 3.5, 0.5, 4.5),
      _ParticleData(0.05, 0.5, 2, 1.5, 3.8),
      _ParticleData(0.45, 0.1, 3, 0.8, 5.2),
      _ParticleData(0.7, 0.9, 2.5, 0.2, 4.2),
    ];

    return particles.map((p) {
      return AnimatedBuilder(
        animation: _particleController,
        builder: (context, _) {
          final size = MediaQuery.of(context).size;
          final t = (_particleController.value + p.phase) % 1.0;
          final yOffset = math.sin(t * 2 * math.pi) * 18;
          final opacity = (math.sin(t * 2 * math.pi) * 0.4 + 0.5)
              .clamp(0.1, 0.9);
          return Positioned(
            left: p.x * size.width,
            top: p.y * size.height + yOffset,
            child: Opacity(
              opacity: opacity,
              child: Container(
                width: p.radius * 2,
                height: p.radius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00C6FF),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00C6FF).withOpacity(0.7),
                      blurRadius: p.radius * 3,
                      spreadRadius: p.radius * 0.5,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }
}

// ─────────────────────────────────────────────
// Data class for particles
// ─────────────────────────────────────────────
class _ParticleData {
  final double x, y, radius, phase, speed;
  const _ParticleData(this.x, this.y, this.radius, this.phase, this.speed);
}

// ─────────────────────────────────────────────
// Custom pulsing loader (replaces CircularProgressIndicator)
// ─────────────────────────────────────────────
class _PulsingLoader extends StatelessWidget {
  final AnimationController controller;
  const _PulsingLoader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = i / 3.0;
            final t = ((controller.value + phase) % 1.0);
            final scale = 0.6 + 0.6 * math.sin(t * math.pi);
            final opacity = 0.3 + 0.7 * math.sin(t * math.pi);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF00C6FF),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00C6FF).withOpacity(0.8),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Orbit ring painter (dashed ellipse)
// ─────────────────────────────────────────────
class _OrbitRingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashCount;

  const _OrbitRingPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.7)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final rx = size.width / 2;
    final ry = size.height * 0.28; // flattened ellipse for 3D look

    final dashAngle = (2 * math.pi) / dashCount;
    final gapRatio = 0.4;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      final sweepAngle = dashAngle * (1 - gapRatio);
      final path = Path();
      bool first = true;
      const steps = 20;
      for (int s = 0; s <= steps; s++) {
        final a = startAngle + sweepAngle * s / steps;
        final x = cx + rx * math.cos(a);
        final y = cy + ry * math.sin(a);
        if (first) {
          path.moveTo(x, y);
          first = false;
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
// Grid background painter
// ─────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E88E5).withOpacity(0.06)
      ..strokeWidth = 0.8;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}