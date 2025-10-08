import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../modules/electricity/electricity_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const _HomeContent(),
    const Center(child: Text('Theory Screen', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
    const Center(child: Text('Simulation Screen', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
    const Center(child: Text('Profile Screen', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color lightCyan = Color(0xFFE0FFFF);
    const Color primaryBlue = Color(0xFF4FC3F7);

    return Scaffold(
      backgroundColor: lightCyan,
      body: _selectedIndex == 0
          ? const _HomeContent()
          : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Theory'),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_outline), label: 'Simulation'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF4FC3F7);
    const Color backgroundColor = Color(0xFFE0FFFF);

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.science_rounded, color: Color(0xFF0288D1), size: 36),
                      SizedBox(width: 8),
                      Text(
                        'Physic Lab',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Logout') {
                        _showLogoutDialog(context);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'Setting', child: Text('Setting')),
                      const PopupMenuItem(value: 'Logout', child: Text('Logout')),
                    ],
                    child: CircleAvatar(
                      backgroundColor: primaryBlue.withOpacity(0.8),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Greetings
              const Text(
                'Welcome to your lab!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              const Text(
                'Explore, Experiment, Discover ✨',
                style: TextStyle(fontSize: 16, color: Colors.grey, fontStyle: FontStyle.italic),
              ),

              const SizedBox(height: 40),

              // Grid Menu
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.9,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildFancyMenu(
                    context,
                    'Gaya & Gerak',
                    'Belajar konsep gaya dan gerak benda',
                    Icons.directions_run,
                    Colors.redAccent,
                  ),
                  _buildFancyMenu(
                    context,
                    'Listrik Dinamis',
                    'Pelajari arus dan rangkaian listrik',
                    Icons.bolt_rounded,
                    Colors.blueAccent,
                    destination: ElectricitySelectionScreen(),
                  ),
                  _buildFancyMenu(
                    context,
                    'Kalor & Suhu',
                    'Pahami energi panas dan perubahannya',
                    Icons.wb_sunny_rounded,
                    Colors.orangeAccent,
                  ),
                  _buildFancyMenu(
                    context,
                    'Gelombang & Bunyi',
                    'Eksperimen gelombang dan suara',
                    Icons.multitrack_audio_rounded,
                    Colors.deepPurpleAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Fancy Menu Item ---
  Widget _buildFancyMenu(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color, {
    Widget? destination,
  }) {
    return GestureDetector(
      onTap: () {
        if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Anda memilih $title')),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.85), color.withOpacity(0.55)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.white.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 4, color: Colors.black26, offset: Offset(1, 1)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Logout dialog ---
  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah Anda yakin ingin logout?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Logout"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
