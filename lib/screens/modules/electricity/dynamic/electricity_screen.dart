import 'package:flutter/material.dart';
import 'module1_screen.dart';
import 'module2_screen.dart';
import 'module3_screen.dart';
import 'module4_screen.dart';
import 'module5_screen.dart';
import 'static_lab_menu.dart';
import 'package:physic_lab_app/screens/auth/login_screen.dart';

// 🎨 Warna Tema Ceria
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

  const Module({ // ✅ jadikan const
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

  final List<Module> modules = const [ // ✅ tambahkan const di list
    Module(
      title: 'Modul 1: Konsep Dasar Listrik Dinamis ⚡',
      description: 'Apa itu listrik? Yuk kenali muatan dan arus listrik!',
      icon: Icons.flash_on,
      iconColor: Colors.orange,
      duration: '10 menit',
    ),
    Module(
      title: 'Modul 2: Arus dan Tegangan 🔋',
      description: 'Pelajari hubungan antara arus, tegangan, dan hambatan!',
      icon: Icons.electric_bolt,
      iconColor: Colors.redAccent,
      duration: '12 menit',
    ),
    Module(
      title: 'Modul 3: Medan Listrik 🌈',
      description: 'Gimana sih arah gaya pada muatan listrik?',
      icon: Icons.bubble_chart,
      iconColor: Colors.blueAccent,
      duration: '15 menit',
    ),
    Module(
      title: 'Modul 4: Elektroskop & Induksi 🔍',
      description: 'Eksperimen sederhana mengenal elektroskop!',
      icon: Icons.science_outlined,
      iconColor: Colors.green,
      duration: '10 menit',
    ),
    Module(
      title: 'Modul 5: Penerapan Listrik Sehari-hari 💡',
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
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                // ❌ jangan pakai const kalau LoginScreen() bukan const constructor
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Yuk, pelajari konsep listrik dengan cara seru!",
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
    String initials = getInitials(userName);

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
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Text(
                initials,
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- MODULE CARD TANPA PROGRES ---
  Widget _buildModuleCard(BuildContext context, Module module) {
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
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: module.iconColor.withOpacity(0.2),
            child: Icon(module.icon, color: module.iconColor, size: 30),
          ),
          title: Text(
            module.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: textColor,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                module.description,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 6),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 18),
        ),
      ),
    );
  }

  // --- FAB LAB ---
  Widget _buildFloatingLabButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => StaticLabMenu()));
      },
      backgroundColor: primaryColor,
      icon: const Icon(Icons.science_outlined, color: Colors.white),
      label: const Text(
        "Lab Virtual",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // --- NAV BAR ---
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
    );
  }
}
