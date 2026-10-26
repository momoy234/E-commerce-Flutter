import 'dart:math';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final AnimationController _bubbleController;
  late final AnimationController _waveController;

  final Random _random = Random();

  final List<_Bubble> _bubbles = List.generate(
    30,
    (index) => _Bubble(
      left: Random().nextDouble(),
      size: 8 + Random().nextDouble() * 30,
      speed: 0.4 + Random().nextDouble() * 1.5,
      delay: Random().nextDouble(),
    ),
  );

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bubbleController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F9FF),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [
                    Color(0xFF00BFFF),
                    Color(0xFF009FE3),
                    Color(0xFF38D9FF),
                    Color(0xFF7CEEFF),
                  ],
                  begin: Alignment(-1 + _animationController.value, -1),
                  end: Alignment(1 - _animationController.value, 1),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x6600BFFF),
                    blurRadius: 25,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  _buildHeaderBubbles(),

                  // Kilauan cahaya air
                  Positioned(
                    top: -55,
                    right: -35,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.12),
                      ),
                    ),
                  ),

                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.water_drop_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          const SizedBox(width: 12),

                          const Expanded(
                            child: Text(
                              'My Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),

                          IconButton(
                            tooltip: 'Notifications',
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      body: Stack(
        children: [
          // ===================================================
          // BACKGROUND AIR
          // ===================================================
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFBDF3FF),
                    Color(0xFFE9FBFF),
                    Color(0xFFF7FEFF),
                    Color(0xFFDDF7FF),
                  ],
                ),
              ),
            ),
          ),

          // ===================================================
          // EFEK CAHAYA AIR
          // ===================================================
          Positioned(
            top: 50,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x5538D9FF),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x4438D9FF),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 50,
            right: -90,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x4429CFFF),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x4438D9FF),
                    blurRadius: 90,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          // ===================================================
          // GELOMBANG AIR
          // ===================================================
          Positioned(
            top: -55,
            left: -120,
            right: -120,
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                final wave = sin(_waveController.value * 2 * pi) * 25;

                return Transform.translate(
                  offset: Offset(wave, 0),
                  child: Container(
                    height: 145,
                    decoration: BoxDecoration(
                      color: const Color(0x5538D9FF),
                      borderRadius: BorderRadius.circular(120),
                    ),
                  ),
                );
              },
            ),
          ),

          // Gelombang kedua
          Positioned(
            top: 80,
            left: -150,
            right: -150,
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                final wave = sin((_waveController.value * 2 * pi) + 2) * 35;

                return Transform.translate(
                  offset: Offset(-wave, 0),
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0x2238BDF8),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                );
              },
            ),
          ),

          // ===================================================
          // GELEMBUNG
          // ===================================================
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _bubbleController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _BubblePainter(
                      bubbles: _bubbles,
                      progress: _bubbleController.value,
                    ),
                  );
                },
              ),
            ),
          ),

          // ===================================================
          // CONTENT
          // ===================================================
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildProfileSection(),

                const SizedBox(height: 12),

                _buildSettingSection(context),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // HEADER BUBBLES
  // =========================================================

  Widget _buildHeaderBubbles() {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _bubbleController,
          builder: (context, child) {
            return CustomPaint(
              painter: _HeaderBubblePainter(progress: _bubbleController.value),
            );
          },
        ),
      ),
    );
  }

  // =========================================================
  // PROFILE
  // =========================================================

  Widget _buildProfileSection() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.88, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 22, 16, 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF006BB6),
              Color(0xFF009FE3),
              Color(0xFF00C6FF),
              Color(0xFF63E8FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Color(0x6600AEEF),
              blurRadius: 28,
              spreadRadius: 2,
              offset: Offset(0, 13),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Kilauan air
            Positioned(
              top: -65,
              right: -45,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.13),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              bottom: -50,
              left: -40,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(right: 30, bottom: 25, child: _animatedBubble(22)),

            Positioned(right: 70, top: 25, child: _animatedBubble(10)),

            Positioned(left: 145, bottom: 20, child: _animatedBubble(14)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
              child: Row(
                children: [
                  // FOTO PROFILE
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x7700AEEF),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/p.jpeg',
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 18),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WaterMemb',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),

                        SizedBox(height: 7),

                        Text(
                          'WaterMemb@gmail.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            letterSpacing: 0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 12),

                        Row(
                          children: [
                            Icon(
                              Icons.water_drop_rounded,
                              color: Colors.white70,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Welcome back!',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SETTING ITEM
  // =========================================================

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        color: Colors.white.withOpacity(0.94),
        shadowColor: const Color(0x5538BDF8),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          splashColor: const Color(0x3338D9FF),
          highlightColor: const Color(0x1138BDF8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // ICON AIR
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8BEAFF), Color(0xFFE0F9FF)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Color(0x3338BDF8), blurRadius: 10),
                    ],
                  ),
                  child: Icon(icon, color: const Color(0xFF008FD1)),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.15,
                      color: Color(0xFF164E63),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFD9F8FF), Color(0xFFB9F0FF)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Color(0xFF008FD1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SETTING SECTION
  // =========================================================

  Widget _buildSettingSection(BuildContext context) {
    return Column(
      children: [
        _buildSettingItem(
          context,
          icon: Icons.person_outline_rounded,
          title: 'Profile',
          onTap: () {
            Navigator.pushNamed(context, '/account_page');
          },
        ),

        _buildSettingItem(
          context,
          icon: Icons.shopping_cart_outlined,
          title: 'Cart',
          onTap: () {
            Navigator.pushNamed(context, '/cart_page');
          },
        ),

        _buildSettingItem(
          context,
          icon: Icons.lock_outline_rounded,
          title: 'Change Password',
          onTap: () {
            Navigator.pushNamed(context, '/change_password_page');
          },
        ),

        _buildSettingItem(
          context,
          icon: Icons.logout_rounded,
          title: 'Logout',
          onTap: () {
            _showLogoutDialog(context);
          },
        ),
      ],
    );
  }

  // =========================================================
  // LOGOUT DIALOG
  // =========================================================

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(Icons.water_drop_rounded, color: Color(0xFF008FD1)),
              SizedBox(width: 10),
              Text('Logout'),
            ],
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008FD1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login_page',
                  (route) => false,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sukses! Logout berhasil!'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Color(0xFF008FD1),
                  ),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // ANIMATED BUBBLE
  // =========================================================

  Widget _animatedBubble(double size) {
    return AnimatedBuilder(
      animation: _bubbleController,
      builder: (context, child) {
        final movement = sin(_bubbleController.value * 2 * pi) * 9;

        final scale = 0.85 + sin(_bubbleController.value * 2 * pi) * 0.12;

        return Transform.translate(
          offset: Offset(0, movement),
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.24),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// =============================================================
// BUBBLE DATA
// =============================================================

class _Bubble {
  final double left;
  final double size;
  final double speed;
  final double delay;

  _Bubble({
    required this.left,
    required this.size,
    required this.speed,
    required this.delay,
  });
}

// =============================================================
// BUBBLE PAINTER
// =============================================================

class _BubblePainter extends CustomPainter {
  final List<_Bubble> bubbles;
  final double progress;

  _BubblePainter({required this.bubbles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < bubbles.length; i++) {
      final bubble = bubbles[i];

      double movement = (progress * bubble.speed + bubble.delay) % 1;

      final waveOffset = sin((progress * 2 * pi) + bubble.delay * 10) * 22;

      final x = bubble.left * size.width + waveOffset;

      final y = size.height + 80 - (movement * (size.height + 180));

      // Bubble utama
      final paint = Paint()
        ..shader =
            RadialGradient(
              colors: [
                Colors.white.withOpacity(0.42),
                Colors.white.withOpacity(0.08),
              ],
            ).createShader(
              Rect.fromCircle(center: Offset(x, y), radius: bubble.size / 2),
            );

      canvas.drawCircle(Offset(x, y), bubble.size / 2, paint);

      // Border bubble
      final borderPaint = Paint()
        ..color = Colors.white.withOpacity(0.38)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3;

      canvas.drawCircle(Offset(x, y), bubble.size / 2, borderPaint);

      // Highlight kecil di bubble
      final highlightPaint = Paint()..color = Colors.white.withOpacity(0.75);

      canvas.drawCircle(
        Offset(x - bubble.size * 0.18, y - bubble.size * 0.18),
        bubble.size * 0.10,
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// =============================================================
// HEADER BUBBLE PAINTER
// =============================================================

class _HeaderBubblePainter extends CustomPainter {
  final double progress;

  _HeaderBubblePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bubbles = [
      [0.08, 0.65, 10.0],
      [0.18, 0.30, 6.0],
      [0.30, 0.22, 5.0],
      [0.44, 0.72, 9.0],
      [0.58, 0.35, 6.0],
      [0.70, 0.70, 12.0],
      [0.82, 0.30, 7.0],
      [0.92, 0.75, 5.0],
    ];

    for (int i = 0; i < bubbles.length; i++) {
      final bubble = bubbles[i];

      final x = size.width * bubble[0];

      final offset = sin((progress * 2 * pi) + i) * 7;

      final y = size.height * bubble[1] + offset;

      final paint = Paint()..color = Colors.white.withOpacity(0.22);

      canvas.drawCircle(Offset(x, y), bubble[2], paint);

      final highlight = Paint()..color = Colors.white.withOpacity(0.5);

      canvas.drawCircle(
        Offset(x - bubble[2] * 0.25, y - bubble[2] * 0.25),
        bubble[2] * 0.2,
        highlight,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HeaderBubblePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
