import 'package:ecommerceapp/page/cart_page.dart';
import 'package:ecommerceapp/page/change_password.dart';
import 'package:ecommerceapp/page/detail_chat.dart';
import 'package:ecommerceapp/page/list_chat.dart';
import 'package:flutter/material.dart';
import 'package:ecommerceapp/page/account_page.dart';
import 'package:ecommerceapp/page/login_page.dart';
import 'package:ecommerceapp/page/register_page.dart';
import 'package:ecommerceapp/page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 182, 155, 75),
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      routes: {
        '/login_page': (context) => const LoginPage(),
        '/sign_up_page': (context) => const RegisterPage(),
        '/account_page': (context) => const AccountPage(),
        '/change_password_page': (context) => const ChangePasswordPage(),
        '/cart_page': (context) => const CartPage(),
        '/home_page': (context) => const HomePage(),
        '/list_chat': (context) => const ChatListPage(),
        '/detail_chat': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments;
          final contactName =
              arguments is Map && arguments['contactName'] is String
              ? arguments['contactName'] as String
              : 'Anonim';
          return ChatScreen(contactName: contactName);
        },
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
