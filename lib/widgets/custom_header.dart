import 'package:flutter/material.dart';
import 'package:physic_lab_app/screens/auth/login_screen.dart';
import 'package:physic_lab_app/services/auth_service.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({
    super.key,
    required this.userName,
  });

  final String userName;

  String _getInitials(String name) {
    final parts = name.trim().split(' ').where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) {
      return '?';
    }
    return parts.map((item) => item[0]).take(2).join().toUpperCase();
  }

  static void showLogoutDialog(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(userName);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello,',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9AA5B5),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      userName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF25324A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '👋',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Logout') {
              showLogoutDialog(context);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'Setting', child: Text('Setting')),
            PopupMenuItem(value: 'Logout', child: Text('Logout')),
          ],
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x140F172A),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: CircleAvatar(
                radius: 15,
                backgroundColor: const Color(0xFF60A5FA),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
