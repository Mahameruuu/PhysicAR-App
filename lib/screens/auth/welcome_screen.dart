import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

import 'home_screen.dart';

/// Flow: Login berhasil → WelcomeScreen → HomeScreen
/// Untuk audio, tambahkan package: audioplayers atau just_audio
/// Letakkan file audio di assets/sounds/physics_theme.mp3

class WelcomeScreen extends StatefulWidget {
  final String userName;

  const WelcomeScreen({super.key, required this.userName});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  // ── Controllers ──────────────────────────────────────────────
  late final AnimationController _masterCtrl;
  late final AnimationController _orbitCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _countdownCtrl;

  // ── Animations ────────────────────────────────────────────────
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _ringExpand;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _nameOpacity;
  late final Animation<double> _subOpacity;
  late final Animation<double> _countdown;
  late final Animation<double> _scanLine;

  // ── Particles ─────────────────────────────────────────────────
  final List<_Particle> _particles = [];
  final Random _rng = Random();

  // ── State ─────────────────────────────────────────────────────
  int _countdownValue = 17;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    _spawnParticles();
    _setupAnimations();
    _startSequence();
  }

  void _spawnParticles() {
    for (int i = 0; i < 60; i++) {
      _particles.add(_Particle(rng: _rng));
    }
  }

  void _setupAnimations() {
    // Master: logo entrance (0–1200 ms)
    _masterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterCtrl,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _ringExpand = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterCtrl,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // Orbit (infinite rotation)
    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    // Pulse glow
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // Text entrance
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: const Interval(0.0, 0.6)),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _nameOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: const Interval(0.3, 0.9)),
    );
    _subOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: const Interval(0.6, 1.0)),
    );

    // Scan line (top → bottom, loops)
    _scanLine = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _orbitCtrl,
        curve: Curves.linear,
      ),
    );

    // Countdown
    _countdownCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 17),
    );
    _countdown = Tween<double>(begin: 1.0, end: 0.0).animate(_countdownCtrl);
  }

  void _startSequence() async {
    // Step 1: Logo entrance
    await _masterCtrl.forward();

    // Step 2: Text entrance (overlap slightly)
    await Future.delayed(const Duration(milliseconds: 200));
    _textCtrl.forward();

    // Step 3: Play audio (uncomment when audioplayers is added)
    _playPhysicsTheme();

    // Step 4: Countdown then navigate
    await Future.delayed(const Duration(milliseconds: 600));
    _countdownCtrl.forward();

    // Tick countdown number
    for (int i = 17; i >= 1; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _countdownValue = i - 1);
    }

    await Future.delayed(const Duration(milliseconds: 300));
    _navigateHome();
  }

  AudioPlayer? _audioPlayer;

  Future<void> _playPhysicsTheme() async {
    _audioPlayer = AudioPlayer();

    await _audioPlayer!.setSource(
      AssetSource('sounds/welcome.mp3'),
    );

    await _audioPlayer!.setVolume(0.4);

    await _audioPlayer!.resume();
  }

  void _navigateHome() {
    if (_navigating || !mounted) return;
    _navigating = true;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => HomeScreen(userName: widget.userName),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: anim,
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.05, end: 1.0).animate(
                CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 700),
      ),
    );
  }

  @override
  void dispose() {
    _masterCtrl.dispose();
    _orbitCtrl.dispose();
    _pulseCtrl.dispose();
    _textCtrl.dispose();
    _countdownCtrl.dispose();
    // _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Stack(
        children: [
          // ── Animated particle background ──
          AnimatedBuilder(
            animation: _orbitCtrl,
            builder: (_, __) => CustomPaint(
              size: size,
              painter: _ParticlePainter(
                particles: _particles,
                progress: _orbitCtrl.value,
              ),
            ),
          ),

          // ── Scan line ──
          AnimatedBuilder(
            animation: _scanLine,
            builder: (_, __) => Positioned(
              top: size.height * _scanLine.value,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        const Color(0xFF06B6D4).withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Grid overlay ──
          IgnorePointer(
            child: Opacity(
              opacity: 0.08,
              child: CustomPaint(
                size: size,
                painter: _GridPainter(),
              ),
            ),
          ),

          // ── Radial glow center ──
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (_, __) => Center(
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF3B82F6).withOpacity(
                        0.12 + 0.06 * _pulseCtrl.value,
                      ),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Orbital rings ──
          AnimatedBuilder(
            animation: Listenable.merge([_orbitCtrl, _masterCtrl]),
            builder: (_, __) {
              return Center(
                child: Opacity(
                  opacity: _ringExpand.value,
                  child: Transform.scale(
                    scale: 0.4 + 0.6 * _ringExpand.value,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _OrbitalRing(
                          radius: 140,
                          rotation: _orbitCtrl.value * 2 * pi,
                          color: const Color(0xFF3B82F6),
                          dotCount: 8,
                          dotRadius: 4,
                          lineOpacity: 0.18,
                        ),
                        _OrbitalRing(
                          radius: 100,
                          rotation: -_orbitCtrl.value * 2 * pi * 1.4,
                          color: const Color(0xFF8B5CF6),
                          dotCount: 6,
                          dotRadius: 3.5,
                          lineOpacity: 0.14,
                          tilt: pi / 5,
                        ),
                        _OrbitalRing(
                          radius: 170,
                          rotation: _orbitCtrl.value * 2 * pi * 0.7,
                          color: const Color(0xFF06B6D4),
                          dotCount: 5,
                          dotRadius: 3,
                          lineOpacity: 0.10,
                          tilt: -pi / 4,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // ── Central atom logo ──
          AnimatedBuilder(
            animation: Listenable.merge([_masterCtrl, _pulseCtrl]),
            builder: (_, __) {
              return Center(
                child: Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: _AtomLogo(pulse: _pulseCtrl.value),
                  ),
                ),
              );
            },
          ),

          // ── Text content ──
          AnimatedBuilder(
            animation: _textCtrl,
            builder: (_, __) {
              return Positioned(
                bottom: 120,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: SlideTransition(
                    position: _textSlide,
                    child: Column(
                      children: [
                        // "SELAMAT DATANG" eyebrow
                        Text(
                          'S E L A M A T  D A T A N G',
                          style: GoogleFonts.spaceGrotesk(
                            color: const Color(0xFF67E8F9),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // User name
                        Opacity(
                          opacity: _nameOpacity.value,
                          child: ShaderMask(
                            shaderCallback: (bounds) =>
                                const LinearGradient(
                              colors: [
                                Color(0xFFFFFFFF),
                                Color(0xFFBFDBFE),
                                Color(0xFF67E8F9),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              widget.userName,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.orbitron(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Subtitle
                        Opacity(
                          opacity: _subOpacity.value,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Siap menjelajahi dunia fisika\ndalam realitas yang imersif',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFCBD5E1),
                                fontSize: 14,
                                height: 1.7,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Music note pill
                        Opacity(
                          opacity: _subOpacity.value,
                          child: _MusicPill(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // ── Countdown bar ──
          AnimatedBuilder(
            animation: _countdown,
            builder: (_, __) {
              return Positioned(
                bottom: 40,
                left: 48,
                right: 48,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Memasuki lab...',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF64748B),
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          _countdownValue > 0 ? '${_countdownValue}s' : 'Go!',
                          style: GoogleFonts.orbitron(
                            color: const Color(0xFF67E8F9),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: 1.0 - _countdown.value,
                        minHeight: 3,
                        backgroundColor: Colors.white.withOpacity(0.07),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF67E8F9),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // ── Skip button ──
          Positioned(
            top: 56,
            right: 24,
            child: SafeArea(
              child: TextButton(
                onPressed: _navigateHome,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF64748B),
                ),
                child: Text(
                  'Skip →',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// ATOM LOGO (central 3D-ish icon)
// ════════════════════════════════════════════════════════════════
class _AtomLogo extends StatelessWidget {
  final double pulse;
  const _AtomLogo({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow halo
          Container(
            width: 90 + 20 * pulse,
            height: 90 + 20 * pulse,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.35 * pulse),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3B82F6),
                  Color(0xFF8B5CF6),
                  Color(0xFF06B6D4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.5),
                  blurRadius: 28 + 12 * pulse,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.hub_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// ORBITAL RING (custom painter)
// ════════════════════════════════════════════════════════════════
class _OrbitalRing extends StatelessWidget {
  final double radius;
  final double rotation;
  final Color color;
  final int dotCount;
  final double dotRadius;
  final double lineOpacity;
  final double tilt;

  const _OrbitalRing({
    required this.radius,
    required this.rotation,
    required this.color,
    required this.dotCount,
    required this.dotRadius,
    required this.lineOpacity,
    this.tilt = 0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(radius * 2, radius * 2),
      painter: _RingPainter(
        radius: radius,
        rotation: rotation,
        color: color,
        dotCount: dotCount,
        dotRadius: dotRadius,
        lineOpacity: lineOpacity,
        tilt: tilt,
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double radius;
  final double rotation;
  final Color color;
  final int dotCount;
  final double dotRadius;
  final double lineOpacity;
  final double tilt;

  _RingPainter({
    required this.radius,
    required this.rotation,
    required this.color,
    required this.dotCount,
    required this.dotRadius,
    required this.lineOpacity,
    required this.tilt,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Ellipse (simulated tilt)
    final ellipseA = radius;
    final ellipseB = radius * cos(tilt).abs().clamp(0.25, 1.0);

    final ellipsePaint = Paint()
      ..color = color.withOpacity(lineOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: ellipseA * 2,
        height: ellipseB * 2,
      ),
      ellipsePaint,
    );

    // Dots (electrons)
    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < dotCount; i++) {
      final angle = rotation + (2 * pi / dotCount) * i;
      final x = center.dx + ellipseA * cos(angle);
      final y = center.dy + ellipseB * sin(angle);

      // Glow
      dotPaint.color = color.withOpacity(0.25);
      canvas.drawCircle(Offset(x, y), dotRadius + 3, dotPaint);

      // Core
      dotPaint.color = color.withOpacity(0.9);
      canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.rotation != rotation || old.tilt != tilt;
}

// ════════════════════════════════════════════════════════════════
// PARTICLES
// ════════════════════════════════════════════════════════════════
class _Particle {
  late double x, y, vx, vy, size, opacity, speed;
  late Color color;

  _Particle({required Random rng}) {
    _reset(rng, initial: true);
  }

  void _reset(Random rng, {bool initial = false}) {
    x = rng.nextDouble();
    y = initial ? rng.nextDouble() : 1.05;
    final angle = -pi / 2 + (rng.nextDouble() - 0.5) * (pi / 3);
    speed = 0.00015 + rng.nextDouble() * 0.0003;
    vx = cos(angle) * speed;
    vy = sin(angle) * speed;
    size = 1.0 + rng.nextDouble() * 2.5;
    opacity = 0.2 + rng.nextDouble() * 0.6;
    final colors = [
      const Color(0xFF3B82F6),
      const Color(0xFF8B5CF6),
      const Color(0xFF06B6D4),
      const Color(0xFFFFFFFF),
    ];
    color = colors[rng.nextInt(colors.length)];
  }

  void update(Random rng) {
    x += vx;
    y += vy;
    if (y < -0.05 || x < -0.05 || x > 1.05) _reset(rng);
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Random _rng = Random();

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      p.update(_rng);
      paint.color = p.color.withOpacity(p.opacity * 0.6);
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}

// ════════════════════════════════════════════════════════════════
// GRID
// ════════════════════════════════════════════════════════════════
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF06B6D4)
      ..strokeWidth = 0.8;

    for (double y = 80; y < size.height; y += 100) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += 80) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ════════════════════════════════════════════════════════════════
// MUSIC PILL
// ════════════════════════════════════════════════════════════════
class _MusicPill extends StatefulWidget {
  @override
  State<_MusicPill> createState() => _MusicPillState();
}

class _MusicPillState extends State<_MusicPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _barCtrl;

  @override
  void initState() {
    super.initState();
    _barCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _barCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: Colors.white.withOpacity(0.07),
            border:
                Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.music_note_rounded,
                color: Color(0xFF67E8F9),
                size: 16,
              ),
              const SizedBox(width: 8),
              // Equalizer bars
              AnimatedBuilder(
                animation: _barCtrl,
                builder: (_, __) => Row(
                  children: List.generate(4, (i) {
                    final offset = (i * 0.25 + _barCtrl.value).remainder(1.0);
                    final h = 6.0 + sin(offset * pi) * 10;
                    return Container(
                      width: 3,
                      height: h,
                      margin: const EdgeInsets.only(right: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF67E8F9),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Physics Theme',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFE2E8F0),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}