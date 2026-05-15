import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ──────────────────────────────────────────────
// DESIGN TOKENS — PhysicAR Sci-fi Theme
// ──────────────────────────────────────────────
const Color kBgDeep       = Color(0xFF0A0E1A);
const Color kBgPanel      = Color(0xFF0D1221);
const Color kBorderColor  = Color(0xFF1A2A4A);
const Color kAccentBlue   = Color(0xFF4FC3F7);
const Color kAccentGlow   = Color(0xFF1A6DFF);
const Color kTextPrimary  = Color(0xFFE8F4FF);
const Color kTextMuted    = Color(0xFF3A5580);
const Color kBallBody1    = Color(0xFF7DD8F8);
const Color kBallBody2    = Color(0xFF1565A8);
const Color kBallBody3    = Color(0xFF0A2A5E);

class KertasData {
  Offset position;
  Offset velocity;
  final Color color;
  final Color darkColor;
  double rotation;
  double rotVelocity;
  double floatPhase;
  bool attached;
  double attachAngle;
  double attachDist;

  KertasData({
    required this.position,
    required this.color,
    required this.darkColor,
    required this.rotation,
    required this.rotVelocity,
    required this.floatPhase,
    this.velocity = Offset.zero,
    this.attached = false,
    this.attachAngle = 0,
    this.attachDist = 0,
  });
}

class ModuleBalonScreen extends StatefulWidget {
  const ModuleBalonScreen({super.key});

  @override
  State<ModuleBalonScreen> createState() => _ModuleBalonScreenState();
}

class _ModuleBalonScreenState extends State<ModuleBalonScreen>
    with SingleTickerProviderStateMixin {
  static const double _balonR      = 48.0;
  static const double _kertasW     = 14.0;
  static const double _kertasH     = 17.0;
  static const int    _paperCount  = 18;

  Offset _balonPos = const Offset(175, 180);
  List<KertasData> _papers = [];
  double _charge = 0.0;
  bool _dragging = false;
  late Ticker _ticker;
  final Random _rng = Random();
  double _pulsePhase = 0;

  static const _paperPalette = [
    [Color(0xFFFF6B6B), Color(0xFFC0392B)],
    [Color(0xFFFFD93D), Color(0xFFC9910D)],
    [Color(0xFF6BCB77), Color(0xFF228B34)],
    [Color(0xFFC77DFF), Color(0xFF6A0DAD)],
    [Color(0xFF4FC3F7), Color(0xFF0073A8)],
    [Color(0xFFFF8C42), Color(0xFFC05000)],
    [Color(0xFFF8A5C2), Color(0xFFC0395A)],
  ];

  @override
  void initState() {
    super.initState();
    _spawnPapers();
    _ticker = createTicker(_onTick)..start();
  }

  void _spawnPapers() {
    _papers = List.generate(_paperCount, (i) {
      final pair = _paperPalette[i % _paperPalette.length];
      return KertasData(
        position: Offset(
          20 + _rng.nextDouble() * 310,
          150 + _rng.nextDouble() * 280,
        ),
        color:      pair[0],
        darkColor:  pair[1],
        rotation:   _rng.nextDouble() * pi * 2,
        rotVelocity: (_rng.nextDouble() - 0.5) * 0.02,
        floatPhase: _rng.nextDouble() * pi * 2,
        velocity:   Offset(
          (_rng.nextDouble() - 0.5) * 0.4,
          (_rng.nextDouble() - 0.5) * 0.4,
        ),
      );
    });
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    setState(() {
      _pulsePhase += 1;
      for (final p in _papers) {
        p.floatPhase += 0.018;
        final fx = sin(p.floatPhase) * 0.6;
        final fy = cos(p.floatPhase * 1.3) * 0.6;

        final dx = _balonPos.dx - p.position.dx;
        final dy = _balonPos.dy - p.position.dy;
        final dist = sqrt(dx * dx + dy * dy);

        if (!p.attached) {
          if (_charge > 0.08 && dist < 200) {
            final strength = (_charge * 0.06) * (1 - dist / 200);
            p.velocity = Offset(
              p.velocity.dx + dx / dist * strength,
              p.velocity.dy + dy / dist * strength,
            );
          }
          p.velocity = Offset(
            (p.velocity.dx + fx * 0.04) * 0.92,
            (p.velocity.dy + fy * 0.04) * 0.92,
          );
          p.position += p.velocity;
          p.rotation += p.rotVelocity;
          p.rotVelocity *= 0.98;

          if (dist < _balonR * 1.1 && _charge > 0.3) {
            p.attached = true;
            p.attachAngle = atan2(dy * -1, dx * -1);
            p.attachDist = _balonR * 1.05;
          }
        } else {
          if (_charge < 0.05) {
            p.attached = false;
            p.velocity = Offset(
              (_rng.nextDouble() - 0.5) * 2,
              (_rng.nextDouble() - 0.5) * 2,
            );
          } else {
            p.attachAngle += 0.008;
            p.position = Offset(
              _balonPos.dx + cos(p.attachAngle) * p.attachDist,
              _balonPos.dy + sin(p.attachAngle) * p.attachDist,
            );
            p.rotation += 0.03;
          }
        }

        // boundary bounce
        p.position = Offset(
          p.position.dx.clamp(_kertasW / 2, 350 - _kertasW / 2),
          p.position.dy.clamp(_kertasH / 2, 460 - _kertasH / 2),
        );
      }

      if (!_dragging && _charge > 0) {
        _charge = (_charge - 0.0008).clamp(0, 1);
      }
    });
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
        border: Border(bottom: BorderSide(color: kBorderColor, width: 1)),
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
                  size: 14, color: kAccentBlue),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MODUL 04 · PHYSICAR',
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 9,
                  letterSpacing: 3,
                  color: kAccentBlue.withOpacity(0.8),
                )),
              const SizedBox(height: 2),
              const Text('LISTRIK STATIS',
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
          // charge indicator badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: kAccentBlue.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(20),
              color: kAccentBlue.withOpacity(0.08),
            ),
            child: Row(
              children: [
                const Icon(Icons.electric_bolt,
                    size: 13, color: kAccentBlue),
                const SizedBox(width: 4),
                Text('${(_charge * 100).toInt()}%',
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: kAccentBlue,
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimArea() {
    return Container(
      color: kBgDeep,
      width: double.infinity,
      child: LayoutBuilder(builder: (ctx, box) {
        return GestureDetector(
          onPanStart: (d) {
            final dist = (d.localPosition - _balonPos).distance;
            if (dist < _balonR * 1.4) _dragging = true;
          },
          onPanUpdate: (d) {
            if (!_dragging) return;
            setState(() {
              _balonPos = Offset(
                (_balonPos.dx + d.delta.dx).clamp(_balonR, box.maxWidth - _balonR),
                (_balonPos.dy + d.delta.dy).clamp(_balonR + 50, box.maxHeight - _balonR),
              );
              final moved = d.delta.distance;
              _charge = (_charge + moved * 0.00008).clamp(0, 1);
            });
          },
          onPanEnd: (_) => _dragging = false,
          child: Stack(
            children: [
              // grid background
              CustomPaint(
                painter: _GridPainter(),
                size: Size(box.maxWidth, box.maxHeight),
              ),
              // hint text
              Positioned(
                top: 16, left: 0, right: 0,
                child: Text(
                  'Seret balon untuk memberi muatan ⚡',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 11,
                    color: kTextMuted,
                    letterSpacing: 1,
                  ),
                ),
              ),
              // papers
              ..._papers.map((p) => Positioned(
                left: p.position.dx - _kertasW / 2,
                top:  p.position.dy - _kertasH / 2,
                child: Transform.rotate(
                  angle: p.rotation,
                  child: CustomPaint(
                    painter: _PaperPainter(p.color, p.darkColor),
                    size: const Size(_kertasW, _kertasH),
                  ),
                ),
              )),
              // balon
              Positioned(
                left: _balonPos.dx - _balonR,
                top:  _balonPos.dy - _balonR,
                child: CustomPaint(
                  painter: _BalonPainter(
                    charge: _charge,
                    pulsePhase: _pulsePhase,
                  ),
                  size: const Size(_balonR * 2, _balonR * 2 + 50),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFooter() {
    final pct = (_charge * 100).toInt();
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: kBgPanel,
        border: Border(top: BorderSide(color: kBorderColor, width: 1)),
      ),
      child: Row(
        children: [
          Text('MUATAN Q',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 9,
              letterSpacing: 2.5,
              color: kAccentBlue.withOpacity(0.7),
            )),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Stack(
                children: [
                  Container(height: 6, color: const Color(0xFF111827)),
                  AnimatedFractionallySizedBox(
                    duration: const Duration(milliseconds: 100),
                    widthFactor: _charge,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [kAccentGlow, kAccentBlue, Color(0xFF00FFE7)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kAccentBlue.withOpacity(0.5),
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
                color: kAccentBlue,
              )),
          ),
        ],
      ),
    );
  }
}

// ── Custom Painters ────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF1A2A4A).withOpacity(0.35)
      ..strokeWidth = 0.5;
    const step = 30.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_GridPainter o) => false;
}

class _PaperPainter extends CustomPainter {
  final Color color;
  final Color dark;
  const _PaperPainter(this.color, this.dark);

  @override
  void paint(Canvas canvas, Size size) {
    final body = Paint()..color = color;
    final fold = Paint()..color = dark;
    final line = Paint()
      ..color = Colors.black26
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // shadow
    canvas.drawRect(
      Rect.fromLTWH(1.5, 1.5, size.width, size.height),
      Paint()..color = Colors.black38..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), body);

    // dog-ear fold
    final foldPath = Path()
      ..moveTo(size.width * 0.65, 0)
      ..lineTo(size.width, size.height * 0.3)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(foldPath, fold);

    // lines
    for (int l = 1; l <= 3; l++) {
      final y = size.height * l / 4.5;
      canvas.drawLine(Offset(2, y), Offset(size.width * 0.6, y), line);
    }
  }

  @override
  bool shouldRepaint(_PaperPainter o) => false;
}

class _BalonPainter extends CustomPainter {
  final double charge;
  final double pulsePhase;

  const _BalonPainter({required this.charge, required this.pulsePhase});

  static const double R = 48.0;
  static const Offset C = Offset(R, R);

  @override
  void paint(Canvas canvas, Size size) {
    // glow
    if (charge > 0.05) {
      final glow = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF4FC3F7).withOpacity(charge * 0.25),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: C, radius: R * 2.2));
      canvas.drawCircle(C, R * 2.2, glow);
    }

    // pulse rings
    if (charge > 0.2) {
      for (int r = 1; r <= 2; r++) {
        final progress = (pulsePhase / 60) % 1;
        final ringR = R * (1.5 + r * 0.6 + progress * R * 0.01);
        final alpha = ((0.35 - progress * 0.35) * charge).clamp(0, 1);
        canvas.drawCircle(
          C, ringR,
          Paint()
            ..color = const Color(0xFF4FC3F7).withOpacity(alpha.toDouble())
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2,
        );
      }
    }

    // body gradient
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.5, -0.5),
        colors: const [kBallBody1, Color(0xFF29A8E0), kBallBody2, kBallBody3],
        stops: const [0, 0.35, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: C, radius: R));
    canvas.drawCircle(C, R, bodyPaint);

    // rim glow
    canvas.drawCircle(
      C, R,
      Paint()
        ..color = charge > 0.1
            ? const Color(0xFF4FC3F7).withOpacity(0.5 + charge * 0.5)
            : const Color(0xFF64B4DC).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // highlight
    canvas.drawOval(
      Rect.fromCenter(
        center: C + const Offset(-13, -13),
        width: R * 0.44,
        height: R * 0.28,
      ),
      Paint()
        ..color = Colors.white.withOpacity(0.38)
        ..style = PaintingStyle.fill,
    );

    // string
    final strPath = Path()
      ..moveTo(C.dx, C.dy + R)
      ..cubicTo(
        C.dx + 8, C.dy + R + 18,
        C.dx - 5, C.dy + R + 32,
        C.dx + 3, C.dy + R + 48,
      );
    canvas.drawPath(
      strPath,
      Paint()
        ..color = const Color(0xFF96C8F0).withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );

    // % text
    if (charge > 0.05) {
      final tp = TextPainter(
        text: TextSpan(
          text: '${(charge * 100).toInt()}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier',
            shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, C - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_BalonPainter o) =>
      o.charge != charge || o.pulsePhase != pulsePhase;
}