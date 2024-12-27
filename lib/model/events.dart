class Event {
  final String id;
  final String? image;
  final String title;
  final String location;
  final String description;
  final String date;
  final String price;
  final String category;
  final int unit;

  Event({
    required this.id,
    this.image,
    required this.title,
    required this.location,
    required this.description,
    required this.date,
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
      description: json['description'] ?? "No Description",
      date: json['date'],
      price: json['price'],
      category: json['category'],
      unit: json['unit'] ?? 0,
    );
  }
}
