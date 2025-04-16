import 'package:flutter/material.dart';
import 'package:home_ease/utils/preference_value.dart';
import 'package:home_ease/view/edit_profile/page/edit_profile_page.dart';
import 'package:home_ease/view/login/page/login.dart';
import 'package:home_ease/view/profile/service/profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future userProfileFuture;

  @override
  void initState() {
    super.initState();
    userProfileFuture = userProfileService();
  }

  Future<void> _refreshProfile() async {
    setState(() {
      userProfileFuture = userProfileService();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: FutureBuilder(
          future: userProfileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return ListView(
                children: [
                  SizedBox(height: 100),
                  Center(
                    child: Column(
                      children: [
                        Image.asset('assets/images/bad request.jpg', height: 200),
                        const SizedBox(height: 10),
                        Text(
                          "Error: ${snapshot.error}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("No user profile found"));
            }

            final userProfile = snapshot.data!;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    userProfile.username ?? "No Name",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
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
                    leading:
                        const Icon(Icons.location_history, color: Colors.blueAccent),
                    title: Text(userProfile.address ?? "Address"),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.phone, color: Colors.blueAccent),
                    title: Text(userProfile.phone ?? "No Phone Number"),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage()),
                    ).then((_) => _refreshProfile());
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor:
                            const Color.fromARGB(255, 208, 235, 247),
                        child: const Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Logout"),
                            content:
                                const Text("Are you sure you want to logout?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await PreferenceValues.userLogout();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const UserLoginPage()),
                                  );
                                },
                                child: const Text("Logout"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 53, 123, 220),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
