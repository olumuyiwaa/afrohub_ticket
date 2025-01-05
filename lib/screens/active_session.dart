import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utilities/const.dart';
import 'main_screens/african_countries/african_countries.dart';
import 'main_screens/bookmarks.dart';
import 'main_screens/home_page.dart';
import 'main_screens/map_screen.dart';
import 'main_screens/profile/profile_page.dart';

class ActiveSession extends StatefulWidget {
  final int pageIndex;

  const ActiveSession({super.key, this.pageIndex = 0});

  @override
  State<ActiveSession> createState() => _ActiveSessionState();
}

class _ActiveSessionState extends State<ActiveSession> {
  int _pageIndex = 0;
  @override
  void initState() {
    super.initState();
    _pageIndex = widget.pageIndex; // Initialize with the passed index
  }

  // Function to handle BottomNavigationBar item taps
  void _bottomNavTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  bool isView1Visible = true; // Initially show the social feed in feeds

  // Function to toggle between the views
  void toggleView() {
    setState(() {
      isView1Visible = !isView1Visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pages to display for each BottomNavigationBarItem
    final List<Widget> selectedPage = [
      const HomePage(),
      const Bookmarks(),
      const MapScreen(),
      const AfricanCountriesPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SafeArea(
          child: selectedPage[_pageIndex], // Display the selected page
        ),
      ),
      bottomNavigationBar:
          //_buildBottomBar(),
          BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        type: BottomNavigationBarType.fixed,
        onTap: _bottomNavTapped,
        currentIndex: _pageIndex,
        selectedItemColor: accentColor,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        items: [
          _buildBottomNavItem('svg/home2.svg', 'Home', 0),
          _buildBottomNavItem('svg/hearth.svg', 'Bookmarks', 1),
          _buildBottomNavItem('svg/map.svg', 'Map', 2),
          _buildBottomNavItem('svg/africa.svg', 'Afro-Wiki', 3),
          _buildBottomNavItem('svg/profile.svg', 'Profile', 4),
        ],
      ),
    );
  }

  // Function to build each BottomNavigationBarItem
  BottomNavigationBarItem _buildBottomNavItem(
      String iconPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        'assets/$iconPath',
        width: 28,
        color: _pageIndex == index ? accentColor : greyColor,
      ),
      label: label, // Dynamic label
    );
  }
}
