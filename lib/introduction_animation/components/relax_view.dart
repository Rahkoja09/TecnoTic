import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RelaxView extends StatelessWidget {
  final AnimationController animationController;
  final double textSize;
  final double TietletextSize;

  const RelaxView({
    super.key,
    required this.animationController,
    required this.textSize,
    required this.TietletextSize,
  });

  @override
  Widget build(BuildContext context) {
    final firstHalfAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.0,
          0.2,
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
          0.2,
          0.4,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final textAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-2, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.2,
          0.4,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final imageAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-4, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.2,
          0.4,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final relaxAnimation =
        Tween<Offset>(begin: const Offset(0, -2), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.0,
          0.2,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    return SlideTransition(
      position: firstHalfAnimation,
      child: SlideTransition(
        position: secondHalfAnimation,
        child: Padding(
          padding: EdgeInsets.only(bottom: 60.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: relaxAnimation,
                child: Text(
                  "Cours",
                  style: TextStyle(
                      fontSize: TietletextSize
                          .sp, // Utiliser textSize.sp pour ajuster la taille
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Jersey'),
                ),
              ),
              SlideTransition(
                position: textAnimation,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 20.w, right: 20.w, top: 16.h, bottom: 16.h),
                  child: Text(
                    "Ici on vous propos des cours sur les TIC, en plusieurs Modules. Attention! c'est gratuit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: textSize.sp), // Ajuster la taille du texte
                  ),
                ),
              ),
              SlideTransition(
                position: imageAnimation,
                child: Container(
                  constraints:
                      BoxConstraints(maxWidth: 300.w, maxHeight: 200.h),
                  child: Image.asset(
                    'assets/introduction_animation/cours2.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
