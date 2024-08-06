// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/state/provider_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modeProvider = Provider.of<ModeProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                        height: modeProvider.isLargeTextMode ? 180.h : 140.h),
                    buildAnimatedHeader(constraints),
                    SizedBox(height: 36.h),
                    buildCategoryRow(),
                    SizedBox(height: 16.h),
                    buildMentoratCard(),
                  ],
                ),
              ),
              buildAppBar(),
            ],
          );
        },
      ),
    );
  }

  Widget buildAnimatedHeader(BoxConstraints constraints) {
    double headerFontSize =
        Provider.of<ModeProvider>(context).isLargeTextMode ? 34.sp : 18.sp;
    double ticeo =
        Provider.of<ModeProvider>(context).isLargeTextMode ? 46.sp : 22.sp;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SizedBox(
          width: constraints.maxWidth,
          height: 200.h,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 16.w,
                right: 16.w,
                child: Container(
                  width: double.infinity,
                  height: 200.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.r,
                        offset: Offset(0, 6.h),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: Image.asset(
                      'assets/design_course/cnfppsh.jpg',
                      width: double.infinity,
                      height: 200.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16.h,
                left: 32.w,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fahalalana hoan\'ny rehetra',
                          style: TextStyle(
                            fontSize: headerFontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1.h),
                                blurRadius: 2.r,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'TIC-eo',
                          style: TextStyle(
                            fontSize: ticeo,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1.h),
                                blurRadius: 2.r,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryRow() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCategoryButton(
                icon: Icons.menu_book_rounded,
                label: 'Cours',
                onPressed: () {},
              ),
              buildCategoryButton(
                icon: Icons.group,
                label: 'Mentorat',
                onPressed: () {},
              ),
              buildCategoryButton(
                icon: Icons.calendar_month_sharp,
                label: 'Planification',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMentoratCard() {
    double subHeaderFontSize =
        Provider.of<ModeProvider>(context).isLargeTextMode ? 24.sp : 20.sp;
    double simpleFontSize =
        Provider.of<ModeProvider>(context).isLargeTextMode ? 26.sp : 16.sp;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                    child: Image.asset(
                      'assets/design_course/mentoring.jpg',
                      width: double.infinity,
                      height: 200.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'Mentorat',
                    style: TextStyle(
                      fontSize: subHeaderFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'Vous êtes le soutien que les autres ont besoins?',
                    style: TextStyle(
                      fontSize: simpleFontSize,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      minimumSize: Size(double.infinity, 50.h),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Inscrivez en tant que mentor',
                      style: TextStyle(
                        fontSize: simpleFontSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    double buttonFontSize =
        Provider.of<ModeProvider>(context).isLargeTextMode ? 26.sp : 16.sp;
    double settings =
        Provider.of<ModeProvider>(context).isLargeTextMode ? 32.r : 24.r;

    return Positioned(
      top: 56.h,
      left: 0.w,
      right: 0.w,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 248, 248, 248),
              borderRadius: BorderRadius.circular(0.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      const AssetImage('assets/design_course/pdp.jpg'),
                  radius: 24.r,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bonjour!',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 58, 89, 223),
                        ),
                      ),
                      Text(
                        'Fanevaniaina Koja',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon:
                      Icon(Icons.settings, color: Colors.grey, size: settings),
                  onPressed: () {},
                  tooltip: 'paramettrage des informations de votre compte',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    double buttonFontSize =
        Provider.of<ModeProvider>(context).isLargeTextMode ? 18.sp : 12.sp;
    double iconSize =
        Provider.of<ModeProvider>(context).isLargeTextMode ? 34.w : 20.w;
    double heighcard =
        Provider.of<ModeProvider>(context).isLargeTextMode ? 84.sp : 60.sp;
    double widthcard =
        Provider.of<ModeProvider>(context).isLargeTextMode ? 124.sp : 100.sp;

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: widthcard,
                height: heighcard,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: iconSize,
                        color: const Color.fromARGB(183, 54, 127, 229),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: buttonFontSize.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 46, 46, 46),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
