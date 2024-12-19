import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utilities/buttons/button_big.dart';
import '../../utilities/buttons/filter_button.dart';
import '../../utilities/buttons/notification_button.dart';
import '../../utilities/const.dart';
import '../../utilities/search.dart';
import '../../utilities/widget/event_card_2.dart';
import '../../utilities/widget/upcoming_events.dart';
import 'category_page.dart';
import 'event/event_page.dart';
import 'event_management/create_event.dart';
import 'view_all.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fetchedName = prefs.getString('full_name');
    setState(() {
      username = fetchedName;
    });
  }

  final List<Map<String, dynamic>> events = [
    {
      "id": 23,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3FdiefHi1pKopD0GEjrsvTLdsyRkuQyuI8hY-hGz3sbHK7bQXB6DibAQIw7te01HQWzg&usqp=CAU",
      "title": "National Swimming Championship",
      "location": "Olympic Aquatic Center, New York",
      "date": "15/07/2024",
      "price": 0,
      "category": "Sport"
    },
    {
      "id": 23,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReqfjoeAkDO53XOlQENMS5j4ZCdLwEoH8uJg&s",
      "title": "Live Music Festival 2024",
      "location": "Madison Square Garden, NY",
      "date": "21/08/2024",
      "price": 50,
      "category": "Concert"
    },
    {
      "id": 23,
      "image":
          "https://www.prayerleader.com/wp-content/uploads/2018/07/ChurchPhoto1-300x199.jpg",
      "title": "Global Prayer Conference",
      "location": "Grace Cathedral, San Francisco",
      "date": "12/09/2024",
      "price": 10,
      "category": "Religious"
    },
    {
      "id": 23,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRaLU9ag8nnEE-cmo6pDBw27nZq1BX4G8GXvA&s",
      "title": "Broadway Night Live",
      "location": "Times Square Theater, NYC",
      "date": "05/11/2024",
      "price": 75,
      "category": "Others"
    },
    {
      "id": 23,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5359eym939w_qE9PVlRFCOcpYDN4u9hqb7A&s",
      "title": "Spring Cultural Festival",
      "location": "Downtown Park, Chicago",
      "date": "01/04/2024",
      "price": 20,
      "category": "Festival"
    },
    {
      "id": 23,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTh1GQlfqFZhKefMjkBfW77y-riPZDbh8CxkA&s",
      "title": "Tech Innovators Expo 2024",
      "location": "Silicon Valley Convention Center, CA",
      "date": "12/10/2024",
      "price": 15,
      "category": "Others"
    },
    {
      "id": 23,
      "image":
          "https://phantom-marca.unidadeditorial.es/7522815a30b944c9d938e89fd75c0f7f/crop/0x0/2037x1358/resize/1200/f/webp/assets/multimedia/imagenes/2024/03/15/17105161181018.png",
      "title": "Champions League Final",
      "location": "Wembley Stadium, London",
      "date": "18/06/2024",
      "price": 150,
      "category": "Sport"
    },
    {
      "id": 23,
      "image":
          "https://u100s.s3.amazonaws.com/articles_images/i2/1486334255202/image.jpg",
      "title": "International Food Carnival",
      "location": "Central Plaza, LA",
      "date": "27/08/2024",
      "price": 5,
      "category": "Festival"
    },
    {
      "id": 23,
      "image":
          "https://www.bellegroveplantation.com/wp-content/uploads/2023/03/bigstock-Professional-Dslr-Camera-And-L-467472545-1024x683.jpg",
      "title": "Photography Workshop 101",
      "location": "Art Institute of Chicago",
      "date": "11/07/2024",
      "price": 30,
      "category": "Others"
    },
    {
      "id": 23,
      "image":
          "https://s1.ticketm.net/dam/a/12d/91bd5a60-ac04-4601-8d73-99456c65c12d_RETINA_PORTRAIT_3_2.jpg",
      "title": "Rock Legends Reunion Tour",
      "location": "Hollywood Bowl, LA",
      "date": "10/05/2024",
      "price": 80,
      "category": "Concert"
    },
  ];

  final List<String> categories = [
    "swimming",
    "game",
    "football",
    "comedy",
    "concert",
    "trophy",
    "tour",
    "festival",
    "study",
    "party",
    "olympic",
    "culture"
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'Welcome Back!',
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.waving_hand,
                      color: Colors.orangeAccent,
                      size: 16,
                    ),
                  ],
                ),
                Text(
                  username ?? 'Loading...',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const NotificationButton()
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Search(
              hintText: 'Search for ticket...',
            )),
            SizedBox(
              width: 16,
            ),
            FilterButton()
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const CreateEvent()));
            },
            child: const ButtonBig(
              buttonText: 'Create New Event',
              isGradient: true,
            )),
        const SizedBox(
          height: 12,
        ),
        UpcomingEvents(),
        const SizedBox(
          height: 16,
        ),
        const Text(
          "View By Category",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 12,
        ),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: 36,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => CategoryPage(
                                  title: category,
                                )));
                  },
                  child: Container(
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
                          "assets/img/$category.png", // Corrected asset path
                          width: 20,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          category[0].toUpperCase() +
                              category.substring(1), // Correct capitalization
                          style: TextStyle(
                            fontSize: 13,
                            color: accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ));
            },
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Featured Events",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(lightColor),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ViewAll(
                              title: "Featured Events",
                              events: events,
                            )));
              },
              child: Text(
                "View All",
                style: TextStyle(color: accentColor),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length < 10 ? events.length : 10,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 8.0, // Spacing between columns
            mainAxisSpacing: 8.0, // Spacing between rows
            childAspectRatio: 0.74, // Adjust based on desired card height
          ),
          itemBuilder: (context, index) {
            final event = events[index];
            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => EventPage(
                                eventId: event["id"],
                              )));
                },
                child: EventCard2(
                  title: event["title"],
                  image: event["image"],
                  location: event["location"],
                  date: event["date"],
                  price: event["price"].toString(),
                  category: event["category"],
                ));
          },
        ),
      ],
    );
  }
}
