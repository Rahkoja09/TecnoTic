import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart'; // Assurez-vous d'importer provider
import 'package:ticeo/components/signup_page.dart';
import 'package:ticeo/components/state/provider_state.dart';
import 'package:audioplayers/audioplayers.dart'; // Assurez-vous d'importer audioplayers

class CenterNextButton extends StatelessWidget {
  final AnimationController animationController;
  final VoidCallback onNextClick;
  final double textSize;

  const CenterNextButton({
    super.key,
    required this.animationController,
    required this.onNextClick,
    required this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    final modeProvider = Provider.of<ModeProvider>(context);
    final isLargeTextMode = modeProvider.isLargeTextMode;

    final topMoveAnimation =
        Tween<Offset>(begin: const Offset(0, 5), end: const Offset(0, 0))
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

    final signUpMoveAnimation =
        Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final loginTextMoveAnimation =
        Tween<Offset>(begin: const Offset(0, 5), end: const Offset(0, 0))
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

    // Ajuste les tailles de texte en fonction de isLargeTextMode
    double adjustedTextSize = isLargeTextMode ? textSize * 1.5 : textSize;

    return Padding(
      padding:
          EdgeInsets.only(bottom: 16.h + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SlideTransition(
            position: topMoveAnimation,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) => AnimatedOpacity(
                opacity: animationController.value >= 0.2 &&
                        animationController.value <= 0.6
                    ? 1
                    : 0,
                duration: const Duration(milliseconds: 480),
                child: _pageView(),
              ),
            ),
          ),
          SlideTransition(
            position: topMoveAnimation,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) => Padding(
                padding: EdgeInsets.only(
                    bottom: 38.h - (38.h * signUpMoveAnimation.value)),
                child: Container(
                  height: 58.h,
                  width: 58.w + (200.w * signUpMoveAnimation.value),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        8.r + 32.r * (1 - signUpMoveAnimation.value)),
                    color: const Color(0xff132137),
                  ),
                  child: PageTransitionSwitcher(
                    duration: const Duration(milliseconds: 480),
                    reverse: signUpMoveAnimation.value < 0.7,
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return SharedAxisTransition(
                        fillColor: Colors.transparent,
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.vertical,
                        child: child,
                      );
                    },
                    child: signUpMoveAnimation.value > 0.7
                        ? InkWell(
                            key: const ValueKey('Sign Up button'),
                            onTap: () => _handleCreateAccount(context),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 16.0.w, right: 16.0.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Créer un compte',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: adjustedTextSize.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_rounded,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          )
                        : Tooltip(
                            message: 'Passer à l\'étape suivante',
                            child: InkWell(
                              key: const ValueKey('next button'),
                              onTap: onNextClick,
                              child: Padding(
                                padding: EdgeInsets.all(16.0.w),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: SlideTransition(
              position: loginTextMoveAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Déjà un compte? ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: (adjustedTextSize - 2).sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    'Se connecter',
                    style: TextStyle(
                      color: const Color(0xff132137),
                      fontSize: adjustedTextSize.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCreateAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignupPage(
          isLargeTextMode: Provider.of<ModeProvider>(context)
              .isLargeTextMode, // Passe la valeur ici
        ),
      ),
    );
  }

  Widget _pageView() {
    int selectedIndex = 0;

    if (animationController.value >= 0.7) {
      selectedIndex = 3;
    } else if (animationController.value >= 0.5) {
      selectedIndex = 2;
    } else if (animationController.value >= 0.3) {
      selectedIndex = 1;
    } else if (animationController.value >= 0.1) {
      selectedIndex = 0;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 4; i++)
            Padding(
              padding: EdgeInsets.all(4.0.w),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 480),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.r),
                  color: selectedIndex == i
                      ? const Color(0xff132137)
                      : const Color(0xffE3E4E4),
                ),
                width: 10.w,
                height: 10.h,
              ),
            )
        ],
      ),
    );
  }
}
