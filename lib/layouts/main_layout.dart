import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/tugas_screen.dart';
import '../screens/lapor_screen.dart';

class MainLayout extends StatefulWidget {
  final Map<String, dynamic> studentData;
  const MainLayout({super.key, required this.studentData});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Data dilempar dari Layout ke masing-masing Halaman
    _pages = [
      HomeScreen(data: widget.studentData),
      TugasScreen(tugasList: widget.studentData['tugas'] ?? [], tahfidzList: widget.studentData['tahfidz'] ?? []),
      const LaporScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))]),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF3F62E2),
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Beranda'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Akademik'),
              BottomNavigationBarItem(icon: Icon(Icons.support_agent_rounded), label: 'Bantuan'),
            ],
          ),
        ),
      ),
    );
  }
}