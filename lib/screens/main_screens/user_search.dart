import 'dart:convert';

import 'package:afrohub/utilities/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../api/api_get.dart';
import '../../model/class_users.dart';
import '../../utilities/search.dart';

class UserSearch extends StatefulWidget {
  final String text;

  const UserSearch({super.key, required this.text});

  @override
  State<UserSearch> createState() => _SearchResultState();
}

class _SearchResultState extends State<UserSearch> {
  // Searched and all events lists
  List<User> searchedUsers = [];
  List<User> allUsers = [];
  final initalQuery = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  /// Loads events and performs the search
  Future<void> _loadUsers() async {
    try {
      final fetchedUsers = await fetchUsers();
      setState(() {
        allUsers = fetchedUsers.toList();
        _searchUsers();
      });
    } catch (e) {
      // Handle error if fetching events fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load events')),
      );
    }
  }

  /// Filters events based on the search text
  void _searchUsers() {
    setState(() {
      searchedUsers = allUsers
          .where((user) =>
              user.name.toLowerCase().contains(widget.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    initalQuery.text = widget.text;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Search(
              searchController: initalQuery,
              hintText: 'Search for ticket...',
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
            )),
            const SizedBox(width: 12),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CloseButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  color: Colors.red,
                ))
          ],
        ),
      ),
      body: searchedUsers.isEmpty
          ? Center(
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
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: searchedUsers.length,
              itemBuilder: (context, index) {
                final user = searchedUsers[index];

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
                              shape:
                                  BoxShape.circle, // Makes the image circular
                              color:
                                  greyColor, // Background color for cases without an image
                            ),
                            child: user.image != null
                                ? ClipOval(
                                    child: Image.memory(
                                      base64Decode(user.image!),
                                      fit: BoxFit
                                          .cover, // Ensures image fits within the container
                                      width: 40, // Matches container width
                                      height: 40, // Matches container height
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 24, // Adjust size for better fit
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
}
