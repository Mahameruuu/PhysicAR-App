import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE0FFFF);
const Color textColor = Color(0xFF37474F);

class Module4Screen extends StatelessWidget {
  const Module4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Modul 4: Beda Potensial & Energi Listrik'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        elevation: 6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            // --- Tujuan Modul ---
            _buildSectionCard(
              title: '🎯 Tujuan Modul',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('- Memahami konsep beda potensial listrik'),
                  Text('- Menjelaskan energi potensial listrik dan hubungannya dengan medan listrik'),
                  Text('- Mengetahui contoh fenomena sehari-hari seperti petir dan percikan listrik'),
                  Text('- Melakukan percobaan sederhana energi potensial listrik'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- Materi Pembelajaran ---
            _buildSectionCard(
              title: '📘 Materi Pembelajaran',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildExpandableTopic(
                    title: '1. Beda Potensial Listrik',
                    content:
                        'Beda potensial listrik (V) adalah energi yang diperlukan untuk memindahkan satu satuan muatan '
                        'dari satu titik ke titik lain dalam medan listrik.\n\n'
                        '🔹 Rumus:\nV = W / q\n'
                        'di mana:\n• W = usaha yang dilakukan (Joule)\n• q = muatan uji (Coulomb)\n\n'
                        'Contoh: saat terjadi petir, beda potensial besar antara awan dan tanah menyebabkan arus listrik mengalir.',
                  ),
                  _buildExpandableTopic(
                    title: '2. Energi Potensial Listrik',
                    content:
                        'Energi potensial listrik (U) adalah energi yang dimiliki muatan karena posisinya dalam medan listrik.\n\n'
                        '🔹 Rumus:\nU = k * q1 * q2 / r\n'
                        'Keterangan:\n• q1, q2 = muatan (C)\n• r = jarak antar muatan (m)\n• k = konstanta Coulomb (9 × 10⁹ N·m²/C²)\n\n'
                        'Energi ini menjelaskan gaya tarik-menarik dan tolak-menolak antar muatan serta fenomena listrik statis.',
                  ),
                  _buildExpandableTopic(
                    title: '3. Hubungan Medan dan Potensial Listrik',
                    content:
                        'Medan listrik (E) dan beda potensial (V) saling berhubungan melalui rumus:\n\n'
                        'E = -dV/dr\n\n'
                        'Artinya, medan listrik menunjukkan arah perubahan potensial listrik — muatan positif bergerak dari potensial tinggi ke rendah.',
                  ),
                  _buildExpandableTopicWithWidget(
                    title: '4. Ilustrasi Beda Potensial',
                    contentWidget: Column(
                      children: [
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/images/beda-potensial.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Gambar: Perbedaan potensial listrik dan aliran arus',
                          style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  _buildExpandableTopic(
                    title: '5. Fenomena Sehari-hari',
                    content:
                        '🔹 Petir antara awan dan tanah\n'
                        '🔹 Percikan listrik saat menyentuh benda logam\n'
                        '🔹 Kapasitor dalam rangkaian elektronik\n'
                        '🔹 Balon menempel di dinding setelah digosok\n\n'
                        'Semua fenomena ini melibatkan beda potensial dan perpindahan muatan listrik.',
                  ),
                  _buildExpandableTopic(
                    title: '6. Percobaan Sederhana',
                    content:
                        '🧪 Gunakan elektroskop atau balon untuk mengamati beda potensial.\n\n'
                        'Langkah-langkah:\n'
                        '1️⃣ Siapkan dua benda bermuatan berbeda.\n'
                        '2️⃣ Ukur atau perkirakan jarak antar benda.\n'
                        '3️⃣ Amati interaksi gaya dan energi potensial yang timbul.\n'
                        '4️⃣ Bandingkan dengan perhitungan berdasarkan rumus V = W / q.\n\n'
                        '💡 Percobaan ini membantu memahami hubungan energi potensial dan beda potensial listrik.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Card utama dengan gradient lembut & radius besar ---
  static Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF81D4FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 5),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  // --- Expandable Topic standar ---
  static Widget _buildExpandableTopic({
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Card(
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: ExpansionTile(
            collapsedBackgroundColor: Colors.white,
            backgroundColor: Colors.white,
            collapsedIconColor: primaryColor,
            iconColor: primaryColor,
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor,
              ),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 15, height: 1.5, color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Versi dengan widget custom (misalnya gambar ilustrasi) ---
  static Widget _buildExpandableTopicWithWidget({
    required String title,
    required Widget contentWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Card(
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: ExpansionTile(
            collapsedBackgroundColor: Colors.white,
            backgroundColor: Colors.white,
            collapsedIconColor: primaryColor,
            iconColor: primaryColor,
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor,
              ),
            ),
            children: [contentWidget],
          ),
        ),
      ),
    );
  }
}
