import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE0FFFF);
const Color textColor = Color(0xFF37474F);

class Module3Screen extends StatelessWidget {
  const Module3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Modul 3: Medan Listrik'),
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
                  Text('- Memahami konsep medan listrik dan arah garis gaya listrik'),
                  Text('- Menghubungkan medan listrik dengan gaya pada muatan uji'),
                  Text('- Memahami hubungan medan listrik dengan energi dan potensial'),
                  Text('- Melakukan pengamatan sederhana terhadap medan listrik'),
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
                    title: '1. Definisi Medan Listrik',
                    content:
                        'Medan listrik adalah daerah di sekitar muatan listrik yang masih dipengaruhi gaya listrik.\n\n'
                        '🔹 Arah garis gaya listrik:\n'
                        '• Keluar dari muatan positif\n'
                        '• Masuk ke muatan negatif\n\n'
                        'Rumus kuat medan listrik:\nE = F / q\n'
                        'Keterangan:\n• E = kuat medan listrik (N/C)\n• F = gaya listrik (N)\n• q = besar muatan uji (C).',
                  ),
                  _buildExpandableTopic(
                    title: '2. Garis Gaya Listrik',
                    content:
                        'Garis imajiner yang menunjukkan arah dan besar medan listrik.\n\n'
                        '🔹 Ciri-ciri:\n'
                        '• Garis keluar dari muatan positif dan masuk ke negatif\n'
                        '• Semakin rapat garis → medan semakin kuat\n'
                        '• Semakin renggang garis → medan semakin lemah\n\n'
                        'Contoh: medan di sekitar muatan tunggal, dipol listrik, atau dua muatan berlawanan.',
                  ),
                  _buildExpandableTopic(
                    title: '3. Medan Listrik dan Hukum Coulomb',
                    content:
                        'Medan listrik berkaitan erat dengan gaya Coulomb.\n\n'
                        'Rumus hubungan antara keduanya:\nF = q × E\n\n'
                        'Artinya, gaya listrik yang dialami sebuah muatan uji berbanding lurus dengan kuat medan listrik di titik tersebut.',
                  ),
                  _buildExpandableTopicWithWidget(
                    title: '4. Ilustrasi Medan Listrik',
                    contentWidget: Column(
                      children: [
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/images/muatan-listrik.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Gambar: Garis gaya listrik di sekitar muatan tunggal',
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
                    title: '5. Percobaan Sederhana Medan Listrik',
                    content:
                        'Gunakan elektroskop atau balon bermuatan untuk mendeteksi arah medan listrik.\n\n'
                        'Langkah-langkah:\n'
                        '1️⃣ Siapkan balon bermuatan dan benda netral.\n'
                        '2️⃣ Dekatkan balon ke benda tersebut.\n'
                        '3️⃣ Amati gaya tarik atau tolak yang terjadi.\n'
                        '4️⃣ Bandingkan hasil pengamatan dengan teori E = F / q.\n\n'
                        '💡 Percobaan ini menunjukkan bahwa medan listrik nyata dapat diamati melalui efek gaya yang ditimbulkannya.',
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
