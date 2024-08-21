import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';

class CustomFormButton extends StatelessWidget {
  final String innerText;
  final void Function()? onPressed;

  const CustomFormButton({
    Key? key,
    required this.innerText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Déclaration des variables pour les tailles et styles par défaut
    double fontSize = 20.sp;
    double buttonHeight = 50.h;
    double borderRadius = 26.r;

    // Charger les préférences de taille de texte depuis la base de données
    _loadPreferences().then((preferences) {
      fontSize = preferences['fontSize']!;
      buttonHeight = preferences['buttonHeight']!;
      borderRadius = preferences['borderRadius']!;
    });

    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.8,
      height: buttonHeight,
      decoration: BoxDecoration(
        color: const Color(0xff233743),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          innerText,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  Future<Map<String, double>> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    double fontSize = mode == 'large' ? 32.sp : 20.sp;
    double buttonHeight = mode == 'large' ? 62.h : 50.h;
    double borderRadius = mode == 'large' ? 34.r : 26.r;

    return {
      'fontSize': fontSize,
      'buttonHeight': buttonHeight,
      'borderRadius': borderRadius,
    };
  }
}
