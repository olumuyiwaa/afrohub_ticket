import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../utilities/buttons/button_big.dart';
import 'create_event.dart';
import 'event_details.dart';

class TicketShop extends StatefulWidget {
  const TicketShop({super.key});

  @override
  State<TicketShop> createState() => _TicketShopState();
}

class _TicketShopState extends State<TicketShop> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmNewPassword = TextEditingController();

  String? _validateConfirmPassword(String? value) {
    if (value != newPassword.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _updatePassword() async {
    if (newPassword.text != confirmNewPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      // await updatePassword(
      //   context: context,
      //   oldPassword: currentPassword.text,
      //   newPassword: newPassword.text,
      //   confirmPassword: confirmNewPassword.text,
      // );
      // ignore: empty_catches
    } catch (e) {}
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Hub For Ticket Sales',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Seamless Ticketing, Simplified Management..",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const CreateEvent()));
                  },
                  child: const ButtonBig(
                    buttonText: 'Create New Event',
                    isGradient: true,
                  )),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Your Posted Events",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: events.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 8.0, // Spacing between columns
                    mainAxisSpacing: 8.0, // Spacing between rows
                    childAspectRatio:
                        0.74, // Adjust based on desired card height
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EventDetails(
                                        eventID: events[index]["id"],
                                      )));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              height: 152,
                              width: 240,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: events[index]["image"],
                                placeholder: (context, url) => Lottie.asset(
                                  'assets/lottie/image.json',
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.photo,
                                  size: 32,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              maxLines: 1,
                              events[index]["title"],
                              style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  events[index]["location"],
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                Text(
                                  events[index]["date"],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$ ${events[index]['price']}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  events[index]["category"],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
