import 'package:flutter/material.dart';

class LoginGoogleScreen extends StatelessWidget {
  const LoginGoogleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login with Google')),
      body: const Center(
        child: Text(
          'Halaman login menggunakan akun Google (belum diimplementasi)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
