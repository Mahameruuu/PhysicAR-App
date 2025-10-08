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
        title: const Text('Modul 1: Konduktor, Isolator, dan Semikonduktor'),
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
            // Tujuan Modul
            _buildSectionCard(
              title: 'Tujuan Modul',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('- Mengenal jenis-jenis bahan listrik: konduktor, isolator, dan semikonduktor'),
                  Text('- Memahami sifat kelistrikan dari masing-masing bahan'),
                  Text('- Menjelaskan penerapan bahan-bahan tersebut dalam kehidupan sehari-hari'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Materi
            _buildSectionCard(
              title: 'Materi Pembelajaran',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildExpandableTopic(
                    title: '1. Pengantar Listrik Dinamis',
                    content:
                        'Listrik dinamis adalah listrik yang dapat mengalir melalui penghantar. '
                        'Pemahaman dasar tentang bahan penghantar listrik sangat penting agar kita tahu bagaimana arus listrik dapat bergerak dari satu titik ke titik lainnya. '
                        'Bahan-bahan ini dibedakan berdasarkan kemampuan mereka menghantarkan elektron.',
                  ),
                  _buildExpandableTopic(
                    title: '2. Konduktor',
                    content:
                        'Konduktor adalah bahan yang mudah menghantarkan listrik. '
                        'Elektron-elektron pada konduktor bergerak bebas sehingga arus listrik mudah mengalir. '
                        'Contoh bahan konduktor: tembaga, aluminium, perak, dan besi.\n\n'
                        '🔹 Ciri-ciri konduktor:\n'
                        '• Hambatan listrik rendah\n'
                        '• Elektron mudah bergerak\n'
                        '• Banyak digunakan dalam kabel dan rangkaian listrik',
                  ),
                  _buildExpandableTopic(
                    title: '3. Isolator',
                    content:
                        'Isolator adalah bahan yang tidak dapat menghantarkan listrik dengan baik. '
                        'Pada isolator, elektron terikat kuat pada atomnya sehingga tidak mudah bergerak. '
                        'Contoh bahan isolator: plastik, karet, kaca, dan kayu kering.\n\n'
                        '🔹 Ciri-ciri isolator:\n'
                        '• Hambatan listrik sangat tinggi\n'
                        '• Elektron tidak bebas bergerak\n'
                        '• Digunakan sebagai pelindung kabel agar aman dari sengatan listrik',
                  ),
                  _buildExpandableTopic(
                    title: '4. Semikonduktor',
                    content:
                        'Semikonduktor memiliki sifat di antara konduktor dan isolator. '
                        'Mereka dapat menghantarkan listrik hanya dalam kondisi tertentu, seperti saat dipanaskan atau diberi tegangan tertentu. '
                        'Contoh bahan semikonduktor: silikon (Si) dan germanium (Ge).\n\n'
                        '🔹 Ciri-ciri semikonduktor:\n'
                        '• Konduktivitas meningkat dengan suhu\n'
                        '• Dapat berfungsi sebagai pengatur arus listrik\n'
                        '• Digunakan dalam komponen elektronik seperti dioda dan transistor',
                  ),
                  _buildExpandableTopic(
                    title: '5. Penerapan dalam Kehidupan Sehari-hari',
                    content:
                        '• Kabel listrik terbuat dari tembaga (konduktor) dan dilapisi plastik (isolator)\n'
                        '• Komputer dan ponsel menggunakan semikonduktor untuk mengatur aliran listrik\n'
                        '• Peralatan rumah tangga dirancang dengan kombinasi bahan konduktor dan isolator untuk keamanan',
                  ),
                  _buildExpandableTopic(
                    title: '6. Refleksi dan Kesimpulan',
                    content:
                        'Setiap bahan memiliki peran penting dalam sistem kelistrikan. '
                        'Konduktor menghantarkan arus, isolator melindungi dari bahaya, dan semikonduktor mengontrol aliran arus listrik. '
                        'Pemahaman ini menjadi dasar untuk mempelajari arus listrik, hukum Ohm, dan rangkaian listrik di modul berikutnya.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Card utama dengan radius besar dan shadow lembut ---
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

  // --- Expandable card dengan radius besar & efek lembut ---
  Widget _buildExpandableTopic({required String title, required String content}) {
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
