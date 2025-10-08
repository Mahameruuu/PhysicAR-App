import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE0FFFF);
const Color textColor = Color(0xFF37474F);

class Module2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Modul 2: Interaksi Muatan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
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
                  Text('- Memahami interaksi antara muatan listrik positif dan negatif'),
                  Text('- Menjelaskan gaya tarik-menarik dan tolak-menolak antar muatan'),
                  Text('- Mengaplikasikan hukum Coulomb pada situasi nyata'),
                  Text('- Melakukan pengamatan dan eksperimen sederhana tentang interaksi muatan'),
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
                    title: '1. Interaksi Antara Muatan',
                    content:
                        'Muatan listrik memiliki dua jenis: positif (+) dan negatif (−).\n\n'
                        '• Muatan sejenis (positif dengan positif, atau negatif dengan negatif) akan saling tolak-menolak.\n'
                        '• Muatan berbeda jenis (positif dengan negatif) akan saling tarik-menarik.\n\n'
                        'Contoh sederhana: dua balon yang digosok dengan kain wol akan menjadi bermuatan sejenis, '
                        'dan jika didekatkan keduanya akan saling menjauh (tolak-menolak).',
                  ),
                  _buildExpandableTopic(
                    title: '2. Hukum Coulomb',
                    content:
                        'Charles Augustin de Coulomb menemukan bahwa besar gaya listrik antara dua muatan '
                        'berbanding lurus dengan hasil kali besar kedua muatan dan berbanding terbalik '
                        'dengan kuadrat jarak antara keduanya.\n\n'
                        '🔹 Rumus:\nF = k × |q₁ × q₂| / r²\n\n'
                        'Keterangan:\n'
                        '• F = gaya listrik (N)\n'
                        '• k = 9 × 10⁹ N·m²/C²\n'
                        '• q₁, q₂ = besar muatan (C)\n'
                        '• r = jarak antar muatan (m)\n\n'
                        '➡️ Gaya ini bisa berupa gaya tarik-menarik (muatan berbeda) atau gaya tolak-menolak (muatan sejenis).',
                  ),
                  _buildExpandableTopic(
                    title: '3. Percobaan Interaksi Muatan',
                    content:
                        'Langkah-langkah percobaan sederhana:\n\n'
                        '1️⃣ Siapkan dua balon karet dan selembar kain wol.\n'
                        '2️⃣ Gosok kedua balon pada kain wol selama beberapa detik.\n'
                        '3️⃣ Gantung kedua balon berdekatan dan amati hasilnya.\n'
                        '4️⃣ Catat apakah terjadi gaya tarik atau tolak, lalu hubungkan dengan hukum Coulomb.\n\n'
                        '💡 Gaya interaksi bergantung pada jarak antar balon dan besarnya muatan yang terkumpul.',
                  ),
                  _buildExpandableTopicWithWidget(
                    title: '4. Arah Gaya Listrik dan Ilustrasi',
                    contentWidget: Column(
                      children: [
                        const Text(
                          'Arah gaya listrik tergantung pada jenis muatan:\n\n'
                          '• Dua muatan positif → saling menjauh\n'
                          '• Dua muatan negatif → saling menjauh\n'
                          '• Muatan positif dan negatif → saling mendekat\n\n'
                          'Ilustrasi di bawah menunjukkan perbedaan interaksi muatan:',
                          style: TextStyle(fontSize: 15, height: 1.5, color: textColor),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/images/ilustrasi-listrik-statis.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  _buildExpandableTopic(
                    title: '5. Aplikasi dalam Kehidupan Sehari-hari',
                    content:
                        'Fenomena interaksi muatan dapat ditemukan di kehidupan sehari-hari:\n\n'
                        '• Rambut berdiri setelah menyisir rambut kering\n'
                        '• Balon menempel di dinding setelah digosok\n'
                        '• Debu menempel pada layar televisi\n'
                        '• Mesin fotokopi dan printer laser memanfaatkan prinsip gaya listrik untuk menarik toner ke kertas.',
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
            children: [
              contentWidget,
            ],
          ),
        ),
      ),
    );
  }
}
