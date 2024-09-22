// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/design_course/content_course/principal_content.dart';
import 'package:ticeo/design_course/content_course/timer_secondes.dart';
import 'package:ticeo/design_course/models/category.dart';
import 'design_course_app_theme.dart';

class CourseInfoScreen extends StatefulWidget {
  final Category category;

  const CourseInfoScreen({super.key, required this.category});

  @override
  _CourseInfoScreenState createState() => _CourseInfoScreenState();
}

class _CourseInfoScreenState extends State<CourseInfoScreen>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController? animationController;
  List<Map<String, dynamic>> coursesList = [];
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
    fetchCourses();
    _loadPreferences();
  }

  bool isLargeTextMode = false;

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      isLargeTextMode = mode == 'largePolice';
    });
  }

  Future<void> fetchCourses() async {
    try {
      // Étape 1: Récupérer l'ID du document basé sur le texte de recherche
      final querySnapshot = await FirebaseFirestore.instance
          .collection('CoursTiceo')
          .where('Nom_Module', isEqualTo: widget.category.title)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;

        // Étape 2: Accéder à la sous-collection 'seances'
        final seancesCollection = FirebaseFirestore.instance
            .collection('CoursTiceo') // Nom de votre collection
            .doc(docId)
            .collection('Seances');

        final seancesSnapshot = await seancesCollection.get();

        setState(() {
          // Étape 3: Ajouter les documents de la sous-collection à la liste
          coursesList = seancesSnapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'title': data['title'] ?? 'No Title',
              'courses': data['course'] ?? 'No Courses',
            };
          }).toList();
        });
      } else {
        print('Aucun document trouvé avec le texte de recherche');
      }
    } catch (e) {
      print('Erreur lors de la récupération des cours : $e');
    }
  }

  Future<void> setData() async {
    animationController?.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    ScreenUtil.init(context,
        designSize: const Size(360, 690), minTextAdapt: true);

    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        ScreenUtil().setHeight(66.0);
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.2,
                  child: Image.asset('assets/design_course/webInterFace.png'),
                ),
              ],
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) -
                  ScreenUtil().setHeight(66.0),
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ScreenUtil().setWidth(32.0)),
                      topRight: Radius.circular(ScreenUtil().setWidth(32.0))),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: DesignCourseAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: ScreenUtil().setWidth(10.0)),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(8)),
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: ScreenUtil().setHeight(infoHeight),
                          maxHeight: tempHeight > infoHeight
                              ? tempHeight
                              : ScreenUtil().setHeight(infoHeight)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(16.0),
                                left: ScreenUtil().setWidth(16),
                                right: ScreenUtil().setWidth(16)),
                            child: Text(
                              widget.category.title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Jersey',
                                fontSize: isLargeTextMode
                                    ? ScreenUtil().setSp(36)
                                    : ScreenUtil().setSp(30),
                                letterSpacing: ScreenUtil().setWidth(0.27),
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(16),
                                right: ScreenUtil().setWidth(16),
                                bottom: ScreenUtil().setHeight(0),
                                top: ScreenUtil().setHeight(6)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: opacity1,
                            child: Padding(
                              padding: EdgeInsets.all(ScreenUtil().setWidth(2)),
                              child: Row(
                                children: <Widget>[
                                  getTimeBoxUI(
                                      widget.category.lessonCount.toString(),
                                      'Séances'),
                                  getTimeBoxUI('2.5', 'Heures'),
                                  getTimeBoxUI('2', 'pratiques'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: opacity2,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(16),
                                    right: ScreenUtil().setWidth(16),
                                    top: ScreenUtil().setHeight(0),
                                    bottom: ScreenUtil().setHeight(0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        opacity: opacity2,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(16),
                                              right: ScreenUtil().setWidth(16),
                                              top: ScreenUtil().setHeight(0),
                                              bottom:
                                                  ScreenUtil().setHeight(0)),
                                          child: ListView.builder(
                                            itemCount: coursesList.length,
                                            itemBuilder: (context, index) {
                                              final course = coursesList[index];
                                              return CourseCard(
                                                title: course['title']!,
                                                courses: course['courses']! +
                                                    ' Cours',
                                                isLargeTextMode:
                                                    isLargeTextMode,
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Principal_content(
                                                              titre: course[
                                                                      'title']
                                                                  .toString(),
                                                              category: widget
                                                                  .category,
                                                            )),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: opacity3,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(16),
                                  bottom: ScreenUtil().setHeight(16),
                                  right: ScreenUtil().setWidth(16)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: ScreenUtil().setWidth(16),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: ScreenUtil().setHeight(38),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 19, 75, 120),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              ScreenUtil().setWidth(16.0)),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Color.fromARGB(
                                                      255, 19, 75, 120)
                                                  .withOpacity(0.5),
                                              offset: const Offset(1.1, 1.1),
                                              blurRadius:
                                                  ScreenUtil().setWidth(10.0)),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'commencer ou continuer le cour',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Jersey',
                                            fontSize: isLargeTextMode
                                                ? ScreenUtil().setSp(26)
                                                : ScreenUtil().setSp(22),
                                            color: DesignCourseAppTheme
                                                .nearlyWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String time, String label) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: DesignCourseAppTheme.grey.withOpacity(0.2),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: ScreenUtil().setWidth(6.0)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                time,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: ScreenUtil().setSp(24),
                    color: Color.fromARGB(255, 221, 153, 76)),
              ),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: isLargeTextMode
                      ? ScreenUtil().setSp(22)
                      : ScreenUtil().setSp(18),
                  fontFamily: 'Jersey',
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  const CourseCard({
    Key? key,
    required this.title,
    required this.courses,
    required this.onTap,
    required this.isLargeTextMode,
  }) : super(key: key);

  final String title;
  final String courses;
  final VoidCallback onTap;
  final bool isLargeTextMode;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        decoration: BoxDecoration(
          border: const Border(
              top: BorderSide(color: Color.fromARGB(255, 210, 210, 210))),
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(0.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: isLargeTextMode
                        ? ScreenUtil().setSp(20)
                        : ScreenUtil().setSp(16),
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(4),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(4),
            ),
            Text(
              courses,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: isLargeTextMode
                    ? ScreenUtil().setSp(18)
                    : ScreenUtil().setSp(14),
                color: Theme.of(context).textTheme.bodyText1?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
