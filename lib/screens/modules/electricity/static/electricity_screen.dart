import 'package:flutter/material.dart';
import 'module1_screen.dart';
import 'module2_screen.dart';
import 'module3_screen.dart';
import 'module4_screen.dart';
import 'static_lab_menu.dart';
import 'package:physic_lab_app/screens/auth/login_screen.dart';
import 'package:physic_lab_app/screens/auth/home_screen.dart'; // ⬅️ Tambahkan ini untuk navigasi ke HomeScreen

// 🎨 Warna Tema Ceria
const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE1F5FE);
const Color cardColor = Colors.white;
const Color textColor = Color(0xFF01579B);

// 📘 Struktur Data Modul
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

class ElectricityScreen extends StatefulWidget {
  final String userName;

  const ElectricityScreen({super.key, required this.userName});

  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen> {
  int _selectedIndex = 1;

  final List<Module> modules = const [
    Module(
      title: 'Modul 1: Konsep Dasar Muatan Listrik ⚡',
      description:
          'Pengertian muatan listrik, hukum Coulomb, dan fenomena listrik statis.',
      icon: Icons.electric_bolt,
      iconColor: Colors.orange,
      duration: '10 menit',
    ),
    Module(
      title: 'Modul 2: Interaksi Muatan 🔋',
      description: 'Gaya tarik-menarik dan tolak-menolak antara muatan listrik.',
      icon: Icons.flash_on,
      iconColor: Colors.redAccent,
      duration: '12 menit',
    ),
    Module(
      title: 'Modul 3: Medan Listrik 🌈',
      description: 'Konsep medan listrik dan penerapannya pada elektroskop.',
      icon: Icons.science_outlined,
      iconColor: Colors.green,
      duration: '15 menit',
    ),
    Module(
      title: 'Modul 4: Latihan dan Analisis 💡',
      description: 'Percobaan sederhana dan analisis hasil eksperimen listrik statis.',
      icon: Icons.assessment,
      iconColor: Colors.blueAccent,
      duration: '8 menit',
    ),
  ];

  // --- Helper ---
  String getInitials(String name) {
    List<String> parts = name.split(' ');
    if (parts.isEmpty) return '?';
    return parts.map((e) => e[0]).take(2).join().toUpperCase();
  }

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
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- Aksi ketika tombol navbar ditekan ---
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(userName: widget.userName),
        ),
      );
    } else if (index == 1) {
      // tetap di ElectricityScreen (Modul)
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Simulation belum tersedia')),
      );
    } else if (index == 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile belum tersedia')),
      );
    }
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
                "Pelajari konsep listrik statis dengan cara yang menyenangkan! ⚡",
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

  Widget _buildHeader(BuildContext context) {
    String initials = getInitials(widget.userName);

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
            'Listrik Statis',
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
          subtitle: Text(
            module.description,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          trailing:
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 18),
        ),
      ),
    );
  }

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

  // 🔹 BOTTOM NAVIGATION – SAMA DENGAN HOMESCREEN 🔹
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Modul'),
        BottomNavigationBarItem(icon: Icon(Icons.play_circle_outline), label: 'Simulation'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      onTap: _onItemTapped,
      showUnselectedLabels: true,
    );
  }
}
