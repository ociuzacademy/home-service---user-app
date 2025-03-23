import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:home_ease/view/home_screen/model/category_list_model.dart';
import 'package:home_ease/view/home_screen/service/category_service.dart';
import 'package:home_ease/view/subservice_view/page/subservice_view.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Service App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 188, 205, 241),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(41, 107, 239, 1),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Home Screen if needed
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                // Navigate to History Screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                // Add logout logic here
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Welcome Text
              const Text(
                'Welcome Ardra !',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(41, 107, 239, 1),
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),

              // Carousel Slider
              _buildCarouselSlider(),

              const SizedBox(height: 20),

              // Services List Header
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Our Services',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(41, 107, 239, 1),
                  ),
                ),
              ),

              // Services Horizontal List
              _buildServicesList(),

              const SizedBox(height: 30),
              const Text(
                'Need instant help? Contact us now!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        autoPlayAnimationDuration: const Duration(seconds: 1),
      ),
      items: [
        'assets/images/home_intro1.jpg',
        'assets/images/home_intro2.jpg',
        'assets/images/home_intro3.jpg',
      ].map((imageUrl) {
        return Container(
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildServicesList() {
    return FutureBuilder<List<CategoryListModel>>(
      future: categoryListService(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                Image.asset('assets/images/bad request.jpg'),
                Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Retry logic
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No service found"),
          );
        }

        List<CategoryListModel> categories = snapshot.data!;
        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ServicesListPage(category_id: category.id.toString()),
                              ),
                            );
                 
                },
                child: Container(
                  width: 150,
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(41, 107, 239, 1),
                        Color.fromARGB(255, 135, 187, 247),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      category.category!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}