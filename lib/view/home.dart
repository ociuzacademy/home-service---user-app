import 'package:flutter/material.dart';
import 'package:home_ease/view/all_history/page/history_page.dart';
import 'package:home_ease/view/view_bookings/page/history_screen.dart';
import 'package:home_ease/view/home_screen/page/home_screen.dart';
import 'package:home_ease/view/profile/page/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const [
          UserHomeScreen(),
          BookingScreen(),
          HistoryPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.book_online), label: "Bookings"),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: const Color.fromARGB(255, 41, 107, 239),
            unselectedItemColor: const Color.fromARGB(255, 130, 130, 130),
            backgroundColor: const Color.fromARGB(255, 216, 225, 247),
            selectedFontSize: 14,
            unselectedFontSize: 12,
            iconSize: 24,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
          ),
        ),
      ),
    );
  }
}