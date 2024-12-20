import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 10),
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildFaqItem(
            question: 'How do I reset my password?',
            answer:
                'Go to the login screen, click "Forgot Password," and follow the instructions sent to your email.',
          ),
          _buildFaqItem(
            question: 'How do I contact customer support?',
            answer:
                'You can contact us via email at support@example.com or call +1 234 567 890.',
          ),
          _buildFaqItem(
            question: 'Why am I not receiving notifications?',
            answer:
                'Ensure notifications are enabled for the app in your device settings.',
          ),
          const SizedBox(height: 20),
          const Text(
            'Need more help?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            tileColor: Colors.white,
            leading: const Icon(Icons.email, color: Colors.blue),
            title: const Text('Email Support'),
            subtitle: const Text('support@afrohub.com'),
            onTap: () {
              _openEmail();
            },
          ),
          const SizedBox(height: 8),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            tileColor: Colors.white,
            leading: const Icon(Icons.phone, color: Colors.green),
            title: const Text('Call Support'),
            subtitle: const Text('+1 234 567 890'),
            onTap: () {
              _callPhoneNumber();
            },
          ),
          const SizedBox(height: 8),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            tileColor: Colors.white,
            leading: const Icon(Icons.language, color: Colors.orange),
            title: const Text('Visit Our Website'),
            subtitle: const Text('www.afrohub.com'),
            onTap: () {
              _openWebsite();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _openEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@afrohub.com',
      query: 'subject=Help Needed',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  void _callPhoneNumber() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+1234567890',
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(
        phoneUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Device cannot make phone calls';
    }
  }

  void _openWebsite() async {
    final Uri websiteUri = Uri(
      scheme: 'https',
      path: 'www.afrohub.com',
      query: 'subject=Help Needed',
    );
    if (await canLaunchUrl(websiteUri)) {
      await launchUrl(websiteUri);
    } else {
      throw 'Could not launch $websiteUri';
    }
  }
}
