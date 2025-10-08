import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE0FFFF);
const Color textColor = Color(0xFF37474F);

class Module1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Modul 1: Listrik Statis'),
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
                  Text('- Memahami konsep dasar listrik statis dan muatan listrik'),
                  Text('- Menjelaskan hukum Coulomb dan penerapannya'),
                  Text('- Menjelaskan konsep medan listrik dan potensial listrik'),
                  Text('- Menghubungkan fenomena listrik statis dengan kehidupan sehari-hari'),
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
                    title: '1. Muatan Listrik',
                    content:
                        'Semua benda tersusun atas atom yang memiliki proton (positif), neutron (netral), dan elektron (negatif). '
                        'Perpindahan elektron dari satu benda ke benda lain menyebabkan benda bermuatan listrik.\n\n'
                        '➡️ Jika benda kehilangan elektron → bermuatan positif.\n'
                        '➡️ Jika benda menerima elektron → bermuatan negatif.',
                  ),
                  _buildExpandableTopic(
                    title: '2. Hukum Coulomb',
                    content:
                        'Hukum Coulomb menjelaskan besar gaya tarik-menarik atau tolak-menolak antara dua muatan listrik:\n\n'
                        '🔹 Rumus: F = k × |q₁ × q₂| / r²\n\n'
                        'Keterangan:\n'
                        '• F = gaya listrik (N)\n'
                        '• k = 9 × 10⁹ N·m²/C²\n'
                        '• q₁, q₂ = besar muatan (C)\n'
                        '• r = jarak antar muatan (m)\n\n'
                        '➡️ Muatan sejenis saling tolak-menolak\n➡️ Muatan berbeda jenis saling tarik-menarik.',
                  ),
                  _buildExpandableTopic(
                    title: '3. Medan Listrik',
                    content:
                        'Medan listrik adalah daerah di sekitar muatan yang masih dipengaruhi gaya listrik.\n\n'
                        '🔹 Rumus: E = F / q₀\n\n'
                        '• Garis gaya keluar dari muatan positif dan menuju ke muatan negatif.\n'
                        '• Semakin rapat garis gaya, semakin besar kuat medan listriknya.',
                  ),
                  _buildExpandableTopic(
                    title: '4. Beda Potensial (Tegangan)',
                    content:
                        'Beda potensial adalah energi yang diperlukan untuk memindahkan muatan dari satu titik ke titik lain.\n\n'
                        '🔹 Rumus: V = W / q\n\n'
                        'Contoh fenomena alami: petir. Awan dan tanah memiliki perbedaan potensial besar yang menimbulkan aliran listrik (kilatan petir).',
                  ),
                  _buildExpandableTopic(
                    title: '5. Fenomena Listrik Statis Sehari-hari',
                    content:
                        '• Rambut berdiri saat disisir\n'
                        '• Debu menempel pada layar televisi\n'
                        '• Petir di langit\n\n'
                        'Semua contoh ini menunjukkan adanya interaksi antara muatan listrik yang tidak bergerak (statis).',
                  ),
                  _buildExpandableTopic(
                    title: '6. Refleksi dan Kesimpulan',
                    content:
                        'Listrik statis menunjukkan bagaimana muatan dapat berpindah dan saling memengaruhi meski tanpa aliran arus. '
                        'Pemahaman ini menjadi dasar untuk mempelajari listrik dinamis dan hukum Ohm pada modul berikutnya.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Card utama dengan gradient lembut ---
  Widget _buildSectionCard({required String title, required Widget child}) {
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

  // --- Expandable Topic dengan radius besar dan padding halus ---
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
}
