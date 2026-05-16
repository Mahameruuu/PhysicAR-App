import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  String _gender = 'L';
  DateTime? _birthDate;
  String _resolvedUserName = 'physicAR Learner';

  final TextEditingController _fullNameController =
      TextEditingController();

  final TextEditingController _addressController =
      TextEditingController();

  final TextEditingController _phoneController =
      TextEditingController();

  late final AnimationController _bgController;
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _loadProfileFromLocal();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _floatController.dispose();

    _fullNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  Future<void> _loadProfileFromLocal() async {
    final prefs = await SharedPreferences.getInstance();

    final currentUser =
        await AuthService.instance.getCurrentUser();

    final emailKey =
        currentUser?.email.toLowerCase() ?? 'guest';

    setState(() {
      _resolvedUserName =
          widget.userName ??
              currentUser?.name ??
              'physicAR Learner';

      _fullNameController.text =
          prefs.getString(
                'profile_${emailKey}_full_name',
              ) ??
              currentUser?.name ??
              '';

      _gender =
          prefs.getString(
            'profile_${emailKey}_gender',
          ) ??
          'L';

      final birthStr = prefs.getString(
        'profile_${emailKey}_birth_date',
      );

      if (birthStr != null && birthStr.isNotEmpty) {
        _birthDate = DateTime.tryParse(birthStr);
      }

      _addressController.text =
          prefs.getString(
            'profile_${emailKey}_address',
          ) ??
          '';

      _phoneController.text =
          prefs.getString(
            'profile_${emailKey}_phone',
          ) ??
          '';
    });
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pilih tanggal lahir terlebih dahulu',
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();

    final currentUser =
        await AuthService.instance.getCurrentUser();

    final emailKey =
        currentUser?.email.toLowerCase() ?? 'guest';

    try {
      await prefs.setString(
        'profile_${emailKey}_full_name',
        _fullNameController.text,
      );

      await prefs.setString(
        'profile_${emailKey}_gender',
        _gender,
      );

      await prefs.setString(
        'profile_${emailKey}_birth_date',
        DateFormat(
          'yyyy-MM-dd',
        ).format(_birthDate!),
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
          const SnackBar(
            backgroundColor: Color(0xFF22C55E),
            content: Text(
              'Profil berhasil diperbarui!',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _birthDate ?? DateTime(2005, 1, 1),
      firstDate: DateTime(1995),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  void _onItemTapped(int index) {
    if (index == 2) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            userName: _resolvedUserName,
          ),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SimulationScreen(
          userName: _resolvedUserName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 2,
      userName: _resolvedUserName,
      onTapNav: _onItemTapped,
      child: Stack(
        children: [
          // BACKGROUND ANIMASI
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (_, __) {
                return CustomPaint(
                  painter: _BackgroundPainter(
                    _bgController.value,
                  ),
                );
              },
            ),
          ),

          // CONTENT
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // HEADER PROFILE
                  AnimatedBuilder(
                    animation: _floatController,
                    builder: (_, child) {
                      final dy = sin(
                            _floatController.value *
                                pi *
                                2,
                          ) *
                          10;

                      return Transform.translate(
                        offset: Offset(0, dy),
                        child: child,
                      );
                    },
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 20,
                          sigmaY: 20,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(
                              32,
                            ),
                            gradient:
                                const LinearGradient(
                              colors: [
                                Color(0xFF0F172A),
                                Color(0xFF111827),
                                Color(0xFF1E293B),
                              ],
                              begin: Alignment.topLeft,
                              end:
                                  Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyan
                                    .withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 30,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // AVATAR 3D
                              Container(
                                padding:
                                    const EdgeInsets.all(
                                  5,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient:
                                      const LinearGradient(
                                    colors: [
                                      Color(0xFF38BDF8),
                                      Color(0xFF8B5CF6),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.cyan
                                          .withValues(
                                        alpha: 0.5,
                                      ),
                                      blurRadius: 25,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 52,
                                  backgroundColor:
                                      const Color(
                                    0xFF0F172A,
                                  ),
                                  child: Text(
                                    _gender == 'L'
                                        ? '👨‍🔬'
                                        : '👩‍🔬',
                                    style:
                                        const TextStyle(
                                      fontSize: 54,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              ShaderMask(
                                shaderCallback:
                                    (bounds) {
                                  return const LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Color(0xFF67E8F9),
                                    ],
                                  ).createShader(
                                    bounds,
                                  );
                                },
                                child: Text(
                                  _resolvedUserName,
                                  style:
                                      GoogleFonts.orbitron(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                'Kelola identitas dan profil pengguna PhysicAR.',
                                textAlign:
                                    TextAlign.center,
                                style:
                                    GoogleFonts.poppins(
                                  color:
                                      Colors.white70,
                                  fontSize: 13,
                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  _buildGlassField(
                    child: TextFormField(
                      controller:
                          _fullNameController,
                      style: GoogleFonts.poppins(),
                      decoration:
                          _inputDecoration(
                        'Nama Lengkap',
                        Icons.person_rounded,
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Nama wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  _buildGlassField(
                    child:
                        DropdownButtonFormField<
                            String>(
                      value: _gender,
                      decoration:
                          _inputDecoration(
                        'Jenis Kelamin',
                        Icons.people_alt_rounded,
                      ),
                      style: GoogleFonts.poppins(
                        color:
                            const Color(0xFF0F172A),
                      ),
                      dropdownColor:
                          Colors.white,
                      items: const [
                        DropdownMenuItem(
                          value: 'L',
                          child: Text(
                            'Laki-laki',
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'P',
                          child: Text(
                            'Perempuan',
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  _buildGlassField(
                    child: TextFormField(
                      readOnly: true,
                      onTap: _pickBirthDate,
                      controller:
                          TextEditingController(
                        text: _birthDate != null
                            ? DateFormat(
                                'dd MMMM yyyy',
                              ).format(
                                _birthDate!,
                              )
                            : '',
                      ),
                      decoration:
                          _inputDecoration(
                        'Tanggal Lahir',
                        Icons.calendar_today,
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Pilih tanggal lahir';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  _buildGlassField(
                    child: TextFormField(
                      controller:
                          _addressController,
                      maxLines: 3,
                      style: GoogleFonts.poppins(),
                      decoration:
                          _inputDecoration(
                        'Alamat',
                        Icons.location_on_rounded,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  _buildGlassField(
                    child: TextFormField(
                      controller:
                          _phoneController,
                      keyboardType:
                          TextInputType.phone,
                      style: GoogleFonts.poppins(),
                      decoration:
                          _inputDecoration(
                        'Nomor HP',
                        Icons.phone_rounded,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // BUTTON 3D
                  SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : _updateProfile,
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.transparent,
                        shadowColor:
                            Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            22,
                          ),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(
                            22,
                          ),
                          gradient:
                              const LinearGradient(
                            colors: [
                              Color(0xFF38BDF8),
                              Color(0xFF8B5CF6),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyan
                                  .withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  width: 26,
                                  height: 26,
                                  child:
                                      CircularProgressIndicator(
                                    color:
                                        Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                  children: [
                                    const Icon(
                                      Icons.save_rounded,
                                      color:
                                          Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'UPDATE PROFIL',
                                      style: GoogleFonts
                                          .orbitron(
                                        color: Colors
                                            .white,
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight
                                                .w700,
                                        letterSpacing:
                                            1,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassField({
    required Widget child,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(24),
            color:
                Colors.white.withValues(alpha: 0.55),
            border: Border.all(
              color:
                  Colors.white.withValues(alpha: 0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withValues(
                  alpha: 0.08,
                ),
                blurRadius: 20,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF38BDF8),
      ),
      labelText: label,
      labelStyle: GoogleFonts.poppins(
        color: const Color(0xFF475569),
      ),
      filled: true,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: Color(0xFF38BDF8),
          width: 1.5,
        ),
      ),
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
    );
  }
}

// ════════════════════════════════════════
// BACKGROUND PAINTER
// ════════════════════════════════════════

class _BackgroundPainter extends CustomPainter {
  final double progress;

  _BackgroundPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFF8FAFC),
          Color(0xFFE0F2FE),
          Color(0xFFF1F5F9),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    canvas.drawRect(rect, paint);

    // FLOATING PARTICLES
    for (int i = 0; i < 18; i++) {
      final dx =
          (size.width / 18) * i +
              sin(progress * pi * 2 + i) *
                  25;

      final dy =
          (size.height / 18) * i +
              cos(progress * pi * 2 + i) *
                  25;

      final radius = 25 + (i % 4) * 10;

      final particlePaint = Paint()
        ..color =
            Colors.cyan.withValues(alpha: 0.05);

      canvas.drawCircle(
        Offset(dx, dy),
        radius.toDouble(),
        particlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _BackgroundPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}