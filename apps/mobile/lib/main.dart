import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8000',
);

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _apiStatus = 'checking';
  String _firestoreStatus = 'checking';

  @override
  void initState() {
    super.initState();
    _loadHealth();
  }

  Future<void> _loadHealth() async {
    try {
      final baseUrl = apiBaseUrl.endsWith('/')
          ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
          : apiBaseUrl;
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) {
        throw StateError('Health request returned HTTP ${response.statusCode}');
      }

      final health = jsonDecode(response.body) as Map<String, dynamic>;
      final firestore = health['firestore'];
      if (firestore != 'connected' &&
          firestore != 'unavailable' &&
          firestore != 'unconfigured') {
        throw const FormatException('Invalid Firestore health status');
      }

      if (mounted) {
        setState(() {
          _apiStatus = 'connected';
          _firestoreStatus = firestore as String;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _apiStatus = 'unavailable';
          _firestoreStatus = 'unavailable';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FEV Field App')),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Text(
              'API: $_apiStatus · Firestore: $_firestoreStatus',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
