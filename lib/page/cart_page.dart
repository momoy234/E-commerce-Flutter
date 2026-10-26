import 'dart:math';
import 'package:flutter/material.dart';
import 'account_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _bubbleController;

  final List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Nike Air Max',
      'price': 1200000,
      'quantity': 1,
      'image': 'assets/images/nike.png',
    },
    {
      'name': 'Adidas Running',
      'price': 950000,
      'quantity': 1,
      'image': 'assets/images/adidas.png',
    },
    {
      'name': 'Casual Shoes',
      'price': 750000,
      'quantity': 2,
      'image': 'assets/images/casual.png',
    },
    {
      'name': 'Knitwer',
      'price': 1250000,
      'quantity': 2,
      'image': 'assets/images/knitwer.png',
    },
  ];

  @override
  void initState() {
    super.initState();

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  // =========================================================
  // FORMAT HARGA
  // =========================================================

  String formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
  }

  // =========================================================
  // TOTAL HARGA
  // =========================================================

  int get totalPrice {
    int total = 0;

    for (var item in cartItems) {
      total += (item['price'] as int) * (item['quantity'] as int);
    }

    return total;
  }

  // =========================================================
  // POPUP HAPUS BARANG
  // =========================================================

  void confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
              SizedBox(width: 10),
              Text(
                'Hapus Barang?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Yakin ingin menghapus "${cartItems[index]['name']}" dari cart?',
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  cartItems.removeAt(index);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Barang berhasil dihapus dari cart'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      // =====================================================
      // BACKGROUND AIR
      // =====================================================
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff38CFFF),
                  Color(0xff159FE8),
                  Color(0xff087BC7),
                  Color(0xff045A9F),
                ],
              ),
            ),
          ),

          // Efek cahaya air
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.12),
              ),
            ),
          ),

          Positioned(
            bottom: -100,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.10),
              ),
            ),
          ),

          // =================================================
          // GELEMBUNG AIR
          // =================================================
          AnimatedBuilder(
            animation: _bubbleController,
            builder: (context, child) {
              return Stack(
                children: [
                  _bubble(size: 25, left: 30, start: 650, delay: 0.0),
                  _bubble(size: 15, left: 90, start: 500, delay: 0.2),
                  _bubble(size: 38, left: 150, start: 700, delay: 0.4),
                  _bubble(size: 18, left: 230, start: 580, delay: 0.1),
                  _bubble(size: 30, left: 300, start: 680, delay: 0.6),
                  _bubble(size: 12, left: 360, start: 450, delay: 0.3),
                  _bubble(size: 22, left: 420, start: 620, delay: 0.5),
                ],
              );
            },
          ),

          // =================================================
          // KONTEN
          // =================================================
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),

                Expanded(
                  child: cartItems.isEmpty
                      ? _buildEmptyCart()
                      : SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 25),
                          child: Column(
                            children: [
                              _buildCartItems(),
                              const SizedBox(height: 15),
                              _buildCoupon(),
                              const SizedBox(height: 20),
                              _buildTotal(),
                              const SizedBox(height: 20),
                              _CheckoutButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AccountPage(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // GELEMBUNG
  // =========================================================

  Widget _bubble({
    required double size,
    required double left,
    required double start,
    required double delay,
  }) {
    final progress = (_bubbleController.value + delay) % 1.0;

    final bottom = start - (progress * 750);

    final horizontalMovement = sin(progress * pi * 2) * 18;

    final opacity = progress < 0.1
        ? progress * 10
        : progress > 0.85
        ? (1 - progress) * 6.6
        : 0.8;

    return Positioned(
      left: left + horizontalMovement,
      bottom: bottom,
      child: Opacity(
        opacity: opacity.clamp(0.0, 0.8),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.22),
            border: Border.all(
              color: Colors.white.withOpacity(0.65),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.18),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Align(
            alignment: const Alignment(-0.3, -0.4),
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // APP BAR
  // =========================================================

  Widget _buildAppBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xff087BC7),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          const Expanded(
            child: Center(
              child: Text(
                'My Cart',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff087BC7),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff35CFFF), Color(0xff087BC7)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${cartItems.length} Items',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // EMPTY CART
  // =========================================================

  Widget _buildEmptyCart() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(25),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 90,
              color: Color(0xff159FE8),
            ),
            SizedBox(height: 15),
            Text(
              'Cart kamu kosong',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Tambahkan barang ke cart terlebih dahulu',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // LIST BARANG
  // =========================================================

  Widget _buildCartItems() {
    return ListView.builder(
      itemCount: cartItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = cartItems[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.94),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.14),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // GAMBAR PRODUK
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff75E3FF), Color(0xff159FE8)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item['image'],
                    width: 82,
                    height: 82,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 82,
                        height: 82,
                        color: const Color(0xffDFF7FF),
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Color(0xff159FE8),
                          size: 35,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 13),

              // INFORMASI PRODUK
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff123B55),
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      formatPrice(item['price']),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xff087BC7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffE3F8FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Quantity: ${item['quantity']}',
                        style: const TextStyle(
                          color: Color(0xff087BC7),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // TOMBOL HAPUS
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    confirmDelete(index);
                  },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // COUPON
  // =========================================================

  Widget _buildCoupon() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.discount_rounded, color: Color(0xff087BC7)),
              SizedBox(width: 8),
              Text(
                'Coupon Code',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff123B55),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan kode kupon',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(
                      Icons.discount_outlined,
                      color: Color(0xff159FE8),
                    ),
                    filled: true,
                    fillColor: const Color(0xffF0FBFF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur kupon belum terhubung ke backend'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff087BC7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TOTAL
  // =========================================================

  Widget _buildTotal() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                formatPrice(totalPrice),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                'FREE',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const Divider(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff123B55),
                ),
              ),
              Text(
                formatPrice(totalPrice),
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xff087BC7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================
// CHECKOUT BUTTON DENGAN ANIMASI
// =============================================================

class _CheckoutButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _CheckoutButton({required this.onPressed});

  @override
  State<_CheckoutButton> createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<_CheckoutButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });

        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff49D9FF), Color(0xff087BC7)],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff087BC7).withOpacity(0.45),
                blurRadius: 15,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.water_drop_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'CHECK OUT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
