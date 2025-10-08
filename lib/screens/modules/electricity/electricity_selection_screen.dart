import 'package:flutter/material.dart';
import 'package:physic_lab_app/screens/modules/electricity/dynamic/electricity_screen.dart';
import 'static/electricity_screen.dart';

// --- Warna Kustom ---
const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE0FFFF);
const Color cardColor = Color(0xFFB3E5FC);
const Color textColor = Color(0xFF37474F);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Physics Lab App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ElectricitySelectionScreen(),
    );
  }
}

class ElectricitySelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🌈 Background gradient biar nggak polos
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0FFFF), Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildTitle(),
                  const SizedBox(height: 24),

                  // 🔸 Tombol Listrik Statis
                  _buildSelectionButton(
                    context,
                    title: 'Listrik Statis',
                    subtitle:
                        'Pelajari muatan listrik yang diam, gaya Coulomb, dan fenomena listrik statis.',
                    icon: Icons.electric_bolt,
                    color: Colors.orange,
                    destination: ElectricityScreen(),
                  ),
                  const SizedBox(height: 30),

                  // 🔹 Tombol Listrik Dinamis
                  _buildSelectionButton(
                    context,
                    title: 'Listrik Dinamis',
                    subtitle:
                        'Pahami arus listrik, rangkaian seri & paralel, serta pengukuran tegangan.',
                    icon: Icons.power_outlined,
                    color: Colors.blue,
                    destination: DynamicElectricityScreen(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // --- Header dengan profil ---
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tombol back dengan bayangan lembut
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: textColor,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const Text(
          'Materi Listrik',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
            letterSpacing: 0.3,
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 20,
          child: Icon(Icons.person_outline, color: textColor),
        ),
      ],
    );
  }

  // --- Judul Halaman ---
  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Jenis Modul Listrik ⚡',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: textColor,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pelajari konsep-konsep listrik melalui simulasi dan eksperimen virtual yang interaktif.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- Tombol Pilihan Modul ---
  Widget _buildSelectionButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget destination,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Card(
            color: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: color.withOpacity(0.4), width: 2),
            ),
            shadowColor: color.withOpacity(0.3),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => destination),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Ikon dengan bayangan lembut
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(icon, size: 48, color: color),
                    ),
                    const SizedBox(width: 20),
                    // Teks judul dan deskripsi
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subtitle,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: const [
                              Text(
                                'Lihat Modul',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios, size: 14, color: primaryColor),
                            ],
                          ),
                        ],
                      ),
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

  // --- Bottom Navigation ---
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Theory'),
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
