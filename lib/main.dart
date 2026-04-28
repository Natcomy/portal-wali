import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const PortalGuruApp());
}

class PortalGuruApp extends StatelessWidget {
  const PortalGuruApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal Guru',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3F62E2),
          primary: const Color(0xFF10B981),
          secondary: const Color(0xFF3B82F6), 
          background: const Color(0xFFF8FAFC), 
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        useMaterial3: true,
        fontFamily: 'Plus Jakarta Sans', 
      ),
      home: const LoginScreen(),
    );
  }
}