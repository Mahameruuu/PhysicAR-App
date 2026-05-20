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
    if (_selectedIndex == index) return;

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
        const SizedBox(height: 24),
        const _SectionHeader(title: 'Courses'),
        const SizedBox(height: 14),
        const _CategoryRow(),
        const SizedBox(height: 20),
        _FeaturedCourseSection(userName: userName),
        const SizedBox(height: 20),
        const _PromoBanner(),
        const SizedBox(height: 20),
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
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Row(
              children: [
                Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search course',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
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
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF0EA5E9),
            borderRadius: BorderRadius.circular(16),
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
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
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
          color: Color(0xFF0EA5E9),
          icon: Icons.menu_book_rounded,
          isActive: true,
        ),
        _CategoryChip(
          label: 'Popular',
          color: Color(0xFFF59E0B),
          icon: Icons.local_fire_department_rounded,
        ),
        _CategoryChip(
          label: 'Newest',
          color: Color(0xFF8B5CF6),
          icon: Icons.auto_awesome_rounded,
        ),
        _CategoryChip(
          label: 'Advance',
          color: Color(0xFF22C55E),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.12) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive ? color.withValues(alpha: 0.24) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedCourseSection extends StatelessWidget {
  const _FeaturedCourseSection({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FeaturedCourseCard(
          title: 'Physics Motion Lab',
          subtitle: 'Explore force, speed, and acceleration with interactive learning.',
          accent: const Color(0xFF0EA5E9),
          icon: Icons.science_outlined,
          lessons: '12 Files',
          duration: '40 min',
        ),
        const SizedBox(height: 14),
        _FeaturedCourseCard(
          title: 'AR Electricity',
          subtitle: 'Learn circuits and electricity using guided interactive modules.',
          accent: const Color(0xFFF59E0B),
          icon: Icons.bolt_rounded,
          lessons: '20 Files',
          duration: '35 min',
          destination: ElectricitySelectionScreen(userName: userName),
        ),
      ],
    );
  }
}

class _FeaturedCourseCard extends StatelessWidget {
  const _FeaturedCourseCard({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.icon,
    required this.lessons,
    required this.duration,
    this.destination,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final IconData icon;
  final String lessons;
  final String duration;
  final Widget? destination;

  void _open(BuildContext context) {
    if (destination != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => destination!),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda memilih $title')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _open(context),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D0F172A),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: accent, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    icon: Icons.folder_open_rounded,
                    label: lessons,
                    color: accent,
                  ),
                  _InfoChip(
                    icon: Icons.access_time_rounded,
                    label: duration,
                    color: accent,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () => _open(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Open Course',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
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
          colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
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
          SizedBox(height: 10),
          Text(
            'Start from basic concepts and continue with interactive simulations.',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 14),
          _BannerButton(),
        ],
      ),
    );
  }
}

class _BannerButton extends StatelessWidget {
  const _BannerButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Check Now',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
        ),
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
          color: const Color(0xFF4F46E5),
          title: 'Creative Physics Design',
          subtitle: 'Illustration, modeling, and concept visuals',
          progress: 'Completed 70%',
          icon: Icons.palette_outlined,
        ),
        const SizedBox(height: 14),
        _ListCourseTile(
          color: const Color(0xFF0F766E),
          title: 'Quantum Courses',
          subtitle: 'Understand waves, energy, and atomic logic',
          progress: 'Completed 100%',
          icon: Icons.auto_graph_rounded,
        ),
        const SizedBox(height: 14),
        _ListCourseTile(
          color: const Color(0xFFD97706),
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

class _ListCourseTile extends StatelessWidget {
  const _ListCourseTile({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.icon,
    this.destination,
  });

  final Color color;
  final String title;
  final String subtitle;
  final String progress;
  final IconData icon;
  final Widget? destination;

  void _open(BuildContext context) {
    if (destination != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => destination!),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda memilih $title')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _open(context),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      progress,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}