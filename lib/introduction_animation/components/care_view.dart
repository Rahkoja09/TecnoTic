import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CareView extends StatelessWidget {
  final AnimationController animationController;
  final double textSize;
  final double TietletextSize;

  const CareView(
      {super.key,
      required this.animationController,
      required this.textSize,
      required this.TietletextSize});

  @override
  Widget build(BuildContext context) {
    final firstHalfAnimation =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.2,
        0.4,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final secondHalfAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.4,
        0.6,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final relaxFirstHalfAnimation =
        Tween<Offset>(begin: const Offset(2, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.2,
        0.4,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final relaxSecondHalfAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-2, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.4,
        0.6,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final imageFirstHalfAnimation =
        Tween<Offset>(begin: const Offset(4, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.2,
        0.4,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final imageSecondHalfAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-4, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.4,
        0.6,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    return SlideTransition(
      position: firstHalfAnimation,
      child: SlideTransition(
        position: secondHalfAnimation,
        child: Padding(
          padding: EdgeInsets.only(bottom: 100.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: imageFirstHalfAnimation,
                child: SlideTransition(
                  position: imageSecondHalfAnimation,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 300.w,
                      maxHeight: 200.h,
                    ),
                    child: Image.asset(
                      'assets/introduction_animation/Mentorat.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SlideTransition(
                position: relaxFirstHalfAnimation,
                child: SlideTransition(
                  position: relaxSecondHalfAnimation,
                  child: Text(
                    "Mentorat",
                    style: TextStyle(
                        fontSize: TietletextSize
                            .sp, // Utiliser textSize pour ajuster la taille
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Jersey'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  bottom: 6.h,
                  top: 6.h,
                ),
                child: Text(
                  "Une service de mentoring à votre disposition, pour avoir des conseilles et assistances des professsionnels",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: textSize.sp, // Ajuster la taille du texte
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
