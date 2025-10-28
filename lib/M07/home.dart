import 'package:flutter/material.dart';
import 'package:materim06/M07/auth.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  const HomeScreen(this.uid, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? email;
  Auth auth = Auth();

  @override
  void initState() {
    super.initState();
    auth.getUSer().then((user) {
      setState(() {
        email = user?.email;
      });
    });
  }

  Future<void> _logout() async {
    await auth.signOut(); // pastikan ada di auth.dart
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login'); // arahkan ke MyLogin
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'User ID: ${widget.uid}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              email != null ? 'Email: $email' : 'Memuat email...',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
