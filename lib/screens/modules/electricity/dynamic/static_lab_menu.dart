import 'dart:math';
import 'package:flutter/material.dart';
import 'experiment/experimen_canvas.dart';
// import 'module_listrik_seri_screen.dart';
// import 'module_listrik_paralel_screen.dart';

class StaticLabMenu extends StatefulWidget {
  const StaticLabMenu({super.key});

  @override
  State<StaticLabMenu> createState() => _StaticLabMenuState();
}

class _StaticLabMenuState extends State<StaticLabMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Animasi bolak-balik lembut
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0FFFF), Color(0xFFB3E5FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // 🌟 AppBar custom
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4FC3F7), Color(0xFF81D4FA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 20,
                left: 16,
                right: 16,
              ),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (Navigator.canPop(context))
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                  const Spacer(),
                  const Text(
                    "🧪 Lab Virtual: Listrik",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            // 🔹 Grid Experiments
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 2,
                  physics: const BouncingScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildExperimentCard(
                      context,
                      title: "Listrik Seri",
                      icon: Icons.linear_scale,
                      color1: Colors.blueAccent,
                      color2: Colors.lightBlue,
                      page: const ExperimenCanvas(target: null),
                      delay: 0,
                    ),
                    _buildExperimentCard(
                      context,
                      title: "Listrik Paralel",
                      icon: Icons.battery_charging_full,
                      color1: Colors.greenAccent,
                      color2: Colors.green,
                      page: const ExperimenCanvas(target: null),
                      delay: 0.4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✨ Kartu interaktif
  Widget _buildExperimentCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color1,
    required Color color2,
    required Widget page,
    required double delay,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: color2.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(3, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final offsetY =
                    sin((_controller.value + delay) * 2 * pi) * 5;
                final scale =
                    1 + sin((_controller.value + delay) * 2 * pi) * 0.05;
                return Transform.translate(
                  offset: Offset(0, offsetY),
                  child: Transform.scale(
                    scale: scale,
                    child: child,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(icon, color: Colors.white, size: 48),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
