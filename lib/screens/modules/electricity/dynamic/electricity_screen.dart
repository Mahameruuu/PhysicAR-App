import 'dart:ui';

import 'package:flutter/material.dart';
import 'module1_screen.dart';
import 'module2_screen.dart';
import 'module3_screen.dart';
import 'module4_screen.dart';
import 'module5_screen.dart';
import 'static_lab_menu.dart';
import 'package:physic_lab_app/screens/auth/login_screen.dart';
import 'package:physic_lab_app/services/auth_service.dart';
import 'package:physic_lab_app/screens/modules/electricity/dynamic/quiz/electricity_quiz_screen.dart';

// ðŸŽ¨ Warna Tema Ceria
const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE1F5FE);
const Color cardColor = Colors.white;
const Color textColor = Color(0xFF01579B);

class Module {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String duration;

  const Module({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.duration,
  });
}

class DynamicElectricityScreen extends StatelessWidget {
  final String userName;

  const DynamicElectricityScreen({super.key, required this.userName});

  final List<Module> modules = const [
    Module(
      title: 'Modul 1: Konsep Dasar Listrik Dinamis',
      description: 'Apa itu listrik? Yuk kenali muatan dan arus listrik!',
      icon: Icons.flash_on,
      iconColor: Colors.orange,
      duration: '10 menit',
    ),
    Module(
      title: 'Modul 2: Arus dan Tegangan Listrik',
      description: 'Pelajari hubungan antara arus, tegangan, dan hambatan!',
      icon: Icons.electric_bolt,
      iconColor: Colors.redAccent,
      duration: '12 menit',
    ),
    Module(
      title: 'Modul 3: Medan Listrik & Gaya Coulomb',
      description: 'Gimana sih arah gaya pada muatan listrik?',
      icon: Icons.bubble_chart,
      iconColor: Colors.blueAccent,
      duration: '15 menit',
    ),
    Module(
      title: 'Modul 4: Elektroskop & Induksi Listrik',
      description: 'Eksperimen sederhana mengenal elektroskop!',
      icon: Icons.science_outlined,
      iconColor: Colors.green,
      duration: '10 menit',
    ),
    Module(
      title: 'Modul 5: Penerapan Listrik Sehari-hari',
      description: 'Bagaimana listrik membantu kehidupan kita?',
      icon: Icons.engineering,
      iconColor: Colors.purple,
      duration: '8 menit',
    ),
  ];

  // --- Ambil inisial nama ---
  String getInitials(String name) {
    List<String> parts = name.split(' ');
    if (parts.isEmpty) return '?';
    return parts.map((e) => e[0]).take(2).join().toUpperCase();
  }

  // --- Logout dialog ---
  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah kamu yakin ingin keluar?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Logout"),
            onPressed: () async {
              Navigator.pop(context);
              await AuthService.instance.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showQuizDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x220F172A),
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      "Mulai Quiz?",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Quiz terdiri dari 10 soal pilihan ganda. Pastikan kamu sudah siap.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Color(0xFF5E7187),
                      ),
                    ),

                    const SizedBox(height: 26),

                    Row(
                      children: [

                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Batal"),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ElectricityQuizScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5CF6),
                            ),
                            child: const Text("Mulai"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLabDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x220F172A),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 78,
                    height: 78,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF36BFFA), Color(0xFF60A5FA)],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: const Icon(
                      Icons.science_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    "Masuk Lab Virtual?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Kamu akan masuk ke laboratorium virtual untuk simulasi listrik.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Color(0xFF5E7187),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Batal"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StaticLabMenu(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          child: const Text("Masuk"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          const _DynamicScreenBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 18, 20, 8),
                  child: Column(
                    children: [
                      Text(
                        "Yuk, pelajari konsep listrik dengan cara seru!",
                        style: TextStyle(
                          fontSize: 18,
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Pilih modul interaktif untuk memahami arus, tegangan, hambatan, dan penerapannya dalam kehidupan sehari-hari.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5D7189),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 110),
                    itemCount: modules.length,
                    itemBuilder: (context, index) {
                      return _buildModuleCard(context, modules[index], index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingButtons(context),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // --- HEADER ---
  Widget _buildHeader(BuildContext context) {
    String initials = getInitials(userName);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF36BFFA), Color(0xFF60A5FA), Color(0xFF7DD3FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x334FC3F7),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _HeaderCircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Column(
              children: [
                Text(
                  'Dynamic Module',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Listrik Dinamis',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Logout') {
                _showLogoutDialog(context);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Setting', child: Text('Setting')),
              PopupMenuItem(value: 'Logout', child: Text('Logout')),
            ],
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x220F172A),
                    blurRadius: 14,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- MODULE CARD TANPA PROGRES ---
  Widget _buildModuleCard(BuildContext context, Module module, int index) {
    return GestureDetector(
      onTap: () {
        if (module.title.contains('Modul 1')) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Module1Screen()));
        } else if (module.title.contains('Modul 2')) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Module2Screen()));
        } else if (module.title.contains('Modul 3')) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Module3Screen()));
        } else if (module.title.contains('Modul 4')) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Module4Screen()));
        } else if (module.title.contains('Modul 5')) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Module5Screen()));
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: module.iconColor.withValues(alpha: 0.16),
          ),
          boxShadow: [
            BoxShadow(
              color: module.iconColor.withValues(alpha: 0.10),
              offset: const Offset(0, 10),
              blurRadius: 24,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    module.iconColor.withValues(alpha: 0.18),
                    module.iconColor.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(module.icon, color: module.iconColor, size: 34),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          module.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: textColor,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: module.iconColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          module.duration,
                          style: TextStyle(
                            color: module.iconColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    module.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5E7187),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              module.iconColor,
                              module.iconColor.withValues(alpha: 0.78),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'Mulai Belajar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: module.iconColor,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- FAB LAB ---
  Widget _buildFloatingButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // =========================
        // QUIZ BUTTON
        // =========================
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Color(0x338B5CF6),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: FloatingActionButton.extended(
                heroTag: 'quiz_btn',
                onPressed: () => _showQuizDialog(context),
                backgroundColor:
                    const Color(0xFF8B5CF6).withValues(alpha: 0.95),
                elevation: 0,
                icon: const Icon(
                  Icons.psychology_rounded,
                  color: Colors.white,
                ),
                label: const Text(
                  "Quiz",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),

        // =========================
        // LAB BUTTON
        // =========================
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(22)),
            boxShadow: [
              BoxShadow(
                color: Color(0x334FC3F7),
                blurRadius: 22,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: FloatingActionButton.extended(
                heroTag: 'lab_btn',
                onPressed: () => _showLabDialog(context),
                backgroundColor: primaryColor.withValues(alpha: 0.96),
                elevation: 0,
                icon: const Icon(
                  Icons.science_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  "Lab Virtual",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- NAV BAR ---
  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Modul'),
          BottomNavigationBarItem(icon: Icon(Icons.science_outlined), label: 'Lab'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
        currentIndex: 1,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _DynamicScreenBackground extends StatelessWidget {
  const _DynamicScreenBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF7FCFF),
            Color(0xFFEAF7FD),
            Color(0xFFE1F5FE),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: const [
          _GlowOrb(
            alignment: Alignment(-1.1, -0.95),
            size: 180,
            color: Color(0x334FC3F7),
          ),
          _GlowOrb(
            alignment: Alignment(1.05, -0.2),
            size: 220,
            color: Color(0x225DAAFB),
          ),
          _GlowOrb(
            alignment: Alignment(-0.9, 0.9),
            size: 190,
            color: Color(0x1A7DD3FC),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.alignment,
    required this.size,
    required this.color,
  });

  final Alignment alignment;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCircleButton extends StatelessWidget {
  const _HeaderCircleButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
