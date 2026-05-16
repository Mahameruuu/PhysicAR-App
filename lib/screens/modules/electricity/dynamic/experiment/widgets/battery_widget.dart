import 'package:flutter/material.dart';

/// BatteryWidget versi baru — metalik 3D, gradient, label tegangan
class BatteryWidget extends StatefulWidget {
  final double voltage;
  final double maxVoltage;

  const BatteryWidget({
    super.key,
    this.voltage = 9.0,
    this.maxVoltage = 20.0,
  });

  @override
  State<BatteryWidget> createState() => _BatteryWidgetState();
}

class _BatteryWidgetState extends State<BatteryWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerCtrl,
      builder: (_, __) => CustomPaint(
        size: const Size(120, 60),
        painter: _BatteryPainter(
          voltage: widget.voltage,
          maxVoltage: widget.maxVoltage,
          shimmer: _shimmerCtrl.value,
        ),
      ),
    );
  }
}

class _BatteryPainter extends CustomPainter {
  final double voltage;
  final double maxVoltage;
  final double shimmer;

  _BatteryPainter({
    required this.voltage,
    required this.maxVoltage,
    required this.shimmer,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;
    const termW = 8.0;
    const bodyX = 0.0;
    final bodyW = size.width - termW;
    const bodyH = 40.0;
    final bodyY = (size.height - bodyH) / 2;
    const r = 8.0;

    // ── Body gradient ────────────────────────────────────────────
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFF22C55E),
        const Color(0xFF16A34A),
        const Color(0xFF166534),
      ],
    ).createShader(Rect.fromLTWH(bodyX, bodyY, bodyW, bodyH));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bodyX, bodyY, bodyW, bodyH),
        const Radius.circular(r),
      ),
      paint,
    );

    // ── Cell dividers ────────────────────────────────────────────
    paint.shader = null;
    paint.color = Colors.black.withOpacity(0.2);
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    for (int i = 1; i < 4; i++) {
      final x = bodyX + bodyW * (i / 4);
      canvas.drawLine(
        Offset(x, bodyY + 6),
        Offset(x, bodyY + bodyH - 6),
        paint,
      );
    }

    // ── Shine highlight ──────────────────────────────────────────
    paint.style = PaintingStyle.fill;
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white.withOpacity(0.35),
        Colors.white.withOpacity(0.0),
      ],
    ).createShader(Rect.fromLTWH(bodyX + 6, bodyY + 2, bodyW - 12, bodyH / 2));
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(bodyX + 4, bodyY + 3, bodyW - 8, bodyH / 2 - 2),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      ),
      paint,
    );

    // ── Shimmer sweep ────────────────────────────────────────────
    final sweepX = bodyX - 30 + (bodyW + 60) * shimmer;
    paint.shader = LinearGradient(
      colors: [
        Colors.transparent,
        Colors.white.withOpacity(0.18),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromLTWH(sweepX - 20, bodyY, 40, bodyH));

    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bodyX, bodyY, bodyW, bodyH),
        const Radius.circular(r),
      ),
    );
    canvas.drawRect(Rect.fromLTWH(sweepX - 20, bodyY, 40, bodyH), paint);
    canvas.restore();

    // ── Voltage label ────────────────────────────────────────────
    paint.shader = null;
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 13,
      fontWeight: FontWeight.bold,
      fontFamily: 'monospace',
    );
    final tp = TextPainter(
      text: TextSpan(
        text: '${voltage.toStringAsFixed(0)}V',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(bodyX + bodyW / 2 - tp.width / 2, bodyY + bodyH / 2 - tp.height / 2),
    );

    // ── Positive terminal ────────────────────────────────────────
    paint.shader = LinearGradient(
      colors: [const Color(0xFF4ADE80), const Color(0xFF16A34A)],
    ).createShader(Rect.fromLTWH(bodyW, bodyY + 10, termW, bodyH - 20));
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(bodyW, bodyY + 10, termW, bodyH - 20),
        topRight: const Radius.circular(4),
        bottomRight: const Radius.circular(4),
      ),
      paint,
    );

    // + symbol
    paint.shader = null;
    paint.color = Colors.white;
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    final mx = bodyW + termW / 2;
    final my = size.height / 2;
    canvas.drawLine(Offset(mx - 3, my), Offset(mx + 3, my), paint);
    canvas.drawLine(Offset(mx, my - 3), Offset(mx, my + 3), paint);

    // ── Bottom label ─────────────────────────────────────────────
    const labelStyle = TextStyle(
      color: Color(0xFF86EFAC),
      fontSize: 9,
      fontFamily: 'monospace',
      letterSpacing: 1.2,
    );
    final lp = TextPainter(
      text: const TextSpan(text: 'BATERAI', style: labelStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    lp.paint(
      canvas,
      Offset(bodyX + bodyW / 2 - lp.width / 2, bodyY + bodyH + 4),
    );
  }

  @override
  bool shouldRepaint(_BatteryPainter old) =>
      old.shimmer != shimmer || old.voltage != voltage;
}