import 'package:carbon_music/features/home/presentation/search_screen.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      body: Center(
        child: Text(
          'HOME FEED\nCOMING SOON',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black45, letterSpacing: 2),
        ),
      ),
    ),
    const HomeScreen(),
    const Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      body: Center(
        child: Text(
          'YOUR LIBRARY\nCOMING SOON',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black45, letterSpacing: 2),
        ),
      ),
    ),
    
    const Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      body: Center(
        child: Text(
          'USER PROFILE\nCOMING SOON',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black45, letterSpacing: 2),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          border: Border(
            top: BorderSide(color: Colors.black.withValues(alpha: 0.05), width: 1),
          ),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.black38,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, height: 1.5),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, height: 1.5),
            items: const [
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home_rounded)), 
                label: 'Home'
              ),
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.search_rounded)), 
                label: 'Search'
              ),
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.library_music_rounded)), 
                label: 'Library'
              ),
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person_rounded)), 
                label: 'Profile'
              ),
            ],
          ),
        ),
      ),
    );
  }
}