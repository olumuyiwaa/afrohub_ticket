import 'dart:convert';
import 'dart:typed_data';

import 'package:afrohub/screens/main_screens/profile/account_deactivation_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_get.dart';
import '../../../api/auth.dart';
import '../../../utilities/const.dart';
import '../event_management/ticket_shop.dart';
import '../tickets/tickets.dart';
import 'change_password.dart';
import 'edit_profile.dart';
import 'help.dart';
import 'privacy_page.dart';
import 'update_interests.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userEmail;
  String? userName;
  String userImage = "";
  String? userPhone;
  String? userID;
  List<String> userInterests = [];

  @override
  void initState() {
    super.initState();

    getUserInfo().then((_) => getUserProfile(userID));
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('email') ?? '';
      userName = prefs.getString('full_name') ?? '';
      userImage = prefs.getString('image') ?? '';
      userPhone = prefs.getString('phone_number') ?? '';
      userID = prefs.getString('id') ?? '';
      userInterests = prefs.getStringList('interests') ?? [];
    });
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
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              showLogoutDialog(context);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                'assets/svg/Logout.svg',
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          )
        ],
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        height: 254,
                        width: 254,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(400),
                            color: greyColor,
                            border: Border.all(width: 2, color: greyColor)),
                        child: Container(
                          height: 242,
                          width: 254,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(400)),
                          child: _buildImage(userImage),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        userName ?? "Loading...",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                size: 25.0,
                                color: accentColor,
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                  child: Text(
                                userEmail ?? "Loading...",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                size: 25.0,
                                color: accentColor,
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                  child: Text(
                                userPhone ?? "Loading...",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              )),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Interests',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UpdateInterests(
                                                  userID: userID!,
                                                )));
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: accentColor,
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Expanded(
                                child: userInterests.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'No interests added. Click the edit icon to add your interests.',
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      )
                                    : GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                          mainAxisExtent: 40,
                                        ),
                                        itemCount: userInterests.length,
                                        itemBuilder: (context, index) {
                                          final interest = userInterests[index];

                                          return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: accentColor,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  interest[0].toUpperCase() +
                                                      interest.substring(
                                                          1), // Correct capitalization
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 12,
                                                    color: accentColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ));
                                        },
                                      )),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                    right: 4,
                    top: 4,
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EditProfile(
                                        name: userName!,
                                        phone: userPhone!,
                                        userID: userID!,
                                      )));
                        },
                        icon: Icon(
                          Icons.edit,
                          color: accentColor,
                        )))
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Profile Settings',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 12,
          ),
          buildSettingsTile(
              context: context,
              title: 'My Ticket Shop',
              icon: 'shop.svg',
              destinationPage: const TicketShop()),
          buildSettingsTile(
              context: context,
              title: 'Change Password',
              icon: 'password.svg',
              destinationPage: const ChangePassword()),
          buildSettingsTile(
              context: context,
              title: 'My Tickets',
              icon: 'ticket.svg',
              destinationPage: Tickets()),
          buildSettingsTile(
              context: context,
              title: 'Privacy',
              icon: 'privacy.svg',
              destinationPage: const PrivacyPage()),
          buildSettingsTile(
              context: context,
              title: 'Help',
              icon: 'info.svg',
              destinationPage: const HelpPage()),
          buildSettingsTile(
              context: context,
              title: 'Deactivate Account',
              icon: 'profile2.svg',
              destinationPage: const AccountDeactivationPage()),
        ],
      ),
    );
  }

  Widget buildSettingsTile({
    required String title,
    String? icon,
    required Widget destinationPage,
    context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationPage),
          );
        },
        tileColor: Colors.white,
        leading: SvgPicture.asset(
          'assets/svg/$icon',
          width: 28,
          color: accentColor,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildImage(String image) {
    // Check if the image is a URL or a Base64 string
    if (image.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: image,
        placeholder: (context, url) => Lottie.asset(
          'assets/lottie/image.json',
          fit: BoxFit.cover,
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.person_rounded,
          size: 160,
        ),
        fit: BoxFit.cover,
      );
    } else {
      if (image.isNotEmpty) {
        final Uint8List decodedBytes = base64Decode(image);
        return Image.memory(
          decodedBytes,
          fit: BoxFit.cover,
        );
      } else {
        return const Icon(
          Icons.person_rounded,
          size: 160,
        );
      }
    }
  }
}
