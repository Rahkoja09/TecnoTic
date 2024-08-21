import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/home/home.dart';
import 'package:ticeo/design_course/welcome_view.dart';
import 'package:ticeo/mentoring/mentoring_home.dart';
import 'package:ticeo/settings/settingsHome.dart';

class GoogleBottomBar extends StatefulWidget {
  const GoogleBottomBar({super.key});

  @override
  State<GoogleBottomBar> createState() => _GoogleBottomBarState();
}

class _GoogleBottomBarState extends State<GoogleBottomBar> {
  int _selectedIndex = 0;
  late bool isLargeTextMode;

  @override
  void initState() {
    super.initState();
    isLargeTextMode = false;
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    String? mode = await dbHelper.getPreference();

    setState(() {
      isLargeTextMode = mode == 'large' || mode == 'largeAndTalk';
    });
  }

  void navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      const HomePage(),
      MentoringHomePage(),
      SettingsPage(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff6200ee),
        unselectedItemColor: const Color.fromARGB(255, 247, 247, 247),
        onTap: (index) {
          navigateTo(index);
        },
        items: _navBarItems,
      ),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.home_rounded,
        color: Color.fromARGB(255, 91, 153, 194)),
    title: const Text("Accueil"),
    selectedColor: Color.fromARGB(255, 106, 106, 106),
  ),
  SalomonBottomBarItem(
    icon: const Icon(
      Icons.book_rounded,
      color: Color.fromARGB(255, 91, 153, 194),
    ),
    title: const Text("Cours"),
    selectedColor: const Color.fromARGB(255, 106, 106, 106),
  ),
  SalomonBottomBarItem(
    icon:
        const Icon(Icons.person_pin, color: Color.fromARGB(255, 91, 153, 194)),
    title: const Text("Mentorat"),
    selectedColor: const Color.fromARGB(255, 106, 106, 106),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.today, color: Color.fromARGB(255, 91, 153, 194)),
    title: const Text("Paramettre"),
    selectedColor: const Color.fromARGB(255, 106, 106, 106),
  ),
];
