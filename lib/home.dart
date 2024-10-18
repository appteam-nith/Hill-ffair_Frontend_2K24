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
    Center(child: HomePage()),
    Center(child: MatchPage()),
    Center(
        child: Center(
            child: Text(
      "Games Section",
      style: TextStyle(fontSize: 30),
    ))),
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
      bottomNavigationBar: ClipRRect(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)), // Rounded edges
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Matches',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.videogame_asset),
                label: 'Game',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xff008CFF),
            unselectedItemColor: Colors.black,
            showUnselectedLabels: true,
            iconSize: 30,
            onTap: _onItemTapped,
          ),
        ),
      ),
      body: screens[_selectedIndex],
    );
  }
}
