import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopBackSkipView extends StatelessWidget {
  final AnimationController animationController;
  final VoidCallback onBackClick;
  final VoidCallback onSkipClick;
  final double textSize;

  const TopBackSkipView({
    super.key,
    required this.onBackClick,
    required this.onSkipClick,
    required this.animationController,
    required this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    final animation =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0.0, 0.0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final skipAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(2, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    return SlideTransition(
      position: animation,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: 58.h, // Adjusted height for responsiveness
          child: Padding(
            padding:
                EdgeInsets.only(left: 8.w, right: 16.w), // Responsive padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onBackClick,
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios_new_rounded,
                          size: 24.sp), // Responsive icon size
                      SizedBox(width: 4.w), // Responsive spacing
                      Text(
                        'Retour',
                        style: TextStyle(
                            fontSize: textSize.sp), // Responsive text size
                      ),
                    ],
                  ),
                ),
                SlideTransition(
                  position: skipAnimation,
                  child: TextButton(
                    onPressed: onSkipClick,
                    child: Text(
                      'Passer les étapes',
                      style: TextStyle(
                        fontSize: textSize.sp, // Responsive text size
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
