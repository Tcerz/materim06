import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:materim06/M07/login_screen.dart';
import 'package:materim06/M07/launch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan binding Flutter siap
  await Firebase.initializeApp(); // 🔥 Inisialisasi Firebase dulu
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Analytics Demo',
      initialRoute: '/login',
      routes: {'/login': (context) => const LoginScreen()},
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LaunchScreen(), // Panggil LaunchScreen
    );
  }
}
