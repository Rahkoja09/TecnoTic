import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/mode_choice/mode_view.dart';
import 'package:ticeo/components/state/provider_state.dart';
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModeProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(414, 896),
        builder: (context, child) {
          return const MaterialApp(
            home: ModeSelectionPage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
