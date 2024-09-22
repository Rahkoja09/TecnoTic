import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/introduction_animation/components/care_view.dart';
import 'package:ticeo/introduction_animation/components/center_next_button.dart';
import 'package:ticeo/introduction_animation/components/mood_diary_vew.dart';
import 'package:ticeo/introduction_animation/components/relax_view.dart';
import 'package:ticeo/introduction_animation/components/splash_view.dart';
import 'package:ticeo/introduction_animation/components/top_back_skip_view.dart';
import 'package:ticeo/introduction_animation/components/welcome_view.dart';

class IntroductionAnimationScreen extends StatefulWidget {
  const IntroductionAnimationScreen({super.key});

  @override
  _IntroductionAnimationScreenState createState() =>
      _IntroductionAnimationScreenState();
}

class _IntroductionAnimationScreenState
    extends State<IntroductionAnimationScreen> with TickerProviderStateMixin {
  AnimationController? _animationController;
  bool _isLargeTextMode = false;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 8));
    _animationController?.animateTo(0.0);
    _loadPreferences();
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      _isLargeTextMode = mode == 'largePolice';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil here if not done in the parent widget
    ScreenUtil.init(context, designSize: const Size(414, 896));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: ClipRect(
        child: Stack(
          children: [
            SplashView(
              animationController: _animationController!,
              textSize: _isLargeTextMode ? 32.sp : 22.sp,
            ),
            RelaxView(
              animationController: _animationController!,
              textSize: _isLargeTextMode ? 36.sp : 22.sp,
              TietletextSize: _isLargeTextMode ? 50.sp : 38.sp,
            ),
            CareView(
              animationController: _animationController!,
              textSize: _isLargeTextMode ? 36.sp : 22.sp,
              TietletextSize: _isLargeTextMode ? 50.sp : 38.sp,
            ),
            MoodDiaryView(
              animationController: _animationController!,
              textSize: _isLargeTextMode ? 36.sp : 22.sp,
              TietletextSize: _isLargeTextMode ? 50.sp : 38.sp,
            ),
            WelcomeView(
              animationController: _animationController!,
              textSize: _isLargeTextMode ? 36.sp : 22.sp,
            ),
            TopBackSkipView(
              onBackClick: _onBackClick,
              onSkipClick: _onSkipClick,
              animationController: _animationController!,
              textSize: _isLargeTextMode ? 26.sp : 22.sp,
            ),
            CenterNextButton(
              animationController: _animationController!,
              onNextClick: _onNextClick,
              textSize: _isLargeTextMode ? 22.sp : 22.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _onSkipClick() {
    _animationController?.animateTo(0.8,
        duration: const Duration(milliseconds: 1200));
  }

  void _onBackClick() {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.2) {
      _animationController?.animateTo(0.0);
    } else if (_animationController!.value > 0.2 &&
        _animationController!.value <= 0.4) {
      _animationController?.animateTo(0.2);
    } else if (_animationController!.value > 0.4 &&
        _animationController!.value <= 0.6) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.6 &&
        _animationController!.value <= 0.8) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.8 &&
        _animationController!.value <= 1.0) {
      _animationController?.animateTo(0.8);
    }
  }

  void _onNextClick() {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.2) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.2 &&
        _animationController!.value <= 0.4) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.4 &&
        _animationController!.value <= 0.6) {
      _animationController?.animateTo(0.8);
    } else if (_animationController!.value > 0.6 &&
        _animationController!.value <= 0.8) {
      _signUpClick();
    }
  }

  void _signUpClick() {
    Navigator.pop(context);
  }
}
