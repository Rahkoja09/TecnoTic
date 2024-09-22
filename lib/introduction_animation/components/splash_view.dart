import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';

class SplashView extends StatefulWidget {
  final AnimationController animationController;
  final double textSize;

  const SplashView({
    super.key,
    required this.animationController,
    required this.textSize,
  });

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool _isLargeTextMode = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences(); // Appel de la fonction pour charger les préférences
  }

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    print('Mode est : $mode');
    setState(() {
      _isLargeTextMode = mode == 'largePolice';
    });
  }

  @override
  Widget build(BuildContext context) {
    final introductionAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.0, -1.0))
            .animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          0.0,
          0.2,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    return SlideTransition(
      position: introductionAnimation,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/introduction_animation/tech_intro2.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0.h, bottom: 5.h),
              child: Text(
                "Bienvenue",
                style: TextStyle(
                  fontSize: widget.textSize.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w),
              child: Text(
                "Explorons la technologie avec Tecno-tic",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: widget.textSize.sp), // Ajuster la taille du texte
              ),
            ),
            SizedBox(
              height: 28.h,
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16.h),
              child: InkWell(
                onTap: () {
                  widget.animationController.animateTo(0.2);
                },
                child: Container(
                  height: _isLargeTextMode ? 75.h : 60.h,
                  padding: EdgeInsets.only(
                    left: _isLargeTextMode ? 60.w : 56.w,
                    right: _isLargeTextMode ? 60.w : 56.w,
                    top: 16.h,
                    bottom: 16.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(38.r),
                    color: const Color(0xff132137),
                  ),
                  child: Text(
                    "Commençons",
                    style: TextStyle(
                        fontSize: widget.textSize.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Jersey'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
