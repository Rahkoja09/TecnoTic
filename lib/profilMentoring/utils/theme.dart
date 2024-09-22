import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static final Color primary = Color.fromARGB(255, 255, 255, 255);
  static final Color cardColor = Color.fromARGB(255, 199, 214, 219);
  static final Color addCardColor = Color.fromARGB(255, 211, 152, 74);
  static final List<Color> iconColors = [
    const Color.fromARGB(255, 243, 86, 33),
    Color(0xFF27cf53),
    Color(0xFFf3a643),
    Color(0xFFbb49dc),
    Color.fromARGB(255, 35, 124, 183)
  ];

  static TextStyle profileHeaderStyle(
          BuildContext context, bool isLargeTextMode) =>
      Theme.of(context).textTheme.headline5!.copyWith(
          color: Theme.of(context).textTheme.bodyText1?.color,
          fontWeight: FontWeight.w500,
          fontSize: isLargeTextMode ? 40.sp : 34.sp,
          fontFamily: 'Jersey');

  static TextStyle cardTitleStyle(BuildContext context, bool isLargeTextMode) =>
      Theme.of(context).textTheme.subtitle1!.copyWith(
          color: Theme.of(context).textTheme.bodyText1?.color,
          fontWeight: FontWeight.w500,
          fontSize: isLargeTextMode ? 38.sp : 20.sp,
          fontFamily: 'Jersey');

  static TextStyle cardDescStyle(BuildContext context, bool isLargeTextMode) =>
      Theme.of(context).textTheme.subtitle1!.copyWith(
          color: Theme.of(context).textTheme.bodyText1?.color,
          fontSize: isLargeTextMode ? 30.sp : 14.sp);
}
