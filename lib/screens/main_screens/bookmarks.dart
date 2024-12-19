import 'package:flutter/material.dart';

import '../../utilities/buttons/notification_button.dart';
import '../../utilities/widget/event_card.dart';
import 'event/event_page.dart';

class Bookmarks extends StatelessWidget {
  Bookmarks({super.key});
  final List<Map<String, dynamic>> events = [
    {
      "id": 12,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3FdiefHi1pKopD0GEjrsvTLdsyRkuQyuI8hY-hGz3sbHK7bQXB6DibAQIw7te01HQWzg&usqp=CAU",
      "title": "National Swimming Championship",
      "location": "Olympic Aquatic Center, New York",
      "date": "15/07/2024",
      "price": 0,
      "category": "Sport"
    },
    {
      "id": 12,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReqfjoeAkDO53XOlQENMS5j4ZCdLwEoH8uJg&s",
      "title": "Live Music Festival 2024",
      "location": "Madison Square Garden, NY",
      "date": "21/08/2024",
      "price": 50,
      "category": "Concert"
    },
    {
      "id": 12,
      "image":
          "https://www.prayerleader.com/wp-content/uploads/2018/07/ChurchPhoto1-300x199.jpg",
      "title": "Global Prayer Conference",
      "location": "Grace Cathedral, San Francisco",
      "date": "12/09/2024",
      "price": 10,
      "category": "Religious"
    },
    {
      "id": 12,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRaLU9ag8nnEE-cmo6pDBw27nZq1BX4G8GXvA&s",
      "title": "Broadway Night Live",
      "location": "Times Square Theater, NYC",
      "date": "05/11/2024",
      "price": 75,
      "category": "Others"
    },
    {
      "id": 12,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5359eym939w_qE9PVlRFCOcpYDN4u9hqb7A&s",
      "title": "Spring Cultural Festival",
      "location": "Downtown Park, Chicago",
      "date": "01/04/2024",
      "price": 20,
      "category": "Festival"
    },
    {
      "id": 12,
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTh1GQlfqFZhKefMjkBfW77y-riPZDbh8CxkA&s",
      "title": "Tech Innovators Expo 2024",
      "location": "Silicon Valley Convention Center, CA",
      "date": "12/10/2024",
      "price": 15,
      "category": "Others"
    },
    {
      "id": 12,
      "image":
          "https://phantom-marca.unidadeditorial.es/7522815a30b944c9d938e89fd75c0f7f/crop/0x0/2037x1358/resize/1200/f/webp/assets/multimedia/imagenes/2024/03/15/17105161181018.png",
      "title": "Champions League Final",
      "location": "Wembley Stadium, London",
      "date": "18/06/2024",
      "price": 150,
      "category": "Sport"
    },
    {
      "id": 12,
      "image":
          "https://u100s.s3.amazonaws.com/articles_images/i2/1486334255202/image.jpg",
      "title": "International Food Carnival",
      "location": "Central Plaza, LA",
      "date": "27/08/2024",
      "price": 5,
      "category": "Festival"
    },
    {
      "id": 12,
      "image":
          "https://www.bellegroveplantation.com/wp-content/uploads/2023/03/bigstock-Professional-Dslr-Camera-And-L-467472545-1024x683.jpg",
      "title": "Photography Workshop 101",
      "location": "Art Institute of Chicago",
      "date": "11/07/2024",
      "price": 30,
      "category": "Others"
    },
    {
      "id": 12,
      "image":
          "https://s1.ticketm.net/dam/a/12d/91bd5a60-ac04-4601-8d73-99456c65c12d_RETINA_PORTRAIT_3_2.jpg",
      "title": "Rock Legends Reunion Tour",
      "location": "Hollywood Bowl, LA",
      "date": "10/05/2024",
      "price": 80,
      "category": "Concert"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          NotificationButton(),
          SizedBox(
            width: 8,
          )
        ],
        title: const Text(
          'Bookmarks',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          final event = events[index];
          return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => EventPage(
                                eventId: event["id"],
                              )));
                },
                child: EventCard(
                  image: event["image"],
                  title: event["title"],
                  location: event["location"],
                  date: event["date"],
                  category: event["category"],
                  price: event["price"].toString(),
                ),
              ));
        },
      ),
    );
  }
}
