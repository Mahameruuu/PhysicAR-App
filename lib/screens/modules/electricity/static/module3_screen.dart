import 'dart:ui';

import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE0FFFF);
const Color textColor = Color(0xFF37474F);
const Color secondaryTextColor = Color(0xFF607086);

class Module3Screen extends StatelessWidget {
  const Module3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          const _ModuleBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, 'Modul 3: Medan Listrik'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildSectionCard(
                          title: 'Tujuan Modul',
                          icon: Icons.track_changes_rounded,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              _BulletText('Memahami konsep medan listrik dan arah garis gaya listrik'),
                              _BulletText('Menghubungkan medan listrik dengan gaya pada muatan uji'),
                              _BulletText('Memahami hubungan medan listrik dengan energi dan potensial'),
                              _BulletText('Melakukan pengamatan sederhana terhadap medan listrik'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        _buildSectionCard(
                          title: 'Materi Pembelajaran',
                          icon: Icons.menu_book_rounded,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildExpandableTopic(
                                title: '1. Definisi Medan Listrik',
                                content:
                                    'Medan listrik adalah daerah di sekitar muatan listrik yang masih dipengaruhi gaya listrik.\n\n'
                                    'Arah garis gaya listrik keluar dari muatan positif dan masuk ke muatan negatif.\n\n'
                                    'Rumus kuat medan listrik:\nE = F / q\n'
                                    'Keterangan:\nE = kuat medan listrik (N/C)\nF = gaya listrik (N)\nq = besar muatan uji (C).',
                              ),
                              _buildExpandableTopic(
                                title: '2. Garis Gaya Listrik',
                                content:
                                    'Garis imajiner ini menunjukkan arah dan besar medan listrik.\n\n'
                                    'Semakin rapat garis, medan semakin kuat.\n'
                                    'Semakin renggang garis, medan semakin lemah.\n\n'
                                    'Contohnya dapat dilihat pada medan di sekitar muatan tunggal, dipol listrik, atau dua muatan berlawanan.',
                              ),
                              _buildExpandableTopic(
                                title: '3. Medan Listrik dan Hukum Coulomb',
                                content:
                                    'Medan listrik berkaitan erat dengan gaya Coulomb.\n\n'
                                    'Rumus hubungan antara keduanya:\nF = q x E\n\n'
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
                                        color: secondaryTextColor,
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
                                    '1. Siapkan balon bermuatan dan benda netral.\n'
                                    '2. Dekatkan balon ke benda tersebut.\n'
                                    '3. Amati gaya tarik atau tolak yang terjadi.\n'
                                    '4. Bandingkan hasil pengamatan dengan teori E = F / q.\n\n'
                                    'Percobaan ini menunjukkan bahwa medan listrik nyata dapat diamati melalui efek gaya yang ditimbulkannya.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF53C8F8), Color(0xFF3B82F6)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x284DA8FF),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(18),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.84),
                Colors.white.withValues(alpha: 0.62),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x140F172A),
                offset: Offset(0, 10),
                blurRadius: 22,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildExpandableTopic({
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x120F172A),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: ExpansionTile(
            collapsedBackgroundColor: Colors.white,
            backgroundColor: Colors.white,
            collapsedIconColor: primaryColor,
            iconColor: primaryColor,
            tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: textColor,
              ),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildExpandableTopicWithWidget({
    required String title,
    required Widget contentWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x120F172A),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: ExpansionTile(
            collapsedBackgroundColor: Colors.white,
            backgroundColor: Colors.white,
            collapsedIconColor: primaryColor,
            iconColor: primaryColor,
            tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
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

class _ModuleBackground extends StatelessWidget {
  const _ModuleBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF7FCFF), Color(0xFFE6F5FF), Color(0xFFDDF2FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: const [
          _BackgroundOrb(alignment: Alignment(-1.0, -0.9), size: 180, color: Color(0x3353C8F8)),
          _BackgroundOrb(alignment: Alignment(1.0, -0.1), size: 220, color: Color(0x224DA8FF)),
          _BackgroundOrb(alignment: Alignment(-0.8, 0.95), size: 190, color: Color(0x2080DEEA)),
        ],
      ),
    );
  }
}

class _BackgroundOrb extends StatelessWidget {
  const _BackgroundOrb({
    required this.alignment,
    required this.size,
    required this.color,
  });

  final Alignment alignment;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class _BulletText extends StatelessWidget {
  const _BulletText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 7),
            decoration: const BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.55,
                color: secondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
