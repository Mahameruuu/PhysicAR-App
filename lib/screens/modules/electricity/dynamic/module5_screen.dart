import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE0FFFF);
const Color textColor = Color(0xFF37474F);

class Module5Screen extends StatelessWidget {
  const Module5Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Modul 5: Penerapan Listrik Statis'),
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
            _buildSectionCard(
              title: 'Tujuan Modul',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('- Menjelaskan penerapan konsep listrik statis di kehidupan sehari-hari.'),
                  Text('- Mengidentifikasi alat dan fenomena yang memanfaatkan listrik statis.'),
                  Text('- Menumbuhkan rasa ingin tahu terhadap aplikasi konsep fisika di sekitar.'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionCard(
              title: 'Materi Pembelajaran',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildExpandableTopic(
                    title: '1. Penerapan Listrik Statis pada Mesin Fotokopi',
                    content:
                        'Mesin fotokopi bekerja berdasarkan prinsip listrik statis.\n\n'
                        'Drum fotokonduktor diisi muatan listrik, lalu cahaya pantulan dari dokumen menyebabkan sebagian muatan hilang sesuai pola gambar. '
                        'Toner bermuatan menempel pada bagian yang bermuatan berlawanan, dan kemudian dipindahkan ke kertas serta dipanaskan untuk menempel permanen.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Photocopier_principle.svg/512px-Photocopier_principle.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '2. Penerapan pada Cat Semprot (Spray Painting)',
                    content:
                        'Dalam proses pengecatan mobil atau logam, digunakan prinsip listrik statis untuk efisiensi.\n\n'
                        'Butiran cat diberi muatan listrik, sedangkan benda yang dicat diberi muatan berlawanan. '
                        'Akibatnya, butiran cat tertarik merata ke seluruh permukaan dan mengurangi pemborosan cat.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Electrostatic_painting_principle.svg/512px-Electrostatic_painting_principle.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '3. Penerapan pada Alat Pengendap Elektrostatik',
                    content:
                        'Alat ini digunakan di pabrik dan pembangkit listrik untuk mengurangi polusi udara.\n\n'
                        'Partikel debu bermuatan listrik statis dan ditarik ke pelat logam bermuatan berlawanan. '
                        'Debu menempel dan kemudian dikumpulkan sehingga udara yang keluar lebih bersih.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Electrostatic_precipitator.svg/512px-Electrostatic_precipitator.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '4. Penerapan pada Mesin Penangkal Petir',
                    content:
                        'Petir terjadi karena perbedaan potensial besar antara awan dan bumi.\n\n'
                        'Penangkal petir bekerja dengan mengalirkan muatan listrik dari awan ke tanah secara aman melalui konduktor logam, '
                        'sehingga bangunan tidak rusak akibat sambaran langsung.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Lightning_rod_diagram.svg/512px-Lightning_rod_diagram.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '5. Penerapan pada Alat Pemisah Debu (Smoke Precipitator)',
                    content:
                        'Pada alat pemisah asap, partikel asap bermuatan negatif diarahkan melalui medan listrik menuju pelat bermuatan positif.\n\n'
                        'Partikel menempel dan tidak ikut keluar bersama gas buangan. Teknologi ini digunakan di industri semen dan baja.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Smoke_precipitator_diagram.svg/512px-Smoke_precipitator_diagram.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '6. Contoh Lain dalam Kehidupan Sehari-hari',
                    content:
                        'Selain penerapan di industri, listrik statis juga dapat ditemukan di sekitar kita:\n\n'
                        '• Rambut berdiri setelah disisir.\n'
                        '• Balon menempel di dinding.\n'
                        '• Pakaian menempel setelah dikeringkan.\n'
                        '• Serbuk debu tertarik ke layar TV.\n\n'
                        'Semua fenomena ini melibatkan interaksi antara muatan positif dan negatif akibat gesekan atau induksi.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Electrostatics_-_hair_standing_up.svg/512px-Electrostatics_-_hair_standing_up.svg.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Section Card ---
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  // --- Expandable Topic ---
  Widget _buildExpandableTopic({
    required String title,
    String? content,
    String? imageUrl,
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
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            children: [
              if (imageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  content ?? '',
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
