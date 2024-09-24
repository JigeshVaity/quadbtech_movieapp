import 'package:flutter/material.dart';
import 'package:quadbtechapp/screen/Home.dart';
import 'package:quadbtechapp/screen/Search.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = [
    const Home(),
    const Search(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // Set the background to transparent
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white, // Color for selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}
