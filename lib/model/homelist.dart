import 'package:flutter/widgets.dart';
import 'package:ticeo/design_course/home_design_course.dart';
import 'package:ticeo/introduction_animation/introduction_animation_screen.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png',
      navigateScreen: const IntroductionAnimationScreen(),
    ),
    HomeList(
      imagePath: 'assets/design_course/design_course.png',
      navigateScreen: const DesignCourseHomeScreen(),
    ),
  ];
}
