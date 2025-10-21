import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Analytics Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainApp(), // 👈 Scaffold harus berada di bawah MaterialApp
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Analytics Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Analytics event triggered!')),
            );
          },
          child: const Text('Send Event'),
        ),
      ),
    );
  }
}
