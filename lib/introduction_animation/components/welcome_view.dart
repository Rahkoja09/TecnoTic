import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeView extends StatelessWidget {
  final AnimationController animationController;
  final double textSize; // Nouveau paramètre pour la taille du texte

  const WelcomeView({
    super.key,
    required this.animationController,
    required this.textSize, // Ajouter le paramètre au constructeur
  });

  @override
  Widget build(BuildContext context) {
    final firstHalfAnimation =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.6,
          0.8,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final secondHalfAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.8,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final welcomeFirstHalfAnimation =
        Tween<Offset>(begin: const Offset(2, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final welcomeImageAnimation =
        Tween<Offset>(begin: const Offset(4, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
      position: firstHalfAnimation,
      child: SlideTransition(
        position: secondHalfAnimation,
        child: Padding(
          padding: EdgeInsets.only(bottom: 80.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: welcomeImageAnimation,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 380.w, // Responsive width
                    maxHeight: 280.h, // Responsive height
                  ),
                  child: Image.asset(
                    'assets/icons/logo.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h, // Responsive height
              ),
              SlideTransition(
                position: welcomeFirstHalfAnimation,
                child: Text(
                  "",
                  style: TextStyle(
                    fontSize: textSize.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 34.w,
                    right: 34.w,
                    top: 16.h,
                    bottom: 6.h), // Responsive padding
                child: Text(
                  "Vers l'excelence Numerique",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: textSize.sp,
                    fontWeight: FontWeight.w500,
                  ), // Ajuster la taille du texte
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
