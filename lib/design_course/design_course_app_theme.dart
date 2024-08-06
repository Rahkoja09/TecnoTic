import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/state/provider_state.dart';

class DesignCourseAppTheme {
  DesignCourseAppTheme._();

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFFFFFF);
  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);

  static TextTheme textTheme(BuildContext context) {
    final textSizeProvider = Provider.of<ModeProvider>(context);
    bool isLargeTextMode = textSizeProvider.isLargeTextMode;

    return TextTheme(
      headline4: display1(isLargeTextMode),
      headline5: headline(isLargeTextMode),
      headline6: title(isLargeTextMode),
      subtitle2: subtitle(isLargeTextMode),
      bodyText1: body2(isLargeTextMode),
      bodyText2: body1(isLargeTextMode),
      caption: caption(isLargeTextMode),
    );
  }

  static TextStyle display1(bool isLargeTextMode) {
    return TextStyle(
      fontFamily: 'WorkSans',
      fontWeight: FontWeight.bold,
      fontSize: isLargeTextMode ? 40.sp : 36.sp,
      letterSpacing: 0.4,
      height: 0.9,
      color: darkerText,
    );
  }

  static TextStyle headline(bool isLargeTextMode) {
    return TextStyle(
      fontFamily: 'WorkSans',
      fontWeight: FontWeight.bold,
      fontSize: isLargeTextMode ? 28.sp : 24.sp,
      letterSpacing: 0.27,
      color: darkerText,
    );
  }

  static TextStyle title(bool isLargeTextMode) {
    return TextStyle(
      fontFamily: 'WorkSans',
      fontWeight: FontWeight.bold,
      fontSize: isLargeTextMode ? 18.sp : 16.sp,
      letterSpacing: 0.18,
      color: darkerText,
    );
  }

  static TextStyle subtitle(bool isLargeTextMode) {
    return TextStyle(
      fontFamily: 'WorkSans',
      fontWeight: FontWeight.w400,
      fontSize: isLargeTextMode ? 16.sp : 14.sp,
      letterSpacing: -0.04,
      color: darkText,
    );
  }

  static TextStyle body2(bool isLargeTextMode) {
    return TextStyle(
      fontFamily: 'WorkSans',
      fontWeight: FontWeight.w400,
      fontSize: isLargeTextMode ? 16.sp : 14.sp,
      letterSpacing: 0.2,
      color: darkText,
    );
  }

  static TextStyle body1(bool isLargeTextMode) {
    return TextStyle(
      fontFamily: 'WorkSans',
      fontWeight: FontWeight.w400,
      fontSize: isLargeTextMode ? 18.sp : 16.sp,
      letterSpacing: -0.05,
      color: darkText,
    );
  }

  static TextStyle caption(bool isLargeTextMode) {
    return TextStyle(
      fontFamily: 'WorkSans',
      fontWeight: FontWeight.w400,
      fontSize: isLargeTextMode ? 14.sp : 12.sp,
      letterSpacing: 0.2,
      color: lightText,
    );
  }
}
