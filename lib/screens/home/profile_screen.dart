import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../layouts/main_scaffold.dart';
import '../../services/auth_service.dart';
import '../auth/home_screen.dart';
import 'simulation_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.userName,
  });

  final String? userName;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String _gender = 'L';
  DateTime? _birthDate;
  String _resolvedUserName = 'physicAR Learner';

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileFromLocal();
  }

  Future<void> _loadProfileFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUser = await AuthService.instance.getCurrentUser();
    final emailKey = currentUser?.email.toLowerCase() ?? 'guest';

    setState(() {
      _resolvedUserName =
          widget.userName ?? currentUser?.name ?? 'physicAR Learner';
      _fullNameController.text =
          prefs.getString('profile_${emailKey}_full_name') ??
              currentUser?.name ??
              '';
      _gender = prefs.getString('profile_${emailKey}_gender') ?? 'L';
      final birthStr = prefs.getString('profile_${emailKey}_birth_date');
      if (birthStr != null && birthStr.isNotEmpty) {
        _birthDate = DateTime.tryParse(birthStr);
      }
      _addressController.text =
          prefs.getString('profile_${emailKey}_address') ?? '';
      _phoneController.text = prefs.getString('profile_${emailKey}_phone') ?? '';
    });
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal lahir dulu')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final currentUser = await AuthService.instance.getCurrentUser();
    final emailKey = currentUser?.email.toLowerCase() ?? 'guest';

    try {
      await prefs.setString(
        'profile_${emailKey}_full_name',
        _fullNameController.text,
      );
      await prefs.setString('profile_${emailKey}_gender', _gender);
      await prefs.setString(
        'profile_${emailKey}_birth_date',
        DateFormat('yyyy-MM-dd').format(_birthDate!),
      );
      await prefs.setString(
        'profile_${emailKey}_address',
        _addressController.text,
      );
      await prefs.setString(
        'profile_${emailKey}_phone',
        _phoneController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile berhasil diupdate!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
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
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      return;
    }

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(userName: _resolvedUserName),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SimulationScreen(userName: _resolvedUserName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 2,
      userName: _resolvedUserName,
      onTapNav: _onItemTapped,
      child: _isLoading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: _gender == 'L'
                        ? Colors.blue.shade100
                        : Colors.pink.shade100,
                    child: Text(
                      _gender == 'L' ? 'ðŸ‘¦' : 'ðŸ‘§',
                      style: const TextStyle(fontSize: 50),
                    ),
                  ),
                  const SizedBox(height: 12),
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
                    validator: (value) => value == null || value.isEmpty
                        ? 'Pilih tanggal lahir'
                        : null,
                  ),
                  const SizedBox(height: 16),
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
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF42A5F5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Update Profil',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
