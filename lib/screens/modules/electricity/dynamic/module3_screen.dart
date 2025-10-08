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
                  Text('- Memahami konsep medan listrik.'),
                  Text('- Menjelaskan arah dan garis gaya medan listrik.'),
                  Text('- Menentukan kuat medan listrik dari satu dan beberapa muatan.'),
                  Text('- Menghubungkan konsep potensial listrik dengan energi listrik.'),
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
                    title: '1. Pengertian Medan Listrik',
                    content:
                        'Medan listrik adalah daerah di sekitar muatan listrik di mana muatan lain mengalami gaya listrik.\n\n'
                        '🔹 Setiap muatan listrik menghasilkan medan listrik.\n'
                        '🔹 Medan listrik digambarkan dengan garis-garis gaya yang menunjukkan arah dan kekuatan medan.\n\n'
                        'Arah garis gaya keluar dari muatan positif dan masuk ke muatan negatif.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Electric_Field_Lines_Positive_Charge.svg/512px-Electric_Field_Lines_Positive_Charge.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '2. Kuat Medan Listrik (E)',
                    content:
                        'Kuat medan listrik menyatakan besar gaya listrik yang bekerja pada muatan uji positif di titik tertentu.\n\n'
                        '🔹 Rumus:\nE = F / q\natau\nE = k × (Q / r²)\n\n'
                        'Keterangan:\n• E = kuat medan listrik (N/C)\n• F = gaya listrik (N)\n• q = muatan uji (C)\n• Q = muatan sumber (C)\n• r = jarak antar muatan (m)\n\n'
                        'Semakin dekat ke muatan sumber, medan listrik semakin kuat.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/Electric_Field_1_Charge.svg/512px-Electric_Field_1_Charge.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '3. Garis Gaya Medan Listrik',
                    content:
                        'Garis gaya listrik menggambarkan arah medan listrik dan interaksi antara muatan.\n\n'
                        'Ciri-ciri garis gaya:\n• Garis tidak pernah berpotongan.\n• Keluar dari muatan positif dan masuk ke muatan negatif.\n• Kerapatan garis menunjukkan besar kuat medan listrik.\n\n'
                        'Jika dua muatan sejenis, garis saling menolak; jika berbeda jenis, garis saling menarik.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Electric_field_due_to_two_opposite_charges.svg/512px-Electric_field_due_to_two_opposite_charges.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '4. Medan Listrik oleh Beberapa Muatan',
                    content:
                        'Jika ada lebih dari satu muatan, kuat medan total di suatu titik adalah jumlah vektor dari medan tiap muatan.\n\n'
                        '🔹 Secara matematis:\nE_total = E₁ + E₂ + E₃ + ...\n\n'
                        'Arah dan besar resultan medan listrik ditentukan dengan prinsip superposisi.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Electric_field_due_to_two_equal_charges.svg/512px-Electric_field_due_to_two_equal_charges.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '5. Potensial Listrik',
                    content:
                        'Potensial listrik menunjukkan energi listrik yang dimiliki muatan di suatu titik akibat adanya medan listrik.\n\n'
                        '🔹 Rumus:\nV = k × (Q / r)\n\n'
                        'Keterangan:\n• V = potensial listrik (Volt)\n• Q = muatan sumber (C)\n• r = jarak dari sumber (m)\n\n'
                        'Perbedaan potensial antara dua titik menyebabkan arus listrik mengalir.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Electric_potential_field.svg/512px-Electric_potential_field.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '6. Energi Potensial Listrik',
                    content:
                        'Energi potensial listrik adalah energi yang dimiliki suatu muatan karena posisinya dalam medan listrik.\n\n'
                        '🔹 Rumus:\nU = q × V\n\n'
                        'Keterangan:\n• U = energi potensial (Joule)\n• q = muatan (C)\n• V = potensial listrik (Volt)\n\n'
                        'Energi ini dapat berubah menjadi energi kinetik saat muatan bergerak.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Electric_field_and_potential.svg/512px-Electric_field_and_potential.svg.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Section Card dengan efek lembut ---
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

  // --- Expandable Topic dengan radius & gambar opsional ---
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
