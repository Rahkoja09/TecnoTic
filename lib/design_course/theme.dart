import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Le theme dynamic en fonction de color picker dans l'interface utilisateur --------
class CustomThemeCourse {
  Color backColors = Color.fromARGB(255, 95, 94, 94);
  Color cardColors = Color.fromARGB(255, 113, 147, 158);
  Color fontColors = Color.fromARGB(255, 255, 255, 255);
  List<Color> iconColors = [
    const Color.fromARGB(255, 243, 86, 33),
    Color(0xFF27cf53),
    Color(0xFFf3a643),
    Color(0xFFbb49dc),
    Color.fromARGB(255, 35, 124, 183)
  ];
}

// Les 3 themes par déffaut --------------
class DarkThemeCourse {
  static final Color backColors = Color.fromARGB(255, 77, 76, 76);
  static final Color cardColors = Color.fromARGB(255, 113, 147, 158);
  static final Color fontColors = Color.fromARGB(255, 255, 255, 255);
  static final List<Color> iconColors = [
    const Color.fromARGB(255, 243, 86, 33),
    Color(0xFF27cf53),
    Color(0xFFf3a643),
    Color(0xFFbb49dc),
    Color.fromARGB(255, 35, 124, 183)
  ];
}

class LightThemeCourse {
  Color backColors = Color.fromARGB(255, 95, 94, 94);
  Color cardColors = Color.fromARGB(255, 113, 147, 158);
  Color fontColors = Color.fromARGB(255, 255, 255, 255);
  List<Color> iconColors = [
    const Color.fromARGB(255, 243, 86, 33),
    Color(0xFF27cf53),
    Color(0xFFf3a643),
    Color(0xFFbb49dc),
    Color.fromARGB(255, 35, 124, 183)
  ];
}

class OrangeThemeCourse {
  Color backColors = Color.fromARGB(255, 95, 94, 94);
  Color cardColors = Color.fromARGB(255, 113, 147, 158);
  Color fontColors = Color.fromARGB(255, 255, 255, 255);
  List<Color> iconColors = [
    const Color.fromARGB(255, 243, 86, 33),
    Color(0xFF27cf53),
    Color(0xFFf3a643),
    Color(0xFFbb49dc),
    Color.fromARGB(255, 35, 124, 183)
  ];
}
