import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/mode_choice/mode_view.dart';
import 'package:ticeo/components/nav_bar/bottom_navbar.dart';
import 'package:ticeo/settings/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Masquer la barre de notification
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);

  final preferencesService = PreferencesService();
  final isFirstLaunch = await preferencesService.isFirstLaunch();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(isFirstLaunch: isFirstLaunch),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;

  MyApp({required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (context, child) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: themeProvider.currentTheme,
              home: isFirstLaunch
                  ? const ModeSelectionPage()
                  : const GoogleBottomBar(),
            );
          },
        );
      },
    );
  }
}
