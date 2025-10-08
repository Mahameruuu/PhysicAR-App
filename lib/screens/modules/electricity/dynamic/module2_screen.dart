import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE0FFFF);
const Color textColor = Color(0xFF37474F);

class Module2Screen extends StatelessWidget {
  const Module2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Modul 2: Listrik Dinamis'),
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
                  Text('- Memahami konsep arus listrik dan hambatan listrik'),
                  Text('- Menjelaskan hukum Ohm dan hukum Kirchoff'),
                  Text('- Menganalisis rangkaian listrik seri dan paralel'),
                  Text('- Mengetahui sumber dan penggunaan energi listrik'),
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
                    title: '1. Hambatan Listrik',
                    content:
                        'Hambatan listrik adalah komponen yang menghambat aliran arus listrik dalam suatu rangkaian.\n\n'
                        'Faktor yang memengaruhi hambatan antara lain jenis bahan resistor, panjang penghantar, luas penampang, dan suhu.\n\n'
                        '🔹 Rumus dasar hambatan:\n'
                        'R = ρ × (L / A)\n\n'
                        'Keterangan:\n'
                        '• R = Hambatan (Ohm)\n'
                        '• ρ = Jenis resistivitas bahan\n'
                        '• L = Panjang penghantar (meter)\n'
                        '• A = Luas penampang penghantar (m²)\n\n'
                        'Semakin panjang penghantar, hambatan bertambah besar; semakin luas penampang, hambatan semakin kecil.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Resistor_symbol.svg/640px-Resistor_symbol.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '2. Arus Listrik',
                    content:
                        'Arus listrik adalah aliran muatan listrik (biasanya elektron) melalui penghantar karena adanya beda potensial (tegangan).\n\n'
                        '🔹 Arus bergerak dari potensial tinggi ke rendah.\n'
                        '🔹 Elektron sebenarnya bergerak dari potensial rendah ke tinggi.\n\n'
                        'Jenis sumber arus listrik:\n'
                        '• Arus Searah (DC): mengalir dalam satu arah tetap, contohnya baterai dan aki.\n'
                        '• Arus Bolak-balik (AC): arah arus berubah secara periodik, contohnya listrik dari PLN atau generator.\n\n'
                        'Hukum Ohm menjelaskan hubungan antara arus, tegangan, dan hambatan:\n'
                        'I = V / R\n\n'
                        'Artinya arus (I) berbanding lurus dengan tegangan (V) dan berbanding terbalik dengan hambatan (R).',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Ohm%27s_Law_with_units.svg/512px-Ohm%27s_Law_with_units.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '3. Hukum Kirchoff',
                    content:
                        'Hukum Kirchoff menjelaskan bahwa jumlah arus listrik yang masuk ke suatu titik cabang sama dengan jumlah arus yang keluar.\n\n'
                        '🔹 Secara matematis:\n'
                        'Σ I_masuk = Σ I_keluar\n\n'
                        'Artinya, tidak ada arus listrik yang hilang — arus terdistribusi sesuai percabangan dalam rangkaian.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Kirchhoff_current_law.svg/512px-Kirchhoff_current_law.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '4. Rangkaian Listrik',
                    content:
                        'Rangkaian listrik adalah susunan beberapa komponen listrik yang dihubungkan sehingga arus dapat mengalir.\n\n'
                        '🔸 Rangkaian Seri:\n'
                        '• Tegangan total: V = V₁ + V₂ + ...\n'
                        '• Arus sama: I₁ = I₂ = ... = I\n'
                        '• Hambatan pengganti: R = R₁ + R₂ + ...\n\n'
                        '🔸 Rangkaian Paralel:\n'
                        '• Tegangan sama: V₁ = V₂ = ... = V\n'
                        '• Arus total: I = I₁ + I₂ + ...\n'
                        '• Hambatan pengganti: 1/Rp = 1/R₁ + 1/R₂ + ...\n\n'
                        'Dalam kehidupan sehari-hari, rangkaian paralel banyak digunakan, misalnya pada instalasi listrik rumah agar setiap lampu tetap menyala meskipun satu lampu padam.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/Series_and_parallel_circuits.svg/640px-Series_and_parallel_circuits.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '5. Sumber Energi Listrik',
                    content:
                        'Sumber energi listrik dapat berasal dari:\n\n'
                        '1) Elemen listrik seperti elemen Volta, baterai, dan aki.\n'
                        '2) Sumber energi alternatif:\n'
                        '   • Pembangkit Listrik Tenaga Angin (PLTB)\n'
                        '   • Pembangkit Listrik Tenaga Air (PLTA)\n'
                        '   • Pembangkit Listrik Tenaga Surya (PLTS)\n'
                        '   • Pembangkit Listrik Tenaga Sampah (PLTSa)\n\n'
                        'Sumber energi ini mengubah energi mekanik, cahaya, atau kimia menjadi energi listrik yang dapat dimanfaatkan.',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Power_station.svg/512px-Power_station.svg.png',
                  ),
                  _buildExpandableTopic(
                    title: '6. Penggunaan Energi Listrik',
                    content:
                        'Energi listrik digunakan dalam berbagai perangkat rumah tangga dan industri.\n\n'
                        'Biaya listrik dihitung berdasarkan energi yang digunakan per kilowatt-jam (kWh).\n\n'
                        '🔹 Rumus energi listrik:\n'
                        'W = P × t\n\n'
                        'Keterangan:\n'
                        '• W = Energi listrik (Joule)\n'
                        '• P = Daya listrik (Watt)\n'
                        '• t = Waktu pemakaian (detik)\n\n'
                        'Total biaya listrik bulanan diperoleh dari:\n'
                        'Biaya = Energi (kWh) × Tarif dasar listrik (Rp/kWh)',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Electric_power_consumption_meter_001.JPG/640px-Electric_power_consumption_meter_001.JPG',
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
