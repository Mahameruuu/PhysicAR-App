import 'dart:math';
import 'package:flutter/material.dart';

/// LampWidget versi baru — 3D glow, filamen animasi, base metalik
class LampWidget extends StatefulWidget {
  final bool isLit;
  final Color color;
  final double brightnessFactor;
  final double size;

  const LampWidget({
    super.key,
    required this.isLit,
    this.color = const Color(0xFF00E676),
    this.brightnessFactor = 1.0,
    this.size = 80,
  });

  @override
  State<LampWidget> createState() => _LampWidgetState();
}

class _LampWidgetState extends State<LampWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowCtrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        return CustomPaint(
          size: Size(widget.size, widget.size * 1.4),
          painter: _LampPainter(
            isLit: widget.isLit,
            color: widget.color,
            pulse: widget.isLit ? _pulse.value : 0,
          ),
        );
      },
    );
  }
}

class _LampPainter extends CustomPainter {
  final bool isLit;
  final Color color;
  final double pulse;

  _LampPainter({
    required this.isLit,
    required this.color,
    required this.pulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.38;
    final bulbR = size.width * 0.38;
    final paint = Paint()..isAntiAlias = true;

    // ── Outer glow halo ─────────────────────────────────────────
    if (isLit && pulse > 0) {
      final haloR = bulbR * (1.8 + 0.4 * pulse);
      paint.shader = RadialGradient(
        colors: [
          color.withOpacity(0.45 * pulse),
          color.withOpacity(0.15 * pulse),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: haloR));
      canvas.drawCircle(Offset(cx, cy), haloR, paint);
    }

    // ── Bulb glass ───────────────────────────────────────────────
    final bulbPath = _buildBulbPath(cx, cy, bulbR, size);

    // Base fill (dark when off, glowing when on)
    if (isLit) {
      paint.shader = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 1.0,
        colors: [
          Color.lerp(Colors.white, color, 0.3)!.withOpacity(0.95),
          color.withOpacity(0.9),
          color.withOpacity(0.6),
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: bulbR));
    } else {
      paint.shader = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 1.0,
        colors: [
          const Color(0xFF2A2A3E),
          const Color(0xFF1A1A2E),
          const Color(0xFF111122),
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: bulbR));
    }
    paint.style = PaintingStyle.fill;
    canvas.drawPath(bulbPath, paint);

    // Glass highlight (specular)
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(isLit ? 0.45 : 0.12),
        Colors.white.withOpacity(0.0),
      ],
    ).createShader(Rect.fromCircle(center: Offset(cx - bulbR * 0.3, cy - bulbR * 0.4), radius: bulbR * 0.5));
    canvas.drawPath(bulbPath, paint);

    // Bulb outline
    paint.shader = null;
    paint.style = PaintingStyle.stroke;
    paint.color = isLit
        ? Colors.white.withOpacity(0.3)
        : const Color(0xFF44446A).withOpacity(0.7);
    paint.strokeWidth = 1.5;
    canvas.drawPath(bulbPath, paint);

    // ── Filament ─────────────────────────────────────────────────
    _drawFilament(canvas, cx, cy, bulbR);

    // ── Metal base ───────────────────────────────────────────────
    _drawBase(canvas, cx, cy + bulbR * 0.9, size.width * 0.28, size.height);
  }

  Path _buildBulbPath(double cx, double cy, double r, Size size) {
    final path = Path();
    final neckW = r * 0.38;
    final neckTop = cy + r * 0.62;
    final neckBot = cy + r * 0.95;

    path.addArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      pi,
      pi,
    );
    path.cubicTo(
      cx + r, neckTop,
      cx + neckW, neckTop,
      cx + neckW, neckBot,
    );
    path.lineTo(cx - neckW, neckBot);
    path.cubicTo(
      cx - neckW, neckTop,
      cx - r, neckTop,
      cx - r, cy,
    );
    path.close();
    return path;
  }

  void _drawFilament(Canvas canvas, double cx, double cy, double r) {
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = isLit ? 2.0 : 1.5;

    final startX = cx - r * 0.38;
    final startY = cy + r * 0.1;
    final amplitude = isLit ? r * 0.22 * (0.7 + 0.3 * pulse) : r * 0.18;

    final path = Path();
    path.moveTo(startX, startY);
    for (int i = 0; i < 6; i++) {
      final x = startX + i * (r * 0.76 / 5);
      final y = startY + (i.isEven ? -amplitude : amplitude);
      path.lineTo(x, y);
    }

    if (isLit) {
      paint.shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.9),
          Color.lerp(Colors.white, color, 0.5)!,
          Colors.white.withOpacity(0.9),
        ],
      ).createShader(Rect.fromLTWH(startX, startY - amplitude, r * 0.76, amplitude * 2));
    } else {
      paint.color = const Color(0xFF666688);
    }
    canvas.drawPath(path, paint);

    // Filament support wires
    paint.shader = null;
    paint.color = isLit
        ? Colors.white.withOpacity(0.6)
        : const Color(0xFF555577);
    paint.strokeWidth = 1.2;
    canvas.drawLine(
      Offset(startX, startY),
      Offset(startX, cy + 0.0),
      paint,
    );
    canvas.drawLine(
      Offset(startX + r * 0.76, startY),
      Offset(startX + r * 0.76, cy + 0.0),
      paint,
    );
  }

  void _drawBase(Canvas canvas, double cx, double neckBot, double hw, double totalH) {
    final paint = Paint()..isAntiAlias = true;
    final baseH = totalH - neckBot;
    final rows = 4;

    for (int i = 0; i < rows; i++) {
      final frac = i / (rows - 1);
      final w = hw * (1.0 - frac * 0.15);
      final top = neckBot + i * (baseH / rows);
      final h = baseH / rows;

      paint.shader = LinearGradient(
        colors: [
          const Color(0xFF475569),
          const Color(0xFF64748B),
          const Color(0xFF334155),
        ],
      ).createShader(Rect.fromLTWH(cx - w, top, w * 2, h));
      canvas.drawRect(Rect.fromLTWH(cx - w, top, w * 2, h), paint);

      // Groove lines
      paint.shader = null;
      paint.color = Colors.black.withOpacity(0.25);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 0.8;
      canvas.drawLine(Offset(cx - w, top), Offset(cx + w, top), paint);
      paint.style = PaintingStyle.fill;
    }
  }

  @override
  bool shouldRepaint(_LampPainter old) =>
      old.isLit != isLit || old.pulse != pulse || old.color != color;
}