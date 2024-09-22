// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, deprecated_member_use

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/Personalise/Personnalise_ui.dart';
import 'package:ticeo/chat/chat.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/design_course/welcome_view.dart';
import 'package:ticeo/mentoring/mentoring_home.dart';
import 'package:ticeo/mentoring/model/form_mentor.dart';
import 'package:ticeo/mentoring/welcome_view.dart';
import 'package:ticeo/notifications/notification_Design.dart';
import 'package:ticeo/settings/settingsHome.dart';

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
  ValueNotifier<bool> _hasNewNotification = ValueNotifier<bool>(false);
  late PageController _pageController;
  Timer? _timer;
  bool _isLargeTextMode = false;
  String ProfilImageUrl = '';
  String PremierNom = '';
  String idMentorNotification = '';
  bool hasNewNotification = false;
  int isMentor = 0;

  final List<Map<String, String>> _imagesWithText = [
    {
      'image': 'assets/design_course/bureau.jpg',
      'title': 'Ensemble avec l\'application',
      'subtitle': 'TECNO-TIC',
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
    recupererNom();
    getImageProfil();
    getIdMentor();
    getIsMentor();
    getImageProfil();
    FirebaseFirestore.instance
        .collection('Mentors')
        .doc("DlMsU7mlJxTXvgCbyrOh")
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> notifications = snapshot.data()!['Notifications'];
        bool newNotif =
            notifications.values.any((notif) => notif['isNew'] == true);
        _hasNewNotification.value = newNotif;
      }
    });
  }

  Future<void> getIsMentor() async {
    isMentor = (await DatabaseHelper().getisMentor())!;
  }

  Future<void> getIdMentor() async {
    var idMentor = await DatabaseHelper().getMentor();
    if (idMentor!.isNotEmpty) {
      idMentorNotification = idMentor.first['IdFireBase'];
      print('print idMentorNotif ici : $idMentorNotification');
    }
  }

  Future<void> recupererNom() async {
    var DataRecup = await DatabaseHelper().getMentor();

    if (DataRecup!.isNotEmpty) {
      String nomComplet = DataRecup.first['NomComplet'] ?? 'Utilisateur';

      PremierNom = nomComplet.split(' ').first;
    }
  }

  // Écouter en temps réel les notifications à partir du document Mentor
  Stream<DocumentSnapshot<Map<String, dynamic>>> getNotificationsStream() {
    return FirebaseFirestore.instance
        .collection('Mentors')
        .doc("DlMsU7mlJxTXvgCbyrOh")
        .snapshots();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    _timer?.cancel();
    _hasNewNotification.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      _isLargeTextMode = mode == 'largePolice';
    });
  }

  Future<void> getImageProfil() async {
    ProfilImageUrl = await DatabaseHelper().getImageProfil() as String;
    if (ProfilImageUrl.isNotEmpty) {}
    print('voici url de image selectionnée :$ProfilImageUrl');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 80.h),
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
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    double headerFontSize = _isLargeTextMode ? 22.sp : 17.sp;
    double ticeoFontSize = _isLargeTextMode ? 36.sp : 30.sp;

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePageMentor(),
                    ),
                  );
                },
              ),
              buildCategoryButton(
                icon: Icons.settings,
                label: 'Theme',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThemeCustomizationPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMentoratCard() {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    double subHeaderFontSize = _isLargeTextMode ? 28.sp : 24.sp;
    double simpleFontSize = _isLargeTextMode ? 22.sp : 14.sp;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Card(
            color: theme.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            ),
            elevation: 1,
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
                      color: Theme.of(context).textTheme.bodyText2?.color,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'Vous êtes le soutien que les autres ont besoin?',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontSize: simpleFontSize,
                        ),
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 19, 75, 120),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      minimumSize: Size(double.infinity, 50.h),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    onPressed: () {
                      if (isMentor == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => MentoringHomePage())));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => FormMentor(
                                      onClose: () {},
                                    ))));
                      }
                    },
                    child: Text(
                      'Inscrivez en tant que mentor',
                      style: TextStyle(
                        fontSize: subHeaderFontSize,
                        fontFamily: 'Jersey',
                        color: Color.fromARGB(255, 255, 255, 255),
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
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    double buttonFontSize = _isLargeTextMode ? 26.sp : 16.sp;
    double bonjoursFS = _isLargeTextMode ? 24.sp : 14.sp;
    double settings = _isLargeTextMode ? 32.r : 22.r;
    double TICEO = _isLargeTextMode ? 26.r : 30.r;

    return Positioned(
      left: 0.w,
      right: 0.w,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(bottom: BorderSide(color: Colors.grey)),
              borderRadius: BorderRadius.all(Radius.circular(5.0.r)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(ProfilImageUrl),
                  radius: 18.r,
                ),
                SizedBox(
                  width: 10.0.h,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        image: const AssetImage('assets/icons/logo.png'),
                        height: 40.h,
                        width: 120.w,
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _hasNewNotification,
                  builder: (context, hasNewNotif, child) {
                    return IconButton(
                      icon: Icon(
                        hasNewNotif
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_none,
                        color: hasNewNotif
                            ? Color.fromARGB(255, 197, 82, 82)
                            : Theme.of(context).textTheme.bodyText2?.color,
                        size: settings - 4,
                      ),
                      onPressed: () {
                        if (isMentor == 0) {
                          print(
                              'Vous n\'etes pas encore un mentor, iscrivez pour acceder aux notifications');
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => NotificationPage(
                                      mentorId: idMentorNotification))));
                        }
                      },
                      tooltip: 'Les Notifications de votre compte',
                    );
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _hasNewNotification,
                  builder: (context, hasNewNotif, child) {
                    return IconButton(
                      icon: Icon(
                        hasNewNotif
                            ? Icons.notifications_active_rounded
                            : Icons.message_outlined,
                        color: hasNewNotif
                            ? Color.fromARGB(255, 197, 82, 82)
                            : Theme.of(context).textTheme.bodyText2?.color,
                        size: settings - 4,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const ChatUI())));
                      },
                      tooltip: 'Message global',
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).textTheme.bodyText2?.color,
                    size: settings,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => SettingsPage())));
                  },
                  color: Color.fromARGB(255, 33, 56, 82),
                  tooltip: 'Menu et paramettrage',
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
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    double buttonFontSize = _isLargeTextMode ? 16.sp : 12.sp;
    double iconSize = _isLargeTextMode ? 34.w : 20.w;
    double heightCard = _isLargeTextMode ? 84.sp : 60.sp;
    double widthCard = _isLargeTextMode ? 100.sp : 100.sp;

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
                  color: theme.cardColor,
                  border: Border.all(color: Color.fromARGB(255, 255, 255, 255)),
                  borderRadius: BorderRadius.circular(5.r),
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
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        label,
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyText2?.color,
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
