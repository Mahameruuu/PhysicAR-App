import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controller untuk tiap field
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileFromLocal(); // tampilkan data lokal dulu
    _fetchProfile(); // fetch terbaru dari server
  }

  // 1️⃣ Load data dari SharedPreferences
  Future<void> _loadProfileFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullNameController.text = prefs.getString('full_name') ?? '';
      _genderController.text = prefs.getString('gender') ?? '';
      _birthDateController.text = prefs.getString('birth_date') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
    });
  }

  // 2️⃣ Fetch profile dari server
  Future<void> _fetchProfile() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          _fullNameController.text = data['full_name'] ?? '';
          _genderController.text = data['gender'] ?? '';
          _birthDateController.text = data['birth_date'] ?? '';
          _addressController.text = data['address'] ?? '';
          _phoneController.text = data['phone'] ?? '';
        });

        // Simpan lokal supaya tetap muncul saat balik ke screen
        await prefs.setString('full_name', data['full_name'] ?? '');
        await prefs.setString('gender', data['gender'] ?? '');
        await prefs.setString('birth_date', data['birth_date'] ?? '');
        await prefs.setString('address', data['address'] ?? '');
        await prefs.setString('phone', data['phone'] ?? '');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengambil data profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  // 3️⃣ Update profile
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token') ?? '';

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'full_name': _fullNameController.text,
          'gender': _genderController.text,
          'birth_date': _birthDateController.text,
          'address': _addressController.text,
          'phone': _phoneController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update SharedPreferences juga
        await prefs.setString('full_name', _fullNameController.text);
        await prefs.setString('gender', _genderController.text);
        await prefs.setString('birth_date', _birthDateController.text);
        await prefs.setString('address', _addressController.text);
        await prefs.setString('phone', _phoneController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile berhasil diupdate!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal update profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  // 4️⃣ Build textfield reusable
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (!isPassword && (value == null || value.isEmpty)) {
              return '$label tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF4FC3F7);
    const Color lightPurpleBackground = Color(0xFFF3E5F5);

    return Scaffold(
      backgroundColor: lightPurpleBackground,
      appBar: AppBar(
        backgroundColor: primaryPurple,
        title: const Text('Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(label: 'Full Name', controller: _fullNameController),
                    _buildTextField(label: 'Gender (L/P)', controller: _genderController),
                    _buildTextField(label: 'Birth Date (YYYY-MM-DD)', controller: _birthDateController),
                    _buildTextField(label: 'Address', controller: _addressController),
                    _buildTextField(label: 'Phone', controller: _phoneController, keyboardType: TextInputType.phone),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        child: const Text('Update Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
