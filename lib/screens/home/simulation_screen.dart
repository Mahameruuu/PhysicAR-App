import 'package:flutter/material.dart';

class SimulationScreen extends StatelessWidget {
  const SimulationScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _steps = const [
    {"step": "1️⃣", "text": "Pengguna melakukan LOGIN ke sistem.", "color": Colors.redAccent, "icon": Icons.login},
    {"step": "2️⃣", "text": "Sistem memverifikasi login. Jika gagal, pengguna mendapat pesan error.", "color": Colors.orangeAccent, "icon": Icons.error_outline},
    {"step": "3️⃣", "text": "Jika berhasil, sistem menampilkan HALAMAN UTAMA.", "color": Colors.yellowAccent, "icon": Icons.home},
    {"step": "4️⃣", "text": "Pengguna MEMILIH MODUL PEMBELAJARAN yang ingin dipelajari.", "color": Colors.greenAccent, "icon": Icons.menu_book},
    {"step": "5️⃣", "text": "Pengguna MEMILIH SUB-MODUL dari modul yang telah dipilih.", "color": Colors.lightBlueAccent, "icon": Icons.layers},
    {"step": "6️⃣", "text": "Sistem menampilkan PENJELASAN MATERI untuk sub-modul tersebut.", "color": Colors.purpleAccent, "icon": Icons.menu_book_outlined},
    {"step": "7️⃣", "text": "Pengguna membuat keputusan: MASUK KE LAB VIRTUAL?", "color": Colors.pinkAccent, "icon": Icons.question_mark},
    {"step": "8️⃣", "text": "Jika Tidak, pengguna kembali ke tampilan penjelasan materi.", "color": Colors.tealAccent, "icon": Icons.arrow_back},
    {"step": "9️⃣", "text": "Jika Ya, pengguna melanjutkan ke HALAMAN LAB VIRTUAL.", "color": Colors.deepOrangeAccent, "icon": Icons.science},
    {"step": "🔟", "text": "Pengguna MEMILIH PERCOBAAN dan MELAKUKAN INTERAKSI di laboratorium virtual.", "color": Colors.indigoAccent, "icon": Icons.build_circle},
    {"step": "1️⃣1️⃣", "text": "Sistem menampilkan HASIL PERCOBAAN yang telah dilakukan.", "color": Colors.lightGreenAccent, "icon": Icons.check_circle_outline},
    {"step": "1️⃣2️⃣", "text": "Pengguna membuat keputusan akhir: INGIN COBA ULANG?", "color": Colors.cyanAccent, "icon": Icons.restart_alt},
    {"step": "1️⃣3️⃣", "text": "Jika Ya, pengguna kembali ke langkah memilih SUB-MODUL untuk mencoba percobaan lain.", "color": Colors.amberAccent, "icon": Icons.loop},
    {"step": "1️⃣4️⃣", "text": "Jika Tidak, alur proses berakhir (END).", "color": Colors.pinkAccent, "icon": Icons.flag},
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF42A5F5);
    const Color lightBackground = Color(0xFFF0F8FF);

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: const Text('Simulasi Penggunaan Aplikasi'),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _steps.length,
        itemBuilder: (context, index) {
          final step = _steps[index];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [step['color'].withOpacity(0.8), step['color'].withOpacity(0.5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: step['color'].withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              leading: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.3),
                child: Icon(step['icon'], color: Colors.white, size: 28),
              ),
              title: Text(
                "${step['step']} ${step['text']}",
                style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
