// lib/widgets/effects.dart
import 'dart:math';
import 'package:flutter/material.dart';

// =================== FIRE EFFECT ===================
class FireEffect extends StatefulWidget {
  final bool active;
  const FireEffect({super.key, required this.active});

  @override
  State<FireEffect> createState() => _FireEffectState();
}

class _FireEffectState extends State<FireEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: widget.active ? (_controller.value * 0.8 + 0.2) : 0,
          child: CustomPaint(
            size: const Size(40, 40),
            painter: FirePainter(_controller.value),
          ),
        );
      },
    );
  }
}

class FirePainter extends CustomPainter {
  final double progress;
  FirePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 5; i++) {
      final offsetY = center.dy - progress * 20 - i * 4;
      final offsetX = center.dx + (i % 2 == 0 ? -3.0 : 3.0) * i;
      paint.shader = RadialGradient(
        colors: [Colors.red, Colors.orange, Colors.yellow.withOpacity(0)],
        stops: const [0, 0.5, 1],
      ).createShader(Rect.fromCircle(center: Offset(offsetX, offsetY), radius: 8 + i * 2));
      canvas.drawCircle(Offset(offsetX, offsetY), 8 + i.toDouble(), paint);
    }
  }

  @override
  bool shouldRepaint(covariant FirePainter oldDelegate) => true;
}

// =================== EXPLOSION / SPARK EFFECT ===================
class ExplosionEffect extends StatefulWidget {
  const ExplosionEffect({super.key});

  @override
  State<ExplosionEffect> createState() => _ExplosionEffectState();
}

class _ExplosionEffectState extends State<ExplosionEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Offset> sparks;
  late List<double> sizes;
  final int sparkCount = 12;

  @override
  void initState() {
    super.initState();
    sparks = List.generate(sparkCount, (_) => Offset.zero);
    sizes = List.generate(sparkCount, (_) => Random().nextDouble() * 3 + 2);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();

    _controller.addListener(() {
      setState(() {
        for (int i = 0; i < sparkCount; i++) {
          double angle = Random().nextDouble() * 2 * pi;
          double radius = _controller.value * 25 * Random().nextDouble();
          sparks[i] = Offset(cos(angle) * radius, sin(angle) * radius);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(50, 50),
      painter: ExplosionPainter(sparks, sizes),
    );
  }
}

class ExplosionPainter extends CustomPainter {
  final List<Offset> sparks;
  final List<double> sizes;
  ExplosionPainter(this.sparks, this.sizes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < sparks.length; i++) {
      paint.color = Colors.orange.withOpacity(1 - (sizes[i]/5));
      canvas.drawCircle(
        Offset(size.width/2 + sparks[i].dx, size.height/2 + sparks[i].dy),
        sizes[i],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ExplosionPainter oldDelegate) => true;
}
