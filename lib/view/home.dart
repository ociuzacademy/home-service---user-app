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
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
        children: [
          UserHomeScreen(),
          BookingScreen(),
          HistoryPage(),
          ProfilePage(),
         
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.stairs), label: "Bookings"),
           BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 65, 129, 225),
        unselectedItemColor: Colors.grey,
        enableFeedback: false,
        selectedFontSize: 13,
        iconSize: 20,
        showSelectedLabels: true,
        
      ),
    );
  }
}


