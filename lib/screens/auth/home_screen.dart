import 'package:flutter/material.dart';

import '../../layouts/main_scaffold.dart';
import '../home/profile_screen.dart';
import '../home/simulation_screen.dart';
import '../modules/electricity/electricity_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      return;
    }

    if (index == 0) {
      setState(() => _selectedIndex = 0);
      return;
    }

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SimulationScreen(userName: widget.userName),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(userName: widget.userName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: _selectedIndex,
      userName: widget.userName,
      onTapNav: _onItemTapped,
      child: _HomeContent(userName: widget.userName),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SearchRow(),
        const SizedBox(height: 22),
        const _SectionHeader(title: 'Courses'),
        const SizedBox(height: 14),
        const _CategoryRow(),
        const SizedBox(height: 18),
        _FeaturedCourseRow(userName: userName),
        const SizedBox(height: 18),
        const _PromoBanner(),
        const SizedBox(height: 18),
        _CourseListSection(userName: userName),
      ],
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x120F172A),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.search_rounded, color: Color(0xFF98A2B3), size: 21),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search',
                    style: TextStyle(
                      color: Color(0xFF98A2B3),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF48B8F2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3348B8F2),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.grid_view_rounded, color: Colors.white),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Color(0xFF25324A),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _CategoryChip(
          label: 'All Topic',
          color: Color(0xFF56C7F5),
          icon: Icons.water_drop_rounded,
          isActive: true,
        ),
        _CategoryChip(
          label: 'Popular',
          color: Color(0xFFFFB938),
          icon: Icons.local_fire_department_rounded,
        ),
        _CategoryChip(
          label: 'Newest',
          color: Color(0xFF8C95D8),
          icon: Icons.auto_awesome_rounded,
        ),
        _CategoryChip(
          label: 'Advance',
          color: Color(0xFF69D28B),
          icon: Icons.school_rounded,
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.color,
    required this.icon,
    this.isActive = false,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.18) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 13, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedCourseRow extends StatelessWidget {
  const _FeaturedCourseRow({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CourseCard(
            title: 'Physics Motion Lab',
            subtitle: 'Explore force, speed, and acceleration',
            accent: const Color(0xFF61C3F9),
            secondary: const Color(0xFF8FD5FB),
            icon: Icons.science_outlined,
            lessons: '12 Files',
            duration: '40 min',
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _CourseCard(
            title: 'AR Electricity',
            subtitle: 'Create circuits and observe interactions',
            accent: const Color(0xFFFFB52E),
            secondary: const Color(0xFFFFD36E),
            icon: Icons.bolt_rounded,
            lessons: '20 Files',
            duration: '35 min',
            destination: ElectricitySelectionScreen(userName: userName),
          ),
        ),
      ],
    );
  }
}

class _CourseCard extends StatefulWidget {
  const _CourseCard({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.secondary,
    required this.icon,
    required this.lessons,
    required this.duration,
    this.destination,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final Color secondary;
  final IconData icon;
  final String lessons;
  final String duration;
  final Widget? destination;

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  bool _pressed = false;

  void _handleTap() {
    if (widget.destination != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => widget.destination!),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda memilih ${widget.title}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_pressed ? 0.98 : 1),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [widget.accent, widget.secondary],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: widget.accent.withValues(alpha: 0.25),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(widget.icon, color: Colors.white),
              ),
            ),
            const SizedBox(height: 26),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.subtitle,
              style: TextStyle(
                fontSize: 12,
                height: 1.45,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _MetaPill(
                  icon: Icons.folder_open_rounded,
                  label: widget.lessons,
                ),
                const SizedBox(width: 8),
                _MetaPill(
                  icon: Icons.access_time_filled_rounded,
                  label: widget.duration,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF62C6F8), Color(0xFF49B1F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2249B1F3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find a course you want to learn!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 14),
                _BannerButton(),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: const [
                Positioned(
                  top: 12,
                  left: 12,
                  child: _FloatingSquare(color: Color(0xFFFFD469)),
                ),
                Positioned(
                  top: 20,
                  right: 10,
                  child: _FloatingSquare(color: Color(0xFF5B8CFF)),
                ),
                Positioned(
                  bottom: 14,
                  left: 22,
                  child: _FloatingSquare(color: Color(0xFFFFFFFF)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerButton extends StatelessWidget {
  const _BannerButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Text(
        'Check Now',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF263145),
        ),
      ),
    );
  }
}

class _FloatingSquare extends StatelessWidget {
  const _FloatingSquare({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _CourseListSection extends StatelessWidget {
  const _CourseListSection({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ListCourseTile(
          colorA: const Color(0xFF7A8CE8),
          colorB: const Color(0xFF596DD6),
          title: 'Creative Physics Design',
          subtitle: 'Illustration, modeling, and concept visuals',
          progress: 'Completed 70%',
          icon: Icons.palette_outlined,
        ),
        const SizedBox(height: 14),
        _ListCourseTile(
          colorA: const Color(0xFF5FD0D2),
          colorB: const Color(0xFF73E0C5),
          title: 'Quantum Courses',
          subtitle: 'Understand waves, energy, and atomic logic',
          progress: 'Completed 100%',
          icon: Icons.auto_graph_rounded,
        ),
        const SizedBox(height: 14),
        _ListCourseTile(
          colorA: const Color(0xFFF3C45F),
          colorB: const Color(0xFFF4B44E),
          title: 'Electrical Module',
          subtitle: 'Open interactive electricity learning content',
          progress: 'Tap to Open',
          icon: Icons.bolt_rounded,
          destination: ElectricitySelectionScreen(userName: userName),
        ),
      ],
    );
  }
}

class _ListCourseTile extends StatefulWidget {
  const _ListCourseTile({
    required this.colorA,
    required this.colorB,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.icon,
    this.destination,
  });

  final Color colorA;
  final Color colorB;
  final String title;
  final String subtitle;
  final String progress;
  final IconData icon;
  final Widget? destination;

  @override
  State<_ListCourseTile> createState() => _ListCourseTileState();
}

class _ListCourseTileState extends State<_ListCourseTile> {
  bool _pressed = false;

  void _handleTap() {
    if (widget.destination != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => widget.destination!),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda memilih ${widget.title}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        transform: Matrix4.identity()..scale(_pressed ? 0.985 : 1),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.colorA, widget.colorB],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: widget.colorA.withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.24),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(widget.icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.progress,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
