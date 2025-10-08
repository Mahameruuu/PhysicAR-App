import 'package:flutter/material.dart';
import 'module1_screen.dart';
import 'module2_screen.dart';
import 'module3_screen.dart';
import 'module4_screen.dart';
import 'static_lab_menu.dart';

// 🎨 Palet Warna
const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE0FFFF);
const Color cardColor = Color(0xFFB3E5FC);
const Color textColor = Color(0xFF37474F);

// 📘 Struktur data modul
class Module {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String status;
  final double? progress;
  final String? duration;

  Module({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.status,
    this.progress,
    this.duration,
  });
}

class ElectricityScreen extends StatelessWidget {
  ElectricityScreen({super.key});

  // 📖 Daftar modul
  final List<Module> modules = [
    Module(
      title: 'Modul 1: Konsep Dasar Muatan Listrik',
      description: 'Pengertian muatan listrik, hukum Coulomb, fenomena listrik statis.',
      icon: Icons.electric_bolt,
      iconColor: Colors.orange,
      status: 'Not Started',
      progress: 0.0,
      duration: '15 min',
    ),
    Module(
      title: 'Modul 2: Interaksi Muatan',
      description: 'Gaya tarik-menarik dan tolak-menolak antara muatan listrik.',
      icon: Icons.flash_on,
      iconColor: Colors.red,
      status: 'Not Started',
      progress: 0.0,
      duration: '10 min',
    ),
    Module(
      title: 'Modul 3: Medan Listrik',
      description: 'Konsep medan listrik dan penerapannya pada elektroskop.',
      icon: Icons.science,
      iconColor: Colors.green,
      status: 'In Progress',
      progress: 0.4,
      duration: '20 min',
    ),
    Module(
      title: 'Modul 4: Latihan dan Analisis',
      description: 'Percobaan sederhana dan analisis hasil eksperimen listrik statis.',
      icon: Icons.assessment,
      iconColor: Colors.blue,
      status: 'Not Started',
      progress: 0.0,
      duration: '25 min',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double overallProgress =
        modules.fold(0.0, (sum, m) => sum + (m.progress ?? 0.0)) / modules.length;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildProgressSection(overallProgress),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                itemCount: modules.length,
                itemBuilder: (context, index) => _buildAnimatedModuleCard(context, modules[index]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingLabButton(context),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // --- Header dengan gradient dan efek bayangan ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF81D4FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 8,
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Listrik Statis',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person_outline, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // --- Progress section dengan tampilan modern ---
  Widget _buildProgressSection(double overallProgress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Modul Praktikum Listrik Statis',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: overallProgress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation(primaryColor),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Daftar Modul',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // --- Card Modul dengan efek animasi ---
  Widget _buildAnimatedModuleCard(BuildContext context, Module module) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _buildModuleCard(context, module),
    );
  }

  // --- Desain Card Modul ---
  Widget _buildModuleCard(BuildContext context, Module module) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        if (module.title.contains('Modul 1')) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Module1Screen()));
        } else if (module.title.contains('Modul 2')) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Module2Screen()));
        } else if (module.title.contains('Modul 3')) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Module3Screen()));
        } else if (module.title.contains('Modul 4')) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Module4Screen()));
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: cardColor, width: 2),
        ),
        elevation: 3,
        shadowColor: Colors.blue.shade100,
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: module.iconColor.withOpacity(0.15),
                ),
                child: Icon(module.icon, color: module.iconColor, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      module.description,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    if (module.status == 'In Progress')
                      LinearProgressIndicator(
                        value: module.progress,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(module.iconColor),
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    if (module.status == 'Not Started' && module.duration != null)
                      Text('Durasi: ${module.duration}',
                          style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Tombol mengambang ke Lab Virtual ---
  Widget _buildFloatingLabButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const StaticLabMenu()));
      },
      backgroundColor: primaryColor,
      icon: const Icon(Icons.science_outlined, color: Colors.white),
      label: const Text(
        "Lab Virtual",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // --- Bottom Navigation ---
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Theory'),
        BottomNavigationBarItem(icon: Icon(Icons.play_circle_outline), label: 'Simulation'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
      currentIndex: 0,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
    );
  }
}
