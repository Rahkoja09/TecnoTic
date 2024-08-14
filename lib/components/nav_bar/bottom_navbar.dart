import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/home/home.dart';
import 'package:ticeo/design_course/welcome_view.dart';

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
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    String? mode = await dbHelper.getPreference();

    // Déterminez si le mode est "grand police"
    setState(() {
      isLargeTextMode = mode == 'largePolice' || mode == 'largeAndTalk';
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(), // Utiliser la valeur
      const HomePage(),
      Container(
        color: Colors.red,
        child: const Center(child: Text("Mentorat")),
      ),
      Container(
        color: Colors.green,
        child: const Center(child: Text("Profil")),
      ),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff6200ee),
        unselectedItemColor: const Color(0xff757575),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: _navBarItems,
      ),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.home_rounded),
    title: const Text("Accueil"),
    selectedColor: const Color.fromARGB(255, 26, 122, 191),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.book_rounded),
    title: const Text("Cours"),
    selectedColor: const Color.fromARGB(255, 26, 122, 191),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.person_pin),
    title: const Text("Mentorat"),
    selectedColor: const Color.fromARGB(255, 26, 122, 191),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.settings),
    title: const Text("Paramettre"),
    selectedColor: const Color.fromARGB(255, 26, 122, 191),
  ),
];
