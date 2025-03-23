import 'package:flutter/material.dart';
import 'package:home_ease/view/service_provider_list/page/location%20access.dart';
import 'package:home_ease/view/profile/service/profile_service.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Color.fromARGB(255, 245, 247, 247),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:  Colors.blueAccent,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: userProfileService(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error State
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/bad request.jpg', height: 200),
                  const SizedBox(height: 10),
                  Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No user profile found"));
          }

          // Extract data
          final userProfile = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/profile.jpg"),
                ),
                const SizedBox(height: 20),
                Text(
                  userProfile.username ?? "No Name",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.email, color: Colors.blueAccent),
                    title: Text(userProfile.email ?? "No Email"),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_history, color: Colors.blueAccent),
                    title: Text(userProfile.address ?? "Address"),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.phone, color: Colors.blueAccent),
                    title: Text(userProfile.phone ?? "No Phone Number"),
                  ),
                ),
                const SizedBox(height: 20), // Add spacing
               // Feedback Button
                // SizedBox(
                //   width: double.infinity, // Make the button full width
                //   child: ElevatedButton(
                //     onPressed: () {
                //       // Handle feedback button press
                //       Navigator.push(
                //                       context,
                //                       MaterialPageRoute(
                //                         builder: (context) =>
                //                              GeolocatorRepairPage(),
                //                       ),
                //                     );

                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color.fromARGB(255, 100, 4, 117), // Purple color
                //       padding: const EdgeInsets.symmetric(vertical: 16), // Add padding
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8), // Rounded corners
                //       ),
                //     ),
                //     child: const Text(
                //       "Give Feedback",
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 16,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

  
}