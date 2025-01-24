import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:hillfair/screens/home_page.dart';
import 'package:hillfair/screens/login_screen.dart';
import 'package:hillfair/screens/matches_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> screens = [
    HomePage(),
    MatchPage(),
    Center(
      child: Text(
        "Games Section",
        style: TextStyle(fontSize: 30),
      ),
    ),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          screens[_selectedIndex],
          // Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CurvedNavigationBar(
              items: const <Widget>[
                Icon(Icons.home),
                Icon(Icons.business),
                Icon(Icons.videogame_asset),
              ],
              index: _selectedIndex,
              backgroundColor:
                  Colors.transparent, // Make background transparent
              color: Color(0xffF3CBB6), // Navigation bar color
              buttonBackgroundColor:
                  Colors.white, // Button color
              onTap: _onItemTapped,
              height: 60,
              animationCurve: Curves.fastEaseInToSlowEaseOut,
            ),
          ),
        ],
      ),
    );
  }
}
