import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

// ──────────────────────────────────────────────
// DESIGN TOKENS — PhysicAR Sci-fi Theme (Storm)
// ──────────────────────────────────────────────
const Color kBgDeep       = Color(0xFF060A14);
const Color kBgPanel      = Color(0xFF0A0E1A);
const Color kBorderColor  = Color(0xFF1A2A4A);
const Color kAccentYellow = Color(0xFFFFD54F);
const Color kAccentOrange = Color(0xFFF57F17);
const Color kTextPrimary  = Color(0xFFE8F0FF);
const Color kTextMuted    = Color(0xFF3A5580);

// ── Data class ────────────────────────────────
class _Particle {
  double x, y, vx, vy, r, alpha, phase;
  _Particle({
    required this.x, required this.y,
    required this.vx, required this.vy,
    required this.r, required this.alpha,
    required this.phase,
  });
}

class _BoltSegment {
  final Offset p1, p2;
  final int depth;
  _BoltSegment(this.p1, this.p2, this.depth);
}

// ── Screen ────────────────────────────────────
class ModulePetirScreen extends StatefulWidget {
  const ModulePetirScreen({super.key});

  @override
  State<ModulePetirScreen> createState() => _ModulePetirScreenState();
}

class _ModulePetirScreenState extends State<ModulePetirScreen>
    with TickerProviderStateMixin {
  double _charge = 0.0;
  bool _lightning = false;
  bool _dragging = false;
  double _flashAlpha = 0.0;
  double _shakeX = 0.0, _shakeY = 0.0;
  double _cloudPulse = 0.0;
  double _t = 0;

  List<_Particle> _particles = [];
  List<_BoltSegment> _boltSegments = [];

  late Ticker _ticker;
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _spawnParticles();
    _ticker = createTicker(_onTick)..start();
  }

  void _spawnParticles() {
    _particles = List.generate(40, (_) => _Particle(
      x: _rng.nextDouble() * 480,
      y: _rng.nextDouble() * 300,
      vx: (_rng.nextDouble() - .5) * .3,
      vy: (_rng.nextDouble() - .5) * .3,
      r: .5 + _rng.nextDouble() * 1.5,
      alpha: _rng.nextDouble() * .5,
      phase: _rng.nextDouble() * pi * 2,
    ));
  }

  void _onTick(Duration _) {
    if (!mounted) return;
    setState(() {
      _t++;
      _cloudPulse = sin(_t * .025) * .05;

      // charge decay
      if (!_lightning && !_dragging && _charge > 0) {
        _charge = (_charge - .0025).clamp(0, 1);
      }

      // trigger lightning
      if (_charge >= 1.0 && !_lightning) _triggerLightning();

      // flash decay
      if (_flashAlpha > 0) _flashAlpha = (_flashAlpha - .04).clamp(0, 1);
      _shakeX *= .82; _shakeY *= .82;

      // particles
      for (final p in _particles) {
        p.phase += .02;
        p.alpha = (.15 + sin(p.phase) * .1) * max(.1, _charge * .8);
        p.x += p.vx + (_rng.nextDouble() - .5) * .2;
        p.y += p.vy + (_rng.nextDouble() - .5) * .2;
        if (p.x < 0) p.x = 480;
        if (p.x > 480) p.x = 0;
        if (p.y < 0) p.y = 300;
        if (p.y > 300) p.y = 0;
      }
    });
  }

  void _triggerLightning() {
    _lightning = true;
    _flashAlpha = 1.0;
    _shakeX = (_rng.nextDouble() - .5) * 18;
    _shakeY = (_rng.nextDouble() - .5) * 10;
    HapticFeedback.heavyImpact();
    _boltSegments = _genBolt(
      const Offset(200, 130),
      pi / 2,
      160,
      7,
    );
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _lightning = false;
        _charge = 0;
        _flashAlpha = 0;
      });
    });
  }

  List<_BoltSegment> _genBolt(Offset start, double angle, double len, int depth) {
    final result = <_BoltSegment>[];
    void seg(Offset p, double a, double l, int d) {
      if (d <= 0 || l < 8) return;
      final end = p + Offset(cos(a) * l, sin(a) * l);
      result.add(_BoltSegment(p, end, d));
      seg(end, a + (_rng.nextDouble() - .5) * .9, l * (.6 + _rng.nextDouble() * .2), d - 1);
      if (_rng.nextDouble() < .4) {
        seg(end, a + (_rng.nextDouble() - .42), l * .5, d - 2);
      }
    }
    seg(start, angle, len, depth);
    return result;
  }

  Offset? _lastDragPos;

  void _onPanStart(DragStartDetails d) {
    // only grab if near cloud center
    const cloudCenter = Offset(175, 140);
    if ((d.localPosition - cloudCenter).distance < 110) {
      _dragging = true;
      _lastDragPos = d.localPosition;
    }
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (!_dragging) return;
    if (_lastDragPos != null) {
      final dist = (d.localPosition - _lastDragPos!).distance;
      setState(() {
        _charge = (_charge + dist * .00038).clamp(0, 1);
      });
    }
    _lastDragPos = d.localPosition;
  }

  void _onPanEnd(DragEndDetails _) {
    _dragging = false;
    _lastDragPos = null;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  // ── UI ────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDeep,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildSimArea()),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      decoration: const BoxDecoration(
        color: kBgPanel,
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                border: Border.all(color: kBorderColor),
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF111827),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 14, color: kAccentYellow),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MODUL 05 · PHYSICAR',
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 9,
                  letterSpacing: 3,
                  color: kAccentYellow.withOpacity(.7),
                )),
              const SizedBox(height: 2),
              const Text('PETIR STATIS',
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kTextPrimary,
                  letterSpacing: 2,
                )),
            ],
          ),
          const Spacer(),
          // charge badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: kAccentYellow.withOpacity(.4)),
              borderRadius: BorderRadius.circular(20),
              color: kAccentYellow.withOpacity(.07),
            ),
            child: Row(
              children: [
                const Icon(Icons.electric_bolt, size: 13, color: kAccentYellow),
                const SizedBox(width: 4),
                Text('${(_charge * 100).toInt()}%',
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: kAccentYellow,
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimArea() {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: ClipRect(
        child: Transform.translate(
          offset: Offset(_shakeX, _shakeY),
          child: CustomPaint(
            painter: _StormScenePainter(
              charge: _charge,
              t: _t,
              cloudPulse: _cloudPulse,
              particles: _particles,
              lightning: _lightning,
              boltSegments: _boltSegments,
              flashAlpha: _flashAlpha,
              rng: _rng,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final pct = (_charge * 100).toInt();
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: kBgPanel,
        border: Border(top: BorderSide(color: kBorderColor)),
      ),
      child: Row(
        children: [
          Text('MUATAN Q',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 9,
              letterSpacing: 2.5,
              color: kAccentYellow.withOpacity(.7),
            )),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Stack(
                children: [
                  Container(height: 6, color: const Color(0xFF111318)),
                  FractionallySizedBox(
                    widthFactor: _charge,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [kAccentOrange, kAccentYellow, Color(0xFFFFF176)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kAccentYellow.withOpacity(.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 36,
            child: Text('$pct%',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Courier',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: kAccentYellow,
              )),
          ),
        ],
      ),
    );
  }
}

// ── Main Scene Painter ────────────────────────
class _StormScenePainter extends CustomPainter {
  final double charge, t, cloudPulse, flashAlpha;
  final bool lightning;
  final List<_Particle> particles;
  final List<_BoltSegment> boltSegments;
  final Random rng;

  const _StormScenePainter({
    required this.charge,
    required this.t,
    required this.cloudPulse,
    required this.particles,
    required this.lightning,
    required this.boltSegments,
    required this.flashAlpha,
    required this.rng,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final W = size.width, H = size.height;

    _drawBackground(canvas, W, H);
    _drawMovingClouds(canvas, W, H);
    _drawParticles(canvas);
    _drawCloud(canvas, W, H);
    if (lightning) _drawLightning(canvas, W, H);
    if (!lightning && charge < .05) _drawHint(canvas, W, H);
  }

  void _drawBackground(Canvas canvas, double W, double H) {
    // sky
    final skyGrad = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(const Color(0xFF060A14), const Color(0xFF1A0A30), charge)!,
          Color.lerp(const Color(0xFF0D1322), const Color(0xFF3D0D0D), charge)!,
        ],
      ).createShader(Rect.fromLTWH(0, 0, W, H * .75));
    canvas.drawRect(Rect.fromLTWH(0, 0, W, H * .75), skyGrad);

    // ground
    final groundGrad = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0A1A0A), Color(0xFF061006)],
      ).createShader(Rect.fromLTWH(0, H * .72, W, H * .28));
    canvas.drawRect(Rect.fromLTWH(0, H * .72, W, H * .28), groundGrad);

    // horizon glow
    if (charge > .05) {
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            Color(0xFFFFDC00).withOpacity(charge * .15),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(
          center: Offset(W * .5, H * .73), radius: W * .45));
      canvas.drawRect(Rect.fromLTWH(0, 0, W, H), glowPaint);
    }

    // grid on ground
    final gridP = Paint()
      ..color = const Color(0xFF326432).withOpacity(.15)
      ..strokeWidth = .8;
    for (double x = 0; x <= W; x += 30) {
      canvas.drawLine(Offset(x, H * .72),
          Offset(W / 2 + (x - W / 2) * .3, H), gridP);
    }
    for (int row = 0; row < 6; row++) {
      final y = H * .73 + row * (H * .27 / 5);
      canvas.drawLine(Offset(0, y), Offset(W, y), gridP);
    }
  }

  void _drawMovingClouds(Canvas canvas, double W, double H) {
    for (int i = 0; i < 8; i++) {
      final cx = ((i * 70 + t * .15) % W + W) % W;
      final cy = 30.0 + i * 18;
      final alpha = .04 + i % 3 * .015;
      final p = Paint()..color = Color.fromRGBO(180, 200, 255, alpha);
      canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: 110, height: 44), p);
      canvas.drawOval(Rect.fromCenter(center: Offset(cx + 30, cy - 8), width: 70, height: 32), p);
    }
  }

  void _drawParticles(Canvas canvas) {
    for (final p in particles) {
      final gp = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFE64A).withOpacity(.9 * p.alpha),
            const Color(0xFFFFE64A).withOpacity(0),
          ],
        ).createShader(Rect.fromCircle(center: Offset(p.x, p.y), radius: p.r * 3));
      canvas.drawCircle(Offset(p.x, p.y), p.r * 3, gp);
    }
  }

  void _drawCloud(Canvas canvas, double W, double H) {
    final cx = W * .5, cy = H * .28;
    final cs = 1 + charge * .08 + cloudPulse;
    canvas.save();
    canvas.translate(cx, cy);
    canvas.scale(cs, cs);

    // glow
    if (charge > .1) {
      final gp = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFC800).withOpacity(charge * .3),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: 110));
      canvas.drawCircle(Offset.zero, 110, gp);
    }

    // helper to lerp int channels
    int lerpC(int a, int b) => (a + (b - a) * charge).round();

    final cloudBase = Color.fromRGBO(lerpC(60, 90), lerpC(80, 100), lerpC(100, 120), 1);
    final cloudDark = Color.fromRGBO(lerpC(30, 60), lerpC(40, 60), lerpC(60, 80), 1);

    void blob(double dx, double dy, double rw, double rh) {
      final gp = Paint()
        ..shader = RadialGradient(
          center: const Alignment(-.3, -.4),
          colors: [cloudBase, cloudDark],
        ).createShader(Rect.fromCenter(
          center: Offset(dx, dy), width: rw * 2, height: rh * 2));
      canvas.drawOval(
        Rect.fromCenter(center: Offset(dx, dy), width: rw * 2, height: rh * 2), gp);
    }

    blob(-55, 10, 50, 35);
    blob(55, 10, 50, 35);
    blob(0, 20, 65, 38);
    blob(-25, -12, 45, 32);
    blob(25, -12, 45, 32);
    blob(0, -28, 35, 26);

    // inner lightning veins
    if (charge > .3) {
      final veinP = Paint()
        ..color = const Color(0xFFFFE650).withOpacity(charge * .6)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      for (int v = 0; v < 5; v++) {
        final sx = (rng.nextDouble() - .5) * 60;
        final sy = (rng.nextDouble() - .5) * 20;
        final path = Path()..moveTo(sx, sy);
        for (int s = 0; s < 4; s++) {
          path.lineTo(sx + (rng.nextDouble() - .5) * 50, sy + rng.nextDouble() * 30);
        }
        canvas.drawPath(path, veinP);
      }
    }

    // percentage text
    if (charge > .05) {
      final tp = TextPainter(
        text: TextSpan(
          text: '${(charge * 100).toInt()}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier',
            shadows: [Shadow(color: Color(0xFFFFDC00), blurRadius: 12)],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2 + 8));
    }

    canvas.restore();
  }

  void _drawLightning(Canvas canvas, double W, double H) {
    for (final b in boltSegments) {
      // glow pass
      canvas.drawLine(
        b.p1, b.p2,
        Paint()
          ..color = const Color(0xFFFFFFC8).withOpacity(.5)
          ..strokeWidth = 6.0 + b.depth * 1.5
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
      // core
      canvas.drawLine(
        b.p1, b.p2,
        Paint()
          ..color = Colors.white.withOpacity(.8 + rng.nextDouble() * .2)
          ..strokeWidth = 1.0 + b.depth * .5
          ..strokeCap = StrokeCap.round,
      );
    }

    // flash overlay
    if (flashAlpha > 0) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, W, H),
        Paint()..color = const Color(0xFFFFF0C8).withOpacity(flashAlpha * .55),
      );
    }
  }

  void _drawHint(Canvas canvas, double W, double H) {
    final tp = TextPainter(
      text: const TextSpan(
        text: 'GOSOK AWAN untuk mengisi muatan',
        style: TextStyle(
          fontFamily: 'Courier',
          fontSize: 11,
          color: Color(0xFF3A5580),
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: W);
    tp.paint(canvas, Offset((W - tp.width) / 2, H - 80));
  }

  @override
  bool shouldRepaint(_StormScenePainter o) => true;
}