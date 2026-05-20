import 'package:flutter/material.dart';
import 'package:physic_lab_app/layouts/main_scaffold.dart';
import 'package:physic_lab_app/screens/auth/home_screen.dart';
import 'package:physic_lab_app/screens/home/profile_screen.dart';
import 'package:physic_lab_app/screens/modules/electricity/dynamic/electricity_screen.dart';

import 'static/electricity_screen.dart';

const Color primaryColor = Color(0xFF1D9BF0);
const Color pageBackgroundColor = Color(0xFFF4F8FC);
const Color cardBorderColor = Color(0xFFE2E8F0);
const Color titleColor = Color(0xFF0F172A);
const Color subtitleColor = Color(0xFF64748B);

class ElectricitySelectionScreen extends StatefulWidget {
  final String userName;

  const ElectricitySelectionScreen({
    super.key,
    required this.userName,
  });

  @override
  State<ElectricitySelectionScreen> createState() =>
      _ElectricitySelectionScreenState();
}

class _ElectricitySelectionScreenState
    extends State<ElectricitySelectionScreen> {
  late final List<_ElectricityModuleItem> _modules;

  @override
  void initState() {
    super.initState();
    _modules = [
      _ElectricityModuleItem(
        title: 'Listrik Statis',
        subtitle:
            'Pelajari muatan listrik diam, gaya Coulomb, dan fenomena listrik statis dengan tampilan interaktif.',
        icon: Icons.electric_bolt_rounded,
        color: const Color(0xFFF59E0B),
        badge: 'Interactive',
        destination: ElectricityScreen(userName: widget.userName),
      ),
      _ElectricityModuleItem(
        title: 'Listrik Dinamis',
        subtitle:
            'Pahami arus listrik, rangkaian seri-paralel, dan pengukuran tegangan secara bertahap.',
        icon: Icons.bolt_rounded,
        color: const Color(0xFF2563EB),
        badge: 'Popular',
        destination: DynamicElectricityScreen(userName: widget.userName),
      ),
    ];
  }

  void _handleNavigationTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(userName: widget.userName),
          ),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(userName: widget.userName),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      userName: widget.userName,
      currentIndex: 1,
      onTapNav: _handleNavigationTap,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: pageBackgroundColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroSection(userName: widget.userName),
              const SizedBox(height: 20),
              const Text(
                'Pilih jenis pembelajaran listrik yang ingin kamu pelajari hari ini.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 18),
              ..._modules.map(
                (module) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _ModuleCard(module: module),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ElectricityModuleItem {
  const _ElectricityModuleItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.badge,
    required this.destination,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String badge;
  final Widget destination;
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE0F2FE),
            Color(0xFFF8FBFF),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorderColor),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 360;

          if (compact) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroLabel(),
                SizedBox(height: 14),
                Text(
                  'Materi Listrik',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Belajar konsep listrik dengan tampilan yang lebih rapi, ringan, dan mudah dipahami.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: subtitleColor,
                  ),
                ),
                SizedBox(height: 16),
                _HeroIconBox(),
              ],
            );
          }

          return const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroLabel(),
                    SizedBox(height: 14),
                    Text(
                      'Materi Listrik',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                        height: 1.15,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Belajar konsep listrik dengan tampilan yang lebih rapi, ringan, dan mudah dipahami.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              _HeroIconBox(),
            ],
          );
        },
      ),
    );
  }
}

class _HeroLabel extends StatelessWidget {
  const _HeroLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 16,
            color: primaryColor,
          ),
          SizedBox(width: 8),
          Text(
            'AR Physics',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroIconBox extends StatelessWidget {
  const _HeroIconBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF38BDF8), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2238BDF8),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.bolt_rounded,
        color: Colors.white,
        size: 40,
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.module});

  final _ElectricityModuleItem module;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => module.destination),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: cardBorderColor),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A0F172A),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 340;

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ModuleIcon(color: module.color, icon: module.icon),
                    const SizedBox(height: 14),
                    _ModuleBody(module: module),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ModuleIcon(color: module.color, icon: module.icon),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _ModuleBody(module: module),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ModuleIcon extends StatelessWidget {
  const _ModuleIcon({
    required this.color,
    required this.icon,
  });

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        icon,
        size: 34,
        color: color,
      ),
    );
  }
}

class _ModuleBody extends StatelessWidget {
  const _ModuleBody({required this.module});

  final _ElectricityModuleItem module;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: module.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            module.badge,
            style: TextStyle(
              color: module.color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          module.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: titleColor,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          module.subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: subtitleColor,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Buka materi',
              style: TextStyle(
                color: module.color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: module.color,
            ),
          ],
        ),
      ],
    );
  }
}