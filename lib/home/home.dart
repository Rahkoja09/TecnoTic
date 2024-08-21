// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/design_course/welcome_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late PageController _pageController;
  Timer? _timer;
  bool _isLargeTextMode = false;

  final List<Map<String, String>> _imagesWithText = [
    {
      'image': 'assets/design_course/bureau.jpg',
      'title': 'Ensemble avec votre application',
      'subtitle': 'TIC-eo',
    },
    {
      'image': 'assets/design_course/cours.jpg',
      'title': 'Cours',
      'subtitle': 'Adapter pour vous',
    },
    {
      'image': 'assets/design_course/mentoring.png',
      'title': 'Mentorat',
      'subtitle': 'De votre meilleur coach',
    },
    {
      'image': 'assets/design_course/planing.jpg',
      'title': 'Planning',
      'subtitle': 'Avec votre propre rithme',
    },
    // Ajoutez d'autres images avec leurs textes ici
  ];

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

    _pageController = PageController();

    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage =
            (_pageController.page!.toInt() + 1) % _imagesWithText.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });

    _loadPreferences();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    _timer?.cancel();
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
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 249, 252),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: _isLargeTextMode ? 180.h : 110.h),
                    buildAnimatedHeader(constraints),
                    SizedBox(height: 16.h),
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
    double headerFontSize = _isLargeTextMode ? 34.sp : 20.sp;
    double ticeoFontSize = _isLargeTextMode ? 46.sp : 30.sp;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SizedBox(
            width: constraints.maxWidth,
            height: 150.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _imagesWithText.length,
              itemBuilder: (context, index) {
                final imageWithText = _imagesWithText[index];
                return Stack(
                  children: [
                    Positioned(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: Image.asset(
                          imageWithText['image']!,
                          width: double.infinity,
                          height: 150.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16.h,
                      left: 16.w,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                imageWithText['title']!,
                                style: TextStyle(
                                  fontSize: headerFontSize,
                                  // fontFamily: 'DotGothic',
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
                                imageWithText['subtitle']!,
                                style: TextStyle(
                                  fontSize: ticeoFontSize,
                                  fontFamily: 'Jersey',
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
                );
              },
            ),
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
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCategoryButton(
                icon: Icons.menu_book_rounded,
                label: 'Cours',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
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
    double subHeaderFontSize = _isLargeTextMode ? 24.sp : 24.sp;
    double simpleFontSize = _isLargeTextMode ? 26.sp : 14.sp;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            ),
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 150.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(5.r),
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
                      // fontFamily: 'DotGothic',
                      fontWeight: FontWeight.w500,
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
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      minimumSize: Size(double.infinity, 50.h),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Inscrivez en tant que mentor',
                      style: TextStyle(
                        fontSize: subHeaderFontSize,
                        fontFamily: 'Jersey',
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
    double buttonFontSize = _isLargeTextMode ? 26.sp : 16.sp;
    double settings = _isLargeTextMode ? 32.r : 24.r;
    double TICEO = _isLargeTextMode ? 26.r : 30.r;

    return Positioned(
      top: 45.h,
      left: 0.w,
      right: 0.w,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Color.fromARGB(39, 91, 153, 194),
              border: Border.all(
                color: Color.fromARGB(255, 203, 203, 203),
              ),
              borderRadius: BorderRadius.all(Radius.circular(5.0.r)),
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
                IconButton(
                  icon: Icon(Icons.menu,
                      color: Color.fromARGB(255, 99, 99, 99), size: settings),
                  onPressed: () {},
                  tooltip: 'Menu et paramettrage',
                ),
                SizedBox(
                  width: 10.0.h,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TIC-eo',
                        style: TextStyle(
                          fontSize: TICEO,
                          fontFamily: 'Jersey',
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 88, 88, 88),
                        ),
                      ),
                      // Text(
                      //   'Fanevaniaina Koja',
                      //   style: TextStyle(
                      //     fontSize: buttonFontSize,
                      //     fontWeight: FontWeight.bold,
                      //     color: Color.fromARGB(255, 125, 125, 125),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.notifications_none,
                      color: const Color.fromARGB(255, 122, 122, 122),
                      size: settings),
                  onPressed: () {},
                  tooltip: 'paramettrage des informations de votre compte',
                ),
                CircleAvatar(
                  backgroundImage:
                      const AssetImage('assets/design_course/pdp.jpg'),
                  radius: 16.r,
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
    double buttonFontSize = _isLargeTextMode ? 18.sp : 12.sp;
    double iconSize = _isLargeTextMode ? 34.w : 20.w;
    double heightCard = _isLargeTextMode ? 84.sp : 60.sp;
    double widthCard = _isLargeTextMode ? 124.sp : 100.sp;

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: widthCard,
                height: heightCard,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color.fromARGB(255, 255, 255, 255)),
                  borderRadius: BorderRadius.circular(5.r),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black12,
                  //     blurRadius: 8.r,
                  //     offset: Offset(0, 4.h),
                  //   ),
                  // ],
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
                          fontSize: buttonFontSize,
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
