import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:ticeo/TaskMentoring/screens/home_page.dart';
import 'package:ticeo/chat/chat.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/home/home.dart';
import 'package:ticeo/design_course/welcome_view.dart';
import 'package:ticeo/mentoring/mentoring_home.dart';
import 'package:ticeo/mentoring/welcome_view.dart';
import 'package:ticeo/profilMentoring/ui/profile/profile_screen.dart';
import 'package:ticeo/settings/settingsHome.dart';

class GoogleBottomBar extends StatefulWidget {
  const GoogleBottomBar({super.key});

  @override
  State<GoogleBottomBar> createState() => _GoogleBottomBarState();
}

class _GoogleBottomBarState extends State<GoogleBottomBar> {
  int _selectedIndex = 0;
  bool isLargeTextMode = false;
  DateTime? _lastPressed; // Pour suivre le dernier appui sur le bouton retour

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    String? mode = await dbHelper.getPreference();

    setState(() {
      isLargeTextMode = mode == 'largePolice';
    });
  }

  void navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    const duration = Duration(seconds: 2);

    if (_lastPressed == null || now.difference(_lastPressed!) > duration) {
      // Premier appui, on affiche le message
      _lastPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appuyez à nouveau pour quitter')),
      );
      return false; // Ne pas quitter l'application
    }

    return true; // Quitter l'application si deuxième appui rapide
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final List<Widget> screens = [
      const HomeScreen(),
      const HomePage(),
      const HomePageMentor(),
      ProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: _onWillPop, // Gérer l'événement "bouton retour"
      child: Scaffold(
        body: screens[_selectedIndex],
        backgroundColor: theme.scaffoldBackgroundColor,
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: const Color.fromARGB(255, 247, 247, 247),
          onTap: (index) {
            navigateTo(index);
          },
          items: _navBarItems(isLargeTextMode, theme, context),
        ),
      ),
    );
  }
}

// Passer isLargeTextMode à cette fonction pour ajuster dynamiquement
List<SalomonBottomBarItem> _navBarItems(
    bool isLargeTextMode, ThemeData theme, BuildContext context) {
  return [
    SalomonBottomBarItem(
      icon: Icon(
        Icons.home_rounded,
        size: isLargeTextMode ? 34.0 : 24.0,
        color: Theme.of(context).textTheme.bodyText1?.color,
      ),
      title: Text(
        "Accueil",
        style: TextStyle(
          fontSize: isLargeTextMode ? 22.0 : 14.0,
          color: Theme.of(context).textTheme.bodyText1?.color,
        ),
      ),
      selectedColor: const Color.fromARGB(255, 106, 106, 106),
    ),
    SalomonBottomBarItem(
      icon: Icon(
        Icons.book_rounded,
        size: isLargeTextMode ? 34.0 : 24.0,
        color: Theme.of(context).textTheme.bodyText1?.color,
      ),
      title: Text(
        "Cours",
        style: TextStyle(
          fontSize: isLargeTextMode ? 22.0 : 14.0,
          color: Theme.of(context).textTheme.bodyText1?.color,
        ),
      ),
      selectedColor: const Color.fromARGB(255, 106, 106, 106),
    ),
    SalomonBottomBarItem(
      icon: Icon(
        Icons.person_pin,
        size: isLargeTextMode ? 34.0 : 24.0,
        color: Theme.of(context).textTheme.bodyText1?.color,
      ),
      title: Text(
        "Mentorat",
        style: TextStyle(
          fontSize: isLargeTextMode ? 22.0 : 14.0,
          color: Theme.of(context).textTheme.bodyText1?.color,
        ),
      ),
      selectedColor: const Color.fromARGB(255, 106, 106, 106),
    ),
    SalomonBottomBarItem(
      icon: Icon(
        Icons.person,
        size: isLargeTextMode ? 34.0 : 24.0,
        color: Theme.of(context).textTheme.bodyText1?.color,
      ),
      title: Text(
        "Profil",
        style: TextStyle(
          fontSize: isLargeTextMode ? 22.0 : 14.0,
          color: Theme.of(context).textTheme.bodyText1?.color,
        ),
      ),
      selectedColor: const Color.fromARGB(255, 106, 106, 106),
    ),
  ];
}
