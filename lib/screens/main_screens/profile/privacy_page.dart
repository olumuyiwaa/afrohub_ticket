import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          Text(
              "At our company, we take user privacy very seriously, especially in the context of our event mobile app. We understand that our users trust us with their personal information, and we strive to uphold that trust by implementing strict privacy policies and security measures. Our event mobile app is designed to collect only the data necessary to provide our users with a seamless event experience, such as event registration information, schedule preferences, and contact details for event organizers. We use industry-standard security protocols to protect this information, including encryption and multi-factor authentication, to ensure that our users' data is kept safe and confidential."),
          SizedBox(
            height: 16,
          ),
          Text(
              "Furthermore, we believe in giving our users control over their own privacy settings. Our event mobile app includes granular privacy settings that allow users to choose which information they want to share with other attendees, event organizers, and sponsors. We also make it easy for users to opt-out of any marketing communications they do not wish to receive."),
          SizedBox(
            height: 16,
          ),
          Text(
              "Finally, we never share our users' personal information with third parties, except where required by law. We believe in being transparent about our data collection and sharing practices, and we provide detailed privacy policies that explain how we collect, use, and share our users' data. We are committed to maintaining the highest standards of data security and privacy for our users, and we will continue to innovate and improve our event mobile app to ensure that it meets the evolving needs of our users in a privacy-respecting way."),
        ],
      ),
    );
  }
}
