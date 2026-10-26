import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecommerceapp/page/account_page.dart';
import 'package:ecommerceapp/page/cart_page.dart';
import 'package:ecommerceapp/page/home_page_content.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          //halaman home
          //Center(child: Text('Halaman utama')),
          HomePageContent(),
          CartPage(),
          AccountPage(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        height: 70,
        color: const Color.fromARGB(255, 18, 218, 244),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: const [
          Icon(Icons.home, size: 25, color: Colors.black),
          Icon(Icons.shopping_cart_checkout, size: 25, color: Colors.black),
          Icon(Icons.account_circle, size: 25, color: Colors.black),
        ],
      ),
    );
  }
}
