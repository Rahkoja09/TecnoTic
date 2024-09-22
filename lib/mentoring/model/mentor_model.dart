class MentorModel {
  final String name;
  final String image;
  final String type;
  final double ratings;
  final double price;
  final MentorModel2
      details;

  MentorModel({
    required this.name,
    required this.type,
    required this.ratings,
    required this.price,
    required this.image,
    required this.details,
  });
}

class MentorModel2 {
  final String propos;
  final String accomplissement;
  final String contact;
  final double heure;

  MentorModel2({
    required this.propos,
    required this.accomplissement,
    required this.contact,
    required this.heure,
  });
}
