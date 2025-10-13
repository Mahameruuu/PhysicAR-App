import 'package:flutter/material.dart';

// --- Model Sederhana untuk Jalur Kawat ---
class WirePath {
  final List<Offset> points;
  WirePath(this.points);
}

extension on WirePath {
  Path pointsToPath() {
    final path = Path();
    if (points.isEmpty) return path;
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    return path;
  }
}

// ----------------------------------------------------
// ABSTRACT: Kelas dasar untuk semua WirePainter
// ----------------------------------------------------
abstract class WirePainter extends CustomPainter {
  final bool isSwitchOn;
  final double animationValue;
  final Paint _wirePaint;
  final Paint _electronPaint;

  WirePainter({
    required this.isSwitchOn,
    required this.animationValue,
  })  : _wirePaint = Paint()
          ..strokeWidth = 8.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        _electronPaint = Paint()
          ..color = Colors.yellowAccent
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

  // Metode bantu untuk menghitung posisi elektron di sepanjang path
  Offset _getPointOnPath(List<Offset> points, double t) {
    if (points.isEmpty) return Offset.zero;

    double totalLength = 0;
    List<double> segmentLengths = [];
    for (int i = 0; i < points.length - 1; i++) {
      double length = (points[i] - points[i + 1]).distance;
      totalLength += length;
      segmentLengths.add(length);
    }

    double targetDistance = t * totalLength;
    double currentDistance = 0;

    for (int i = 0; i < segmentLengths.length; i++) {
      if (currentDistance + segmentLengths[i] >= targetDistance) {
        double segmentFraction = (targetDistance - currentDistance) / segmentLengths[i];
        return Offset.lerp(points[i], points[i + 1], segmentFraction)!;
      }
      currentDistance += segmentLengths[i];
    }
    return points.last;
  }

  // Menggambar elektron yang bergerak di sepanjang path
  void _drawElectrons(Canvas canvas, WirePath path, int count) {
    if (!isSwitchOn || path.points.length < 2) return;

    for (int i = 0; i < count; i++) {
      double t = (animationValue + i / count) % 1.0;
      final electronPosition = _getPointOnPath(path.points, t);
      canvas.drawCircle(
        electronPosition,
        4.0,
        _electronPaint,
      );
    }
  }

  void drawCircuitPath(Canvas canvas, Size size);
  WirePath getPath(Size size);

  @override
  void paint(Canvas canvas, Size size) {
    // Gradient kabel 3D
    _wirePaint.shader = LinearGradient(
      colors: isSwitchOn
          ? [Colors.orange.shade300, Colors.yellow.shade400, Colors.orange.shade700]
          : [Colors.grey.shade400, Colors.grey.shade500, Colors.grey.shade600],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    drawCircuitPath(canvas, size);

    if (isSwitchOn) {
      _drawElectrons(canvas, getPath(size), 25);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is WirePainter) {
      return oldDelegate.isSwitchOn != isSwitchOn ||
          oldDelegate.animationValue != animationValue;
    }
    return true;
  }
}

// ----------------------------------------------------
// CustomPainter untuk Rangkaian Paralel
// ----------------------------------------------------
class ParallelCircuitPainter extends WirePainter {
  ParallelCircuitPainter({
    required super.isSwitchOn,
    required super.animationValue,
  });

  @override
  void drawCircuitPath(Canvas canvas, Size size) {
    final path = Path();

    final w = size.width;
    final h = size.height;

    // Battery dan junction relatif terhadap ukuran layar
    final batteryX = w * 0.2;
    final batteryY = h * 0.8;
    final junctionTopY = h * 0.1;
    final junctionBottomY = h * 0.7;
    final junctionLeftX = w * 0.25;
    final junctionRightX = w * 0.75;
    final lampX = w * 0.6;
    final lamp1Y = h * 0.3;
    final lamp2Y = h * 0.5;
    final switchX = w * 0.35;
    final switchY = h * 0.55;

    // Jalur utama dari baterai ke junction atas
    path.moveTo(batteryX, batteryY);
    path.lineTo(junctionRightX, batteryY);
    path.lineTo(junctionRightX, junctionTopY);
    path.lineTo(junctionLeftX, junctionTopY);

    // Cabang Lampu 1
    path.moveTo(junctionLeftX, junctionTopY);
    path.lineTo(lampX, junctionTopY);
    path.lineTo(lampX, lamp1Y);
    path.lineTo(lampX, lamp1Y + 20);
    path.lineTo(junctionRightX, lamp1Y + 20);
    path.lineTo(junctionRightX, junctionBottomY);

    // Cabang Lampu 2 via saklar
    path.moveTo(junctionLeftX, junctionTopY);
    path.lineTo(junctionLeftX, lamp2Y);
    path.lineTo(lampX, lamp2Y);
    path.lineTo(lampX, lamp2Y + 20);
    path.lineTo(junctionLeftX, lamp2Y + 20);
    path.lineTo(junctionLeftX, switchY + 10);
    path.lineTo(switchX + 20, switchY + 10);
    path.lineTo(switchX + 20, switchY - 20);
    path.lineTo(junctionRightX, switchY - 20);
    path.lineTo(junctionRightX, junctionBottomY);

    // Jalur kembali ke baterai (-)
    path.moveTo(junctionRightX, junctionBottomY);
    path.lineTo(batteryX, junctionBottomY);
    path.lineTo(batteryX, batteryY);

    canvas.drawPath(path, _wirePaint);
  }

  @override
  WirePath getPath(Size size) {
    final w = size.width;
    final h = size.height;

    final batteryX = w * 0.2;
    final batteryY = h * 0.8;
    final junctionTopY = h * 0.1;
    final junctionBottomY = h * 0.7;
    final junctionLeftX = w * 0.25;
    final junctionRightX = w * 0.75;
    final lampX = w * 0.6;
    final lamp1Y = h * 0.3;
    final lamp2Y = h * 0.5;
    final switchX = w * 0.35;
    final switchY = h * 0.55;

    return WirePath([
      Offset(batteryX, batteryY),
      Offset(junctionRightX, batteryY),
      Offset(junctionRightX, junctionTopY),
      Offset(junctionLeftX, junctionTopY),
      Offset(junctionLeftX, lamp2Y),
      Offset(lampX, lamp2Y),
      Offset(lampX, lamp2Y + 20),
      Offset(junctionLeftX, lamp2Y + 20),
      Offset(junctionLeftX, switchY + 10),
      Offset(switchX + 20, switchY + 10),
      Offset(switchX + 20, switchY - 20),
      Offset(junctionRightX, switchY - 20),
      Offset(junctionRightX, junctionBottomY),
      Offset(batteryX, junctionBottomY),
      Offset(batteryX, batteryY),
    ]);
  }
}

// ----------------------------------------------------
// CustomPainter untuk Rangkaian Seri
// ----------------------------------------------------
class SeriesCircuitPainter extends WirePainter {
  SeriesCircuitPainter({
    required super.isSwitchOn,
    required super.animationValue,
  });

  @override
  void drawCircuitPath(Canvas canvas, Size size) {
    final path = Path();

    final w = size.width;
    final h = size.height;

    // Loop persegi relatif
    final leftX = w * 0.2;
    final rightX = w * 0.8;
    final topY = h * 0.2;
    final bottomY = h * 0.8;

    path.moveTo(w * 0.5, bottomY); // battery +
    path.lineTo(leftX, bottomY);
    path.lineTo(leftX, topY);
    path.lineTo(rightX, topY);
    path.lineTo(rightX, bottomY);
    path.lineTo(w * 0.5, bottomY); // battery -

    canvas.drawPath(path, _wirePaint);
  }

  @override
  WirePath getPath(Size size) {
    final w = size.width;
    final h = size.height;

    final leftX = w * 0.2;
    final rightX = w * 0.8;
    final topY = h * 0.2;
    final bottomY = h * 0.8;

    return WirePath([
      Offset(w * 0.5, bottomY),
      Offset(leftX, bottomY),
      Offset(leftX, topY),
      Offset(rightX, topY),
      Offset(rightX, bottomY),
      Offset(w * 0.5, bottomY),
    ]);
  }
}
