import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_get.dart';
import '../../../model/class_countries.dart';
import '../../../utilities/buttons/button_big.dart';
import '../../../utilities/buttons/notification_button.dart';
import 'country_page.dart';
import 'create_country.dart';

class AfricanCountriesPage extends StatefulWidget {
  const AfricanCountriesPage({super.key});

  @override
  State<AfricanCountriesPage> createState() => _AfricanCountriesPageState();
}

class _AfricanCountriesPageState extends State<AfricanCountriesPage> {
  late Future<List<Country>> featuredEvents;

  String? username;
  bool _isLoading = true;
  List<Country> countries = [];

  Future<void> _loadCountries() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedCountries = await getCountries();
      setState(() {
        countries = fetchedCountries.toList();
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
    Future.wait([getUserInfo(), _loadCountries()]);
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fetchedName = prefs.getString('full_name');
    setState(() {
      username = fetchedName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "African Countries",
          style: TextStyle(fontSize: 18),
        ),
        actions: const [
          NotificationButton(),
          SizedBox(
            width: 8,
          )
        ],
      ),
      body: ListView(children: [
        const SizedBox(
          height: 20,
        ),
        InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const CreateCountry()));
            },
            child: const ButtonBig(
              buttonText: 'Upload New Country Details',
              isGradient: true,
            )),
        const SizedBox(
          height: 12,
        ),
        _isLoading
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    const SizedBox(height: 240),
                    Lottie.asset(
                      'assets/lottie/loading.json',
                      fit: BoxFit.cover,
                    )
                  ]))
            : countries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 240),
                        SvgPicture.asset(
                          'assets/svg/africa.svg',
                          width: 180,
                          color: const Color(0xff869FAC),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text('No Country Information Available'),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      mainAxisExtent: 140,
                    ),
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      final country = countries[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CountryPage(
                                        countryId: country.id,
                                      )));
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.maxFinite,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                child: _buildImage(
                                  country.image,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              country.title,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ]),
    );
  }

  Widget _buildImage(String image) {
    // Check if the image is a URL
    if (image.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: image,
        placeholder: (context, url) => Lottie.asset(
          'assets/lottie/image.json',
          fit: BoxFit.cover,
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.photo,
          size: 32,
          color: Colors.grey,
        ),
        fit: BoxFit.cover,
      );
    } else {
      // Handle base64 image
      try {
        // Remove data URL prefix if present
        String base64String = image;
        if (image.contains(',')) {
          base64String = image.split(',')[1];
        }

        // Remove any whitespace
        base64String = base64String.trim();

        // Add padding if needed
        int paddingLength = 4 - (base64String.length % 4);
        if (paddingLength < 4) {
          base64String += '=' * paddingLength;
        }

        // Decode base64
        final Uint8List decodedBytes = base64Decode(base64String);

        // Verify the decoded data is actually an image
        if (decodedBytes.isEmpty) {
          throw Exception('Empty image data');
        }

        return Image.memory(
          decodedBytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Error loading image: $error');
            return const Icon(
              Icons.photo,
              color: Colors.grey,
              size: 32,
            );
          },
        );
      } catch (e) {
        debugPrint('Error decoding base64 image: $e');
        return const Icon(
          Icons.photo,
          color: Colors.grey,
          size: 32,
        );
      }
    }
  }
}
