import 'package:afrohub/screens/main_screens/profile/account_deactivation_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/auth.dart';
import '../../../utilities/const.dart';
import '../event_management/ticket_shop.dart';
import '../tickets/tickets.dart';
import 'change_password.dart';
import 'edit_profile.dart';
import 'help.dart';
import 'privacy_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userEmail;
  String? userName;
  String? userPhone;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('email');
      userName = prefs.getString('full_name');
      userPhone = prefs.getString('phone_number');
    });
  }

  final Map<dynamic, dynamic> user = {
    "image": "",
    "interests": [
      "All Africa",
      "Western Africa",
      "Nigeria",
      "Ghana",
      "South Africa",
      "Egypt",
    ],
  };

  @override
  Widget build(BuildContext context) {
    Future<void> signUserOut() async {
      signOut(
        context: context,
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              signUserOut();
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
                          child: CachedNetworkImage(
                            imageUrl: user["image"],
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              color: accentColor,
                            ),
                            errorWidget: (context, url, error) =>
                                SvgPicture.asset('assets/svg/usericon.svg'),
                            fit: BoxFit.cover,
                          ),
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
                              Text(
                                userEmail ?? "Loading...",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
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
                              Text(
                                userPhone ?? "Loading...",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Interests',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Expanded(
                                child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                mainAxisExtent: 40,
                              ),
                              itemCount: user["interests"].length,
                              itemBuilder: (context, index) {
                                final interest = user["interests"][index];

                                return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
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
                                          overflow: TextOverflow.ellipsis,
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
}
