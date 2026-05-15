import 'package:flutter/material.dart';
import 'package:physic_lab_app/layouts/main_scaffold.dart';
import 'package:physic_lab_app/screens/auth/home_screen.dart';

import 'profile_screen.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({
    super.key,
    this.userName,
  });

  final String? userName;

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  final List<Map<String, dynamic>> _steps = const [
    {
      "step": "1ï¸âƒ£",
      "text": "Pengguna melakukan LOGIN ke sistem.",
      "color": Colors.redAccent,
      "icon": Icons.login,
    },
    {
      "step":
          "2ï¸âƒ£",
      "text":
          "Sistem memverifikasi login. Jika gagal, pengguna mendapat pesan error.",
      "color": Colors.orangeAccent,
      "icon": Icons.error_outline,
    },
    {
      "step": "3ï¸âƒ£",
      "text": "Jika berhasil, sistem menampilkan HALAMAN UTAMA.",
      "color": Colors.yellowAccent,
      "icon": Icons.home,
    },
    {
      "step": "4ï¸âƒ£",
      "text":
          "Pengguna MEMILIH MODUL PEMBELAJARAN yang ingin dipelajari.",
      "color": Colors.greenAccent,
      "icon": Icons.menu_book,
    },
    {
      "step": "5ï¸âƒ£",
      "text": "Pengguna MEMILIH SUB-MODUL dari modul yang telah dipilih.",
      "color": Colors.lightBlueAccent,
      "icon": Icons.layers,
    },
    {
      "step": "6ï¸âƒ£",
      "text": "Sistem menampilkan PENJELASAN MATERI untuk sub-modul tersebut.",
      "color": Colors.purpleAccent,
      "icon": Icons.menu_book_outlined,
    },
    {
      "step": "7ï¸âƒ£",
      "text": "Pengguna membuat keputusan: MASUK KE LAB VIRTUAL?",
      "color": Colors.pinkAccent,
      "icon": Icons.question_mark,
    },
    {
      "step": "8ï¸âƒ£",
      "text": "Jika Tidak, pengguna kembali ke tampilan penjelasan materi.",
      "color": Colors.tealAccent,
      "icon": Icons.arrow_back,
    },
    {
      "step": "9ï¸âƒ£",
      "text": "Jika Ya, pengguna melanjutkan ke HALAMAN LAB VIRTUAL.",
      "color": Colors.deepOrangeAccent,
      "icon": Icons.science,
    },
    {
      "step": "ðŸ”Ÿ",
      "text":
          "Pengguna MEMILIH PERCOBAAN dan MELAKUKAN INTERAKSI di laboratorium virtual.",
      "color": Colors.indigoAccent,
      "icon": Icons.build_circle,
    },
    {
      "step": "1ï¸âƒ£1ï¸âƒ£",
      "text": "Sistem menampilkan HASIL PERCOBAAN yang telah dilakukan.",
      "color": Colors.lightGreenAccent,
      "icon": Icons.check_circle_outline,
    },
    {
      "step": "1ï¸âƒ£2ï¸âƒ£",
      "text": "Pengguna membuat keputusan akhir: INGIN COBA ULANG?",
      "color": Colors.cyanAccent,
      "icon": Icons.restart_alt,
    },
    {
      "step": "1ï¸âƒ£3ï¸âƒ£",
      "text":
          "Jika Ya, pengguna kembali ke langkah memilih SUB-MODUL untuk mencoba percobaan lain.",
      "color": Colors.amberAccent,
      "icon": Icons.loop,
    },
    {
      "step": "1ï¸âƒ£4ï¸âƒ£",
      "text": "Jika Tidak, alur proses berakhir (END).",
      "color": Colors.pinkAccent,
      "icon": Icons.flag,
    },
  ];

  String get _resolvedUserName => widget.userName ?? 'physicAR Learner';

  void _onItemTapped(int index) {
    if (index == 1) {
      return;
    }

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(userName: _resolvedUserName),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(userName: _resolvedUserName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 1,
      userName: _resolvedUserName,
      onTapNav: _onItemTapped,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Simulasi Penggunaan Aplikasi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF25324A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Alur penggunaan aplikasi PhysicAR dari login hingga eksplorasi lab virtual.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 18),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _steps.length,
            itemBuilder: (context, index) {
              final step = _steps[index];
              final Color stepColor = step['color'] as Color;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      stepColor.withValues(alpha: 0.8),
                      stepColor.withValues(alpha: 0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: stepColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    child: Icon(
                      step['icon'] as IconData,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    "${step['step']} ${step['text']}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
