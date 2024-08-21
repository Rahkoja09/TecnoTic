// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Ajout de flutter_screenutil
import 'design_course_app_theme.dart';

class CourseInfoScreen extends StatefulWidget {
  const CourseInfoScreen({super.key});

  @override
  _CourseInfoScreenState createState() => _CourseInfoScreenState();
}

class _CourseInfoScreenState extends State<CourseInfoScreen>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController? animationController;
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
    // Initialisation de ScreenUtil
    ScreenUtil.init(context,
        designSize: const Size(360, 690), minTextAdapt: true);

    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        ScreenUtil().setHeight(66.0); // Utilisation de ScreenUtil
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
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
                  ScreenUtil().setHeight(66.0), // Utilisation de ScreenUtil
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: DesignCourseAppTheme.nearlyWhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ScreenUtil()
                          .setWidth(32.0)), // Utilisation de ScreenUtil
                      topRight: Radius.circular(ScreenUtil()
                          .setWidth(32.0))), // Utilisation de ScreenUtil
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: DesignCourseAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: ScreenUtil()
                            .setWidth(10.0)), // Utilisation de ScreenUtil
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil()
                          .setWidth(8)), // Utilisation de ScreenUtil
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: ScreenUtil().setHeight(
                              infoHeight), // Utilisation de ScreenUtil
                          maxHeight: tempHeight > infoHeight
                              ? tempHeight
                              : ScreenUtil().setHeight(
                                  infoHeight)), // Utilisation de ScreenUtil
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(16.0),
                                left: ScreenUtil().setWidth(16),
                                right: ScreenUtil()
                                    .setWidth(16)), // Utilisation de ScreenUtil
                            child: Text(
                              "Composantes de l'ordinateur",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Jersey',
                                fontSize: ScreenUtil()
                                    .setSp(30), // Utilisation de ScreenUtil
                                letterSpacing: ScreenUtil().setWidth(
                                    0.27), // Utilisation de ScreenUtil
                                color: DesignCourseAppTheme.darkerText,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(16),
                                right: ScreenUtil().setWidth(16),
                                bottom: ScreenUtil().setHeight(0),
                                top: ScreenUtil()
                                    .setHeight(6)), // Utilisation de ScreenUtil
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
                              padding: EdgeInsets.all(ScreenUtil()
                                  .setWidth(2)), // Utilisation de ScreenUtil
                              child: Row(
                                children: <Widget>[
                                  getTimeBoxUI('2', 'Séances'),
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
                                    bottom: ScreenUtil().setHeight(
                                        0)), // Utilisation de ScreenUtil
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ListView(
                                        children: const <Widget>[
                                          CourseCard(
                                            title: 'Les bases de MS Word',
                                            duration: '2 heures',
                                            courses: '3 cours',
                                          ),
                                          CourseCard(
                                            title: 'Mise en forme et police',
                                            duration: '1.5 heures',
                                            courses: '2 cours',
                                          ),
                                          CourseCard(
                                            title: 'Tableaux et Graphiques',
                                            duration: '2.5 heures',
                                            courses: '4 cours',
                                          ),
                                          CourseCard(
                                            title: 'Macros et Automatisation',
                                            duration: '3 heures',
                                            courses: '5 cours',
                                          ),
                                          CourseCard(
                                            title:
                                                'Conseils et astuces avancés',
                                            duration: '2 heures',
                                            courses: '3 cours',
                                          ),
                                        ],
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
                                  right: ScreenUtil().setWidth(
                                      16)), // Utilisation de ScreenUtil
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: ScreenUtil().setWidth(
                                        50), // Utilisation de ScreenUtil
                                    height: ScreenUtil().setHeight(
                                        50), // Utilisation de ScreenUtil
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: DesignCourseAppTheme.nearlyWhite,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(ScreenUtil().setWidth(
                                              16.0)), // Utilisation de ScreenUtil
                                        ),
                                        border: Border.all(
                                            color: DesignCourseAppTheme.grey
                                                .withOpacity(0.2)),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: DesignCourseAppTheme.nearlyBlue,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(
                                        16), // Utilisation de ScreenUtil
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: ScreenUtil().setHeight(
                                          38), // Utilisation de ScreenUtil
                                      decoration: BoxDecoration(
                                        color: DesignCourseAppTheme.nearlyBlue,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(ScreenUtil().setWidth(
                                              16.0)), // Utilisation de ScreenUtil
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: DesignCourseAppTheme
                                                  .nearlyBlue
                                                  .withOpacity(0.5),
                                              offset: const Offset(1.1, 1.1),
                                              blurRadius: ScreenUtil().setWidth(
                                                  10.0)), // Utilisation de ScreenUtil
                                        ],
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'commencer ou continuer le cour',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Jersey',
                                            fontSize: 22,
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
                            height: ScreenUtil()
                                .setHeight(0), // Utilisation de ScreenUtil
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
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
            right: ScreenUtil().setWidth(10)), // Utilisation de ScreenUtil
        child: Container(
          padding: EdgeInsets.all(
              ScreenUtil().setWidth(10)), // Utilisation de ScreenUtil
          decoration: BoxDecoration(
            color: DesignCourseAppTheme.nearlyWhite,
            borderRadius: BorderRadius.circular(
                ScreenUtil().setWidth(10.0)), // Utilisation de ScreenUtil
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: DesignCourseAppTheme.grey.withOpacity(0.2),
                  offset: const Offset(1.1, 1.1),
                  blurRadius:
                      ScreenUtil().setWidth(6.0)), // Utilisation de ScreenUtil
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                time,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize:
                        ScreenUtil().setSp(24), // Utilisation de ScreenUtil
                    color: Color.fromARGB(255, 221, 153, 76)),
              ),
              Text(
                label,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize:
                        ScreenUtil().setSp(14), // Utilisation de ScreenUtil
                    color: DesignCourseAppTheme.grey),
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
    required this.duration,
    required this.courses,
  }) : super(key: key);

  final String title;
  final String duration;
  final String courses;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
          ScreenUtil().setWidth(16)), // Utilisation de ScreenUtil
      decoration: BoxDecoration(
        border: const Border(
            top: BorderSide(color: Color.fromARGB(255, 210, 210, 210))),
        color: DesignCourseAppTheme.nearlyWhite,
        borderRadius: BorderRadius.circular(
            ScreenUtil().setWidth(0.0)), // Utilisation de ScreenUtil
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: ScreenUtil().setSp(16), // Utilisation de ScreenUtil
              color: const Color.fromARGB(255, 72, 73, 73),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(4), // Utilisation de ScreenUtil
          ),
          Text(
            duration,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: ScreenUtil().setSp(14), // Utilisation de ScreenUtil
              color: DesignCourseAppTheme.grey,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(4), // Utilisation de ScreenUtil
          ),
          Text(
            courses,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: ScreenUtil().setSp(14), // Utilisation de ScreenUtil
              color: DesignCourseAppTheme.grey,
            ),
          ),
        ],
      ),
    );
  }
}
