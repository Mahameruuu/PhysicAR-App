import 'package:flutter/material.dart';
import 'module1_screen.dart';
import 'module2_screen.dart';
import 'module3_screen.dart';
import 'module4_screen.dart';
import 'module5_screen.dart';
import 'static_lab_menu.dart';

// 🎨 Warna Tema
const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE0F7FA);
const Color cardColor = Color(0xFFFFFFFF);
const Color textColor = Color(0xFF004D40);

// 📘 Struktur data modul
class Module {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String status;
  final double progress;
  final String duration;

  Module({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.status,
    required this.progress,
    required this.duration,
  });
}

class DynamicElectricityScreen extends StatelessWidget {
  DynamicElectricityScreen({super.key});

  // 📖 Daftar modul
  final List<Module> modules = [
    Module(
      title: 'Modul 1: Konsep Dasar Listrik Statis',
      description: 'Memahami muatan listrik, gaya Coulomb, dan interaksi muatan.',
      icon: Icons.flash_on,
      iconColor: Colors.orange,
      status: 'Completed',
      progress: 1.0,
      duration: '15 min',
    ),
    Module(
      title: 'Modul 2: Listrik Dinamis',
      description: 'Mempelajari arus, tegangan, hambatan, dan hukum Ohm.',
      icon: Icons.electric_bolt,
      iconColor: Colors.redAccent,
      status: 'Completed',
      progress: 1.0,
      duration: '20 min',
    ),
    Module(
      title: 'Modul 3: Medan Listrik',
      description: 'Menjelaskan konsep medan listrik dan gaya pada muatan uji.',
      icon: Icons.bubble_chart,
      iconColor: Colors.blueAccent,
      status: 'In Progress',
      progress: 0.4,
      duration: '25 min',
    ),
    Module(
      title: 'Modul 4: Induksi dan Elektroskop',
      description: 'Melihat fenomena elektroskop serta perpindahan muatan.',
      icon: Icons.science_outlined,
      iconColor: Colors.green,
      status: 'Not Started',
      progress: 0.0,
      duration: '30 min',
    ),
    Module(
      title: 'Modul 5: Penerapan Listrik Statis',
      description: 'Menjelaskan penerapan listrik statis dalam kehidupan sehari-hari.',
      icon: Icons.engineering,
      iconColor: Colors.purple,
      status: 'Not Started',
      progress: 0.0,
      duration: '25 min',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double overallProgress =
        modules.fold(0.0, (sum, m) => sum + m.progress) / modules.length;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildProgressSummary(overallProgress),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  return _buildModuleCard(context, modules[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingLabButton(context),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // --- HEADER ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, Color(0xFF81D4FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Listrik Dinamis',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(Icons.person_outline, color: primaryColor),
          ),
        ],
      ),
    );
  }

  // --- PROGRESS SUMMARY ---
  Widget _buildProgressSummary(double progress) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kemajuan Belajar Kamu',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation(primaryColor),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${(progress * 100).toInt()}% Selesai',
            style: const TextStyle(
                color: textColor, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // --- MODULE CARD ---
  Widget _buildModuleCard(BuildContext context, Module module) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Hero(
                tag: module.title,
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: module.iconColor.withOpacity(0.2),
                  child: Icon(module.icon, color: module.iconColor, size: 30),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(module.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textColor)),
                    const SizedBox(height: 4),
                    Text(
                      module.description,
                      style: const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    _buildModuleStatus(module),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- STATUS BAR ---
  Widget _buildModuleStatus(Module module) {
    if (module.status == 'Completed') {
      return Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.green, size: 16),
          SizedBox(width: 6),
          Text('Selesai', style: TextStyle(color: Colors.green)),
        ],
      );
    } else if (module.status == 'In Progress') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${(module.progress * 100).toInt()}% Selesai',
            style: const TextStyle(color: primaryColor),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: module.progress,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation(primaryColor),
              minHeight: 6,
            ),
          ),
        ],
      );
    } else {
      return Text('Durasi: ${module.duration}',
          style: const TextStyle(color: Colors.grey));
    }
  }

  // --- TOMBOL LAB VIRTUAL ---
  Widget _buildFloatingLabButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const StaticLabMenu()));
      },
      backgroundColor: primaryColor,
      icon: const Icon(Icons.science_outlined, color: Colors.white),
      label: const Text(
        "Lab Virtual",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // --- BOTTOM NAVIGATION ---
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Theory'),
        BottomNavigationBarItem(icon: Icon(Icons.science_outlined), label: 'Simulation'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
      currentIndex: 1,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      showUnselectedLabels: true,
    );
  }
}
