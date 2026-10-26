import 'dart:math';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Animasi
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // State untuk toggle visibilitas password
  bool _obscurePassword = true;

  // ==============================
  // TEMA AIR
  // ==============================
  static const Color primaryBlue = Color(0xFF1687D9);
  static const Color primaryDarkBlue = Color(0xFF075A9C);
  static const Color lightBlue = Color(0xFFEAF8FF);

  static const Color textDark = Color(0xFF1E242B);
  static const Color textMuted = Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();

    // Setup controller animasi sederhana & halus
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ==========================================
  // GELEMBUNG AIR
  // ==========================================
  Widget _buildWaterBubbles() {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: BubblePainter(animation: _animController),
      ),
    );
  }

  // ==========================================
  // LOGO
  // ==========================================
  Widget _buildLogo() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 105,
        height: 105,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.30),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 105,
                height: 105,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5BCBFF), primaryBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_bag_rounded,
                  size: 52,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ==========================================
  // HEADER
  // ==========================================
  Widget _buildHeader() {
    return Column(
      children: [
        _buildLogo(),

        const Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
            color: primaryBlue,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Please enter your email and password',
          style: TextStyle(fontSize: 14, color: textMuted),
        ),
      ],
    );
  }

  // ==========================================
  // EMAIL
  // ==========================================
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(fontSize: 15, color: textDark),
          decoration: InputDecoration(
            hintText: 'nama@email.com',
            hintStyle: TextStyle(
              color: textMuted.withOpacity(0.6),
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: primaryBlue,
              size: 22,
            ),
            filled: true,
            fillColor: const Color(0xFFF7FCFF),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.blue.shade100, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primaryBlue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red.shade400, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Email tidak boleh kosong";
            }

            if (RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                ).hasMatch(value) ==
                false) {
              return 'Email tidak valid';
            }

            return null;
          },
        ),
      ],
    );
  }

  // ==========================================
  // PASSWORD
  // ==========================================
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: const TextStyle(fontSize: 15, color: textDark),
          decoration: InputDecoration(
            hintText: 'Masukkan password',
            hintStyle: TextStyle(
              color: textMuted.withOpacity(0.6),
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: primaryBlue,
              size: 22,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: textMuted,
                size: 22,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            filled: true,
            fillColor: const Color(0xFFF7FCFF),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.blue.shade100, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primaryBlue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red.shade400, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password tidak boleh kosong";
            }

            if (value.length < 6) {
              return 'Password harus lebih daripada 6 karakter';
            }

            return null;
          },
        ),
      ],
    );
  }

  // ==========================================
  // LOGIN BUTTON
  // ==========================================
  Widget _buildLoginButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF5BCBFF), primaryBlue, primaryDarkBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pushNamed(context, '/home_page');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Email atau Password tidak valid'),
                  ],
                ),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.8,
              ),
            ),

            SizedBox(width: 8),

            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SIGN UP
  // ==========================================
  Widget _buildSignUpLink(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/sign_up_page');
      },
      style: TextButton.styleFrom(foregroundColor: primaryBlue),
      child: RichText(
        text: const TextSpan(
          text: 'Belum punya akun? ',
          style: TextStyle(color: textMuted, fontSize: 14),
          children: [
            TextSpan(
              text: 'Buat dulu',
              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // BUILD
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE9F8FF), Color(0xFFC7EEFF), Color(0xFFEAF9FF)],
          ),
        ),

        child: Stack(
          children: [
            // ==============================
            // GELEMBUNG AIR
            // ==============================
            Positioned.fill(child: _buildWaterBubbles()),

            // Ornamen air bagian atas
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.25),
                ),
              ),
            ),

            // Ornamen air bagian bawah
            Positioned(
              bottom: -70,
              left: -60,
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryBlue.withOpacity(0.08),
                ),
              ),
            ),

            // ==============================
            // CONTENT
            // ==============================
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 420),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26.0,
                          vertical: 34.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: primaryBlue.withOpacity(0.10),
                              blurRadius: 30,
                              offset: const Offset(0, 12),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.8),
                              blurRadius: 20,
                              offset: const Offset(0, -5),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.85),
                            width: 1.5,
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildHeader(),

                              const SizedBox(height: 28),

                              _buildEmailField(),

                              const SizedBox(height: 18),

                              _buildPasswordField(),

                              const SizedBox(height: 28),

                              _buildLoginButton(context),

                              const SizedBox(height: 12),

                              _buildSignUpLink(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// CUSTOM PAINTER UNTUK GELEMBUNG AIR
// ======================================================

class BubblePainter extends CustomPainter {
  final Animation<double> animation;

  BubblePainter({required this.animation}) : super(repaint: animation);

  final List<_Bubble> bubbles = const [
    _Bubble(0.08, 0.92, 18, 0.0),
    _Bubble(0.20, 0.80, 9, 0.25),
    _Bubble(0.32, 0.95, 14, 0.50),
    _Bubble(0.45, 0.78, 7, 0.15),
    _Bubble(0.58, 0.92, 20, 0.70),
    _Bubble(0.70, 0.75, 11, 0.35),
    _Bubble(0.82, 0.90, 16, 0.60),
    _Bubble(0.94, 0.70, 8, 0.20),
    _Bubble(0.12, 0.55, 6, 0.40),
    _Bubble(0.88, 0.48, 13, 0.10),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final bubble in bubbles) {
      final progress = (animation.value + bubble.delay) % 1.0;

      // Bergerak dari bawah ke atas
      final y = size.height * (bubble.startY - progress * 1.15);

      final x = size.width * bubble.x + sin(progress * pi * 2) * 18;

      // Jika sudah terlalu tinggi, jangan tampilkan
      if (y < -50 || y > size.height + 50) {
        continue;
      }

      final opacity = (sin(progress * pi)).clamp(0.0, 1.0) * 0.45;

      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.white.withOpacity(opacity);

      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = Colors.white.withOpacity(opacity + 0.15);

      canvas.drawCircle(Offset(x, y), bubble.size, paint);

      canvas.drawCircle(Offset(x, y), bubble.size, borderPaint);

      // Efek pantulan kecil pada gelembung
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(opacity + 0.15);

      canvas.drawCircle(
        Offset(x - bubble.size * 0.30, y - bubble.size * 0.30),
        bubble.size * 0.20,
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BubblePainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

// ======================================================
// DATA GELEMBUNG
// ======================================================

class _Bubble {
  final double x;
  final double startY;
  final double size;
  final double delay;

  const _Bubble(this.x, this.startY, this.size, this.delay);
}
