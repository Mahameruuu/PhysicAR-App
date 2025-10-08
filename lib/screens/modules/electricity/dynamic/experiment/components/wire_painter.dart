// lib/screens/modules/electricity/dynamic/experiment/components/wire_painter.dart

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

abstract class WirePainter extends CustomPainter {
  final bool isSwitchOn;
  final double animationValue; 
  final Paint _wirePaint;
  final Paint _electronPaint;

  WirePainter({
    required this.isSwitchOn,
    required this.animationValue,
  }) : _wirePaint = Paint()
          ..strokeWidth = 8.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        _electronPaint = Paint()
          ..color = Colors.yellowAccent
          ..style = PaintingStyle.fill;

  // Metode untuk mendapatkan titik pada path tertentu
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
        // Memastikan tidak mengembalikan null jika Offset.lerp tidak dijalankan
        return Offset.lerp(points[i], points[i + 1], segmentFraction)!;
      }
      currentDistance += segmentLengths[i];
    }
    return points.last;
  }

  // Metode untuk menggambar elektron di sepanjang jalur
  void _drawElectrons(Canvas canvas, WirePath path, int count) {
    // Menggunakan jalur yang jauh lebih disederhanakan untuk animasi agar terlihat mengalir
    if (!isSwitchOn || path.points.length < 2) return;

    for (int i = 0; i < count; i++) {
      // Elektron mengalir dari positif ke negatif (arah t = 0 ke t = 1)
      double t = (animationValue + i / count) % 1.0; 
      final electronPosition = _getPointOnPath(path.points, t);
      canvas.drawCircle(electronPosition, 3.0, _electronPaint); 
    }
  }

  void drawCircuitPath(Canvas canvas, Size size);
  WirePath getPath(Size size); // Jalur utama untuk animasi elektron

  @override
  void paint(Canvas canvas, Size size) {
    // Gradient shader untuk efek 3D kabel
    _wirePaint.shader = LinearGradient(
      colors: [Colors.brown.shade700, Colors.black87],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Menggambar Jalur Kawat (Garis Hitam/Cokelat)
    drawCircuitPath(canvas, size);

    // Menggambar Elektron
    if (isSwitchOn) {
      // Karena rangkaian paralel, animasi pada satu jalur WirePath
      // tidak akan merepresentasikan aliran di kedua cabang.
      // Untuk tujuan demo ini, kita menggunakan jalur komprehensif 
      // yang dibuat di getPath untuk menunjukkan pergerakan umum.
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
// CustomPainter untuk Rangkaian Paralel yang Disesuaikan
// ----------------------------------------------------
class ParallelCircuitPainter extends WirePainter {
  ParallelCircuitPainter({required super.isSwitchOn, required super.animationValue});

  // --- Konstanta Koordinat Relatif ---
  static const double batteryCenterX = 150.0;
  static const double batteryBottomY = 450.0;
  static const double junctionYTop = 30.0;
  static const double junctionYBottom = 380.0; // Titik kumpul negatif utama
  static const double junctionXLeft = 80.0; // Sisi kiri utama
  static const double junctionXRight = 320.0; // Sisi kanan utama
  static const double lamp1Y = 120.0;
  static const double lamp2Y = 280.0; 
  static const double lampX = 250.0; // Posisi horizontal lampu
  static const double switchY = 320.0;
  static const double switchX = 120.0;

  @override
  void drawCircuitPath(Canvas canvas, Size size) {
    final path = Path();

    // 1. Jalur Utama Baterai (+) ke Junction Positif Atas
    path.moveTo(batteryCenterX, batteryBottomY - 25); // Baterai (+)
    path.lineTo(junctionXRight, batteryBottomY - 25); 
    path.lineTo(junctionXRight, junctionYTop); 
    path.lineTo(junctionXLeft, junctionYTop); // Junction Positif Atas

    // --- CABANG PARALEL ---

    // 2. Jalur Cabang Lampu 1 (Atas)
    // Dimulai dari Junction Positif Atas
    path.moveTo(junctionXLeft, junctionYTop);
    path.lineTo(lampX, junctionYTop); // Jalan ke kanan
    path.lineTo(lampX, lamp1Y); // Masuk Lampu 1
    path.lineTo(lampX, lamp1Y + 30); // Keluar Lampu 1

    // Dari Lampu 1 ke Junction Negatif Bawah
    path.lineTo(junctionXRight, lamp1Y + 30);
    path.lineTo(junctionXRight, junctionYBottom); // Titik Kumpul Negatif Utama (Akhir Lampu 1)
    
    // 3. Jalur Cabang Lampu 2 (Bawah) melalui Saklar
    // Dimulai dari Junction Positif Atas
    path.moveTo(junctionXLeft, junctionYTop); 
    path.lineTo(junctionXLeft, lamp2Y); // Turun ke ketinggian Lampu 2
    path.lineTo(lampX, lamp2Y); // Masuk Lampu 2
    path.lineTo(lampX, lamp2Y + 30); // Keluar Lampu 2

    // Dari Lampu 2, melalui saklar, ke Junction Negatif Bawah
    path.lineTo(junctionXLeft, lamp2Y + 30); // Ke kiri untuk ke saklar

    // Melewati area saklar (disederhanakan)
    path.lineTo(junctionXLeft, switchY + 60); // Masuk ke Saklar
    path.lineTo(switchX + 30, switchY + 60); // Melintasi Saklar
    path.lineTo(switchX + 30, switchY - 40); // Keluar Saklar (ke atas)

    path.lineTo(junctionXRight, switchY - 40); // ke Sisi Kanan
    // Menghubungkan ke Titik Kumpul Negatif Utama yang sama
    path.lineTo(junctionXRight, junctionYBottom); // Titik Kumpul Negatif Utama (Akhir Lampu 2)

    // 4. Jalur Utama Baterai (-)
    // Dimulai dari Junction Negatif Bawah
    path.moveTo(junctionXRight, junctionYBottom);
    path.lineTo(batteryCenterX, junctionYBottom); 
    path.lineTo(batteryCenterX, batteryBottomY); // Baterai (-)

    canvas.drawPath(path, _wirePaint);
  }

  @override
  WirePath getPath(Size size) {
    // Jalur Komprehensif untuk Animasi Elektron.
    // Jalur ini mengikuti jalur yang paling panjang (melalui lampu 2 dan saklar)
    // untuk memastikan animasi elektron mencakup segmen-segmen unik.
    
    return WirePath([
      // Dari Baterai (+) ke Junction Atas
      Offset(batteryCenterX, batteryBottomY - 25), 
      Offset(junctionXRight, batteryBottomY - 25),
      Offset(junctionXRight, junctionYTop), 
      Offset(junctionXLeft, junctionYTop), 
      
      // Cabang Lampu 2 (Jalur yang paling kompleks)
      Offset(junctionXLeft, lamp2Y),
      Offset(lampX, lamp2Y),
      Offset(lampX, lamp2Y + 30),
      Offset(junctionXLeft, lamp2Y + 30),
      Offset(junctionXLeft, switchY + 60), // Masuk Saklar
      Offset(switchX + 30, switchY + 60), // Melintasi Saklar
      Offset(switchX + 30, switchY - 40),
      Offset(junctionXRight, switchY - 40),
      Offset(junctionXRight, junctionYBottom),
      
      // Dari Junction Bawah ke Baterai (-)
      Offset(batteryCenterX, junctionYBottom),
      Offset(batteryCenterX, batteryBottomY), 
    ]);
  }
}