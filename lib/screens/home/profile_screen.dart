import 'package:flutter/material.dart';
// Asumsi LoginScreen ada di jalur yang benar
import '../auth/login_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  final String userName;
  // Contoh data tambahan agar widget lebih fungsional
  final String userEmail;
  final String userPhoneNumber;
  final String userWebsite;
  final String userRole;

  const ProfileScreen({
    Key? key,
    required this.userName,
    this.userEmail = "vikasassudani909@gmail.com",
    this.userPhoneNumber = "+91 9876543210",
    this.userWebsite = "www.vikasassudani.com",
    this.userRole = "UI/UX Designer",
  }) : super(key: key);

  // Widget kustom untuk meniru tampilan kolom input di gambar
  Widget _buildTextFieldContainer({
    required String label,
    required String value,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas kolom input
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        // Container yang meniru TextField
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100, // Latar belakang abu-abu muda untuk kolom
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isPassword ? '••••••••••' : value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                icon,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Warna tema dari gambar
    const Color primaryPurple = Color(0xFF4FC3F7); // Warna ungu yang lebih gelap untuk latar depan
    const Color lightPurpleBackground = Color(0xFFF3E5F5); // Ungu muda untuk latar belakang utama

    return Scaffold(
      // Mengatur latar belakang Scaffold menjadi ungu muda
      backgroundColor: lightPurpleBackground, 
      
      body: Stack(
        children: [
          // 1. Bagian Header Ungu di atas
          Container(
            height: 250, // Sesuaikan tinggi sesuai kebutuhan
            decoration: const BoxDecoration(
              color: primaryPurple, // Ungu gelap untuk header
            ),
          ),
          
          // 2. Konten Utama (Scrollable)
          SingleChildScrollView(
            child: Column(
              children: [
                // Ruang untuk AppBar palsu dan konten atas (Nama/Avatar)
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          "Your Profile",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),

                // Avatar and Name Section
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon( // Menggunakan ikon sebagai pengganti memoji
                    Icons.person,
                    size: 80,
                    color: primaryPurple,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white
                  ),
                ),
                Text(
                  userRole,
                  style: const TextStyle(
                    fontSize: 16, 
                    color: Colors.white70
                  ),
                ),
                
                const SizedBox(height: 24),

                // Card Konten Utama (Informasi Detail)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20), // Sudut lebih melengkung
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Menggunakan widget kustom baru
                      _buildTextFieldContainer(
                        label: "Your Email",
                        value: userEmail,
                        icon: Icons.email_outlined,
                      ),
                      _buildTextFieldContainer(
                        label: "Phone Number",
                        value: userPhoneNumber,
                        icon: Icons.call,
                      ),
                      _buildTextFieldContainer(
                        label: "Website",
                        value: userWebsite,
                        icon: Icons.language,
                      ),
                      _buildTextFieldContainer(
                        label: "Password",
                        value: "password", // Nilai tidak ditampilkan
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),
                      
                      // Menambahkan jarak di akhir kartu
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Logout Button Dihilangkan karena tidak ada di referensi gambar
                // Jika ingin ditambahkan, bisa diletakkan di bawah sini.
                
                // ElevatedButton.icon( ... )
                
                const SizedBox(height: 50), // Jarak di bagian bawah
              ],
            ),
          ),
        ],
      ),
    );
  }
}