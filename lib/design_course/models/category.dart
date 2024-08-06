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
    // Category(
    //   imagePath: 'assets/design_course/interFace2.png',
    //   title: 'User interface Design',
    //   lessonCount: 22,
    //   money: 18,
    //   rating: 4.6,
    // ),
  ];

  static List<Category> popularCourseList = <Category>[
    Category(
      imagePath: 'assets/design_course/base.jpg',
      title: "Utilisation de base de l'ordinateur ",
      lessonCount: 12,
      money: 25,
      rating: 4.8,
    ),
    Category(
      imagePath: 'assets/design_course/word.jpg',
      title: 'Traitement de texte avec Microsoft Word ',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
    Category(
      imagePath: 'assets/design_course/excel.jpg',
      title: 'Tableur avec Microsoft Excel ',
      lessonCount: 12,
      money: 25,
      rating: 4.8,
    ),
    Category(
      imagePath: 'assets/design_course/pp.jpg',
      title: 'Présentations avec Microsoft PowerPoint ',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
  ];
}
