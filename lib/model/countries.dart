class Country {
  final String id;
  final String image;
  final String title;
  final String president;
  final String independenceDate;
  final String capital;
  final String currency;
  final String population;
  final String demonym;
  final double? latitude;
  final double? longitude;
  final String description;
  final String language;
  final String timeZone;
  final String link;
  final String associationLeaderName;
  final String associationLeaderEmail;
  final String associationLeaderPhone;
  final String associationLeaderPhoto;
  final String createdById;

  Country({
    required this.id,
    required this.image,
    required this.title,
    required this.president,
    required this.independenceDate,
    required this.capital,
    required this.currency,
    required this.population,
    required this.demonym,
    this.latitude,
    this.longitude,
    required this.description,
    required this.language,
    required this.timeZone,
    required this.link,
    required this.associationLeaderName,
    required this.associationLeaderEmail,
    required this.associationLeaderPhone,
    required this.associationLeaderPhoto,
    required this.createdById,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['_id'] ?? "",
      image: json['image'] ?? "",
      title: json['title'] ?? "",
      president: json['president'] ?? "",
      independenceDate: json['independenceDate'] ?? "",
      capital: json['capital'] ?? "",
      currency: json['currency'] ?? "",
      population: json['population'] ?? "",
      demonym: json['demonym'] ?? "",
      latitude: json['latitude'],
      longitude: json['longitude'],
      description: json['description'] ?? "",
      language: json['language'] ?? "",
      timeZone: json['time_zone'] ?? "",
      link: json['link'] ?? "",
      associationLeaderName: json['association_leader_name'] ?? "",
      associationLeaderEmail: json['association_leader_email'] ?? "",
      associationLeaderPhone: json['association_leader_phone'] ?? "",
      associationLeaderPhoto: json['association_leader_photo'] ?? "",
      createdById: json['created_by_id'] ?? "",
    );
  }
}
