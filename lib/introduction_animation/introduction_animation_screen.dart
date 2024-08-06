// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart'; // Assurez-vous d'importer provider
import 'package:ticeo/components/state/provider_state.dart';
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

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 8));
    _animationController?.animateTo(0.0);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modeProvider = Provider.of<ModeProvider>(context);
    final isLargeTextMode = modeProvider.isLargeTextMode;

    // Initialize ScreenUtil here if not done in the parent widget
    ScreenUtil.init(context, designSize: const Size(414, 896));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: ClipRect(
        child: Stack(
          children: [
            SplashView(
              animationController: _animationController!,
              textSize: isLargeTextMode ? 32.sp : 22.sp,
            ),
            RelaxView(
              animationController: _animationController!,
              textSize: isLargeTextMode ? 36.sp : 22.sp,
            ),
            CareView(
              animationController: _animationController!,
              textSize: isLargeTextMode ? 36.sp : 22.sp,
            ),
            MoodDiaryView(
              animationController: _animationController!,
              textSize: isLargeTextMode ? 36.sp : 22.sp,
            ),
            WelcomeView(
              animationController: _animationController!,
              textSize: isLargeTextMode ? 36.sp : 22.sp,
            ),
            TopBackSkipView(
              onBackClick: _onBackClick,
              onSkipClick: _onSkipClick,
              animationController: _animationController!,
              textSize: isLargeTextMode ? 22.sp : 22.sp,
            ),
            CenterNextButton(
              animationController: _animationController!,
              onNextClick: _onNextClick,
              textSize: isLargeTextMode ? 16.sp : 16.sp,
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
