class Event {
  final String id;
  final String? image;
  final String title;
  final String location;
  final String address;
  final String description;
  final String date;
  final String time;
  final String price;
  final String category;
  final double? longitude;
  final double? latitude;
  final int unit;

  Event({
    required this.id,
    this.image,
    required this.title,
    this.longitude,
    this.latitude,
    required this.location,
    required this.address,
    required this.description,
    required this.date,
    required this.time,
    required this.price,
    required this.category,
    required this.unit,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      image: json['image'],
      title: json['title'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'] ?? "No Address",
      description: json['description'] ?? "No Description",
      date: json['date'] ?? "No Date",
      time: json['time'] ?? "No time",
      price: json['price'],
      category: json['category'],
      unit: json['unit'] ?? 0,
    );
  }
}
