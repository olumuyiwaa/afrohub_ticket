import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../api/api_get.dart';
import '../../../api/auth.dart';
import '../../../model/class_events.dart';
import '../../../model/class_users.dart';
import '../../../utilities/const.dart';
import '../../../utilities/search.dart';
import '../user_search.dart';

class ManageUserPage extends StatefulWidget {
  const ManageUserPage({super.key});

  @override
  State<ManageUserPage> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUserPage> {
  late Future<List<Event>> featuredEvents;
  String? username;
  String? userId;

  List<Event> _events = [];

  bool _isLoading = true;

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedEvents = await getFeaturedEvents();
      setState(() {
        _events = fetchedEvents.toList();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                signOut(
                  context: context,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage Afrohub Users',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "All Users in one place, Simplified Management..",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Search(
              hintText: 'Search for User...',
              onSubmitted: (query) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => UserSearch(
                      text: query,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),

            const Text(
              "Grant / Revoke Association Leader Access",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),

            const SizedBox(
              height: 12,
            ),
            // Adjusting for scrolling and UI
            FutureBuilder<List<User>>(
              future: fetchUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Lottie.asset(
                      'assets/lottie/loading.json',
                      fit: BoxFit.cover,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/profile.svg',
                        width: 180,
                        color: greyColor,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'No User Found',
                        style: TextStyle(color: greyColor, fontSize: 20),
                      ),
                    ],
                  ));
                } else {
                  final users = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return user.role != "admin"
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  tileColor: Colors.white,
                                  title: Text(user.fullName),
                                  subtitle: Text(user.role == "user"
                                      ? "Regular User"
                                      : "Country's Campus Association Leader"),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                      color: accentColor,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: const Color(0xFFE1E7EA),
                                        width: 2,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    child: Text(
                                      user.role == "user"
                                          ? "Grant Access"
                                          : "Revoke Access",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape
                                          .circle, // Makes the image circular
                                      color:
                                          greyColor, // Background color for cases without an image
                                    ),
                                    child: user.image != null
                                        ? ClipOval(
                                            child: Image.memory(
                                              base64Decode(user.image!),
                                              fit: BoxFit
                                                  .cover, // Ensures image fits within the container
                                              width:
                                                  40, // Matches container width
                                              height:
                                                  40, // Matches container height
                                            ),
                                          )
                                        : const Icon(
                                            Icons.person,
                                            size:
                                                24, // Adjust size for better fit
                                            color: Colors
                                                .white, // Use grey color to indicate no image
                                          ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  );
                }
              },
            )
          ],
        ));
  }
}
