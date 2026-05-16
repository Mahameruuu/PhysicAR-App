import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'Semua field harus diisi');
      return;
    }
    if (password != confirmPassword) {
      Fluttertoast.showToast(msg: 'Password tidak cocok!');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.instance.register(
        name: name,
        email: email,
        password: password,
      );

      if (result.success) {
        Fluttertoast.showToast(msg: result.message ?? 'Registrasi berhasil!');
        if (!mounted) {
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        Fluttertoast.showToast(
          msg: result.message ?? 'Registrasi gagal',
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Terjadi kesalahan: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isCompact = size.width < 380;
    final horizontalPadding = isCompact ? 18.0 : 24.0;

    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final hasStartedTypingPassword =
        password.isNotEmpty || confirmPassword.isNotEmpty;
    final passwordsMatch =
        confirmPassword.isEmpty || password == confirmPassword;
    final passwordStrongEnough = password.length >= 8 || password.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          const _FuturisticAuthBackground(),
          SafeArea(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 980),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 44 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  20,
                  horizontalPadding,
                  28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Hero(
                      tag: 'PhysicLab-auth-logo',
                      child: _BrandCluster(),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Text(
                      'Create Account',
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: isCompact ? 30 : 34,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 310),
                      child: Text(
                        'Start your immersive journey into interactive AR physics learning.',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFBFDBFE),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _InfoPill(
                      icon: Icons.science_outlined,
                      label: 'Create your lab-ready account in seconds',
                    ),
                    const SizedBox(height: 24),
                    _GlassPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _PanelHeader(
                            eyebrow: 'ONBOARDING',
                            title: 'Build your futuristic learning profile',
                            subtitle:
                                'Secure your access to simulations, smart physics content, and AR-based discovery.',
                          ),
                          const SizedBox(height: 24),
                          _AuthTextField(
                            controller: _nameController,
                            hintText: 'Full name',
                            icon: Icons.person_outline_rounded,
                          ),
                          const SizedBox(height: 16),
                          _AuthTextField(
                            controller: _emailController,
                            hintText: 'Email address',
                            icon: Icons.alternate_email_rounded,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          _AuthTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            icon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            onChanged: (_) => setState(() {}),
                            suffix: IconButton(
                              splashRadius: 18,
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: const Color(0xFFD6E4FF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _AuthTextField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirm password',
                            icon: Icons.verified_user_outlined,
                            obscureText: _obscureConfirmPassword,
                            onChanged: (_) => setState(() {}),
                            suffix: IconButton(
                              splashRadius: 18,
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: const Color(0xFFD6E4FF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          _ValidationPanel(
                            isVisible: hasStartedTypingPassword,
                            passwordsMatch: passwordsMatch,
                            passwordStrongEnough: passwordStrongEnough,
                          ),
                          const SizedBox(height: 18),
                          _GradientActionButton(
                            label: 'Register',
                            isLoading: _isLoading,
                            onPressed: register,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFCBD5E1),
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Login',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF67E8F9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FuturisticAuthBackground extends StatelessWidget {
  const _FuturisticAuthBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF020617),
            Color(0xFF0F172A),
            Color(0xFF111827),
            Color(0xFF020617),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: const [
          _AnimatedOrb(
            size: 220,
            alignment: Alignment(-1.05, -0.92),
            color: Color(0xFF3B82F6),
          ),
          _AnimatedOrb(
            size: 180,
            alignment: Alignment(1.02, -0.3),
            color: Color(0xFF8B5CF6),
          ),
          _AnimatedOrb(
            size: 160,
            alignment: Alignment(-0.85, 0.72),
            color: Color(0xFF06B6D4),
          ),
          _AnimatedOrb(
            size: 240,
            alignment: Alignment(1.1, 0.95),
            color: Color(0xFF2563EB),
          ),
          _GridGlow(),
        ],
      ),
    );
  }
}

class _AnimatedOrb extends StatelessWidget {
  const _AnimatedOrb({
    required this.size,
    required this.alignment,
    required this.color,
  });

  final double size;
  final Alignment alignment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.06),
      duration: const Duration(milliseconds: 3200),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Align(
          alignment: alignment,
          child: Transform.scale(scale: value, child: child),
        );
      },
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: 0.45),
                color.withValues(alpha: 0.14),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GridGlow extends StatelessWidget {
  const _GridGlow();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.16,
        child: CustomPaint(
          painter: _GridGlowPainter(),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _GridGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final horizontal = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x0006B6D4), Color(0xAA06B6D4), Color(0x0006B6D4)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 1;

    final vertical = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x003B82F6), Color(0x883B82F6), Color(0x003B82F6)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 1;

    for (double y = 90; y < size.height; y += 120) {
      canvas.drawLine(Offset(24, y), Offset(size.width - 24, y), horizontal);
    }

    for (double x = 40; x < size.width; x += 96) {
      canvas.drawLine(Offset(x, 72), Offset(x, size.height - 72), vertical);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BrandCluster extends StatelessWidget {
  const _BrandCluster();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF3B82F6),
                Color(0xFF8B5CF6),
                Color(0xFF06B6D4),
              ],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x553B82F6),
                blurRadius: 24,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.28),
                  ),
                ),
              ),
              const Icon(
                Icons.hub_rounded,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PhysicLab',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Immersive physics experience',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF94A3B8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: Colors.white.withValues(alpha: 0.08),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: const Color(0xFF67E8F9)),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: const Color(0xFFE2E8F0),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.14),
                Colors.white.withValues(alpha: 0.07),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.16),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33111827),
                blurRadius: 34,
                offset: Offset(0, 22),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: GoogleFonts.spaceGrotesk(
            color: const Color(0xFF67E8F9),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            color: const Color(0xFFCBD5E1),
            fontSize: 13,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _AuthTextField extends StatefulWidget {
  const _AuthTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;

  @override
  State<_AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<_AuthTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) {
        setState(() => _isFocused = focused);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: _isFocused ? 0.12 : 0.08),
              Colors.white.withValues(alpha: _isFocused ? 0.08 : 0.05),
            ],
          ),
          border: Border.all(
            color: _isFocused
                ? const Color(0xFF67E8F9)
                : Colors.white.withValues(alpha: 0.10),
          ),
          boxShadow: _isFocused
              ? const [
                  BoxShadow(
                    color: Color(0x333B82F6),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ]
              : null,
        ),
        child: TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          onChanged: widget.onChanged,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: GoogleFonts.poppins(
              color: const Color(0xFF94A3B8),
              fontSize: 14,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
              child: Icon(widget.icon, color: const Color(0xFFD6E4FF), size: 20),
            ),
            suffixIcon: widget.suffix,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _ValidationPanel extends StatelessWidget {
  const _ValidationPanel({
    required this.isVisible,
    required this.passwordsMatch,
    required this.passwordStrongEnough,
  });

  final bool isVisible;
  final bool passwordsMatch;
  final bool passwordStrongEnough;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      height: isVisible ? null : 0,
      padding: EdgeInsets.all(isVisible ? 14 : 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withValues(alpha: isVisible ? 0.06 : 0),
        border: Border.all(
          color: isVisible
              ? Colors.white.withValues(alpha: 0.10)
              : Colors.transparent,
        ),
      ),
      child: isVisible
          ? Column(
              children: [
                _ValidationRow(
                  isValid: passwordStrongEnough,
                  validLabel: 'Password strength looks good',
                  invalidLabel: 'Use at least 8 characters',
                ),
                const SizedBox(height: 10),
                _ValidationRow(
                  isValid: passwordsMatch,
                  validLabel: 'Password confirmation matches',
                  invalidLabel: 'Password confirmation must match',
                ),
              ],
            )
          : null,
    );
  }
}

class _ValidationRow extends StatelessWidget {
  const _ValidationRow({
    required this.isValid,
    required this.validLabel,
    required this.invalidLabel,
  });

  final bool isValid;
  final String validLabel;
  final String invalidLabel;

  @override
  Widget build(BuildContext context) {
    final color =
        isValid ? const Color(0xFF22C55E) : const Color(0xFFF97316);

    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.15),
          ),
          child: Icon(
            isValid
                ? Icons.check_rounded
                : Icons.priority_high_rounded,
            size: 14,
            color: color,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            isValid ? validLabel : invalidLabel,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientActionButton extends StatefulWidget {
  const _GradientActionButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  State<_GradientActionButton> createState() => _GradientActionButtonState();
}

class _GradientActionButtonState extends State<_GradientActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.isLoading;

    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: disabled ? null : (_) => setState(() => _pressed = false),
      onTapCancel: disabled ? null : () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_pressed ? 0.98 : 1),
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: disabled
                ? const [Color(0xFF475569), Color(0xFF334155)]
                : const [
                    Color(0xFF3B82F6),
                    Color(0xFF8B5CF6),
                    Color(0xFF06B6D4),
                  ],
          ),
          boxShadow: disabled
              ? null
              : const [
                  BoxShadow(
                    color: Color(0x883B82F6),
                    blurRadius: 30,
                    offset: Offset(0, 14),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: disabled ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          child: widget.isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
              : Text(
                  widget.label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
