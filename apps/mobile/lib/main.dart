import 'package:flutter/material.dart';

void main() {
  runApp(const FevApp());
}

class FevApp extends StatelessWidget {
  const FevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FEV Field App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FEV Field App')),
      body: const Center(
        child: Text(
          'FEV Field App — scaffold OK',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
