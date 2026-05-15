import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:physic_lab_app/screens/auth/home_screen.dart';
import 'package:physic_lab_app/screens/auth/login_screen.dart';
import 'package:physic_lab_app/screens/home/profile_screen.dart';
import 'package:physic_lab_app/screens/modules/electricity/dynamic/electricity_screen.dart';
import 'package:physic_lab_app/services/auth_service.dart';

import 'static/electricity_screen.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFF3FAFF);
const Color textColor = Color(0xFF37474F);
const Color secondaryTextColor = Color(0xFF64748B);

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
  int _selectedIndex = 1;

  late final List<_ElectricityModuleItem> _modules;

  @override
  void initState() {
    super.initState();
    _modules = [
      _ElectricityModuleItem(
        title: 'Listrik Statis',
        subtitle:
            'Pelajari muatan listrik yang diam, gaya Coulomb, dan fenomena listrik statis.',
        icon: Icons.electric_bolt_rounded,
        color: const Color(0xFFFFB648),
        badge: 'Interactive',
        destination: ElectricityScreen(userName: widget.userName),
      ),
      _ElectricityModuleItem(
        title: 'Listrik Dinamis',
        subtitle:
            'Pahami arus listrik, rangkaian seri & paralel, serta pengukuran tegangan.',
        icon: Icons.bolt_rounded,
        color: const Color(0xFF41A5FF),
        badge: 'Popular',
        destination: DynamicElectricityScreen(userName: widget.userName),
      ),
    ];
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

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
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          const _ElectricityBackground(),
          SafeArea(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 850),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 28 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24),
                    _buildHeroPanel(),
                    const SizedBox(height: 22),
                    _buildSectionHeader(),
                    const SizedBox(height: 16),
                    ..._modules.map(
                      (module) => Padding(
                        padding: EdgeInsets.only(
                          bottom: module == _modules.last ? 0 : 18,
                        ),
                        child: _buildSelectionButton(context, module),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final initials = getInitials(widget.userName);

    return Row(
      children: [
        _GlassIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(userName: widget.userName),
              ),
            );
          },
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello, explorer',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7A90),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Logout') {
              _showLogoutDialog(context);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'Setting', child: Text('Setting')),
            PopupMenuItem(value: 'Logout', child: Text('Logout')),
          ],
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xFF76D7FF), Color(0xFF4DA8FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x334FC3F7),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroPanel() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.82),
                Colors.white.withValues(alpha: 0.58),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.65),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A0F172A),
                blurRadius: 24,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoTag(
                      label: 'AR Physics',
                      icon: Icons.auto_awesome_rounded,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Materi Listrik',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        height: 1.15,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Eksplorasi konsep listrik dengan simulasi yang lebih visual, interaktif, dan mudah dipahami.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Color(0xFF607086),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF63D6FF), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x334DA8FF),
                      blurRadius: 18,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih jenis pembelajaran listrik yang ingin kamu eksplorasi hari ini.',
          style: TextStyle(
            fontSize: 14,
            color: secondaryTextColor,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionButton(
    BuildContext context,
    _ElectricityModuleItem module,
  ) {
    return _SelectionCard(
      title: module.title,
      subtitle: module.subtitle,
      icon: module.icon,
      color: module.color,
      badge: module.badge,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => module.destination),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            active: _selectedIndex == 0,
            onTap: () => _onItemTapped(0),
          ),
          _NavItem(
            icon: Icons.play_circle_outline_rounded,
            label: 'Simulation',
            active: _selectedIndex == 1,
            onTap: () => _onItemTapped(1),
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            active: _selectedIndex == 2,
            onTap: () => _onItemTapped(2),
          ),
        ],
      ),
    );
  }

  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await AuthService.instance.logout();
              if (!context.mounted) {
                return;
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  String getInitials(String name) {
    final parts = name.trim().split(' ').where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) {
      return '?';
    }
    return parts.map((item) => item[0]).take(2).join().toUpperCase();
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

class _ElectricityBackground extends StatelessWidget {
  const _ElectricityBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF6FDFF),
            Color(0xFFE7F7FF),
            Color(0xFFDDF4FF),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: const [
          _BackgroundOrb(
            alignment: Alignment(-1.05, -0.95),
            size: 180,
            color: Color(0x554FC3F7),
          ),
          _BackgroundOrb(
            alignment: Alignment(1.1, -0.2),
            size: 220,
            color: Color(0x3347A8FF),
          ),
          _BackgroundOrb(
            alignment: Alignment(-0.8, 0.9),
            size: 200,
            color: Color(0x22A7F3D0),
          ),
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
            colors: [
              color,
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Material(
          color: Colors.white.withValues(alpha: 0.62),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 52,
              height: 52,
              child: Icon(icon, color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  const _InfoTag({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: primaryColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF2563EB),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionCard extends StatefulWidget {
  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.badge,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String badge;
  final VoidCallback onTap;

  @override
  State<_SelectionCard> createState() => _SelectionCardState();
}

class _SelectionCardState extends State<_SelectionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_pressed ? 0.985 : 1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.86),
                    Colors.white.withValues(alpha: 0.62),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.75),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x160F172A),
                    blurRadius: 24,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.color.withValues(alpha: 0.20),
                          widget.color.withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 42,
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: widget.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.badge,
                            style: TextStyle(
                              color: widget.color,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: secondaryTextColor,
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    widget.color,
                                    widget.color.withValues(alpha: 0.78),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'Mulai Belajar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: widget.color,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF58C1F5).withValues(alpha: 0.14)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: active ? const Color(0xFF48B8F2) : const Color(0xFFAAB3C2),
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? const Color(0xFF48B8F2) : const Color(0xFFAAB3C2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
