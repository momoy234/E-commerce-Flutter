import 'package:flutter/material.dart';

class CartItemSamples extends StatefulWidget {
  const CartItemSamples({super.key});

  @override
  State<CartItemSamples> createState() => _CartItemSamplesState();
}

class _CartItemSamplesState extends State<CartItemSamples> {
  final List<_CartProduct> _products = [
    _CartProduct(name: 'Produk 1', price: 125000),
    _CartProduct(name: 'Produk 2', price: 89000),
    _CartProduct(name: 'Produk 3', price: 150000),
    _CartProduct(name: 'Produk 4', price: 75000),
    _CartProduct(name: 'Produk 5', price: 210000),
    _CartProduct(name: 'Produk 6', price: 99000),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final product in _products)
          Container(
            height: 110,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.asset('assets/images/1.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp ${product.price}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          _quantityButton(
                            icon: Icons.remove,
                            onPressed: product.quantity > 1
                                ? () => setState(() => product.quantity--)
                                : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text('${product.quantity}'),
                          ),
                          _quantityButton(
                            icon: Icons.add,
                            onPressed: () => setState(() => product.quantity++),
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Hapus produk',
                            visualDensity: VisualDensity.compact,
                            constraints: const BoxConstraints.tightFor(
                              width: 36,
                              height: 36,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () =>
                                setState(() => _products.remove(product)),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                              size: 20,
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
    );
  }

  Widget _quantityButton({required IconData icon, VoidCallback? onPressed}) {
    return SizedBox(
      width: 28,
      height: 28,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        icon: Icon(icon, size: 17),
      ),
    );
  }
}

class _CartProduct {
  _CartProduct({required this.name, required this.price});

  final String name;
  final int price;
  int quantity = 1;
}
