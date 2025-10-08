import 'package:flutter/material.dart';

// Definisi Warna Kustom
const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE0FFFF);
const Color cardColor = Color(0xFFB3E5FC);
const Color textColor = Color(0xFF37474F);

// Struktur Data Modul
class Module {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String status;
  final double? progress; // 0.0 - 1.0
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

class MechanicsScreen extends StatelessWidget {
  // Daftar Modul Sesuai Data Kamu
  final List<Module> modules = [
    Module(
      title: 'Modul 1: Konsep Dasar Arus Listrik',
      description: 'Materi Pokok & Tujuan',
      icon: Icons.bolt,
      iconColor: Colors.blue,
      status: 'Not Started',
      progress: 0.0,
      duration: '15 min',
    ),
    Module(
      title: 'Modul 2: Persiapan Simulasi PhET',
      description: 'Petunjuk Penggunaan & Alat/Bahan',
      icon: Icons.computer,
      iconColor: Colors.cyan,
      status: 'Not Started',
      progress: 0.0,
      duration: '10 min',
    ),
    Module(
      title: 'Modul 3: Merancang Rangkaian Dasar',
      description: 'Langkah Kerja 3,4,5 (Susunan komponen, saklar)',
      icon: Icons.build,
      iconColor: Colors.orange,
      status: 'In Progress',
      progress: 0.5,
      duration: null,
    ),
    Module(
      title: 'Modul 4: Analisis Aliran Elektron',
      description: 'Langkah Kerja 6 & Analisis Data Q2',
      icon: Icons.electric_meter,
      iconColor: Colors.green,
      status: 'Completed',
      progress: 1.0,
      duration: null,
    ),
    Module(
      title: 'Modul 5: Analisis Pemutusan Rangkaian',
      description: 'Langkah Kerja 7 & Analisis Data Q3',
      icon: Icons.power_off,
      iconColor: Colors.red,
      status: 'Not Started',
      progress: 0.0,
      duration: '20 min',
    ),
    Module(
      title: 'Modul 6: Pengukuran dan Analisis Tegangan',
      description: 'Langkah Kerja 8 & Analisis Data Q4',
      icon: Icons.bolt_outlined,
      iconColor: Colors.purple,
      status: 'Not Started',
      progress: 0.0,
      duration: '30 min',
    ),
    Module(
      title: 'Modul 7: Data & Kesimpulan',
      description: 'Data Hasil Percobaan & Kesimpulan',
      icon: Icons.data_usage,
      iconColor: Colors.teal,
      status: 'Not Started',
      progress: 0.0,
      duration: '15 min',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildProgressBarAndTitle(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  return _buildModuleCard(modules[index]);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: textColor,
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Mechanics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
          ),
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: Border.all(color: textColor.withOpacity(0.5)),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, size: 24, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBarAndTitle() {
    double overallProgress =
        modules.fold(0.0, (sum, item) => sum + (item.progress ?? 0.0)) / modules.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mechanics Practical Modules',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: overallProgress,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          const Text(
            'Module List',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(Module module) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cardColor, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(module.icon, color: module.iconColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(module.title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(module.description,
                            style: const TextStyle(fontSize: 14, color: Colors.grey)),
                        const SizedBox(height: 8),
                        if (module.status == 'In Progress' && module.progress != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${(module.progress! * 100).toInt()}% Completed',
                                  style: TextStyle(color: primaryColor)),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: module.progress,
                                backgroundColor: Colors.grey.shade300,
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(primaryColor),
                                minHeight: 4,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ],
                          ),
                        if (module.status == 'Not Started' && module.duration != null)
                          Text('Duration: ${module.duration}', style: const TextStyle(color: Colors.grey)),
                        if (module.status == 'Completed')
                          Row(
                            children: const [
                              Icon(Icons.check_circle, size: 16, color: Colors.green),
                              SizedBox(width: 4),
                              Text('Completed', style: TextStyle(color: Colors.green)),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
      onTap: (index) {},
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
    );
  }
}
