import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';

class PageHeading extends StatelessWidget {
  final String title;

  const PageHeading({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: _loadPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
              child: Text('Erreur de chargement des préférences'));
        }

        double fontSize = snapshot.data?['fontSize'] ?? 25.sp;

        return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 25.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSerif',
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, double>> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    double fontSize = mode == 'large' ? 34.sp : 25.sp;

    return {
      'fontSize': fontSize,
    };
  }
}
