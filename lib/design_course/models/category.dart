import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  Category({
    this.title = '',
    this.imagePath = '',
    this.lessonCount = 0,
    this.money = 0,
    this.rating = 0.0,
  });

  String title;
  int lessonCount;
  int money;
  double rating;
  String imagePath;

  static List<Category> popularCourseList = [];

  static void addCategory(Category category) {
    popularCourseList.add(category);
  }

  Future<void> fetchPopularCourses() async {
    final collection = FirebaseFirestore.instance.collection('CoursTiceo');
    final querySnapshot = await collection.get();

    popularCourseList.clear();

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      String title = data['Nom_Module'] ?? 'Unknown';
      String imagePath = _getImagePathBasedOnTitle(title);

      final category = Category(
        title: title,
        lessonCount: data['Nb_Seances'] ?? 0,
        imagePath: imagePath,
      );
      addCategory(category);
    }
  }

  // Fonction pour obtenir le chemin de l'image basé sur le titre
  static String _getImagePathBasedOnTitle(String title) {
    if (title.toLowerCase().contains('word')) {
      return 'assets/design_course/word.jpg';
    } else if (title.toLowerCase().contains('excel')) {
      return 'assets/design_course/excel.jpg';
    } else if (title.toLowerCase().contains('point')) {
      return 'assets/design_course/pp.jpg';
    } else if (title.toLowerCase().contains('l\'ordinateur')) {
      return 'assets/design_course/base.jpg';
    } else if (title.toLowerCase().contains('mobile')) {
      return 'assets/design_course/mobile.jpg';
    } else if (title.toLowerCase().contains('internet')) {
      return 'assets/design_course/internet.jpg';
    } else if (title.toLowerCase().contains('braille')) {
      return 'assets/design_course/braille.jpg';
    } else {
      return 'assets/design_course/base.jpg';
    }
  }

  static List<Category> categoryList = <Category>[
    Category(
      imagePath: 'assets/design_course/interFace1.png',
      title: 'Introduction aux TIC ',
      lessonCount: 24,
      money: 25,
      rating: 4.3,
    ),
    Category(
      imagePath: 'assets/design_course/interFace2.png',
      title: 'Premiers pas avec un ordinateur',
      lessonCount: 22,
      money: 18,
      rating: 4.6,
    ),
    Category(
      imagePath: 'assets/design_course/04.jpg',
      title: 'Mise en route et familiarisation ',
      lessonCount: 24,
      money: 25,
      rating: 4.3,
    ),
  ];
}
