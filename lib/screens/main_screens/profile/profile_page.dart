import 'package:afrohub/provider/auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utilities/const.dart';
import '../../not_found_page.dart';
import '../event_management/ticket_shop.dart';
import 'change_password.dart';
import 'edit_profile.dart';
import 'privacy_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final Map<dynamic, dynamic> user = {
    "name": "Full Name",
    "image":
        "https://media.licdn.com/dms/image/v2/D4D03AQHT47BuaMJRTg/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1713186951164?e=1739404800&v=beta&t=Yw8rKZ6jIeB8tfEyFbWM4PdNGnd6N_lcpyzwVL6D2NQ",
    "email": "oladoyinemmanuel@gmail.com",
    "phone": "123456789",
    "interests": [
      "football",
      "comedy",
      "concert",
      "trophy",
      "tour",
      "festival",
    ],
  };

  @override
  Widget build(BuildContext context) {
    Future<void> _signOut() async {
      signOut(password: '123456789', context: context, email: user["email"]);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              _signOut;
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(10),
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
                        user["name"],
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
                                user["email"],
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
                                user["phone"],
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
                                mainAxisExtent: 36,
                              ),
                              itemCount: user["interests"].length,
                              itemBuilder: (context, index) {
                                final interest = user["interests"][index];

                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: accentColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/img/$interest.png", // Corrected asset path
                                        width: 20,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        interest[0].toUpperCase() +
                                            interest.substring(
                                                1), // Correct capitalization
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: accentColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                );
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
                                      EditProfile()));
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
              title: 'Ticket Shop',
              icon: 'shop.svg',
              destinationPage: const TicketShop()),
          buildSettingsTile(
              context: context,
              title: 'Change Password',
              icon: 'password.svg',
              destinationPage: const ChangePassword()),
          buildSettingsTile(
              context: context,
              title: 'Payment Method',
              icon: 'card.svg',
              destinationPage: const NotFoundPage()),
          buildSettingsTile(
              context: context,
              title: 'Privacy',
              icon: 'privacy.svg',
              destinationPage: const PrivacyPage()),
          buildSettingsTile(
              context: context,
              title: 'Help',
              icon: 'info.svg',
              destinationPage: const NotFoundPage()),
          buildSettingsTile(
              context: context,
              title: 'Deactivate Account',
              icon: 'profile2.svg',
              destinationPage: const NotFoundPage()),
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
