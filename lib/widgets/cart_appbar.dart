import 'dart:math';
import 'package:flutter/material.dart';

class CartAppbar extends StatefulWidget {
  const CartAppbar({super.key});

  @override
  State<CartAppbar> createState() => _CartAppbarState();
}

class _CartAppbarState extends State<CartAppbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color(0xFF0284C7),
                  Color(0xFF0EA5E9),
                  Color(0xFF38BDF8),
                  Color(0xFF67E8F9),
                ],
                begin: Alignment(
                  -1 + sin(_controller.value * 2 * pi) * 0.3,
                  -1,
                ),
                end: Alignment(1, 1),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x660EA5E9),
                  blurRadius: 18,
                  offset: Offset(0, 7),
                ),
              ],
            ),
            child: Stack(
              children: [
                // ==============================
                // GELEMBUNG AIR
                // ==============================
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _BubblePainter(progress: _controller.value),
                    ),
                  ),
                ),

                // ==============================
                // EFEK GELOMBANG
                // ==============================
                Positioned(
                  bottom: -35,
                  left: -30,
                  right: -30,
                  child: Transform.translate(
                    offset: Offset(sin(_controller.value * 2 * pi) * 20, 0),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),

                // ==============================
                // CONTENT APPBAR
                // ==============================
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        // BACK BUTTON
                        Material(
                          color: Colors.white.withOpacity(0.15),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            splashColor: Colors.white.withOpacity(0.3),
                            onTap: () {
                              Navigator.pushNamed(context, '/');
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(9),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                size: 23,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 18),

                        // CART ICON
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.16),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: const Icon(
                            Icons.shopping_cart_rounded,
                            size: 22,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // TITLE
                        const Expanded(
                          child: Text(
                            'My Cart',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),

                        // MORE BUTTON
                        Material(
                          color: Colors.white.withOpacity(0.15),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            splashColor: Colors.white.withOpacity(0.3),
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(9),
                              child: Icon(
                                Icons.more_vert_rounded,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
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
    );
  }
}

// ==========================================================
// BUBBLE PAINTER
// ==========================================================

class _BubblePainter extends CustomPainter {
  final double progress;

  _BubblePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bubbles = [
      [0.08, 0.80, 7.0],
      [0.18, 0.35, 4.0],
      [0.32, 0.70, 6.0],
      [0.48, 0.25, 5.0],
      [0.62, 0.75, 8.0],
      [0.75, 0.35, 4.0],
      [0.88, 0.70, 6.0],
      [0.95, 0.25, 4.0],
    ];

    for (int i = 0; i < bubbles.length; i++) {
      final bubble = bubbles[i];

      final double x = size.width * bubble[0];

      final double movement = sin((progress * 2 * pi) + i) * 7;

      final double y = size.height * bubble[1] + movement;

      final fillPaint = Paint()
        ..color = Colors.white.withOpacity(0.18)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), bubble[2], fillPaint);

      final borderPaint = Paint()
        ..color = Colors.white.withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawCircle(Offset(x, y), bubble[2], borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
