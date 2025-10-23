import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String _gender = 'L';
  DateTime? _birthDate;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileFromLocal();
    _fetchProfile();
  }

  Future<void> _loadProfileFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullNameController.text = prefs.getString('full_name') ?? '';
      _gender = prefs.getString('gender') ?? 'L';
      final birthStr = prefs.getString('birth_date');
      if (birthStr != null && birthStr.isNotEmpty) {
        _birthDate = DateTime.tryParse(birthStr);
      }
      _addressController.text = prefs.getString('address') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
    });
  }

  Future<void> _fetchProfile() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('https://physiclab.my.id/api/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          _fullNameController.text = data['full_name'] ?? '';
          _gender = data['gender'] ?? 'L';
          final birthStr = data['birth_date'];
          if (birthStr != null && birthStr.isNotEmpty) {
            _birthDate = DateTime.tryParse(birthStr);
          }
          _addressController.text = data['address'] ?? '';
          _phoneController.text = data['phone'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() => _isLoading = false);
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal lahir dulu')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token') ?? '';

    try {
      final response = await http.post(
        Uri.parse('https://physiclab.my.id/api/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'full_name': _fullNameController.text,
          'gender': _gender,
          'birth_date': DateFormat('yyyy-MM-dd').format(_birthDate!),
          'address': _addressController.text,
          'phone': _phoneController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await prefs.setString('full_name', _fullNameController.text);
        await prefs.setString('gender', _gender);
        await prefs.setString(
            'birth_date', DateFormat('yyyy-MM-dd').format(_birthDate!));
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() => _isLoading = false);
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2005, 1, 1),
      firstDate: DateTime(1995),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF42A5F5);
    const Color lightBackground = Color(0xFFE3F2FD);

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Profil Kamu'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          _gender == 'L' ? Colors.blue.shade100 : Colors.pink.shade100,
                      child: Text(
                        _gender == 'L' ? '👦' : '👧',
                        style: const TextStyle(fontSize: 50),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Nama lengkap
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Lengkap',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    // Jenis kelamin
                    DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: InputDecoration(
                        labelText: 'Jenis Kelamin',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                        DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                      ],
                      onChanged: (value) => setState(() => _gender = value!),
                    ),
                    const SizedBox(height: 16),

                    // Tanggal lahir
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Tanggal Lahir',
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onTap: _pickBirthDate,
                      controller: TextEditingController(
                        text: _birthDate != null
                            ? DateFormat('yyyy-MM-dd').format(_birthDate!)
                            : '',
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Pilih tanggal lahir' : null,
                    ),
                    const SizedBox(height: 16),

                    // Alamat
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nomor HP
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Nomor HP',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tombol update
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        child: const Text(
                          'Update Profil',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
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
