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
        title: const Text('Modul 4: Elektroskop dan Fenomena Listrik Statis'),
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
            // Tujuan Modul
            _buildSectionCard(
              title: 'Tujuan Modul',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('- Menjelaskan prinsip kerja elektroskop.'),
                  Text('- Menunjukkan fenomena listrik statis dalam kehidupan sehari-hari.'),
                  Text('- Menjelaskan cara pembuktian adanya muatan listrik dengan elektroskop.'),
                  Text('- Membedakan proses induksi dan konduksi pada elektroskop.'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Materi Pembelajaran
            _buildSectionCard(
              title: 'Materi Pembelajaran',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildExpandableTopic(
                    title: '1. Pengertian Elektroskop',
                    content:
                        'Elektroskop adalah alat untuk mendeteksi ada tidaknya muatan listrik pada suatu benda.\n\n'
                        'Bagian utama elektroskop terdiri dari:\n'
                        '• Kepala logam (biasanya berbentuk bulat)\n'
                        '• Batang logam penghantar\n'
                        '• Dua daun logam tipis di bagian bawah\n\n'
                        'Ketika benda bermuatan didekatkan ke kepala elektroskop, daun logam akan membuka atau menutup sesuai jenis muatannya.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Electroscope_en.svg/512px-Electroscope_en.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '2. Cara Kerja Elektroskop',
                    content:
                        'Ketika benda bermuatan didekatkan pada kepala elektroskop, muatan listrik berpindah atau terinduksi ke daun-daunnya.\n\n'
                        'Jika daun-daun bermuatan sejenis, mereka saling tolak-menolak sehingga membuka. Jika muatan berlawanan, daun menutup.\n\n'
                        'Dengan demikian, besar dan jenis muatan dapat diamati dari derajat keterbukaan daun logam.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Electroscope_operation.svg/512px-Electroscope_operation.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '3. Proses Konduksi dan Induksi',
                    content:
                        '🔹 **Konduksi:**\nTerjadi saat benda bermuatan menyentuh elektroskop, sehingga muatan berpindah langsung ke elektroskop.\n\n'
                        '🔹 **Induksi:**\nTerjadi saat benda bermuatan didekatkan tanpa menyentuh elektroskop, sehingga muatan elektroskop berubah karena gaya tarik atau tolak.\n\n'
                        'Kedua proses ini menyebabkan daun elektroskop membuka karena perubahan distribusi muatan.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Charging_by_induction_and_conduction.svg/512px-Charging_by_induction_and_conduction.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '4. Jenis Elektroskop',
                    content:
                        'Beberapa jenis elektroskop yang sering digunakan:\n\n'
                        '1. Elektroskop Daun Logam (Gold Leaf Electroscope)\n'
                        '   - Menggunakan dua daun tipis dari logam emas.\n'
                        '   - Sangat sensitif terhadap muatan kecil.\n\n'
                        '2. Elektroskop Digital\n'
                        '   - Menggunakan sensor elektronis untuk mengukur besar dan polaritas muatan.\n\n'
                        'Keduanya bekerja berdasarkan prinsip gaya tolak-menolak antar muatan sejenis.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Gold_leaf_electroscope.svg/512px-Gold_leaf_electroscope.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '5. Fenomena Listrik Statis Sehari-hari',
                    content:
                        'Beberapa contoh fenomena listrik statis di kehidupan sehari-hari:\n\n'
                        '• Rambut berdiri setelah digosok dengan sisir plastik.\n'
                        '• Debu tertarik ke layar TV atau monitor.\n'
                        '• Petir di langit terjadi karena beda potensial besar antara awan dan bumi.\n'
                        '• Balon yang digosok kain bisa menempel di dinding.\n\n'
                        'Fenomena ini membuktikan adanya gaya listrik akibat interaksi antar muatan.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Electrostatics_-_hair_standing_up.svg/512px-Electrostatics_-_hair_standing_up.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '6. Percobaan Sederhana Elektroskop',
                    content:
                        'Kamu dapat membuat elektroskop sederhana dari bahan sehari-hari:\n\n'
                        'Bahan:\n• Botol kaca\n• Kawat logam\n• Dua potongan kertas aluminium tipis\n• Tutup gabus\n\n'
                        'Langkah:\n1. Tusukkan kawat ke gabus dan pasang pada mulut botol.\n'
                        '2. Gantung dua potongan aluminium pada ujung bawah kawat.\n'
                        '3. Gosok sisir plastik dan dekatkan ke kepala kawat.\n'
                        '   → Daun logam akan membuka menandakan ada muatan listrik.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Electroscope_experiment.svg/512px-Electroscope_experiment.svg.png',
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
