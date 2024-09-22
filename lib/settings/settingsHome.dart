// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/Personalise/Personnalise_ui.dart';
import 'package:ticeo/components/aboutApp.dart';
import 'package:ticeo/components/database_gest/database_helper.dart'
    as dbHelper;
import 'package:ticeo/components/aideAssistance.dart' as aideAssistance;
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticeo/components/feedback/feedback.dart';
import 'package:ticeo/components/login_page.dart';
import 'package:ticeo/components/termCondition/termCondition.dart';
import 'package:ticeo/notifications/notification_Design.dart';
import 'package:ticeo/profilMentoring/ui/profile/profile_screen.dart';
import 'package:ticeo/services/stream_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLargeTextMode = false;
  String idMentorNotification = '';
  int isMentor = 0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    getIdMentor();
    getIsMentor();
  }

  Future<void> getIsMentor() async {
    isMentor = (await dbHelper.DatabaseHelper().getisMentor())!;
  }

  Future<void> _loadPreferences() async {
    final mode = await dbHelper.DatabaseHelper().getPreference();
    setState(() {
      _isLargeTextMode = mode == 'largePolice';
    });
  }

  void _logout() async {
    try {
      // Annuler les abonnements à tous les flux
      StreamService().cancelSubscription();

      // Procéder à la déconnexion
      await FirebaseAuth.instance.signOut();
      await dbHelper.DatabaseHelper().deleteTableDataIfExists('utilisateurs');
      await dbHelper.DatabaseHelper().deleteTableDataIfExists('Mentor');

      // Naviguer vers la page de connexion après la déconnexion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } catch (e) {
      print(
          'Erreur lors de la déconnexion ou de la suppression des données: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  Future<void> getIdMentor() async {
    var infoMentor = await dbHelper.DatabaseHelper().getMentor();
    if (infoMentor!.isNotEmpty) {
      idMentorNotification = infoMentor.first['IdFireBase'];
      print('id fire base recuperer ici marci : $idMentorNotification');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    double titlesize = _isLargeTextMode ? 26.h : 16.h;
    double iconSize = _isLargeTextMode ? 30.w : 25.w;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          'Paramètres',
          style: TextStyle(
            fontSize: _isLargeTextMode ? 36.h : 26.h,
            fontFamily: 'Jersey',
            color: Theme.of(context).textTheme.bodyText1?.color,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).textTheme.bodyText1?.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(
                Icons.person,
                color: Theme.of(context).textTheme.bodyText1?.color,
                size: iconSize,
              ),
              title: Text('Profil',
                  style: TextStyle(
                    fontSize: titlesize,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  )),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.notifications,
                color: Theme.of(context).textTheme.bodyText1?.color,
                size: iconSize,
              ),
              title: Text('Notification',
                  style: TextStyle(
                    fontSize: titlesize,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  )),
              onTap: () {
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
            ),
            ListTile(
              leading: Icon(
                Icons.palette,
                color: Theme.of(context).textTheme.bodyText1?.color,
                size: iconSize,
              ),
              title: Text('Apparance et thème',
                  style: TextStyle(
                    fontSize: titlesize,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => ThemeCustomizationPage())));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.description,
                color: Theme.of(context).textTheme.bodyText1?.color,
                size: iconSize,
              ),
              title: Text('Termes et conditions',
                  style: TextStyle(
                    fontSize: titlesize,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Termscreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.help,
                color: Theme.of(context).textTheme.bodyText1?.color,
                size: iconSize,
              ),
              title: Text('Aide et assistance',
                  style: TextStyle(
                    fontSize: titlesize,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            aideAssistance.HelpAndSupportPage())));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info,
                color: Theme.of(context).textTheme.bodyText1?.color,
                size: iconSize,
              ),
              title: Text('À propos',
                  style: TextStyle(
                    fontSize: titlesize,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const AboutPage())));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info,
                color: Theme.of(context).textTheme.bodyText1?.color,
                size: iconSize,
              ),
              title: Text('Feedback',
                  style: TextStyle(
                    fontSize: titlesize,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  )),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => FeedbackPage())));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red,
                size: iconSize,
              ),
              title: Text('Se déconnecter',
                  style: TextStyle(fontSize: titlesize, color: Colors.red)),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
